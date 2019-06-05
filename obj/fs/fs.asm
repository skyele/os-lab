
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 f6 1b 00 00       	call   801c27 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800075:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800085:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0b                	je     800095 <ide_probe_disk1+0x36>
	     x++)
  80008a:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  80008d:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800093:	75 f0                	jne    800085 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800095:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a6:	0f 9e c3             	setle  %bl
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	0f b6 c3             	movzbl %bl,%eax
  8000af:	50                   	push   %eax
  8000b0:	68 80 41 80 00       	push   $0x804180
  8000b5:	e8 1f 1d 00 00       	call   801dd9 <cprintf>
	return (x < 1000);
}
  8000ba:	89 d8                	mov    %ebx,%eax
  8000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    

008000c1 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ca:	83 f8 01             	cmp    $0x1,%eax
  8000cd:	77 07                	ja     8000d6 <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000cf:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 97 41 80 00       	push   $0x804197
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 a7 41 80 00       	push   $0x8041a7
  8000e5:	e8 f9 1b 00 00       	call   801ce3 <_panic>

008000ea <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	0f 87 87 00 00 00    	ja     80018f <ide_read+0xa5>

	ide_wait_ready(0);
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	e8 21 ff ff ff       	call   800033 <ide_wait_ready>
  800112:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800117:	89 f0                	mov    %esi,%eax
  800119:	ee                   	out    %al,(%dx)
  80011a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80011f:	89 f8                	mov    %edi,%eax
  800121:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800122:	89 f8                	mov    %edi,%eax
  800124:	c1 e8 08             	shr    $0x8,%eax
  800127:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80012c:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80012d:	89 f8                	mov    %edi,%eax
  80012f:	c1 e8 10             	shr    $0x10,%eax
  800132:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800137:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800138:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  80013f:	c1 e0 04             	shl    $0x4,%eax
  800142:	83 e0 10             	and    $0x10,%eax
  800145:	c1 ef 18             	shr    $0x18,%edi
  800148:	83 e7 0f             	and    $0xf,%edi
  80014b:	09 f8                	or     %edi,%eax
  80014d:	83 c8 e0             	or     $0xffffffe0,%eax
  800150:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800155:	ee                   	out    %al,(%dx)
  800156:	b8 20 00 00 00       	mov    $0x20,%eax
  80015b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	c1 e6 09             	shl    $0x9,%esi
  800164:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	39 f3                	cmp    %esi,%ebx
  800168:	74 3b                	je     8001a5 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016a:	b8 01 00 00 00       	mov    $0x1,%eax
  80016f:	e8 bf fe ff ff       	call   800033 <ide_wait_ready>
  800174:	85 c0                	test   %eax,%eax
  800176:	78 32                	js     8001aa <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  800178:	89 df                	mov    %ebx,%edi
  80017a:	b9 80 00 00 00       	mov    $0x80,%ecx
  80017f:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800184:	fc                   	cld    
  800185:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800187:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80018d:	eb d7                	jmp    800166 <ide_read+0x7c>
	assert(nsecs <= 256);
  80018f:	68 b0 41 80 00       	push   $0x8041b0
  800194:	68 bd 41 80 00       	push   $0x8041bd
  800199:	6a 44                	push   $0x44
  80019b:	68 a7 41 80 00       	push   $0x8041a7
  8001a0:	e8 3e 1b 00 00       	call   801ce3 <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	57                   	push   %edi
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c1:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c4:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ca:	0f 87 87 00 00 00    	ja     800257 <ide_write+0xa5>

	ide_wait_ready(0);
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	e8 59 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001da:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	ee                   	out    %al,(%dx)
  8001e2:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ea:	89 f0                	mov    %esi,%eax
  8001ec:	c1 e8 08             	shr    $0x8,%eax
  8001ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f4:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f5:	89 f0                	mov    %esi,%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
  8001ff:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800200:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800207:	c1 e0 04             	shl    $0x4,%eax
  80020a:	83 e0 10             	and    $0x10,%eax
  80020d:	c1 ee 18             	shr    $0x18,%esi
  800210:	83 e6 0f             	and    $0xf,%esi
  800213:	09 f0                	or     %esi,%eax
  800215:	83 c8 e0             	or     $0xffffffe0,%eax
  800218:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80021d:	ee                   	out    %al,(%dx)
  80021e:	b8 30 00 00 00       	mov    $0x30,%eax
  800223:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800228:	ee                   	out    %al,(%dx)
  800229:	c1 e7 09             	shl    $0x9,%edi
  80022c:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80022e:	39 fb                	cmp    %edi,%ebx
  800230:	74 3b                	je     80026d <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800232:	b8 01 00 00 00       	mov    $0x1,%eax
  800237:	e8 f7 fd ff ff       	call   800033 <ide_wait_ready>
  80023c:	85 c0                	test   %eax,%eax
  80023e:	78 32                	js     800272 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800240:	89 de                	mov    %ebx,%esi
  800242:	b9 80 00 00 00       	mov    $0x80,%ecx
  800247:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80024c:	fc                   	cld    
  80024d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800255:	eb d7                	jmp    80022e <ide_write+0x7c>
	assert(nsecs <= 256);
  800257:	68 b0 41 80 00       	push   $0x8041b0
  80025c:	68 bd 41 80 00       	push   $0x8041bd
  800261:	6a 5d                	push   $0x5d
  800263:	68 a7 41 80 00       	push   $0x8041a7
  800268:	e8 76 1a 00 00       	call   801ce3 <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <diskaddr>:
#define CACHE_SIZE 15

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 08             	sub    $0x8,%esp
  800280:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800283:	85 c0                	test   %eax,%eax
  800285:	74 19                	je     8002a0 <diskaddr+0x26>
  800287:	8b 15 4c a0 80 00    	mov    0x80a04c,%edx
  80028d:	85 d2                	test   %edx,%edx
  80028f:	74 05                	je     800296 <diskaddr+0x1c>
  800291:	39 42 04             	cmp    %eax,0x4(%edx)
  800294:	76 0a                	jbe    8002a0 <diskaddr+0x26>
		panic("bad block number %08x in diskaddr", blockno);
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800296:	05 00 00 01 00       	add    $0x10000,%eax
  80029b:	c1 e0 0c             	shl    $0xc,%eax
}
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8002a0:	50                   	push   %eax
  8002a1:	68 d4 41 80 00       	push   $0x8041d4
  8002a6:	6a 0c                	push   $0xc
  8002a8:	68 b0 42 80 00       	push   $0x8042b0
  8002ad:	e8 31 1a 00 00       	call   801ce3 <_panic>

008002b2 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8002b8:	89 d0                	mov    %edx,%eax
  8002ba:	c1 e8 16             	shr    $0x16,%eax
  8002bd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c9:	f6 c1 01             	test   $0x1,%cl
  8002cc:	74 0d                	je     8002db <va_is_mapped+0x29>
  8002ce:	c1 ea 0c             	shr    $0xc,%edx
  8002d1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8002d8:	83 e0 01             	and    $0x1,%eax
  8002db:	83 e0 01             	and    $0x1,%eax
}
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	c1 e8 0c             	shr    $0xc,%eax
  8002e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002f0:	c1 e8 06             	shr    $0x6,%eax
  8002f3:	83 e0 01             	and    $0x1,%eax
}
  8002f6:	5d                   	pop    %ebp
  8002f7:	c3                   	ret    

008002f8 <va_is_accessed>:

// Is this virtual address accessed?
bool
va_is_accessed(void *va)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_A) != 0;
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	c1 e8 0c             	shr    $0xc,%eax
  800301:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800308:	c1 e8 05             	shr    $0x5,%eax
  80030b:	83 e0 01             	and    $0x1,%eax
}
  80030e:	5d                   	pop    %ebp
  80030f:	c3                   	ret    

00800310 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	57                   	push   %edi
  800314:	56                   	push   %esi
  800315:	53                   	push   %ebx
  800316:	83 ec 0c             	sub    $0xc,%esp
  800319:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80031c:	8d b3 00 00 00 f0    	lea    -0x10000000(%ebx),%esi
	int r;
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800322:	81 fe ff ff ff bf    	cmp    $0xbfffffff,%esi
  800328:	77 61                	ja     80038b <flush_block+0x7b>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80032a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	bool is_map = va_is_mapped(addr);
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	53                   	push   %ebx
  800334:	e8 79 ff ff ff       	call   8002b2 <va_is_mapped>
  800339:	89 c7                	mov    %eax,%edi
	bool is_dir = va_is_dirty(addr);
  80033b:	89 1c 24             	mov    %ebx,(%esp)
  80033e:	e8 9d ff ff ff       	call   8002e0 <va_is_dirty>
	if(!is_map || !is_dir)
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	89 fa                	mov    %edi,%edx
  800348:	84 d2                	test   %dl,%dl
  80034a:	74 37                	je     800383 <flush_block+0x73>
  80034c:	84 c0                	test   %al,%al
  80034e:	74 33                	je     800383 <flush_block+0x73>
		return;
	r = ide_write(blockno * BLKSECTS, addr, BLKSECTS);
  800350:	83 ec 04             	sub    $0x4,%esp
  800353:	6a 08                	push   $0x8
  800355:	53                   	push   %ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800356:	c1 ee 0c             	shr    $0xc,%esi
	r = ide_write(blockno * BLKSECTS, addr, BLKSECTS);
  800359:	c1 e6 03             	shl    $0x3,%esi
  80035c:	56                   	push   %esi
  80035d:	e8 50 fe ff ff       	call   8001b2 <ide_write>
	if(r < 0)
  800362:	83 c4 10             	add    $0x10,%esp
  800365:	85 c0                	test   %eax,%eax
  800367:	78 34                	js     80039d <flush_block+0x8d>
		panic("the ide_write panic!\n");
	r = sys_page_map(0, addr, 0, addr, PTE_SYSCALL);
  800369:	83 ec 0c             	sub    $0xc,%esp
  80036c:	68 07 0e 00 00       	push   $0xe07
  800371:	53                   	push   %ebx
  800372:	6a 00                	push   $0x0
  800374:	53                   	push   %ebx
  800375:	6a 00                	push   $0x0
  800377:	e8 f1 25 00 00       	call   80296d <sys_page_map>
	if(r < 0)
  80037c:	83 c4 20             	add    $0x20,%esp
  80037f:	85 c0                	test   %eax,%eax
  800381:	78 2e                	js     8003b1 <flush_block+0xa1>
		panic("the sys_page_map panic!\n");
	// panic("flush_block not implemented");
}
  800383:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800386:	5b                   	pop    %ebx
  800387:	5e                   	pop    %esi
  800388:	5f                   	pop    %edi
  800389:	5d                   	pop    %ebp
  80038a:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  80038b:	53                   	push   %ebx
  80038c:	68 b8 42 80 00       	push   $0x8042b8
  800391:	6a 5a                	push   $0x5a
  800393:	68 b0 42 80 00       	push   $0x8042b0
  800398:	e8 46 19 00 00       	call   801ce3 <_panic>
		panic("the ide_write panic!\n");
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 d3 42 80 00       	push   $0x8042d3
  8003a5:	6a 64                	push   $0x64
  8003a7:	68 b0 42 80 00       	push   $0x8042b0
  8003ac:	e8 32 19 00 00       	call   801ce3 <_panic>
		panic("the sys_page_map panic!\n");
  8003b1:	83 ec 04             	sub    $0x4,%esp
  8003b4:	68 e9 42 80 00       	push   $0x8042e9
  8003b9:	6a 67                	push   $0x67
  8003bb:	68 b0 42 80 00       	push   $0x8042b0
  8003c0:	e8 1e 19 00 00       	call   801ce3 <_panic>

008003c5 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	53                   	push   %ebx
  8003c9:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8003cf:	68 cd 07 80 00       	push   $0x8007cd
  8003d4:	e8 26 28 00 00       	call   802bff <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8003d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003e0:	e8 95 fe ff ff       	call   80027a <diskaddr>
  8003e5:	83 c4 0c             	add    $0xc,%esp
  8003e8:	68 08 01 00 00       	push   $0x108
  8003ed:	50                   	push   %eax
  8003ee:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8003f4:	50                   	push   %eax
  8003f5:	e8 cc 22 00 00       	call   8026c6 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  8003fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800401:	e8 74 fe ff ff       	call   80027a <diskaddr>
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	68 02 43 80 00       	push   $0x804302
  80040e:	50                   	push   %eax
  80040f:	e8 24 21 00 00       	call   802538 <strcpy>
	flush_block(diskaddr(1));
  800414:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80041b:	e8 5a fe ff ff       	call   80027a <diskaddr>
  800420:	89 04 24             	mov    %eax,(%esp)
  800423:	e8 e8 fe ff ff       	call   800310 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800428:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80042f:	e8 46 fe ff ff       	call   80027a <diskaddr>
  800434:	89 04 24             	mov    %eax,(%esp)
  800437:	e8 76 fe ff ff       	call   8002b2 <va_is_mapped>
  80043c:	83 c4 10             	add    $0x10,%esp
  80043f:	84 c0                	test   %al,%al
  800441:	0f 84 d1 01 00 00    	je     800618 <bc_init+0x253>
	assert(!va_is_dirty(diskaddr(1)));
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	6a 01                	push   $0x1
  80044c:	e8 29 fe ff ff       	call   80027a <diskaddr>
  800451:	89 04 24             	mov    %eax,(%esp)
  800454:	e8 87 fe ff ff       	call   8002e0 <va_is_dirty>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	84 c0                	test   %al,%al
  80045e:	0f 85 ca 01 00 00    	jne    80062e <bc_init+0x269>
	sys_page_unmap(0, diskaddr(1));
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	6a 01                	push   $0x1
  800469:	e8 0c fe ff ff       	call   80027a <diskaddr>
  80046e:	83 c4 08             	add    $0x8,%esp
  800471:	50                   	push   %eax
  800472:	6a 00                	push   $0x0
  800474:	e8 36 25 00 00       	call   8029af <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800479:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800480:	e8 f5 fd ff ff       	call   80027a <diskaddr>
  800485:	89 04 24             	mov    %eax,(%esp)
  800488:	e8 25 fe ff ff       	call   8002b2 <va_is_mapped>
  80048d:	83 c4 10             	add    $0x10,%esp
  800490:	84 c0                	test   %al,%al
  800492:	0f 85 ac 01 00 00    	jne    800644 <bc_init+0x27f>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800498:	83 ec 0c             	sub    $0xc,%esp
  80049b:	6a 01                	push   $0x1
  80049d:	e8 d8 fd ff ff       	call   80027a <diskaddr>
  8004a2:	83 c4 08             	add    $0x8,%esp
  8004a5:	68 02 43 80 00       	push   $0x804302
  8004aa:	50                   	push   %eax
  8004ab:	e8 33 21 00 00       	call   8025e3 <strcmp>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	0f 85 9f 01 00 00    	jne    80065a <bc_init+0x295>
	memmove(diskaddr(1), &backup, sizeof backup);
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	6a 01                	push   $0x1
  8004c0:	e8 b5 fd ff ff       	call   80027a <diskaddr>
  8004c5:	83 c4 0c             	add    $0xc,%esp
  8004c8:	68 08 01 00 00       	push   $0x108
  8004cd:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  8004d3:	53                   	push   %ebx
  8004d4:	50                   	push   %eax
  8004d5:	e8 ec 21 00 00       	call   8026c6 <memmove>
	flush_block(diskaddr(1));
  8004da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8004e1:	e8 94 fd ff ff       	call   80027a <diskaddr>
  8004e6:	89 04 24             	mov    %eax,(%esp)
  8004e9:	e8 22 fe ff ff       	call   800310 <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  8004ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8004f5:	e8 80 fd ff ff       	call   80027a <diskaddr>
  8004fa:	83 c4 0c             	add    $0xc,%esp
  8004fd:	68 08 01 00 00       	push   $0x108
  800502:	50                   	push   %eax
  800503:	53                   	push   %ebx
  800504:	e8 bd 21 00 00       	call   8026c6 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800509:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800510:	e8 65 fd ff ff       	call   80027a <diskaddr>
  800515:	83 c4 08             	add    $0x8,%esp
  800518:	68 02 43 80 00       	push   $0x804302
  80051d:	50                   	push   %eax
  80051e:	e8 15 20 00 00       	call   802538 <strcpy>
	flush_block(diskaddr(1) + 20);
  800523:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80052a:	e8 4b fd ff ff       	call   80027a <diskaddr>
  80052f:	83 c0 14             	add    $0x14,%eax
  800532:	89 04 24             	mov    %eax,(%esp)
  800535:	e8 d6 fd ff ff       	call   800310 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80053a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800541:	e8 34 fd ff ff       	call   80027a <diskaddr>
  800546:	89 04 24             	mov    %eax,(%esp)
  800549:	e8 64 fd ff ff       	call   8002b2 <va_is_mapped>
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	84 c0                	test   %al,%al
  800553:	0f 84 1a 01 00 00    	je     800673 <bc_init+0x2ae>
	sys_page_unmap(0, diskaddr(1));
  800559:	83 ec 0c             	sub    $0xc,%esp
  80055c:	6a 01                	push   $0x1
  80055e:	e8 17 fd ff ff       	call   80027a <diskaddr>
  800563:	83 c4 08             	add    $0x8,%esp
  800566:	50                   	push   %eax
  800567:	6a 00                	push   $0x0
  800569:	e8 41 24 00 00       	call   8029af <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  80056e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800575:	e8 00 fd ff ff       	call   80027a <diskaddr>
  80057a:	89 04 24             	mov    %eax,(%esp)
  80057d:	e8 30 fd ff ff       	call   8002b2 <va_is_mapped>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	84 c0                	test   %al,%al
  800587:	0f 85 ff 00 00 00    	jne    80068c <bc_init+0x2c7>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	6a 01                	push   $0x1
  800592:	e8 e3 fc ff ff       	call   80027a <diskaddr>
  800597:	83 c4 08             	add    $0x8,%esp
  80059a:	68 02 43 80 00       	push   $0x804302
  80059f:	50                   	push   %eax
  8005a0:	e8 3e 20 00 00       	call   8025e3 <strcmp>
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	85 c0                	test   %eax,%eax
  8005aa:	0f 85 f5 00 00 00    	jne    8006a5 <bc_init+0x2e0>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005b0:	83 ec 0c             	sub    $0xc,%esp
  8005b3:	6a 01                	push   $0x1
  8005b5:	e8 c0 fc ff ff       	call   80027a <diskaddr>
  8005ba:	83 c4 0c             	add    $0xc,%esp
  8005bd:	68 08 01 00 00       	push   $0x108
  8005c2:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	e8 f7 20 00 00       	call   8026c6 <memmove>
	flush_block(diskaddr(1));
  8005cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d6:	e8 9f fc ff ff       	call   80027a <diskaddr>
  8005db:	89 04 24             	mov    %eax,(%esp)
  8005de:	e8 2d fd ff ff       	call   800310 <flush_block>
	cprintf("block cache is good\n");
  8005e3:	c7 04 24 3e 43 80 00 	movl   $0x80433e,(%esp)
  8005ea:	e8 ea 17 00 00       	call   801dd9 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  8005ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005f6:	e8 7f fc ff ff       	call   80027a <diskaddr>
  8005fb:	83 c4 0c             	add    $0xc,%esp
  8005fe:	68 08 01 00 00       	push   $0x108
  800603:	50                   	push   %eax
  800604:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060a:	50                   	push   %eax
  80060b:	e8 b6 20 00 00       	call   8026c6 <memmove>
}
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800616:	c9                   	leave  
  800617:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800618:	68 24 43 80 00       	push   $0x804324
  80061d:	68 bd 41 80 00       	push   $0x8041bd
  800622:	6a 78                	push   $0x78
  800624:	68 b0 42 80 00       	push   $0x8042b0
  800629:	e8 b5 16 00 00       	call   801ce3 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80062e:	68 09 43 80 00       	push   $0x804309
  800633:	68 bd 41 80 00       	push   $0x8041bd
  800638:	6a 79                	push   $0x79
  80063a:	68 b0 42 80 00       	push   $0x8042b0
  80063f:	e8 9f 16 00 00       	call   801ce3 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800644:	68 23 43 80 00       	push   $0x804323
  800649:	68 bd 41 80 00       	push   $0x8041bd
  80064e:	6a 7d                	push   $0x7d
  800650:	68 b0 42 80 00       	push   $0x8042b0
  800655:	e8 89 16 00 00       	call   801ce3 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80065a:	68 f8 41 80 00       	push   $0x8041f8
  80065f:	68 bd 41 80 00       	push   $0x8041bd
  800664:	68 80 00 00 00       	push   $0x80
  800669:	68 b0 42 80 00       	push   $0x8042b0
  80066e:	e8 70 16 00 00       	call   801ce3 <_panic>
	assert(va_is_mapped(diskaddr(1)));
  800673:	68 24 43 80 00       	push   $0x804324
  800678:	68 bd 41 80 00       	push   $0x8041bd
  80067d:	68 91 00 00 00       	push   $0x91
  800682:	68 b0 42 80 00       	push   $0x8042b0
  800687:	e8 57 16 00 00       	call   801ce3 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  80068c:	68 23 43 80 00       	push   $0x804323
  800691:	68 bd 41 80 00       	push   $0x8041bd
  800696:	68 99 00 00 00       	push   $0x99
  80069b:	68 b0 42 80 00       	push   $0x8042b0
  8006a0:	e8 3e 16 00 00       	call   801ce3 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006a5:	68 f8 41 80 00       	push   $0x8041f8
  8006aa:	68 bd 41 80 00       	push   $0x8041bd
  8006af:	68 9c 00 00 00       	push   $0x9c
  8006b4:	68 b0 42 80 00       	push   $0x8042b0
  8006b9:	e8 25 16 00 00       	call   801ce3 <_panic>

008006be <bc_evict>:

void 
bc_evict(void* now_addr)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	56                   	push   %esi
  8006c2:	53                   	push   %ebx
			time_clock_hdr ++;
			time_clock_hdr = time_clock_hdr % CACHE_SIZE;
			return;
		}
		time_clock_hdr ++;
		time_clock_hdr = time_clock_hdr % CACHE_SIZE;
  8006c3:	bb 89 88 88 88       	mov    $0x88888889,%ebx
		void *addr = (void *)block_cache_array[time_clock_hdr];
  8006c8:	a1 3c a0 80 00       	mov    0x80a03c,%eax
  8006cd:	8b 34 85 00 a0 80 00 	mov    0x80a000(,%eax,4),%esi
		if(!addr){
  8006d4:	85 f6                	test   %esi,%esi
  8006d6:	74 4f                	je     800727 <bc_evict+0x69>
		if(va_is_accessed(addr)){
  8006d8:	83 ec 0c             	sub    $0xc,%esp
  8006db:	56                   	push   %esi
  8006dc:	e8 17 fc ff ff       	call   8002f8 <va_is_accessed>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	84 c0                	test   %al,%al
  8006e6:	0f 84 8a 00 00 00    	je     800776 <bc_evict+0xb8>
			r = sys_clear_access_bit(0, addr);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	56                   	push   %esi
  8006f0:	6a 00                	push   $0x0
  8006f2:	e8 c6 24 00 00       	call   802bbd <sys_clear_access_bit>
			if(r < 0)
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	78 61                	js     80075f <bc_evict+0xa1>
		time_clock_hdr ++;
  8006fe:	a1 3c a0 80 00       	mov    0x80a03c,%eax
  800703:	8d 48 01             	lea    0x1(%eax),%ecx
		time_clock_hdr = time_clock_hdr % CACHE_SIZE;
  800706:	89 c8                	mov    %ecx,%eax
  800708:	f7 eb                	imul   %ebx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	c1 fa 03             	sar    $0x3,%edx
  80070f:	89 c8                	mov    %ecx,%eax
  800711:	c1 f8 1f             	sar    $0x1f,%eax
  800714:	29 c2                	sub    %eax,%edx
  800716:	89 d0                	mov    %edx,%eax
  800718:	c1 e0 04             	shl    $0x4,%eax
  80071b:	29 d0                	sub    %edx,%eax
  80071d:	29 c1                	sub    %eax,%ecx
  80071f:	89 0d 3c a0 80 00    	mov    %ecx,0x80a03c
	while(true){
  800725:	eb a1                	jmp    8006c8 <bc_evict+0xa>
			block_cache_array[time_clock_hdr] = (uintptr_t)now_addr;
  800727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80072a:	89 1c 85 00 a0 80 00 	mov    %ebx,0x80a000(,%eax,4)
			time_clock_hdr ++;
  800731:	8d 48 01             	lea    0x1(%eax),%ecx
			time_clock_hdr = time_clock_hdr % CACHE_SIZE;
  800734:	ba 89 88 88 88       	mov    $0x88888889,%edx
  800739:	89 c8                	mov    %ecx,%eax
  80073b:	f7 ea                	imul   %edx
  80073d:	01 ca                	add    %ecx,%edx
  80073f:	c1 fa 03             	sar    $0x3,%edx
  800742:	89 c8                	mov    %ecx,%eax
  800744:	c1 f8 1f             	sar    $0x1f,%eax
  800747:	29 c2                	sub    %eax,%edx
  800749:	89 d0                	mov    %edx,%eax
  80074b:	c1 e0 04             	shl    $0x4,%eax
  80074e:	29 d0                	sub    %edx,%eax
  800750:	29 c1                	sub    %eax,%ecx
  800752:	89 0d 3c a0 80 00    	mov    %ecx,0x80a03c
	}
  800758:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80075b:	5b                   	pop    %ebx
  80075c:	5e                   	pop    %esi
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    
				panic("sys_clear_access_bit is panic!\n");
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 1c 42 80 00       	push   $0x80421c
  800767:	68 c1 00 00 00       	push   $0xc1
  80076c:	68 b0 42 80 00       	push   $0x8042b0
  800771:	e8 6d 15 00 00       	call   801ce3 <_panic>
			if(va_is_dirty(addr)){
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	56                   	push   %esi
  80077a:	e8 61 fb ff ff       	call   8002e0 <va_is_dirty>
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	84 c0                	test   %al,%al
  800784:	75 39                	jne    8007bf <bc_evict+0x101>
			block_cache_array[time_clock_hdr] = (uintptr_t)now_addr;
  800786:	8b 0d 3c a0 80 00    	mov    0x80a03c,%ecx
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	89 04 8d 00 a0 80 00 	mov    %eax,0x80a000(,%ecx,4)
			time_clock_hdr ++;
  800796:	83 c1 01             	add    $0x1,%ecx
			time_clock_hdr = time_clock_hdr % CACHE_SIZE;
  800799:	ba 89 88 88 88       	mov    $0x88888889,%edx
  80079e:	89 c8                	mov    %ecx,%eax
  8007a0:	f7 ea                	imul   %edx
  8007a2:	01 ca                	add    %ecx,%edx
  8007a4:	c1 fa 03             	sar    $0x3,%edx
  8007a7:	89 c8                	mov    %ecx,%eax
  8007a9:	c1 f8 1f             	sar    $0x1f,%eax
  8007ac:	29 c2                	sub    %eax,%edx
  8007ae:	89 d0                	mov    %edx,%eax
  8007b0:	c1 e0 04             	shl    $0x4,%eax
  8007b3:	29 d0                	sub    %edx,%eax
  8007b5:	29 c1                	sub    %eax,%ecx
  8007b7:	89 0d 3c a0 80 00    	mov    %ecx,0x80a03c
			return;
  8007bd:	eb 99                	jmp    800758 <bc_evict+0x9a>
				flush_block(addr);
  8007bf:	83 ec 0c             	sub    $0xc,%esp
  8007c2:	56                   	push   %esi
  8007c3:	e8 48 fb ff ff       	call   800310 <flush_block>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	eb b9                	jmp    800786 <bc_evict+0xc8>

008007cd <bc_pgfault>:
{
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	56                   	push   %esi
  8007d1:	53                   	push   %ebx
  8007d2:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8007d5:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8007d7:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  8007dd:	89 c6                	mov    %eax,%esi
  8007df:	c1 ee 0c             	shr    $0xc,%esi
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8007e2:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8007e7:	0f 87 95 00 00 00    	ja     800882 <bc_pgfault+0xb5>
	if (super && blockno >= super->s_nblocks)
  8007ed:	a1 4c a0 80 00       	mov    0x80a04c,%eax
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	74 09                	je     8007ff <bc_pgfault+0x32>
  8007f6:	39 70 04             	cmp    %esi,0x4(%eax)
  8007f9:	0f 86 9e 00 00 00    	jbe    80089d <bc_pgfault+0xd0>
	addr = ROUNDDOWN(addr, PGSIZE);
  8007ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W);
  800805:	83 ec 04             	sub    $0x4,%esp
  800808:	6a 07                	push   $0x7
  80080a:	53                   	push   %ebx
  80080b:	6a 00                	push   $0x0
  80080d:	e8 18 21 00 00       	call   80292a <sys_page_alloc>
	if(r < 0)
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	85 c0                	test   %eax,%eax
  800817:	0f 88 92 00 00 00    	js     8008af <bc_pgfault+0xe2>
	ide_read(blockno * BLKSECTS, addr, BLKSECTS);
  80081d:	83 ec 04             	sub    $0x4,%esp
  800820:	6a 08                	push   $0x8
  800822:	53                   	push   %ebx
  800823:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  80082a:	50                   	push   %eax
  80082b:	e8 ba f8 ff ff       	call   8000ea <ide_read>
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800830:	89 d8                	mov    %ebx,%eax
  800832:	c1 e8 0c             	shr    $0xc,%eax
  800835:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80083c:	25 07 0e 00 00       	and    $0xe07,%eax
  800841:	89 04 24             	mov    %eax,(%esp)
  800844:	53                   	push   %ebx
  800845:	6a 00                	push   $0x0
  800847:	53                   	push   %ebx
  800848:	6a 00                	push   $0x0
  80084a:	e8 1e 21 00 00       	call   80296d <sys_page_map>
  80084f:	83 c4 20             	add    $0x20,%esp
  800852:	85 c0                	test   %eax,%eax
  800854:	78 6d                	js     8008c3 <bc_pgfault+0xf6>
	if (bitmap && block_is_free(blockno))
  800856:	83 3d 48 a0 80 00 00 	cmpl   $0x0,0x80a048
  80085d:	74 10                	je     80086f <bc_pgfault+0xa2>
  80085f:	83 ec 0c             	sub    $0xc,%esp
  800862:	56                   	push   %esi
  800863:	e8 d5 00 00 00       	call   80093d <block_is_free>
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	84 c0                	test   %al,%al
  80086d:	75 66                	jne    8008d5 <bc_pgfault+0x108>
	bc_evict(addr);
  80086f:	83 ec 0c             	sub    $0xc,%esp
  800872:	53                   	push   %ebx
  800873:	e8 46 fe ff ff       	call   8006be <bc_evict>
}
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80087e:	5b                   	pop    %ebx
  80087f:	5e                   	pop    %esi
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 72 04             	pushl  0x4(%edx)
  800888:	53                   	push   %ebx
  800889:	ff 72 28             	pushl  0x28(%edx)
  80088c:	68 3c 42 80 00       	push   $0x80423c
  800891:	6a 31                	push   $0x31
  800893:	68 b0 42 80 00       	push   $0x8042b0
  800898:	e8 46 14 00 00       	call   801ce3 <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80089d:	56                   	push   %esi
  80089e:	68 6c 42 80 00       	push   $0x80426c
  8008a3:	6a 34                	push   $0x34
  8008a5:	68 b0 42 80 00       	push   $0x8042b0
  8008aa:	e8 34 14 00 00       	call   801ce3 <_panic>
		panic("the sys_page_alloc panic!\n");
  8008af:	83 ec 04             	sub    $0x4,%esp
  8008b2:	68 53 43 80 00       	push   $0x804353
  8008b7:	6a 3f                	push   $0x3f
  8008b9:	68 b0 42 80 00       	push   $0x8042b0
  8008be:	e8 20 14 00 00       	call   801ce3 <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8008c3:	50                   	push   %eax
  8008c4:	68 90 42 80 00       	push   $0x804290
  8008c9:	6a 44                	push   $0x44
  8008cb:	68 b0 42 80 00       	push   $0x8042b0
  8008d0:	e8 0e 14 00 00       	call   801ce3 <_panic>
		panic("reading free block %08x\n", blockno);
  8008d5:	56                   	push   %esi
  8008d6:	68 6e 43 80 00       	push   $0x80436e
  8008db:	6a 49                	push   $0x49
  8008dd:	68 b0 42 80 00       	push   $0x8042b0
  8008e2:	e8 fc 13 00 00       	call   801ce3 <_panic>

008008e7 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8008ed:	a1 4c a0 80 00       	mov    0x80a04c,%eax
  8008f2:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8008f8:	75 1b                	jne    800915 <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8008fa:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800901:	77 26                	ja     800929 <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	68 c5 43 80 00       	push   $0x8043c5
  80090b:	e8 c9 14 00 00       	call   801dd9 <cprintf>
}
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	c9                   	leave  
  800914:	c3                   	ret    
		panic("bad file system magic number");
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 87 43 80 00       	push   $0x804387
  80091d:	6a 0f                	push   $0xf
  80091f:	68 a4 43 80 00       	push   $0x8043a4
  800924:	e8 ba 13 00 00       	call   801ce3 <_panic>
		panic("file system is too large");
  800929:	83 ec 04             	sub    $0x4,%esp
  80092c:	68 ac 43 80 00       	push   $0x8043ac
  800931:	6a 12                	push   $0x12
  800933:	68 a4 43 80 00       	push   $0x8043a4
  800938:	e8 a6 13 00 00       	call   801ce3 <_panic>

0080093d <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	53                   	push   %ebx
  800941:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800944:	8b 15 4c a0 80 00    	mov    0x80a04c,%edx
  80094a:	85 d2                	test   %edx,%edx
  80094c:	74 25                	je     800973 <block_is_free+0x36>
		return 0;
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  800953:	39 4a 04             	cmp    %ecx,0x4(%edx)
  800956:	76 18                	jbe    800970 <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800958:	89 cb                	mov    %ecx,%ebx
  80095a:	c1 eb 05             	shr    $0x5,%ebx
  80095d:	b8 01 00 00 00       	mov    $0x1,%eax
  800962:	d3 e0                	shl    %cl,%eax
  800964:	8b 15 48 a0 80 00    	mov    0x80a048,%edx
  80096a:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  80096d:	0f 95 c0             	setne  %al
		return 1;
	return 0;
}
  800970:	5b                   	pop    %ebx
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    
		return 0;
  800973:	b8 00 00 00 00       	mov    $0x0,%eax
  800978:	eb f6                	jmp    800970 <block_is_free+0x33>

0080097a <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	53                   	push   %ebx
  80097e:	83 ec 04             	sub    $0x4,%esp
  800981:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800984:	85 c9                	test   %ecx,%ecx
  800986:	74 1a                	je     8009a2 <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  800988:	89 cb                	mov    %ecx,%ebx
  80098a:	c1 eb 05             	shr    $0x5,%ebx
  80098d:	8b 15 48 a0 80 00    	mov    0x80a048,%edx
  800993:	b8 01 00 00 00       	mov    $0x1,%eax
  800998:	d3 e0                	shl    %cl,%eax
  80099a:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  80099d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    
		panic("attempt to free zero block");
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 d9 43 80 00       	push   $0x8043d9
  8009aa:	6a 2d                	push   $0x2d
  8009ac:	68 a4 43 80 00       	push   $0x8043a4
  8009b1:	e8 2d 13 00 00       	call   801ce3 <_panic>

008009b6 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	56                   	push   %esi
  8009ba:	53                   	push   %ebx
	// LAB 5: Your code here.
	// panic("alloc_block not implemented");
	uint32_t blockno;
	int r;
	//1 - free, 0 - used
	for(blockno = 0; blockno < super->s_nblocks; blockno++){
  8009bb:	a1 4c a0 80 00       	mov    0x80a04c,%eax
  8009c0:	8b 70 04             	mov    0x4(%eax),%esi
  8009c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009c8:	39 de                	cmp    %ebx,%esi
  8009ca:	74 48                	je     800a14 <alloc_block+0x5e>
		if(block_is_free(blockno)){
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	53                   	push   %ebx
  8009d0:	e8 68 ff ff ff       	call   80093d <block_is_free>
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	84 c0                	test   %al,%al
  8009da:	75 05                	jne    8009e1 <alloc_block+0x2b>
	for(blockno = 0; blockno < super->s_nblocks; blockno++){
  8009dc:	83 c3 01             	add    $0x1,%ebx
  8009df:	eb e7                	jmp    8009c8 <alloc_block+0x12>
			// bitmap[blockno/32] ^= 1<<(blockno%32);//lab5 bug
			bitmap[blockno/32] &= ~(1<<(blockno%32));
  8009e1:	89 d8                	mov    %ebx,%eax
  8009e3:	c1 e8 05             	shr    $0x5,%eax
  8009e6:	c1 e0 02             	shl    $0x2,%eax
  8009e9:	89 c6                	mov    %eax,%esi
  8009eb:	03 35 48 a0 80 00    	add    0x80a048,%esi
  8009f1:	ba 01 00 00 00       	mov    $0x1,%edx
  8009f6:	89 d9                	mov    %ebx,%ecx
  8009f8:	d3 e2                	shl    %cl,%edx
  8009fa:	f7 d2                	not    %edx
  8009fc:	21 16                	and    %edx,(%esi)
			flush_block(&bitmap[blockno/32]);
  8009fe:	83 ec 0c             	sub    $0xc,%esp
  800a01:	03 05 48 a0 80 00    	add    0x80a048,%eax
  800a07:	50                   	push   %eax
  800a08:	e8 03 f9 ff ff       	call   800310 <flush_block>
			return blockno;
  800a0d:	89 d8                	mov    %ebx,%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
  800a12:	eb 05                	jmp    800a19 <alloc_block+0x63>
		}
	}
	return -E_NO_DISK;
  800a14:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  800a19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a1c:	5b                   	pop    %ebx
  800a1d:	5e                   	pop    %esi
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	57                   	push   %edi
  800a24:	56                   	push   %esi
  800a25:	53                   	push   %ebx
  800a26:	83 ec 1c             	sub    $0x1c,%esp
  800a29:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	if(filebno >= NDIRECT + NINDIRECT)
  800a2c:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  800a32:	0f 87 91 00 00 00    	ja     800ac9 <file_block_walk+0xa9>
		return -E_INVAL;
	else if(filebno < NDIRECT)
  800a38:	83 fa 09             	cmp    $0x9,%edx
  800a3b:	77 18                	ja     800a55 <file_block_walk+0x35>
		*ppdiskbno = &(f->f_direct[filebno]);
  800a3d:	8d 84 90 88 00 00 00 	lea    0x88(%eax,%edx,4),%eax
  800a44:	89 01                	mov    %eax,(%ecx)
			flush_block(diskaddr(r));
		}
		filebno -= NDIRECT;
		*ppdiskbno = &(((uint32_t *)diskaddr(f->f_indirect))[filebno]);
	}
	return 0;
  800a46:	bf 00 00 00 00       	mov    $0x0,%edi
	// LAB 5: Your code here.
    // panic("file_block_walk not implemented");
}
  800a4b:	89 f8                	mov    %edi,%eax
  800a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	5f                   	pop    %edi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    
  800a55:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800a58:	89 d3                	mov    %edx,%ebx
  800a5a:	89 c6                	mov    %eax,%esi
		if(!f->f_indirect){
  800a5c:	83 b8 b0 00 00 00 00 	cmpl   $0x0,0xb0(%eax)
  800a63:	75 43                	jne    800aa8 <file_block_walk+0x88>
			if(!alloc)
  800a65:	89 f8                	mov    %edi,%eax
  800a67:	84 c0                	test   %al,%al
  800a69:	74 68                	je     800ad3 <file_block_walk+0xb3>
			r = alloc_block();
  800a6b:	e8 46 ff ff ff       	call   8009b6 <alloc_block>
  800a70:	89 c7                	mov    %eax,%edi
			if(r < 0)
  800a72:	85 c0                	test   %eax,%eax
  800a74:	78 d5                	js     800a4b <file_block_walk+0x2b>
			memset(diskaddr(r), 0, BLKSIZE);
  800a76:	83 ec 0c             	sub    $0xc,%esp
  800a79:	50                   	push   %eax
  800a7a:	e8 fb f7 ff ff       	call   80027a <diskaddr>
  800a7f:	83 c4 0c             	add    $0xc,%esp
  800a82:	68 00 10 00 00       	push   $0x1000
  800a87:	6a 00                	push   $0x0
  800a89:	50                   	push   %eax
  800a8a:	e8 ef 1b 00 00       	call   80267e <memset>
			f->f_indirect = r;
  800a8f:	89 be b0 00 00 00    	mov    %edi,0xb0(%esi)
			flush_block(diskaddr(r));
  800a95:	89 3c 24             	mov    %edi,(%esp)
  800a98:	e8 dd f7 ff ff       	call   80027a <diskaddr>
  800a9d:	89 04 24             	mov    %eax,(%esp)
  800aa0:	e8 6b f8 ff ff       	call   800310 <flush_block>
  800aa5:	83 c4 10             	add    $0x10,%esp
		*ppdiskbno = &(((uint32_t *)diskaddr(f->f_indirect))[filebno]);
  800aa8:	83 ec 0c             	sub    $0xc,%esp
  800aab:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  800ab1:	e8 c4 f7 ff ff       	call   80027a <diskaddr>
  800ab6:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800aba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800abd:	89 03                	mov    %eax,(%ebx)
  800abf:	83 c4 10             	add    $0x10,%esp
	return 0;
  800ac2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac7:	eb 82                	jmp    800a4b <file_block_walk+0x2b>
		return -E_INVAL;
  800ac9:	bf fd ff ff ff       	mov    $0xfffffffd,%edi
  800ace:	e9 78 ff ff ff       	jmp    800a4b <file_block_walk+0x2b>
				return -E_NOT_FOUND;
  800ad3:	bf f5 ff ff ff       	mov    $0xfffffff5,%edi
  800ad8:	e9 6e ff ff ff       	jmp    800a4b <file_block_walk+0x2b>

00800add <check_bitmap>:
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800ae2:	a1 4c a0 80 00       	mov    0x80a04c,%eax
  800ae7:	8b 70 04             	mov    0x4(%eax),%esi
  800aea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aef:	89 d8                	mov    %ebx,%eax
  800af1:	c1 e0 0f             	shl    $0xf,%eax
  800af4:	39 c6                	cmp    %eax,%esi
  800af6:	76 2e                	jbe    800b26 <check_bitmap+0x49>
		assert(!block_is_free(2+i));
  800af8:	83 ec 0c             	sub    $0xc,%esp
  800afb:	8d 43 02             	lea    0x2(%ebx),%eax
  800afe:	50                   	push   %eax
  800aff:	e8 39 fe ff ff       	call   80093d <block_is_free>
  800b04:	83 c4 10             	add    $0x10,%esp
  800b07:	84 c0                	test   %al,%al
  800b09:	75 05                	jne    800b10 <check_bitmap+0x33>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800b0b:	83 c3 01             	add    $0x1,%ebx
  800b0e:	eb df                	jmp    800aef <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  800b10:	68 f4 43 80 00       	push   $0x8043f4
  800b15:	68 bd 41 80 00       	push   $0x8041bd
  800b1a:	6a 5b                	push   $0x5b
  800b1c:	68 a4 43 80 00       	push   $0x8043a4
  800b21:	e8 bd 11 00 00       	call   801ce3 <_panic>
	assert(!block_is_free(0));
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	6a 00                	push   $0x0
  800b2b:	e8 0d fe ff ff       	call   80093d <block_is_free>
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	84 c0                	test   %al,%al
  800b35:	75 28                	jne    800b5f <check_bitmap+0x82>
	assert(!block_is_free(1));
  800b37:	83 ec 0c             	sub    $0xc,%esp
  800b3a:	6a 01                	push   $0x1
  800b3c:	e8 fc fd ff ff       	call   80093d <block_is_free>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	84 c0                	test   %al,%al
  800b46:	75 2d                	jne    800b75 <check_bitmap+0x98>
	cprintf("bitmap is good\n");
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	68 2c 44 80 00       	push   $0x80442c
  800b50:	e8 84 12 00 00       	call   801dd9 <cprintf>
}
  800b55:	83 c4 10             	add    $0x10,%esp
  800b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    
	assert(!block_is_free(0));
  800b5f:	68 08 44 80 00       	push   $0x804408
  800b64:	68 bd 41 80 00       	push   $0x8041bd
  800b69:	6a 5e                	push   $0x5e
  800b6b:	68 a4 43 80 00       	push   $0x8043a4
  800b70:	e8 6e 11 00 00       	call   801ce3 <_panic>
	assert(!block_is_free(1));
  800b75:	68 1a 44 80 00       	push   $0x80441a
  800b7a:	68 bd 41 80 00       	push   $0x8041bd
  800b7f:	6a 5f                	push   $0x5f
  800b81:	68 a4 43 80 00       	push   $0x8043a4
  800b86:	e8 58 11 00 00       	call   801ce3 <_panic>

00800b8b <fs_init>:
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800b91:	e8 c9 f4 ff ff       	call   80005f <ide_probe_disk1>
  800b96:	84 c0                	test   %al,%al
  800b98:	74 41                	je     800bdb <fs_init+0x50>
		ide_set_disk(1);
  800b9a:	83 ec 0c             	sub    $0xc,%esp
  800b9d:	6a 01                	push   $0x1
  800b9f:	e8 1d f5 ff ff       	call   8000c1 <ide_set_disk>
  800ba4:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800ba7:	e8 19 f8 ff ff       	call   8003c5 <bc_init>
	super = diskaddr(1);
  800bac:	83 ec 0c             	sub    $0xc,%esp
  800baf:	6a 01                	push   $0x1
  800bb1:	e8 c4 f6 ff ff       	call   80027a <diskaddr>
  800bb6:	a3 4c a0 80 00       	mov    %eax,0x80a04c
	check_super();
  800bbb:	e8 27 fd ff ff       	call   8008e7 <check_super>
	bitmap = diskaddr(2);
  800bc0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800bc7:	e8 ae f6 ff ff       	call   80027a <diskaddr>
  800bcc:	a3 48 a0 80 00       	mov    %eax,0x80a048
	check_bitmap();
  800bd1:	e8 07 ff ff ff       	call   800add <check_bitmap>
}
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    
		ide_set_disk(0);
  800bdb:	83 ec 0c             	sub    $0xc,%esp
  800bde:	6a 00                	push   $0x0
  800be0:	e8 dc f4 ff ff       	call   8000c1 <ide_set_disk>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	eb bd                	jmp    800ba7 <fs_init+0x1c>

00800bea <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 18             	sub    $0x18,%esp
  800bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
    // LAB 5: Your code here.
	uint32_t *ppdiskbno;
   	int r;
	if(filebno >= NDIRECT + NINDIRECT)
  800bf3:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  800bf9:	77 49                	ja     800c44 <file_get_block+0x5a>
		return -E_INVAL;
    r = file_block_walk(f, filebno, &ppdiskbno, 1);
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	6a 01                	push   $0x1
  800c00:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	e8 15 fe ff ff       	call   800a20 <file_block_walk>
	if(r < 0)
  800c0b:	83 c4 10             	add    $0x10,%esp
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	78 30                	js     800c42 <file_get_block+0x58>
		return r;
	if(!*ppdiskbno){
  800c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c15:	83 38 00             	cmpl   $0x0,(%eax)
  800c18:	75 0e                	jne    800c28 <file_get_block+0x3e>
		r = alloc_block();
  800c1a:	e8 97 fd ff ff       	call   8009b6 <alloc_block>
		if(r < 0)
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	78 1f                	js     800c42 <file_get_block+0x58>
			return r;
		*ppdiskbno = r;
  800c23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c26:	89 02                	mov    %eax,(%edx)
	}
	*blk = diskaddr(*ppdiskbno);
  800c28:	83 ec 0c             	sub    $0xc,%esp
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2e:	ff 30                	pushl  (%eax)
  800c30:	e8 45 f6 ff ff       	call   80027a <diskaddr>
  800c35:	8b 55 10             	mov    0x10(%ebp),%edx
  800c38:	89 02                	mov    %eax,(%edx)
	return 0;
  800c3a:	83 c4 10             	add    $0x10,%esp
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
	// panic("file_get_block not implemented");
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    
		return -E_INVAL;
  800c44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c49:	eb f7                	jmp    800c42 <file_get_block+0x58>

00800c4b <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800c57:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800c5d:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
  800c63:	eb 03                	jmp    800c68 <walk_path+0x1d>
		p++;
  800c65:	83 c0 01             	add    $0x1,%eax
	while (*p == '/')
  800c68:	80 38 2f             	cmpb   $0x2f,(%eax)
  800c6b:	74 f8                	je     800c65 <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800c6d:	8b 0d 4c a0 80 00    	mov    0x80a04c,%ecx
  800c73:	83 c1 08             	add    $0x8,%ecx
  800c76:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800c7c:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800c83:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800c89:	85 c9                	test   %ecx,%ecx
  800c8b:	74 06                	je     800c93 <walk_path+0x48>
		*pdir = 0;
  800c8d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800c93:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800c99:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800ca4:	e9 c5 01 00 00       	jmp    800e6e <walk_path+0x223>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800ca9:	83 c6 01             	add    $0x1,%esi
		while (*path != '/' && *path != '\0')
  800cac:	0f b6 16             	movzbl (%esi),%edx
  800caf:	80 fa 2f             	cmp    $0x2f,%dl
  800cb2:	74 04                	je     800cb8 <walk_path+0x6d>
  800cb4:	84 d2                	test   %dl,%dl
  800cb6:	75 f1                	jne    800ca9 <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800cb8:	89 f3                	mov    %esi,%ebx
  800cba:	29 c3                	sub    %eax,%ebx
  800cbc:	83 fb 7f             	cmp    $0x7f,%ebx
  800cbf:	0f 8f 71 01 00 00    	jg     800e36 <walk_path+0x1eb>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800cc5:	83 ec 04             	sub    $0x4,%esp
  800cc8:	53                   	push   %ebx
  800cc9:	50                   	push   %eax
  800cca:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800cd0:	50                   	push   %eax
  800cd1:	e8 f0 19 00 00       	call   8026c6 <memmove>
		name[path - p] = '\0';
  800cd6:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800cdd:	00 
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	eb 03                	jmp    800ce6 <walk_path+0x9b>
		p++;
  800ce3:	83 c6 01             	add    $0x1,%esi
	while (*p == '/')
  800ce6:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800ce9:	74 f8                	je     800ce3 <walk_path+0x98>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800ceb:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800cf1:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800cf8:	0f 85 3f 01 00 00    	jne    800e3d <walk_path+0x1f2>
	assert((dir->f_size % BLKSIZE) == 0);
  800cfe:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800d04:	89 c1                	mov    %eax,%ecx
  800d06:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
  800d0c:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
  800d12:	0f 85 8e 00 00 00    	jne    800da6 <walk_path+0x15b>
	nblock = dir->f_size / BLKSIZE;
  800d18:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800d1e:	85 c0                	test   %eax,%eax
  800d20:	0f 48 c2             	cmovs  %edx,%eax
  800d23:	c1 f8 0c             	sar    $0xc,%eax
  800d26:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
			if (strcmp(f[j].f_name, name) == 0) {
  800d2c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
  800d32:	89 b5 44 ff ff ff    	mov    %esi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800d38:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800d3e:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800d44:	74 79                	je     800dbf <walk_path+0x174>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800d46:	83 ec 04             	sub    $0x4,%esp
  800d49:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800d4f:	50                   	push   %eax
  800d50:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800d56:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800d5c:	e8 89 fe ff ff       	call   800bea <file_get_block>
  800d61:	83 c4 10             	add    $0x10,%esp
  800d64:	85 c0                	test   %eax,%eax
  800d66:	0f 88 d8 00 00 00    	js     800e44 <walk_path+0x1f9>
  800d6c:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800d72:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
			if (strcmp(f[j].f_name, name) == 0) {
  800d78:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800d7e:	83 ec 08             	sub    $0x8,%esp
  800d81:	57                   	push   %edi
  800d82:	53                   	push   %ebx
  800d83:	e8 5b 18 00 00       	call   8025e3 <strcmp>
  800d88:	83 c4 10             	add    $0x10,%esp
  800d8b:	85 c0                	test   %eax,%eax
  800d8d:	0f 84 c1 00 00 00    	je     800e54 <walk_path+0x209>
  800d93:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800d99:	39 f3                	cmp    %esi,%ebx
  800d9b:	75 db                	jne    800d78 <walk_path+0x12d>
	for (i = 0; i < nblock; i++) {
  800d9d:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800da4:	eb 92                	jmp    800d38 <walk_path+0xed>
	assert((dir->f_size % BLKSIZE) == 0);
  800da6:	68 3c 44 80 00       	push   $0x80443c
  800dab:	68 bd 41 80 00       	push   $0x8041bd
  800db0:	68 d9 00 00 00       	push   $0xd9
  800db5:	68 a4 43 80 00       	push   $0x8043a4
  800dba:	e8 24 0f 00 00       	call   801ce3 <_panic>
  800dbf:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800dc5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800dca:	80 3e 00             	cmpb   $0x0,(%esi)
  800dcd:	75 5f                	jne    800e2e <walk_path+0x1e3>
				if (pdir)
  800dcf:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	74 08                	je     800de1 <walk_path+0x196>
					*pdir = dir;
  800dd9:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800ddf:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800de1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de5:	74 15                	je     800dfc <walk_path+0x1b1>
					strcpy(lastelem, name);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800df0:	50                   	push   %eax
  800df1:	ff 75 08             	pushl  0x8(%ebp)
  800df4:	e8 3f 17 00 00       	call   802538 <strcpy>
  800df9:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800dfc:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800e08:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800e0d:	eb 1f                	jmp    800e2e <walk_path+0x1e3>
		}
	}

	if (pdir)
  800e0f:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800e15:	85 c0                	test   %eax,%eax
  800e17:	74 02                	je     800e1b <walk_path+0x1d0>
		*pdir = dir;
  800e19:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800e1b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e21:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800e27:	89 08                	mov    %ecx,(%eax)
	return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    
			return -E_BAD_PATH;
  800e36:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800e3b:	eb f1                	jmp    800e2e <walk_path+0x1e3>
			return -E_NOT_FOUND;
  800e3d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800e42:	eb ea                	jmp    800e2e <walk_path+0x1e3>
  800e44:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800e4a:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800e4d:	75 df                	jne    800e2e <walk_path+0x1e3>
  800e4f:	e9 71 ff ff ff       	jmp    800dc5 <walk_path+0x17a>
  800e54:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
  800e5a:	89 f0                	mov    %esi,%eax
  800e5c:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800e62:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800e68:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	while (*path != '\0') {
  800e6e:	80 38 00             	cmpb   $0x0,(%eax)
  800e71:	74 9c                	je     800e0f <walk_path+0x1c4>
  800e73:	89 c6                	mov    %eax,%esi
  800e75:	e9 32 fe ff ff       	jmp    800cac <walk_path+0x61>

00800e7a <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("the path %s\n", path);
  800e84:	53                   	push   %ebx
  800e85:	68 59 44 80 00       	push   $0x804459
  800e8a:	e8 4a 0f 00 00       	call   801dd9 <cprintf>
	return walk_path(path, 0, pf, 0);
  800e8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9e:	89 d8                	mov    %ebx,%eax
  800ea0:	e8 a6 fd ff ff       	call   800c4b <walk_path>
}
  800ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
  800eb0:	83 ec 2c             	sub    $0x2c,%esp
  800eb3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800eb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb9:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800ec5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800eca:	39 ca                	cmp    %ecx,%edx
  800ecc:	7e 7e                	jle    800f4c <file_read+0xa2>

	count = MIN(count, f->f_size - offset);
  800ece:	29 ca                	sub    %ecx,%edx
  800ed0:	39 da                	cmp    %ebx,%edx
  800ed2:	89 d8                	mov    %ebx,%eax
  800ed4:	0f 46 c2             	cmovbe %edx,%eax
  800ed7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (pos = offset; pos < offset + count; ) {
  800eda:	89 cb                	mov    %ecx,%ebx
  800edc:	01 c1                	add    %eax,%ecx
  800ede:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800ee1:	89 de                	mov    %ebx,%esi
  800ee3:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800ee6:	76 61                	jbe    800f49 <file_read+0x9f>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800ee8:	83 ec 04             	sub    $0x4,%esp
  800eeb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800eee:	50                   	push   %eax
  800eef:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800ef5:	85 db                	test   %ebx,%ebx
  800ef7:	0f 49 c3             	cmovns %ebx,%eax
  800efa:	c1 f8 0c             	sar    $0xc,%eax
  800efd:	50                   	push   %eax
  800efe:	ff 75 08             	pushl  0x8(%ebp)
  800f01:	e8 e4 fc ff ff       	call   800bea <file_get_block>
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	78 3f                	js     800f4c <file_read+0xa2>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f0d:	89 da                	mov    %ebx,%edx
  800f0f:	c1 fa 1f             	sar    $0x1f,%edx
  800f12:	c1 ea 14             	shr    $0x14,%edx
  800f15:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800f18:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f1d:	29 d0                	sub    %edx,%eax
  800f1f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800f24:	29 c2                	sub    %eax,%edx
  800f26:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800f29:	29 f1                	sub    %esi,%ecx
  800f2b:	89 ce                	mov    %ecx,%esi
  800f2d:	39 ca                	cmp    %ecx,%edx
  800f2f:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800f32:	83 ec 04             	sub    $0x4,%esp
  800f35:	56                   	push   %esi
  800f36:	03 45 e4             	add    -0x1c(%ebp),%eax
  800f39:	50                   	push   %eax
  800f3a:	57                   	push   %edi
  800f3b:	e8 86 17 00 00       	call   8026c6 <memmove>
		pos += bn;
  800f40:	01 f3                	add    %esi,%ebx
		buf += bn;
  800f42:	01 f7                	add    %esi,%edi
  800f44:	83 c4 10             	add    $0x10,%esp
  800f47:	eb 98                	jmp    800ee1 <file_read+0x37>
	}
	return count;
  800f49:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4f:	5b                   	pop    %ebx
  800f50:	5e                   	pop    %esi
  800f51:	5f                   	pop    %edi
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    

00800f54 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	57                   	push   %edi
  800f58:	56                   	push   %esi
  800f59:	53                   	push   %ebx
  800f5a:	83 ec 2c             	sub    $0x2c,%esp
  800f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800f60:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (f->f_size > newsize)
  800f63:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800f69:	39 f8                	cmp    %edi,%eax
  800f6b:	7f 1c                	jg     800f89 <file_set_size+0x35>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800f6d:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
	flush_block(f);
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	53                   	push   %ebx
  800f77:	e8 94 f3 ff ff       	call   800310 <flush_block>
	return 0;
}
  800f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800f89:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800f8f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f94:	0f 48 c2             	cmovs  %edx,%eax
  800f97:	c1 f8 0c             	sar    $0xc,%eax
  800f9a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800f9d:	8d 87 fe 1f 00 00    	lea    0x1ffe(%edi),%eax
  800fa3:	89 fa                	mov    %edi,%edx
  800fa5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800fab:	0f 49 c2             	cmovns %edx,%eax
  800fae:	c1 f8 0c             	sar    $0xc,%eax
  800fb1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800fb4:	89 c6                	mov    %eax,%esi
  800fb6:	eb 3c                	jmp    800ff4 <file_set_size+0xa0>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800fb8:	83 7d d0 0a          	cmpl   $0xa,-0x30(%ebp)
  800fbc:	77 af                	ja     800f6d <file_set_size+0x19>
  800fbe:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	74 a5                	je     800f6d <file_set_size+0x19>
		free_block(f->f_indirect);
  800fc8:	83 ec 0c             	sub    $0xc,%esp
  800fcb:	50                   	push   %eax
  800fcc:	e8 a9 f9 ff ff       	call   80097a <free_block>
		f->f_indirect = 0;
  800fd1:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
  800fd8:	00 00 00 
  800fdb:	83 c4 10             	add    $0x10,%esp
  800fde:	eb 8d                	jmp    800f6d <file_set_size+0x19>
			cprintf("warning: file_free_block: %e", r);
  800fe0:	83 ec 08             	sub    $0x8,%esp
  800fe3:	50                   	push   %eax
  800fe4:	68 66 44 80 00       	push   $0x804466
  800fe9:	e8 eb 0d 00 00       	call   801dd9 <cprintf>
  800fee:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ff1:	83 c6 01             	add    $0x1,%esi
  800ff4:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800ff7:	76 bf                	jbe    800fb8 <file_set_size+0x64>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800ff9:	83 ec 0c             	sub    $0xc,%esp
  800ffc:	6a 00                	push   $0x0
  800ffe:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  801001:	89 f2                	mov    %esi,%edx
  801003:	89 d8                	mov    %ebx,%eax
  801005:	e8 16 fa ff ff       	call   800a20 <file_block_walk>
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	85 c0                	test   %eax,%eax
  80100f:	78 cf                	js     800fe0 <file_set_size+0x8c>
	if (*ptr) {
  801011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801014:	8b 00                	mov    (%eax),%eax
  801016:	85 c0                	test   %eax,%eax
  801018:	74 d7                	je     800ff1 <file_set_size+0x9d>
		free_block(*ptr);
  80101a:	83 ec 0c             	sub    $0xc,%esp
  80101d:	50                   	push   %eax
  80101e:	e8 57 f9 ff ff       	call   80097a <free_block>
		*ptr = 0;
  801023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801026:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80102c:	83 c4 10             	add    $0x10,%esp
  80102f:	eb c0                	jmp    800ff1 <file_set_size+0x9d>

00801031 <file_write>:
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	57                   	push   %edi
  801035:	56                   	push   %esi
  801036:	53                   	push   %ebx
  801037:	83 ec 2c             	sub    $0x2c,%esp
  80103a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80103d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  801040:	89 d8                	mov    %ebx,%eax
  801042:	03 45 10             	add    0x10(%ebp),%eax
  801045:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801048:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104b:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  801051:	77 68                	ja     8010bb <file_write+0x8a>
	for (pos = offset; pos < offset + count; ) {
  801053:	89 de                	mov    %ebx,%esi
  801055:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  801058:	76 74                	jbe    8010ce <file_write+0x9d>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  80105a:	83 ec 04             	sub    $0x4,%esp
  80105d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801060:	50                   	push   %eax
  801061:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801067:	85 db                	test   %ebx,%ebx
  801069:	0f 49 c3             	cmovns %ebx,%eax
  80106c:	c1 f8 0c             	sar    $0xc,%eax
  80106f:	50                   	push   %eax
  801070:	ff 75 08             	pushl  0x8(%ebp)
  801073:	e8 72 fb ff ff       	call   800bea <file_get_block>
  801078:	83 c4 10             	add    $0x10,%esp
  80107b:	85 c0                	test   %eax,%eax
  80107d:	78 52                	js     8010d1 <file_write+0xa0>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  80107f:	89 da                	mov    %ebx,%edx
  801081:	c1 fa 1f             	sar    $0x1f,%edx
  801084:	c1 ea 14             	shr    $0x14,%edx
  801087:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  80108a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80108f:	29 d0                	sub    %edx,%eax
  801091:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801096:	29 c1                	sub    %eax,%ecx
  801098:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80109b:	29 f2                	sub    %esi,%edx
  80109d:	39 d1                	cmp    %edx,%ecx
  80109f:	89 d6                	mov    %edx,%esi
  8010a1:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  8010a4:	83 ec 04             	sub    $0x4,%esp
  8010a7:	56                   	push   %esi
  8010a8:	57                   	push   %edi
  8010a9:	03 45 e4             	add    -0x1c(%ebp),%eax
  8010ac:	50                   	push   %eax
  8010ad:	e8 14 16 00 00       	call   8026c6 <memmove>
		pos += bn;
  8010b2:	01 f3                	add    %esi,%ebx
		buf += bn;
  8010b4:	01 f7                	add    %esi,%edi
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	eb 98                	jmp    801053 <file_write+0x22>
		if ((r = file_set_size(f, offset + count)) < 0)
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	50                   	push   %eax
  8010bf:	51                   	push   %ecx
  8010c0:	e8 8f fe ff ff       	call   800f54 <file_set_size>
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	79 87                	jns    801053 <file_write+0x22>
  8010cc:	eb 03                	jmp    8010d1 <file_write+0xa0>
	return count;
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
}
  8010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	56                   	push   %esi
  8010dd:	53                   	push   %ebx
  8010de:	83 ec 10             	sub    $0x10,%esp
  8010e1:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  8010e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e9:	eb 03                	jmp    8010ee <file_flush+0x15>
  8010eb:	83 c3 01             	add    $0x1,%ebx
  8010ee:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  8010f4:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8010fa:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  801100:	85 c9                	test   %ecx,%ecx
  801102:	0f 49 c1             	cmovns %ecx,%eax
  801105:	c1 f8 0c             	sar    $0xc,%eax
  801108:	39 d8                	cmp    %ebx,%eax
  80110a:	7e 3b                	jle    801147 <file_flush+0x6e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	6a 00                	push   $0x0
  801111:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  801114:	89 da                	mov    %ebx,%edx
  801116:	89 f0                	mov    %esi,%eax
  801118:	e8 03 f9 ff ff       	call   800a20 <file_block_walk>
  80111d:	83 c4 10             	add    $0x10,%esp
  801120:	85 c0                	test   %eax,%eax
  801122:	78 c7                	js     8010eb <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801127:	85 c0                	test   %eax,%eax
  801129:	74 c0                	je     8010eb <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	85 c0                	test   %eax,%eax
  80112f:	74 ba                	je     8010eb <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	50                   	push   %eax
  801135:	e8 40 f1 ff ff       	call   80027a <diskaddr>
  80113a:	89 04 24             	mov    %eax,(%esp)
  80113d:	e8 ce f1 ff ff       	call   800310 <flush_block>
  801142:	83 c4 10             	add    $0x10,%esp
  801145:	eb a4                	jmp    8010eb <file_flush+0x12>
	}
	flush_block(f);
  801147:	83 ec 0c             	sub    $0xc,%esp
  80114a:	56                   	push   %esi
  80114b:	e8 c0 f1 ff ff       	call   800310 <flush_block>
	if (f->f_indirect)
  801150:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	85 c0                	test   %eax,%eax
  80115b:	75 07                	jne    801164 <file_flush+0x8b>
		flush_block(diskaddr(f->f_indirect));
}
  80115d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801160:	5b                   	pop    %ebx
  801161:	5e                   	pop    %esi
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  801164:	83 ec 0c             	sub    $0xc,%esp
  801167:	50                   	push   %eax
  801168:	e8 0d f1 ff ff       	call   80027a <diskaddr>
  80116d:	89 04 24             	mov    %eax,(%esp)
  801170:	e8 9b f1 ff ff       	call   800310 <flush_block>
  801175:	83 c4 10             	add    $0x10,%esp
}
  801178:	eb e3                	jmp    80115d <file_flush+0x84>

0080117a <file_create>:
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	57                   	push   %edi
  80117e:	56                   	push   %esi
  80117f:	53                   	push   %ebx
  801180:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801186:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80118c:	50                   	push   %eax
  80118d:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  801193:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	e8 aa fa ff ff       	call   800c4b <walk_path>
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	0f 84 0b 01 00 00    	je     8012b7 <file_create+0x13d>
	if (r != -E_NOT_FOUND || dir == 0)
  8011ac:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8011af:	0f 85 ca 00 00 00    	jne    80127f <file_create+0x105>
  8011b5:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  8011bb:	85 f6                	test   %esi,%esi
  8011bd:	0f 84 bc 00 00 00    	je     80127f <file_create+0x105>
	assert((dir->f_size % BLKSIZE) == 0);
  8011c3:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  8011c9:	89 c3                	mov    %eax,%ebx
  8011cb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  8011d1:	75 57                	jne    80122a <file_create+0xb0>
	nblock = dir->f_size / BLKSIZE;
  8011d3:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	0f 48 c2             	cmovs  %edx,%eax
  8011de:	c1 f8 0c             	sar    $0xc,%eax
  8011e1:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8011e7:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  8011ed:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  8011f3:	0f 84 8e 00 00 00    	je     801287 <file_create+0x10d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8011f9:	83 ec 04             	sub    $0x4,%esp
  8011fc:	57                   	push   %edi
  8011fd:	53                   	push   %ebx
  8011fe:	56                   	push   %esi
  8011ff:	e8 e6 f9 ff ff       	call   800bea <file_get_block>
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	85 c0                	test   %eax,%eax
  801209:	78 74                	js     80127f <file_create+0x105>
  80120b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801211:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  801217:	80 38 00             	cmpb   $0x0,(%eax)
  80121a:	74 27                	je     801243 <file_create+0xc9>
  80121c:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  801221:	39 d0                	cmp    %edx,%eax
  801223:	75 f2                	jne    801217 <file_create+0x9d>
	for (i = 0; i < nblock; i++) {
  801225:	83 c3 01             	add    $0x1,%ebx
  801228:	eb c3                	jmp    8011ed <file_create+0x73>
	assert((dir->f_size % BLKSIZE) == 0);
  80122a:	68 3c 44 80 00       	push   $0x80443c
  80122f:	68 bd 41 80 00       	push   $0x8041bd
  801234:	68 f2 00 00 00       	push   $0xf2
  801239:	68 a4 43 80 00       	push   $0x8043a4
  80123e:	e8 a0 0a 00 00       	call   801ce3 <_panic>
				*file = &f[j];
  801243:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801259:	e8 da 12 00 00       	call   802538 <strcpy>
	*pf = f;
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801267:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801269:	83 c4 04             	add    $0x4,%esp
  80126c:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  801272:	e8 62 fe ff ff       	call   8010d9 <file_flush>
	return 0;
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801282:	5b                   	pop    %ebx
  801283:	5e                   	pop    %esi
  801284:	5f                   	pop    %edi
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    
	dir->f_size += BLKSIZE;
  801287:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  80128e:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801291:	83 ec 04             	sub    $0x4,%esp
  801294:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  80129a:	50                   	push   %eax
  80129b:	53                   	push   %ebx
  80129c:	56                   	push   %esi
  80129d:	e8 48 f9 ff ff       	call   800bea <file_get_block>
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	78 d6                	js     80127f <file_create+0x105>
	*file = &f[0];
  8012a9:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8012af:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8012b5:	eb 92                	jmp    801249 <file_create+0xcf>
		return -E_FILE_EXISTS;
  8012b7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8012bc:	eb c1                	jmp    80127f <file_create+0x105>

008012be <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8012c5:	bb 01 00 00 00       	mov    $0x1,%ebx
  8012ca:	a1 4c a0 80 00       	mov    0x80a04c,%eax
  8012cf:	39 58 04             	cmp    %ebx,0x4(%eax)
  8012d2:	76 19                	jbe    8012ed <fs_sync+0x2f>
		flush_block(diskaddr(i));
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	53                   	push   %ebx
  8012d8:	e8 9d ef ff ff       	call   80027a <diskaddr>
  8012dd:	89 04 24             	mov    %eax,(%esp)
  8012e0:	e8 2b f0 ff ff       	call   800310 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  8012e5:	83 c3 01             	add    $0x1,%ebx
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	eb dd                	jmp    8012ca <fs_sync+0xc>
}
  8012ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  8012f8:	e8 c1 ff ff ff       	call   8012be <fs_sync>
	return 0;
}
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <serve_init>:
{
  801304:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  801309:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80130e:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801313:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801315:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801318:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80131e:	83 c0 01             	add    $0x1,%eax
  801321:	83 c2 10             	add    $0x10,%edx
  801324:	3d 00 04 00 00       	cmp    $0x400,%eax
  801329:	75 e8                	jne    801313 <serve_init+0xf>
}
  80132b:	c3                   	ret    

0080132c <openfile_alloc>:
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	83 ec 0c             	sub    $0xc,%esp
  801335:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  801338:	bb 00 00 00 00       	mov    $0x0,%ebx
  80133d:	89 de                	mov    %ebx,%esi
  80133f:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  801342:	83 ec 0c             	sub    $0xc,%esp
  801345:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  80134b:	e8 6c 22 00 00       	call   8035bc <pageref>
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	85 c0                	test   %eax,%eax
  801355:	74 17                	je     80136e <openfile_alloc+0x42>
  801357:	83 f8 01             	cmp    $0x1,%eax
  80135a:	74 30                	je     80138c <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  80135c:	83 c3 01             	add    $0x1,%ebx
  80135f:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801365:	75 d6                	jne    80133d <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  801367:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80136c:	eb 4f                	jmp    8013bd <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	6a 07                	push   $0x7
  801373:	89 d8                	mov    %ebx,%eax
  801375:	c1 e0 04             	shl    $0x4,%eax
  801378:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  80137e:	6a 00                	push   $0x0
  801380:	e8 a5 15 00 00       	call   80292a <sys_page_alloc>
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	85 c0                	test   %eax,%eax
  80138a:	78 31                	js     8013bd <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  80138c:	c1 e3 04             	shl    $0x4,%ebx
  80138f:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  801396:	04 00 00 
			*o = &opentab[i];
  801399:	81 c6 60 50 80 00    	add    $0x805060,%esi
  80139f:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8013a1:	83 ec 04             	sub    $0x4,%esp
  8013a4:	68 00 10 00 00       	push   $0x1000
  8013a9:	6a 00                	push   $0x0
  8013ab:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  8013b1:	e8 c8 12 00 00       	call   80267e <memset>
			return (*o)->o_fileid;
  8013b6:	8b 07                	mov    (%edi),%eax
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
}
  8013bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5f                   	pop    %edi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    

008013c5 <openfile_lookup>:
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	57                   	push   %edi
  8013c9:	56                   	push   %esi
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 18             	sub    $0x18,%esp
  8013ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  8013d1:	89 fb                	mov    %edi,%ebx
  8013d3:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8013d9:	89 de                	mov    %ebx,%esi
  8013db:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8013de:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  8013e4:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8013ea:	e8 cd 21 00 00       	call   8035bc <pageref>
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	83 f8 01             	cmp    $0x1,%eax
  8013f5:	7e 1d                	jle    801414 <openfile_lookup+0x4f>
  8013f7:	c1 e3 04             	shl    $0x4,%ebx
  8013fa:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  801400:	75 19                	jne    80141b <openfile_lookup+0x56>
	*po = o;
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	89 30                	mov    %esi,(%eax)
	return 0;
  801407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80140f:	5b                   	pop    %ebx
  801410:	5e                   	pop    %esi
  801411:	5f                   	pop    %edi
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    
		return -E_INVAL;
  801414:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801419:	eb f1                	jmp    80140c <openfile_lookup+0x47>
  80141b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801420:	eb ea                	jmp    80140c <openfile_lookup+0x47>

00801422 <serve_set_size>:
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	53                   	push   %ebx
  801426:	83 ec 18             	sub    $0x18,%esp
  801429:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80142c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142f:	50                   	push   %eax
  801430:	ff 33                	pushl  (%ebx)
  801432:	ff 75 08             	pushl  0x8(%ebp)
  801435:	e8 8b ff ff ff       	call   8013c5 <openfile_lookup>
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	85 c0                	test   %eax,%eax
  80143f:	78 14                	js     801455 <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801441:	83 ec 08             	sub    $0x8,%esp
  801444:	ff 73 04             	pushl  0x4(%ebx)
  801447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144a:	ff 70 04             	pushl  0x4(%eax)
  80144d:	e8 02 fb ff ff       	call   800f54 <file_set_size>
  801452:	83 c4 10             	add    $0x10,%esp
}
  801455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <serve_read>:
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	53                   	push   %ebx
  80145e:	83 ec 18             	sub    $0x18,%esp
  801461:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	r =	openfile_lookup(envid, req->req_fileid, &open_file);
  801464:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801467:	50                   	push   %eax
  801468:	ff 33                	pushl  (%ebx)
  80146a:	ff 75 08             	pushl  0x8(%ebp)
  80146d:	e8 53 ff ff ff       	call   8013c5 <openfile_lookup>
	if(r < 0)
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	78 33                	js     8014ac <serve_read+0x52>
	r = file_read(open_file->o_file, ret->ret_buf, MIN(req->req_n, sizeof(ret->ret_buf)), open_file->o_fd->fd_offset);
  801479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147c:	8b 42 0c             	mov    0xc(%edx),%eax
  80147f:	ff 70 04             	pushl  0x4(%eax)
  801482:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  801489:	b8 00 10 00 00       	mov    $0x1000,%eax
  80148e:	0f 46 43 04          	cmovbe 0x4(%ebx),%eax
  801492:	50                   	push   %eax
  801493:	53                   	push   %ebx
  801494:	ff 72 04             	pushl  0x4(%edx)
  801497:	e8 0e fa ff ff       	call   800eaa <file_read>
	if(r < 0)
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 09                	js     8014ac <serve_read+0x52>
	open_file->o_fd->fd_offset += r;
  8014a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a6:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a9:	01 42 04             	add    %eax,0x4(%edx)
}
  8014ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <serve_write>:
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	53                   	push   %ebx
  8014b5:	83 ec 18             	sub    $0x18,%esp
  8014b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	r =	openfile_lookup(envid, req->req_fileid, &open_file);
  8014bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014be:	50                   	push   %eax
  8014bf:	ff 33                	pushl  (%ebx)
  8014c1:	ff 75 08             	pushl  0x8(%ebp)
  8014c4:	e8 fc fe ff ff       	call   8013c5 <openfile_lookup>
	if(r < 0)
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 28                	js     8014f8 <serve_write+0x47>
			req->req_n, open_file->o_fd->fd_offset);
  8014d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
	r = file_write(open_file->o_file, req->req_buf, 
  8014d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8014d6:	ff 72 04             	pushl  0x4(%edx)
  8014d9:	ff 73 04             	pushl  0x4(%ebx)
  8014dc:	83 c3 08             	add    $0x8,%ebx
  8014df:	53                   	push   %ebx
  8014e0:	ff 70 04             	pushl  0x4(%eax)
  8014e3:	e8 49 fb ff ff       	call   801031 <file_write>
	if(r < 0)
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 09                	js     8014f8 <serve_write+0x47>
	open_file->o_fd->fd_offset += r;
  8014ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8014f5:	01 42 04             	add    %eax,0x4(%edx)
}
  8014f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <serve_stat>:
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	53                   	push   %ebx
  801501:	83 ec 18             	sub    $0x18,%esp
  801504:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801507:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150a:	50                   	push   %eax
  80150b:	ff 33                	pushl  (%ebx)
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	e8 b0 fe ff ff       	call   8013c5 <openfile_lookup>
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	85 c0                	test   %eax,%eax
  80151a:	78 3f                	js     80155b <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  80151c:	83 ec 08             	sub    $0x8,%esp
  80151f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801522:	ff 70 04             	pushl  0x4(%eax)
  801525:	53                   	push   %ebx
  801526:	e8 0d 10 00 00       	call   802538 <strcpy>
	ret->ret_size = o->o_file->f_size;
  80152b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152e:	8b 50 04             	mov    0x4(%eax),%edx
  801531:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  801537:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80153d:	8b 40 04             	mov    0x4(%eax),%eax
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80154a:	0f 94 c0             	sete   %al
  80154d:	0f b6 c0             	movzbl %al,%eax
  801550:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <serve_flush>:
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801566:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801569:	50                   	push   %eax
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	ff 30                	pushl  (%eax)
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	e8 4e fe ff ff       	call   8013c5 <openfile_lookup>
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	78 16                	js     801594 <serve_flush+0x34>
	file_flush(o->o_file);
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801584:	ff 70 04             	pushl  0x4(%eax)
  801587:	e8 4d fb ff ff       	call   8010d9 <file_flush>
	return 0;
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <serve_open>:
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	53                   	push   %ebx
  80159a:	81 ec 18 04 00 00    	sub    $0x418,%esp
  8015a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  8015a3:	68 00 04 00 00       	push   $0x400
  8015a8:	53                   	push   %ebx
  8015a9:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	e8 11 11 00 00       	call   8026c6 <memmove>
	path[MAXPATHLEN-1] = 0;
  8015b5:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  8015b9:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8015bf:	89 04 24             	mov    %eax,(%esp)
  8015c2:	e8 65 fd ff ff       	call   80132c <openfile_alloc>
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	0f 88 f0 00 00 00    	js     8016c2 <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  8015d2:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8015d9:	74 33                	je     80160e <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015e4:	50                   	push   %eax
  8015e5:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015eb:	50                   	push   %eax
  8015ec:	e8 89 fb ff ff       	call   80117a <file_create>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	79 37                	jns    80162f <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8015f8:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  8015ff:	0f 85 bd 00 00 00    	jne    8016c2 <serve_open+0x12c>
  801605:	83 f8 f3             	cmp    $0xfffffff3,%eax
  801608:	0f 85 b4 00 00 00    	jne    8016c2 <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801617:	50                   	push   %eax
  801618:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80161e:	50                   	push   %eax
  80161f:	e8 56 f8 ff ff       	call   800e7a <file_open>
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	85 c0                	test   %eax,%eax
  801629:	0f 88 93 00 00 00    	js     8016c2 <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  80162f:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  801636:	74 17                	je     80164f <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  801638:	83 ec 08             	sub    $0x8,%esp
  80163b:	6a 00                	push   $0x0
  80163d:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  801643:	e8 0c f9 ff ff       	call   800f54 <file_set_size>
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	85 c0                	test   %eax,%eax
  80164d:	78 73                	js     8016c2 <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  80164f:	83 ec 08             	sub    $0x8,%esp
  801652:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801658:	50                   	push   %eax
  801659:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80165f:	50                   	push   %eax
  801660:	e8 15 f8 ff ff       	call   800e7a <file_open>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	85 c0                	test   %eax,%eax
  80166a:	78 56                	js     8016c2 <serve_open+0x12c>
	o->o_file = f;
  80166c:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801672:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801678:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  80167b:	8b 50 0c             	mov    0xc(%eax),%edx
  80167e:	8b 08                	mov    (%eax),%ecx
  801680:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801683:	8b 48 0c             	mov    0xc(%eax),%ecx
  801686:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80168c:	83 e2 03             	and    $0x3,%edx
  80168f:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801692:	8b 40 0c             	mov    0xc(%eax),%eax
  801695:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80169b:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  80169d:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8016a3:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  8016a9:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  8016ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8016b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b7:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  8016bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	56                   	push   %esi
  8016cb:	53                   	push   %ebx
  8016cc:	83 ec 18             	sub    $0x18,%esp
	cprintf("in %s\n", __FUNCTION__);
  8016cf:	68 10 45 80 00       	push   $0x804510
  8016d4:	68 78 47 80 00       	push   $0x804778
  8016d9:	e8 fb 06 00 00       	call   801dd9 <cprintf>
  8016de:	83 c4 10             	add    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016e1:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8016e4:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8016e7:	e9 82 00 00 00       	jmp    80176e <serve+0xa7>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  8016ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8016f3:	83 f8 01             	cmp    $0x1,%eax
  8016f6:	74 23                	je     80171b <serve+0x54>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  8016f8:	83 f8 08             	cmp    $0x8,%eax
  8016fb:	77 36                	ja     801733 <serve+0x6c>
  8016fd:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  801704:	85 d2                	test   %edx,%edx
  801706:	74 2b                	je     801733 <serve+0x6c>
			r = handlers[req](whom, fsreq);
  801708:	83 ec 08             	sub    $0x8,%esp
  80170b:	ff 35 44 50 80 00    	pushl  0x805044
  801711:	ff 75 f4             	pushl  -0xc(%ebp)
  801714:	ff d2                	call   *%edx
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	eb 31                	jmp    80174c <serve+0x85>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  80171b:	53                   	push   %ebx
  80171c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80171f:	50                   	push   %eax
  801720:	ff 35 44 50 80 00    	pushl  0x805044
  801726:	ff 75 f4             	pushl  -0xc(%ebp)
  801729:	e8 68 fe ff ff       	call   801596 <serve_open>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	eb 19                	jmp    80174c <serve+0x85>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	ff 75 f4             	pushl  -0xc(%ebp)
  801739:	50                   	push   %eax
  80173a:	68 e4 44 80 00       	push   $0x8044e4
  80173f:	e8 95 06 00 00       	call   801dd9 <cprintf>
  801744:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801747:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80174c:	ff 75 f0             	pushl  -0x10(%ebp)
  80174f:	ff 75 ec             	pushl  -0x14(%ebp)
  801752:	50                   	push   %eax
  801753:	ff 75 f4             	pushl  -0xc(%ebp)
  801756:	e8 a2 15 00 00       	call   802cfd <ipc_send>
		sys_page_unmap(0, fsreq);
  80175b:	83 c4 08             	add    $0x8,%esp
  80175e:	ff 35 44 50 80 00    	pushl  0x805044
  801764:	6a 00                	push   $0x0
  801766:	e8 44 12 00 00       	call   8029af <sys_page_unmap>
  80176b:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  80176e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	53                   	push   %ebx
  801779:	ff 35 44 50 80 00    	pushl  0x805044
  80177f:	56                   	push   %esi
  801780:	e8 0f 15 00 00       	call   802c94 <ipc_recv>
		if (!(perm & PTE_P)) {
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  80178c:	0f 85 5a ff ff ff    	jne    8016ec <serve+0x25>
			cprintf("Invalid request from %08x: no argument page\n",
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	ff 75 f4             	pushl  -0xc(%ebp)
  801798:	68 b4 44 80 00       	push   $0x8044b4
  80179d:	e8 37 06 00 00       	call   801dd9 <cprintf>
			continue; // just leave it hanging...
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	eb c7                	jmp    80176e <serve+0xa7>

008017a7 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 10             	sub    $0x10,%esp
	cprintf("in serv.c %s\n", __FUNCTION__);
  8017ad:	68 08 45 80 00       	push   $0x804508
  8017b2:	68 83 44 80 00       	push   $0x804483
  8017b7:	e8 1d 06 00 00       	call   801dd9 <cprintf>
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8017bc:	c7 05 60 90 80 00 91 	movl   $0x804491,0x809060
  8017c3:	44 80 00 
	cprintf("FS is running\n");
  8017c6:	c7 04 24 94 44 80 00 	movl   $0x804494,(%esp)
  8017cd:	e8 07 06 00 00       	call   801dd9 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8017d2:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8017d7:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8017dc:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8017de:	c7 04 24 a3 44 80 00 	movl   $0x8044a3,(%esp)
  8017e5:	e8 ef 05 00 00       	call   801dd9 <cprintf>

	serve_init();
  8017ea:	e8 15 fb ff ff       	call   801304 <serve_init>
	fs_init();
  8017ef:	e8 97 f3 ff ff       	call   800b8b <fs_init>
	serve();
  8017f4:	e8 ce fe ff ff       	call   8016c7 <serve>

008017f9 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	53                   	push   %ebx
  8017fd:	83 ec 1c             	sub    $0x1c,%esp
	cprintf("in %s\n", __FUNCTION__);
  801800:	68 48 47 80 00       	push   $0x804748
  801805:	68 78 47 80 00       	push   $0x804778
  80180a:	e8 ca 05 00 00       	call   801dd9 <cprintf>
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80180f:	83 c4 0c             	add    $0xc,%esp
  801812:	6a 07                	push   $0x7
  801814:	68 00 10 00 00       	push   $0x1000
  801819:	6a 00                	push   $0x0
  80181b:	e8 0a 11 00 00       	call   80292a <sys_page_alloc>
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	85 c0                	test   %eax,%eax
  801825:	0f 88 68 02 00 00    	js     801a93 <fs_test+0x29a>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 00 10 00 00       	push   $0x1000
  801833:	ff 35 48 a0 80 00    	pushl  0x80a048
  801839:	68 00 10 00 00       	push   $0x1000
  80183e:	e8 83 0e 00 00       	call   8026c6 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801843:	e8 6e f1 ff ff       	call   8009b6 <alloc_block>
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	85 c0                	test   %eax,%eax
  80184d:	0f 88 52 02 00 00    	js     801aa5 <fs_test+0x2ac>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801853:	8d 50 1f             	lea    0x1f(%eax),%edx
  801856:	0f 49 d0             	cmovns %eax,%edx
  801859:	c1 fa 05             	sar    $0x5,%edx
  80185c:	89 c3                	mov    %eax,%ebx
  80185e:	c1 fb 1f             	sar    $0x1f,%ebx
  801861:	c1 eb 1b             	shr    $0x1b,%ebx
  801864:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  801867:	83 e1 1f             	and    $0x1f,%ecx
  80186a:	29 d9                	sub    %ebx,%ecx
  80186c:	b8 01 00 00 00       	mov    $0x1,%eax
  801871:	d3 e0                	shl    %cl,%eax
  801873:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  80187a:	0f 84 37 02 00 00    	je     801ab7 <fs_test+0x2be>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801880:	8b 0d 48 a0 80 00    	mov    0x80a048,%ecx
  801886:	85 04 91             	test   %eax,(%ecx,%edx,4)
  801889:	0f 85 3e 02 00 00    	jne    801acd <fs_test+0x2d4>
	cprintf("alloc_block is good\n");
  80188f:	83 ec 0c             	sub    $0xc,%esp
  801892:	68 5e 45 80 00       	push   $0x80455e
  801897:	e8 3d 05 00 00       	call   801dd9 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  80189c:	83 c4 08             	add    $0x8,%esp
  80189f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a2:	50                   	push   %eax
  8018a3:	68 73 45 80 00       	push   $0x804573
  8018a8:	e8 cd f5 ff ff       	call   800e7a <file_open>
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8018b3:	74 08                	je     8018bd <fs_test+0xc4>
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	0f 88 26 02 00 00    	js     801ae3 <fs_test+0x2ea>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	0f 84 30 02 00 00    	je     801af5 <fs_test+0x2fc>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  8018c5:	83 ec 08             	sub    $0x8,%esp
  8018c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cb:	50                   	push   %eax
  8018cc:	68 97 45 80 00       	push   $0x804597
  8018d1:	e8 a4 f5 ff ff       	call   800e7a <file_open>
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	0f 88 28 02 00 00    	js     801b09 <fs_test+0x310>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  8018e1:	83 ec 0c             	sub    $0xc,%esp
  8018e4:	68 b7 45 80 00       	push   $0x8045b7
  8018e9:	e8 eb 04 00 00       	call   801dd9 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018ee:	83 c4 0c             	add    $0xc,%esp
  8018f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f4:	50                   	push   %eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fa:	e8 eb f2 ff ff       	call   800bea <file_get_block>
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	85 c0                	test   %eax,%eax
  801904:	0f 88 11 02 00 00    	js     801b1b <fs_test+0x322>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  80190a:	83 ec 08             	sub    $0x8,%esp
  80190d:	68 fc 46 80 00       	push   $0x8046fc
  801912:	ff 75 f0             	pushl  -0x10(%ebp)
  801915:	e8 c9 0c 00 00       	call   8025e3 <strcmp>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	85 c0                	test   %eax,%eax
  80191f:	0f 85 08 02 00 00    	jne    801b2d <fs_test+0x334>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	68 dd 45 80 00       	push   $0x8045dd
  80192d:	e8 a7 04 00 00       	call   801dd9 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801935:	0f b6 10             	movzbl (%eax),%edx
  801938:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193d:	c1 e8 0c             	shr    $0xc,%eax
  801940:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	a8 40                	test   $0x40,%al
  80194c:	0f 84 ef 01 00 00    	je     801b41 <fs_test+0x348>
	file_flush(f);
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	ff 75 f4             	pushl  -0xc(%ebp)
  801958:	e8 7c f7 ff ff       	call   8010d9 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80195d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801960:	c1 e8 0c             	shr    $0xc,%eax
  801963:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	a8 40                	test   $0x40,%al
  80196f:	0f 85 e2 01 00 00    	jne    801b57 <fs_test+0x35e>
	cprintf("file_flush is good\n");
  801975:	83 ec 0c             	sub    $0xc,%esp
  801978:	68 11 46 80 00       	push   $0x804611
  80197d:	e8 57 04 00 00       	call   801dd9 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801982:	83 c4 08             	add    $0x8,%esp
  801985:	6a 00                	push   $0x0
  801987:	ff 75 f4             	pushl  -0xc(%ebp)
  80198a:	e8 c5 f5 ff ff       	call   800f54 <file_set_size>
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	0f 88 d3 01 00 00    	js     801b6d <fs_test+0x374>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  80199a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199d:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  8019a4:	0f 85 d5 01 00 00    	jne    801b7f <fs_test+0x386>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019aa:	c1 e8 0c             	shr    $0xc,%eax
  8019ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019b4:	a8 40                	test   $0x40,%al
  8019b6:	0f 85 d9 01 00 00    	jne    801b95 <fs_test+0x39c>
	cprintf("file_truncate is good\n");
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	68 65 46 80 00       	push   $0x804665
  8019c4:	e8 10 04 00 00       	call   801dd9 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8019c9:	c7 04 24 fc 46 80 00 	movl   $0x8046fc,(%esp)
  8019d0:	e8 2a 0b 00 00       	call   8024ff <strlen>
  8019d5:	83 c4 08             	add    $0x8,%esp
  8019d8:	50                   	push   %eax
  8019d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019dc:	e8 73 f5 ff ff       	call   800f54 <file_set_size>
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	0f 88 bf 01 00 00    	js     801bab <fs_test+0x3b2>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ef:	89 c2                	mov    %eax,%edx
  8019f1:	c1 ea 0c             	shr    $0xc,%edx
  8019f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019fb:	f6 c2 40             	test   $0x40,%dl
  8019fe:	0f 85 b9 01 00 00    	jne    801bbd <fs_test+0x3c4>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801a0a:	52                   	push   %edx
  801a0b:	6a 00                	push   $0x0
  801a0d:	50                   	push   %eax
  801a0e:	e8 d7 f1 ff ff       	call   800bea <file_get_block>
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	85 c0                	test   %eax,%eax
  801a18:	0f 88 b5 01 00 00    	js     801bd3 <fs_test+0x3da>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  801a1e:	83 ec 08             	sub    $0x8,%esp
  801a21:	68 fc 46 80 00       	push   $0x8046fc
  801a26:	ff 75 f0             	pushl  -0x10(%ebp)
  801a29:	e8 0a 0b 00 00       	call   802538 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	c1 e8 0c             	shr    $0xc,%eax
  801a34:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	a8 40                	test   $0x40,%al
  801a40:	0f 84 9f 01 00 00    	je     801be5 <fs_test+0x3ec>
	file_flush(f);
  801a46:	83 ec 0c             	sub    $0xc,%esp
  801a49:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4c:	e8 88 f6 ff ff       	call   8010d9 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a54:	c1 e8 0c             	shr    $0xc,%eax
  801a57:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	a8 40                	test   $0x40,%al
  801a63:	0f 85 92 01 00 00    	jne    801bfb <fs_test+0x402>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	c1 e8 0c             	shr    $0xc,%eax
  801a6f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a76:	a8 40                	test   $0x40,%al
  801a78:	0f 85 93 01 00 00    	jne    801c11 <fs_test+0x418>
	cprintf("file rewrite is good\n");
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	68 a5 46 80 00       	push   $0x8046a5
  801a86:	e8 4e 03 00 00       	call   801dd9 <cprintf>
}
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801a93:	50                   	push   %eax
  801a94:	68 16 45 80 00       	push   $0x804516
  801a99:	6a 13                	push   $0x13
  801a9b:	68 29 45 80 00       	push   $0x804529
  801aa0:	e8 3e 02 00 00       	call   801ce3 <_panic>
		panic("alloc_block: %e", r);
  801aa5:	50                   	push   %eax
  801aa6:	68 33 45 80 00       	push   $0x804533
  801aab:	6a 18                	push   $0x18
  801aad:	68 29 45 80 00       	push   $0x804529
  801ab2:	e8 2c 02 00 00       	call   801ce3 <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801ab7:	68 43 45 80 00       	push   $0x804543
  801abc:	68 bd 41 80 00       	push   $0x8041bd
  801ac1:	6a 1a                	push   $0x1a
  801ac3:	68 29 45 80 00       	push   $0x804529
  801ac8:	e8 16 02 00 00       	call   801ce3 <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801acd:	68 bc 46 80 00       	push   $0x8046bc
  801ad2:	68 bd 41 80 00       	push   $0x8041bd
  801ad7:	6a 1c                	push   $0x1c
  801ad9:	68 29 45 80 00       	push   $0x804529
  801ade:	e8 00 02 00 00       	call   801ce3 <_panic>
		panic("file_open /not-found: %e", r);
  801ae3:	50                   	push   %eax
  801ae4:	68 7e 45 80 00       	push   $0x80457e
  801ae9:	6a 20                	push   $0x20
  801aeb:	68 29 45 80 00       	push   $0x804529
  801af0:	e8 ee 01 00 00       	call   801ce3 <_panic>
		panic("file_open /not-found succeeded!");
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	68 dc 46 80 00       	push   $0x8046dc
  801afd:	6a 22                	push   $0x22
  801aff:	68 29 45 80 00       	push   $0x804529
  801b04:	e8 da 01 00 00       	call   801ce3 <_panic>
		panic("file_open /newmotd: %e", r);
  801b09:	50                   	push   %eax
  801b0a:	68 a0 45 80 00       	push   $0x8045a0
  801b0f:	6a 24                	push   $0x24
  801b11:	68 29 45 80 00       	push   $0x804529
  801b16:	e8 c8 01 00 00       	call   801ce3 <_panic>
		panic("file_get_block: %e", r);
  801b1b:	50                   	push   %eax
  801b1c:	68 ca 45 80 00       	push   $0x8045ca
  801b21:	6a 28                	push   $0x28
  801b23:	68 29 45 80 00       	push   $0x804529
  801b28:	e8 b6 01 00 00       	call   801ce3 <_panic>
		panic("file_get_block returned wrong data");
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	68 24 47 80 00       	push   $0x804724
  801b35:	6a 2a                	push   $0x2a
  801b37:	68 29 45 80 00       	push   $0x804529
  801b3c:	e8 a2 01 00 00       	call   801ce3 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b41:	68 f6 45 80 00       	push   $0x8045f6
  801b46:	68 bd 41 80 00       	push   $0x8041bd
  801b4b:	6a 2e                	push   $0x2e
  801b4d:	68 29 45 80 00       	push   $0x804529
  801b52:	e8 8c 01 00 00       	call   801ce3 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b57:	68 f5 45 80 00       	push   $0x8045f5
  801b5c:	68 bd 41 80 00       	push   $0x8041bd
  801b61:	6a 30                	push   $0x30
  801b63:	68 29 45 80 00       	push   $0x804529
  801b68:	e8 76 01 00 00       	call   801ce3 <_panic>
		panic("file_set_size: %e", r);
  801b6d:	50                   	push   %eax
  801b6e:	68 25 46 80 00       	push   $0x804625
  801b73:	6a 34                	push   $0x34
  801b75:	68 29 45 80 00       	push   $0x804529
  801b7a:	e8 64 01 00 00       	call   801ce3 <_panic>
	assert(f->f_direct[0] == 0);
  801b7f:	68 37 46 80 00       	push   $0x804637
  801b84:	68 bd 41 80 00       	push   $0x8041bd
  801b89:	6a 35                	push   $0x35
  801b8b:	68 29 45 80 00       	push   $0x804529
  801b90:	e8 4e 01 00 00       	call   801ce3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b95:	68 4b 46 80 00       	push   $0x80464b
  801b9a:	68 bd 41 80 00       	push   $0x8041bd
  801b9f:	6a 36                	push   $0x36
  801ba1:	68 29 45 80 00       	push   $0x804529
  801ba6:	e8 38 01 00 00       	call   801ce3 <_panic>
		panic("file_set_size 2: %e", r);
  801bab:	50                   	push   %eax
  801bac:	68 7c 46 80 00       	push   $0x80467c
  801bb1:	6a 3a                	push   $0x3a
  801bb3:	68 29 45 80 00       	push   $0x804529
  801bb8:	e8 26 01 00 00       	call   801ce3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801bbd:	68 4b 46 80 00       	push   $0x80464b
  801bc2:	68 bd 41 80 00       	push   $0x8041bd
  801bc7:	6a 3b                	push   $0x3b
  801bc9:	68 29 45 80 00       	push   $0x804529
  801bce:	e8 10 01 00 00       	call   801ce3 <_panic>
		panic("file_get_block 2: %e", r);
  801bd3:	50                   	push   %eax
  801bd4:	68 90 46 80 00       	push   $0x804690
  801bd9:	6a 3d                	push   $0x3d
  801bdb:	68 29 45 80 00       	push   $0x804529
  801be0:	e8 fe 00 00 00       	call   801ce3 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801be5:	68 f6 45 80 00       	push   $0x8045f6
  801bea:	68 bd 41 80 00       	push   $0x8041bd
  801bef:	6a 3f                	push   $0x3f
  801bf1:	68 29 45 80 00       	push   $0x804529
  801bf6:	e8 e8 00 00 00       	call   801ce3 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801bfb:	68 f5 45 80 00       	push   $0x8045f5
  801c00:	68 bd 41 80 00       	push   $0x8041bd
  801c05:	6a 41                	push   $0x41
  801c07:	68 29 45 80 00       	push   $0x804529
  801c0c:	e8 d2 00 00 00       	call   801ce3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c11:	68 4b 46 80 00       	push   $0x80464b
  801c16:	68 bd 41 80 00       	push   $0x8041bd
  801c1b:	6a 42                	push   $0x42
  801c1d:	68 29 45 80 00       	push   $0x804529
  801c22:	e8 bc 00 00 00       	call   801ce3 <_panic>

00801c27 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	57                   	push   %edi
  801c2b:	56                   	push   %esi
  801c2c:	53                   	push   %ebx
  801c2d:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  801c30:	c7 05 50 a0 80 00 00 	movl   $0x0,0x80a050
  801c37:	00 00 00 
	envid_t find = sys_getenvid();
  801c3a:	e8 ad 0c 00 00       	call   8028ec <sys_getenvid>
  801c3f:	8b 1d 50 a0 80 00    	mov    0x80a050,%ebx
  801c45:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  801c4a:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  801c4f:	bf 01 00 00 00       	mov    $0x1,%edi
  801c54:	eb 0b                	jmp    801c61 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  801c56:	83 c2 01             	add    $0x1,%edx
  801c59:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  801c5f:	74 21                	je     801c82 <libmain+0x5b>
		if(envs[i].env_id == find)
  801c61:	89 d1                	mov    %edx,%ecx
  801c63:	c1 e1 07             	shl    $0x7,%ecx
  801c66:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  801c6c:	8b 49 48             	mov    0x48(%ecx),%ecx
  801c6f:	39 c1                	cmp    %eax,%ecx
  801c71:	75 e3                	jne    801c56 <libmain+0x2f>
  801c73:	89 d3                	mov    %edx,%ebx
  801c75:	c1 e3 07             	shl    $0x7,%ebx
  801c78:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801c7e:	89 fe                	mov    %edi,%esi
  801c80:	eb d4                	jmp    801c56 <libmain+0x2f>
  801c82:	89 f0                	mov    %esi,%eax
  801c84:	84 c0                	test   %al,%al
  801c86:	74 06                	je     801c8e <libmain+0x67>
  801c88:	89 1d 50 a0 80 00    	mov    %ebx,0x80a050
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801c8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c92:	7e 0a                	jle    801c9e <libmain+0x77>
		binaryname = argv[0];
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	8b 00                	mov    (%eax),%eax
  801c99:	a3 60 90 80 00       	mov    %eax,0x809060

	cprintf("in libmain.c call umain!\n");
  801c9e:	83 ec 0c             	sub    $0xc,%esp
  801ca1:	68 50 47 80 00       	push   $0x804750
  801ca6:	e8 2e 01 00 00       	call   801dd9 <cprintf>
	// call user main routine
	umain(argc, argv);
  801cab:	83 c4 08             	add    $0x8,%esp
  801cae:	ff 75 0c             	pushl  0xc(%ebp)
  801cb1:	ff 75 08             	pushl  0x8(%ebp)
  801cb4:	e8 ee fa ff ff       	call   8017a7 <umain>

	// exit gracefully
	exit();
  801cb9:	e8 0b 00 00 00       	call   801cc9 <exit>
}
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    

00801cc9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801ccf:	e8 94 12 00 00       	call   802f68 <close_all>
	sys_env_destroy(0);
  801cd4:	83 ec 0c             	sub    $0xc,%esp
  801cd7:	6a 00                	push   $0x0
  801cd9:	e8 cd 0b 00 00       	call   8028ab <sys_env_destroy>
}
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	56                   	push   %esi
  801ce7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801ce8:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801ced:	8b 40 48             	mov    0x48(%eax),%eax
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	68 a4 47 80 00       	push   $0x8047a4
  801cf8:	50                   	push   %eax
  801cf9:	68 74 47 80 00       	push   $0x804774
  801cfe:	e8 d6 00 00 00       	call   801dd9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  801d03:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d06:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801d0c:	e8 db 0b 00 00       	call   8028ec <sys_getenvid>
  801d11:	83 c4 04             	add    $0x4,%esp
  801d14:	ff 75 0c             	pushl  0xc(%ebp)
  801d17:	ff 75 08             	pushl  0x8(%ebp)
  801d1a:	56                   	push   %esi
  801d1b:	50                   	push   %eax
  801d1c:	68 80 47 80 00       	push   $0x804780
  801d21:	e8 b3 00 00 00       	call   801dd9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d26:	83 c4 18             	add    $0x18,%esp
  801d29:	53                   	push   %ebx
  801d2a:	ff 75 10             	pushl  0x10(%ebp)
  801d2d:	e8 56 00 00 00       	call   801d88 <vcprintf>
	cprintf("\n");
  801d32:	c7 04 24 07 43 80 00 	movl   $0x804307,(%esp)
  801d39:	e8 9b 00 00 00       	call   801dd9 <cprintf>
  801d3e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d41:	cc                   	int3   
  801d42:	eb fd                	jmp    801d41 <_panic+0x5e>

00801d44 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	53                   	push   %ebx
  801d48:	83 ec 04             	sub    $0x4,%esp
  801d4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801d4e:	8b 13                	mov    (%ebx),%edx
  801d50:	8d 42 01             	lea    0x1(%edx),%eax
  801d53:	89 03                	mov    %eax,(%ebx)
  801d55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d58:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801d5c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d61:	74 09                	je     801d6c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801d63:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801d67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801d6c:	83 ec 08             	sub    $0x8,%esp
  801d6f:	68 ff 00 00 00       	push   $0xff
  801d74:	8d 43 08             	lea    0x8(%ebx),%eax
  801d77:	50                   	push   %eax
  801d78:	e8 f1 0a 00 00       	call   80286e <sys_cputs>
		b->idx = 0;
  801d7d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	eb db                	jmp    801d63 <putch+0x1f>

00801d88 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801d91:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d98:	00 00 00 
	b.cnt = 0;
  801d9b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801da2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801db1:	50                   	push   %eax
  801db2:	68 44 1d 80 00       	push   $0x801d44
  801db7:	e8 4a 01 00 00       	call   801f06 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801dbc:	83 c4 08             	add    $0x8,%esp
  801dbf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801dc5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801dcb:	50                   	push   %eax
  801dcc:	e8 9d 0a 00 00       	call   80286e <sys_cputs>

	return b.cnt;
}
  801dd1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ddf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801de2:	50                   	push   %eax
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	e8 9d ff ff ff       	call   801d88 <vcprintf>
	va_end(ap);

	return cnt;
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	57                   	push   %edi
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
  801df3:	83 ec 1c             	sub    $0x1c,%esp
  801df6:	89 c6                	mov    %eax,%esi
  801df8:	89 d7                	mov    %edx,%edi
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e03:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801e06:	8b 45 10             	mov    0x10(%ebp),%eax
  801e09:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  801e0c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  801e10:	74 2c                	je     801e3e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  801e12:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801e1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e1f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801e22:	39 c2                	cmp    %eax,%edx
  801e24:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  801e27:	73 43                	jae    801e6c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  801e29:	83 eb 01             	sub    $0x1,%ebx
  801e2c:	85 db                	test   %ebx,%ebx
  801e2e:	7e 6c                	jle    801e9c <printnum+0xaf>
				putch(padc, putdat);
  801e30:	83 ec 08             	sub    $0x8,%esp
  801e33:	57                   	push   %edi
  801e34:	ff 75 18             	pushl  0x18(%ebp)
  801e37:	ff d6                	call   *%esi
  801e39:	83 c4 10             	add    $0x10,%esp
  801e3c:	eb eb                	jmp    801e29 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  801e3e:	83 ec 0c             	sub    $0xc,%esp
  801e41:	6a 20                	push   $0x20
  801e43:	6a 00                	push   $0x0
  801e45:	50                   	push   %eax
  801e46:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e49:	ff 75 e0             	pushl  -0x20(%ebp)
  801e4c:	89 fa                	mov    %edi,%edx
  801e4e:	89 f0                	mov    %esi,%eax
  801e50:	e8 98 ff ff ff       	call   801ded <printnum>
		while (--width > 0)
  801e55:	83 c4 20             	add    $0x20,%esp
  801e58:	83 eb 01             	sub    $0x1,%ebx
  801e5b:	85 db                	test   %ebx,%ebx
  801e5d:	7e 65                	jle    801ec4 <printnum+0xd7>
			putch(padc, putdat);
  801e5f:	83 ec 08             	sub    $0x8,%esp
  801e62:	57                   	push   %edi
  801e63:	6a 20                	push   $0x20
  801e65:	ff d6                	call   *%esi
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	eb ec                	jmp    801e58 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	ff 75 18             	pushl  0x18(%ebp)
  801e72:	83 eb 01             	sub    $0x1,%ebx
  801e75:	53                   	push   %ebx
  801e76:	50                   	push   %eax
  801e77:	83 ec 08             	sub    $0x8,%esp
  801e7a:	ff 75 dc             	pushl  -0x24(%ebp)
  801e7d:	ff 75 d8             	pushl  -0x28(%ebp)
  801e80:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e83:	ff 75 e0             	pushl  -0x20(%ebp)
  801e86:	e8 a5 20 00 00       	call   803f30 <__udivdi3>
  801e8b:	83 c4 18             	add    $0x18,%esp
  801e8e:	52                   	push   %edx
  801e8f:	50                   	push   %eax
  801e90:	89 fa                	mov    %edi,%edx
  801e92:	89 f0                	mov    %esi,%eax
  801e94:	e8 54 ff ff ff       	call   801ded <printnum>
  801e99:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  801e9c:	83 ec 08             	sub    $0x8,%esp
  801e9f:	57                   	push   %edi
  801ea0:	83 ec 04             	sub    $0x4,%esp
  801ea3:	ff 75 dc             	pushl  -0x24(%ebp)
  801ea6:	ff 75 d8             	pushl  -0x28(%ebp)
  801ea9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801eac:	ff 75 e0             	pushl  -0x20(%ebp)
  801eaf:	e8 8c 21 00 00       	call   804040 <__umoddi3>
  801eb4:	83 c4 14             	add    $0x14,%esp
  801eb7:	0f be 80 ab 47 80 00 	movsbl 0x8047ab(%eax),%eax
  801ebe:	50                   	push   %eax
  801ebf:	ff d6                	call   *%esi
  801ec1:	83 c4 10             	add    $0x10,%esp
	}
}
  801ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec7:	5b                   	pop    %ebx
  801ec8:	5e                   	pop    %esi
  801ec9:	5f                   	pop    %edi
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    

00801ecc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801ed2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801ed6:	8b 10                	mov    (%eax),%edx
  801ed8:	3b 50 04             	cmp    0x4(%eax),%edx
  801edb:	73 0a                	jae    801ee7 <sprintputch+0x1b>
		*b->buf++ = ch;
  801edd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ee0:	89 08                	mov    %ecx,(%eax)
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	88 02                	mov    %al,(%edx)
}
  801ee7:	5d                   	pop    %ebp
  801ee8:	c3                   	ret    

00801ee9 <printfmt>:
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801eef:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801ef2:	50                   	push   %eax
  801ef3:	ff 75 10             	pushl  0x10(%ebp)
  801ef6:	ff 75 0c             	pushl  0xc(%ebp)
  801ef9:	ff 75 08             	pushl  0x8(%ebp)
  801efc:	e8 05 00 00 00       	call   801f06 <vprintfmt>
}
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <vprintfmt>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	57                   	push   %edi
  801f0a:	56                   	push   %esi
  801f0b:	53                   	push   %ebx
  801f0c:	83 ec 3c             	sub    $0x3c,%esp
  801f0f:	8b 75 08             	mov    0x8(%ebp),%esi
  801f12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f15:	8b 7d 10             	mov    0x10(%ebp),%edi
  801f18:	e9 32 04 00 00       	jmp    80234f <vprintfmt+0x449>
		padc = ' ';
  801f1d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  801f21:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  801f28:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  801f2f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801f36:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801f3d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  801f44:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801f49:	8d 47 01             	lea    0x1(%edi),%eax
  801f4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f4f:	0f b6 17             	movzbl (%edi),%edx
  801f52:	8d 42 dd             	lea    -0x23(%edx),%eax
  801f55:	3c 55                	cmp    $0x55,%al
  801f57:	0f 87 12 05 00 00    	ja     80246f <vprintfmt+0x569>
  801f5d:	0f b6 c0             	movzbl %al,%eax
  801f60:	ff 24 85 80 49 80 00 	jmp    *0x804980(,%eax,4)
  801f67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801f6a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  801f6e:	eb d9                	jmp    801f49 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801f70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801f73:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  801f77:	eb d0                	jmp    801f49 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801f79:	0f b6 d2             	movzbl %dl,%edx
  801f7c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f84:	89 75 08             	mov    %esi,0x8(%ebp)
  801f87:	eb 03                	jmp    801f8c <vprintfmt+0x86>
  801f89:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801f8c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801f8f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801f93:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801f96:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f99:	83 fe 09             	cmp    $0x9,%esi
  801f9c:	76 eb                	jbe    801f89 <vprintfmt+0x83>
  801f9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fa1:	8b 75 08             	mov    0x8(%ebp),%esi
  801fa4:	eb 14                	jmp    801fba <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  801fa6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa9:	8b 00                	mov    (%eax),%eax
  801fab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fae:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb1:	8d 40 04             	lea    0x4(%eax),%eax
  801fb4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801fb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801fba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fbe:	79 89                	jns    801f49 <vprintfmt+0x43>
				width = precision, precision = -1;
  801fc0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fc6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801fcd:	e9 77 ff ff ff       	jmp    801f49 <vprintfmt+0x43>
  801fd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	0f 48 c1             	cmovs  %ecx,%eax
  801fda:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801fdd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801fe0:	e9 64 ff ff ff       	jmp    801f49 <vprintfmt+0x43>
  801fe5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801fe8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  801fef:	e9 55 ff ff ff       	jmp    801f49 <vprintfmt+0x43>
			lflag++;
  801ff4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801ff8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801ffb:	e9 49 ff ff ff       	jmp    801f49 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  802000:	8b 45 14             	mov    0x14(%ebp),%eax
  802003:	8d 78 04             	lea    0x4(%eax),%edi
  802006:	83 ec 08             	sub    $0x8,%esp
  802009:	53                   	push   %ebx
  80200a:	ff 30                	pushl  (%eax)
  80200c:	ff d6                	call   *%esi
			break;
  80200e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  802011:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  802014:	e9 33 03 00 00       	jmp    80234c <vprintfmt+0x446>
			err = va_arg(ap, int);
  802019:	8b 45 14             	mov    0x14(%ebp),%eax
  80201c:	8d 78 04             	lea    0x4(%eax),%edi
  80201f:	8b 00                	mov    (%eax),%eax
  802021:	99                   	cltd   
  802022:	31 d0                	xor    %edx,%eax
  802024:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802026:	83 f8 10             	cmp    $0x10,%eax
  802029:	7f 23                	jg     80204e <vprintfmt+0x148>
  80202b:	8b 14 85 e0 4a 80 00 	mov    0x804ae0(,%eax,4),%edx
  802032:	85 d2                	test   %edx,%edx
  802034:	74 18                	je     80204e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  802036:	52                   	push   %edx
  802037:	68 cf 41 80 00       	push   $0x8041cf
  80203c:	53                   	push   %ebx
  80203d:	56                   	push   %esi
  80203e:	e8 a6 fe ff ff       	call   801ee9 <printfmt>
  802043:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  802046:	89 7d 14             	mov    %edi,0x14(%ebp)
  802049:	e9 fe 02 00 00       	jmp    80234c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80204e:	50                   	push   %eax
  80204f:	68 c3 47 80 00       	push   $0x8047c3
  802054:	53                   	push   %ebx
  802055:	56                   	push   %esi
  802056:	e8 8e fe ff ff       	call   801ee9 <printfmt>
  80205b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80205e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  802061:	e9 e6 02 00 00       	jmp    80234c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  802066:	8b 45 14             	mov    0x14(%ebp),%eax
  802069:	83 c0 04             	add    $0x4,%eax
  80206c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80206f:	8b 45 14             	mov    0x14(%ebp),%eax
  802072:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  802074:	85 c9                	test   %ecx,%ecx
  802076:	b8 bc 47 80 00       	mov    $0x8047bc,%eax
  80207b:	0f 45 c1             	cmovne %ecx,%eax
  80207e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  802081:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802085:	7e 06                	jle    80208d <vprintfmt+0x187>
  802087:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80208b:	75 0d                	jne    80209a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80208d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802090:	89 c7                	mov    %eax,%edi
  802092:	03 45 e0             	add    -0x20(%ebp),%eax
  802095:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802098:	eb 53                	jmp    8020ed <vprintfmt+0x1e7>
  80209a:	83 ec 08             	sub    $0x8,%esp
  80209d:	ff 75 d8             	pushl  -0x28(%ebp)
  8020a0:	50                   	push   %eax
  8020a1:	e8 71 04 00 00       	call   802517 <strnlen>
  8020a6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8020a9:	29 c1                	sub    %eax,%ecx
  8020ab:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8020b3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8020b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8020ba:	eb 0f                	jmp    8020cb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	53                   	push   %ebx
  8020c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8020c3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8020c5:	83 ef 01             	sub    $0x1,%edi
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 ff                	test   %edi,%edi
  8020cd:	7f ed                	jg     8020bc <vprintfmt+0x1b6>
  8020cf:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8020d2:	85 c9                	test   %ecx,%ecx
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d9:	0f 49 c1             	cmovns %ecx,%eax
  8020dc:	29 c1                	sub    %eax,%ecx
  8020de:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8020e1:	eb aa                	jmp    80208d <vprintfmt+0x187>
					putch(ch, putdat);
  8020e3:	83 ec 08             	sub    $0x8,%esp
  8020e6:	53                   	push   %ebx
  8020e7:	52                   	push   %edx
  8020e8:	ff d6                	call   *%esi
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8020f0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8020f2:	83 c7 01             	add    $0x1,%edi
  8020f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8020f9:	0f be d0             	movsbl %al,%edx
  8020fc:	85 d2                	test   %edx,%edx
  8020fe:	74 4b                	je     80214b <vprintfmt+0x245>
  802100:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802104:	78 06                	js     80210c <vprintfmt+0x206>
  802106:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80210a:	78 1e                	js     80212a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80210c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802110:	74 d1                	je     8020e3 <vprintfmt+0x1dd>
  802112:	0f be c0             	movsbl %al,%eax
  802115:	83 e8 20             	sub    $0x20,%eax
  802118:	83 f8 5e             	cmp    $0x5e,%eax
  80211b:	76 c6                	jbe    8020e3 <vprintfmt+0x1dd>
					putch('?', putdat);
  80211d:	83 ec 08             	sub    $0x8,%esp
  802120:	53                   	push   %ebx
  802121:	6a 3f                	push   $0x3f
  802123:	ff d6                	call   *%esi
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	eb c3                	jmp    8020ed <vprintfmt+0x1e7>
  80212a:	89 cf                	mov    %ecx,%edi
  80212c:	eb 0e                	jmp    80213c <vprintfmt+0x236>
				putch(' ', putdat);
  80212e:	83 ec 08             	sub    $0x8,%esp
  802131:	53                   	push   %ebx
  802132:	6a 20                	push   $0x20
  802134:	ff d6                	call   *%esi
			for (; width > 0; width--)
  802136:	83 ef 01             	sub    $0x1,%edi
  802139:	83 c4 10             	add    $0x10,%esp
  80213c:	85 ff                	test   %edi,%edi
  80213e:	7f ee                	jg     80212e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  802140:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802143:	89 45 14             	mov    %eax,0x14(%ebp)
  802146:	e9 01 02 00 00       	jmp    80234c <vprintfmt+0x446>
  80214b:	89 cf                	mov    %ecx,%edi
  80214d:	eb ed                	jmp    80213c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80214f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  802152:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  802159:	e9 eb fd ff ff       	jmp    801f49 <vprintfmt+0x43>
	if (lflag >= 2)
  80215e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  802162:	7f 21                	jg     802185 <vprintfmt+0x27f>
	else if (lflag)
  802164:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802168:	74 68                	je     8021d2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80216a:	8b 45 14             	mov    0x14(%ebp),%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802172:	89 c1                	mov    %eax,%ecx
  802174:	c1 f9 1f             	sar    $0x1f,%ecx
  802177:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80217a:	8b 45 14             	mov    0x14(%ebp),%eax
  80217d:	8d 40 04             	lea    0x4(%eax),%eax
  802180:	89 45 14             	mov    %eax,0x14(%ebp)
  802183:	eb 17                	jmp    80219c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  802185:	8b 45 14             	mov    0x14(%ebp),%eax
  802188:	8b 50 04             	mov    0x4(%eax),%edx
  80218b:	8b 00                	mov    (%eax),%eax
  80218d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802190:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  802193:	8b 45 14             	mov    0x14(%ebp),%eax
  802196:	8d 40 08             	lea    0x8(%eax),%eax
  802199:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80219c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80219f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8021a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8021ac:	78 3f                	js     8021ed <vprintfmt+0x2e7>
			base = 10;
  8021ae:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8021b3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8021b7:	0f 84 71 01 00 00    	je     80232e <vprintfmt+0x428>
				putch('+', putdat);
  8021bd:	83 ec 08             	sub    $0x8,%esp
  8021c0:	53                   	push   %ebx
  8021c1:	6a 2b                	push   $0x2b
  8021c3:	ff d6                	call   *%esi
  8021c5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8021c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8021cd:	e9 5c 01 00 00       	jmp    80232e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8021d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8021da:	89 c1                	mov    %eax,%ecx
  8021dc:	c1 f9 1f             	sar    $0x1f,%ecx
  8021df:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8021e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e5:	8d 40 04             	lea    0x4(%eax),%eax
  8021e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8021eb:	eb af                	jmp    80219c <vprintfmt+0x296>
				putch('-', putdat);
  8021ed:	83 ec 08             	sub    $0x8,%esp
  8021f0:	53                   	push   %ebx
  8021f1:	6a 2d                	push   $0x2d
  8021f3:	ff d6                	call   *%esi
				num = -(long long) num;
  8021f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021fb:	f7 d8                	neg    %eax
  8021fd:	83 d2 00             	adc    $0x0,%edx
  802200:	f7 da                	neg    %edx
  802202:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802205:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802208:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80220b:	b8 0a 00 00 00       	mov    $0xa,%eax
  802210:	e9 19 01 00 00       	jmp    80232e <vprintfmt+0x428>
	if (lflag >= 2)
  802215:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  802219:	7f 29                	jg     802244 <vprintfmt+0x33e>
	else if (lflag)
  80221b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80221f:	74 44                	je     802265 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  802221:	8b 45 14             	mov    0x14(%ebp),%eax
  802224:	8b 00                	mov    (%eax),%eax
  802226:	ba 00 00 00 00       	mov    $0x0,%edx
  80222b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80222e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802231:	8b 45 14             	mov    0x14(%ebp),%eax
  802234:	8d 40 04             	lea    0x4(%eax),%eax
  802237:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80223a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80223f:	e9 ea 00 00 00       	jmp    80232e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  802244:	8b 45 14             	mov    0x14(%ebp),%eax
  802247:	8b 50 04             	mov    0x4(%eax),%edx
  80224a:	8b 00                	mov    (%eax),%eax
  80224c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80224f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802252:	8b 45 14             	mov    0x14(%ebp),%eax
  802255:	8d 40 08             	lea    0x8(%eax),%eax
  802258:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80225b:	b8 0a 00 00 00       	mov    $0xa,%eax
  802260:	e9 c9 00 00 00       	jmp    80232e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  802265:	8b 45 14             	mov    0x14(%ebp),%eax
  802268:	8b 00                	mov    (%eax),%eax
  80226a:	ba 00 00 00 00       	mov    $0x0,%edx
  80226f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802272:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802275:	8b 45 14             	mov    0x14(%ebp),%eax
  802278:	8d 40 04             	lea    0x4(%eax),%eax
  80227b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80227e:	b8 0a 00 00 00       	mov    $0xa,%eax
  802283:	e9 a6 00 00 00       	jmp    80232e <vprintfmt+0x428>
			putch('0', putdat);
  802288:	83 ec 08             	sub    $0x8,%esp
  80228b:	53                   	push   %ebx
  80228c:	6a 30                	push   $0x30
  80228e:	ff d6                	call   *%esi
	if (lflag >= 2)
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  802297:	7f 26                	jg     8022bf <vprintfmt+0x3b9>
	else if (lflag)
  802299:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80229d:	74 3e                	je     8022dd <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80229f:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8022af:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b2:	8d 40 04             	lea    0x4(%eax),%eax
  8022b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8022b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8022bd:	eb 6f                	jmp    80232e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8022bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c2:	8b 50 04             	mov    0x4(%eax),%edx
  8022c5:	8b 00                	mov    (%eax),%eax
  8022c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8022cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d0:	8d 40 08             	lea    0x8(%eax),%eax
  8022d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8022d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8022db:	eb 51                	jmp    80232e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8022dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8022ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f0:	8d 40 04             	lea    0x4(%eax),%eax
  8022f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8022f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8022fb:	eb 31                	jmp    80232e <vprintfmt+0x428>
			putch('0', putdat);
  8022fd:	83 ec 08             	sub    $0x8,%esp
  802300:	53                   	push   %ebx
  802301:	6a 30                	push   $0x30
  802303:	ff d6                	call   *%esi
			putch('x', putdat);
  802305:	83 c4 08             	add    $0x8,%esp
  802308:	53                   	push   %ebx
  802309:	6a 78                	push   $0x78
  80230b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80230d:	8b 45 14             	mov    0x14(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	ba 00 00 00 00       	mov    $0x0,%edx
  802317:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80231a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80231d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  802320:	8b 45 14             	mov    0x14(%ebp),%eax
  802323:	8d 40 04             	lea    0x4(%eax),%eax
  802326:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802329:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80232e:	83 ec 0c             	sub    $0xc,%esp
  802331:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  802335:	52                   	push   %edx
  802336:	ff 75 e0             	pushl  -0x20(%ebp)
  802339:	50                   	push   %eax
  80233a:	ff 75 dc             	pushl  -0x24(%ebp)
  80233d:	ff 75 d8             	pushl  -0x28(%ebp)
  802340:	89 da                	mov    %ebx,%edx
  802342:	89 f0                	mov    %esi,%eax
  802344:	e8 a4 fa ff ff       	call   801ded <printnum>
			break;
  802349:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80234c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80234f:	83 c7 01             	add    $0x1,%edi
  802352:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802356:	83 f8 25             	cmp    $0x25,%eax
  802359:	0f 84 be fb ff ff    	je     801f1d <vprintfmt+0x17>
			if (ch == '\0')
  80235f:	85 c0                	test   %eax,%eax
  802361:	0f 84 28 01 00 00    	je     80248f <vprintfmt+0x589>
			putch(ch, putdat);
  802367:	83 ec 08             	sub    $0x8,%esp
  80236a:	53                   	push   %ebx
  80236b:	50                   	push   %eax
  80236c:	ff d6                	call   *%esi
  80236e:	83 c4 10             	add    $0x10,%esp
  802371:	eb dc                	jmp    80234f <vprintfmt+0x449>
	if (lflag >= 2)
  802373:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  802377:	7f 26                	jg     80239f <vprintfmt+0x499>
	else if (lflag)
  802379:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80237d:	74 41                	je     8023c0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80237f:	8b 45 14             	mov    0x14(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	ba 00 00 00 00       	mov    $0x0,%edx
  802389:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80238c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80238f:	8b 45 14             	mov    0x14(%ebp),%eax
  802392:	8d 40 04             	lea    0x4(%eax),%eax
  802395:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802398:	b8 10 00 00 00       	mov    $0x10,%eax
  80239d:	eb 8f                	jmp    80232e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80239f:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a2:	8b 50 04             	mov    0x4(%eax),%edx
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8023ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b0:	8d 40 08             	lea    0x8(%eax),%eax
  8023b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8023b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8023bb:	e9 6e ff ff ff       	jmp    80232e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8023c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8023d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d3:	8d 40 04             	lea    0x4(%eax),%eax
  8023d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8023d9:	b8 10 00 00 00       	mov    $0x10,%eax
  8023de:	e9 4b ff ff ff       	jmp    80232e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8023e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8023e6:	83 c0 04             	add    $0x4,%eax
  8023e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ef:	8b 00                	mov    (%eax),%eax
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	74 14                	je     802409 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8023f5:	8b 13                	mov    (%ebx),%edx
  8023f7:	83 fa 7f             	cmp    $0x7f,%edx
  8023fa:	7f 37                	jg     802433 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8023fc:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8023fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802401:	89 45 14             	mov    %eax,0x14(%ebp)
  802404:	e9 43 ff ff ff       	jmp    80234c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  802409:	b8 0a 00 00 00       	mov    $0xa,%eax
  80240e:	bf e1 48 80 00       	mov    $0x8048e1,%edi
							putch(ch, putdat);
  802413:	83 ec 08             	sub    $0x8,%esp
  802416:	53                   	push   %ebx
  802417:	50                   	push   %eax
  802418:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80241a:	83 c7 01             	add    $0x1,%edi
  80241d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  802421:	83 c4 10             	add    $0x10,%esp
  802424:	85 c0                	test   %eax,%eax
  802426:	75 eb                	jne    802413 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  802428:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80242b:	89 45 14             	mov    %eax,0x14(%ebp)
  80242e:	e9 19 ff ff ff       	jmp    80234c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  802433:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  802435:	b8 0a 00 00 00       	mov    $0xa,%eax
  80243a:	bf 19 49 80 00       	mov    $0x804919,%edi
							putch(ch, putdat);
  80243f:	83 ec 08             	sub    $0x8,%esp
  802442:	53                   	push   %ebx
  802443:	50                   	push   %eax
  802444:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  802446:	83 c7 01             	add    $0x1,%edi
  802449:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	85 c0                	test   %eax,%eax
  802452:	75 eb                	jne    80243f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  802454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802457:	89 45 14             	mov    %eax,0x14(%ebp)
  80245a:	e9 ed fe ff ff       	jmp    80234c <vprintfmt+0x446>
			putch(ch, putdat);
  80245f:	83 ec 08             	sub    $0x8,%esp
  802462:	53                   	push   %ebx
  802463:	6a 25                	push   $0x25
  802465:	ff d6                	call   *%esi
			break;
  802467:	83 c4 10             	add    $0x10,%esp
  80246a:	e9 dd fe ff ff       	jmp    80234c <vprintfmt+0x446>
			putch('%', putdat);
  80246f:	83 ec 08             	sub    $0x8,%esp
  802472:	53                   	push   %ebx
  802473:	6a 25                	push   $0x25
  802475:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802477:	83 c4 10             	add    $0x10,%esp
  80247a:	89 f8                	mov    %edi,%eax
  80247c:	eb 03                	jmp    802481 <vprintfmt+0x57b>
  80247e:	83 e8 01             	sub    $0x1,%eax
  802481:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802485:	75 f7                	jne    80247e <vprintfmt+0x578>
  802487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80248a:	e9 bd fe ff ff       	jmp    80234c <vprintfmt+0x446>
}
  80248f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802492:	5b                   	pop    %ebx
  802493:	5e                   	pop    %esi
  802494:	5f                   	pop    %edi
  802495:	5d                   	pop    %ebp
  802496:	c3                   	ret    

00802497 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 18             	sub    $0x18,%esp
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8024a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8024a6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8024aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8024ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	74 26                	je     8024de <vsnprintf+0x47>
  8024b8:	85 d2                	test   %edx,%edx
  8024ba:	7e 22                	jle    8024de <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8024bc:	ff 75 14             	pushl  0x14(%ebp)
  8024bf:	ff 75 10             	pushl  0x10(%ebp)
  8024c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8024c5:	50                   	push   %eax
  8024c6:	68 cc 1e 80 00       	push   $0x801ecc
  8024cb:	e8 36 fa ff ff       	call   801f06 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8024d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	83 c4 10             	add    $0x10,%esp
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    
		return -E_INVAL;
  8024de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e3:	eb f7                	jmp    8024dc <vsnprintf+0x45>

008024e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8024eb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8024ee:	50                   	push   %eax
  8024ef:	ff 75 10             	pushl  0x10(%ebp)
  8024f2:	ff 75 0c             	pushl  0xc(%ebp)
  8024f5:	ff 75 08             	pushl  0x8(%ebp)
  8024f8:	e8 9a ff ff ff       	call   802497 <vsnprintf>
	va_end(ap);

	return rc;
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
  80250a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80250e:	74 05                	je     802515 <strlen+0x16>
		n++;
  802510:	83 c0 01             	add    $0x1,%eax
  802513:	eb f5                	jmp    80250a <strlen+0xb>
	return n;
}
  802515:	5d                   	pop    %ebp
  802516:	c3                   	ret    

00802517 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802520:	ba 00 00 00 00       	mov    $0x0,%edx
  802525:	39 c2                	cmp    %eax,%edx
  802527:	74 0d                	je     802536 <strnlen+0x1f>
  802529:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80252d:	74 05                	je     802534 <strnlen+0x1d>
		n++;
  80252f:	83 c2 01             	add    $0x1,%edx
  802532:	eb f1                	jmp    802525 <strnlen+0xe>
  802534:	89 d0                	mov    %edx,%eax
	return n;
}
  802536:	5d                   	pop    %ebp
  802537:	c3                   	ret    

00802538 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	53                   	push   %ebx
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802542:	ba 00 00 00 00       	mov    $0x0,%edx
  802547:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80254b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80254e:	83 c2 01             	add    $0x1,%edx
  802551:	84 c9                	test   %cl,%cl
  802553:	75 f2                	jne    802547 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  802555:	5b                   	pop    %ebx
  802556:	5d                   	pop    %ebp
  802557:	c3                   	ret    

00802558 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	53                   	push   %ebx
  80255c:	83 ec 10             	sub    $0x10,%esp
  80255f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802562:	53                   	push   %ebx
  802563:	e8 97 ff ff ff       	call   8024ff <strlen>
  802568:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80256b:	ff 75 0c             	pushl  0xc(%ebp)
  80256e:	01 d8                	add    %ebx,%eax
  802570:	50                   	push   %eax
  802571:	e8 c2 ff ff ff       	call   802538 <strcpy>
	return dst;
}
  802576:	89 d8                	mov    %ebx,%eax
  802578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	56                   	push   %esi
  802581:	53                   	push   %ebx
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802588:	89 c6                	mov    %eax,%esi
  80258a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80258d:	89 c2                	mov    %eax,%edx
  80258f:	39 f2                	cmp    %esi,%edx
  802591:	74 11                	je     8025a4 <strncpy+0x27>
		*dst++ = *src;
  802593:	83 c2 01             	add    $0x1,%edx
  802596:	0f b6 19             	movzbl (%ecx),%ebx
  802599:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80259c:	80 fb 01             	cmp    $0x1,%bl
  80259f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8025a2:	eb eb                	jmp    80258f <strncpy+0x12>
	}
	return ret;
}
  8025a4:	5b                   	pop    %ebx
  8025a5:	5e                   	pop    %esi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    

008025a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	56                   	push   %esi
  8025ac:	53                   	push   %ebx
  8025ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8025b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025b3:	8b 55 10             	mov    0x10(%ebp),%edx
  8025b6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8025b8:	85 d2                	test   %edx,%edx
  8025ba:	74 21                	je     8025dd <strlcpy+0x35>
  8025bc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8025c0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8025c2:	39 c2                	cmp    %eax,%edx
  8025c4:	74 14                	je     8025da <strlcpy+0x32>
  8025c6:	0f b6 19             	movzbl (%ecx),%ebx
  8025c9:	84 db                	test   %bl,%bl
  8025cb:	74 0b                	je     8025d8 <strlcpy+0x30>
			*dst++ = *src++;
  8025cd:	83 c1 01             	add    $0x1,%ecx
  8025d0:	83 c2 01             	add    $0x1,%edx
  8025d3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8025d6:	eb ea                	jmp    8025c2 <strlcpy+0x1a>
  8025d8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8025da:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8025dd:	29 f0                	sub    %esi,%eax
}
  8025df:	5b                   	pop    %ebx
  8025e0:	5e                   	pop    %esi
  8025e1:	5d                   	pop    %ebp
  8025e2:	c3                   	ret    

008025e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8025ec:	0f b6 01             	movzbl (%ecx),%eax
  8025ef:	84 c0                	test   %al,%al
  8025f1:	74 0c                	je     8025ff <strcmp+0x1c>
  8025f3:	3a 02                	cmp    (%edx),%al
  8025f5:	75 08                	jne    8025ff <strcmp+0x1c>
		p++, q++;
  8025f7:	83 c1 01             	add    $0x1,%ecx
  8025fa:	83 c2 01             	add    $0x1,%edx
  8025fd:	eb ed                	jmp    8025ec <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8025ff:	0f b6 c0             	movzbl %al,%eax
  802602:	0f b6 12             	movzbl (%edx),%edx
  802605:	29 d0                	sub    %edx,%eax
}
  802607:	5d                   	pop    %ebp
  802608:	c3                   	ret    

00802609 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	53                   	push   %ebx
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8b 55 0c             	mov    0xc(%ebp),%edx
  802613:	89 c3                	mov    %eax,%ebx
  802615:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802618:	eb 06                	jmp    802620 <strncmp+0x17>
		n--, p++, q++;
  80261a:	83 c0 01             	add    $0x1,%eax
  80261d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  802620:	39 d8                	cmp    %ebx,%eax
  802622:	74 16                	je     80263a <strncmp+0x31>
  802624:	0f b6 08             	movzbl (%eax),%ecx
  802627:	84 c9                	test   %cl,%cl
  802629:	74 04                	je     80262f <strncmp+0x26>
  80262b:	3a 0a                	cmp    (%edx),%cl
  80262d:	74 eb                	je     80261a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80262f:	0f b6 00             	movzbl (%eax),%eax
  802632:	0f b6 12             	movzbl (%edx),%edx
  802635:	29 d0                	sub    %edx,%eax
}
  802637:	5b                   	pop    %ebx
  802638:	5d                   	pop    %ebp
  802639:	c3                   	ret    
		return 0;
  80263a:	b8 00 00 00 00       	mov    $0x0,%eax
  80263f:	eb f6                	jmp    802637 <strncmp+0x2e>

00802641 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80264b:	0f b6 10             	movzbl (%eax),%edx
  80264e:	84 d2                	test   %dl,%dl
  802650:	74 09                	je     80265b <strchr+0x1a>
		if (*s == c)
  802652:	38 ca                	cmp    %cl,%dl
  802654:	74 0a                	je     802660 <strchr+0x1f>
	for (; *s; s++)
  802656:	83 c0 01             	add    $0x1,%eax
  802659:	eb f0                	jmp    80264b <strchr+0xa>
			return (char *) s;
	return 0;
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802660:	5d                   	pop    %ebp
  802661:	c3                   	ret    

00802662 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80266c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80266f:	38 ca                	cmp    %cl,%dl
  802671:	74 09                	je     80267c <strfind+0x1a>
  802673:	84 d2                	test   %dl,%dl
  802675:	74 05                	je     80267c <strfind+0x1a>
	for (; *s; s++)
  802677:	83 c0 01             	add    $0x1,%eax
  80267a:	eb f0                	jmp    80266c <strfind+0xa>
			break;
	return (char *) s;
}
  80267c:	5d                   	pop    %ebp
  80267d:	c3                   	ret    

0080267e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	57                   	push   %edi
  802682:	56                   	push   %esi
  802683:	53                   	push   %ebx
  802684:	8b 7d 08             	mov    0x8(%ebp),%edi
  802687:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80268a:	85 c9                	test   %ecx,%ecx
  80268c:	74 31                	je     8026bf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80268e:	89 f8                	mov    %edi,%eax
  802690:	09 c8                	or     %ecx,%eax
  802692:	a8 03                	test   $0x3,%al
  802694:	75 23                	jne    8026b9 <memset+0x3b>
		c &= 0xFF;
  802696:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80269a:	89 d3                	mov    %edx,%ebx
  80269c:	c1 e3 08             	shl    $0x8,%ebx
  80269f:	89 d0                	mov    %edx,%eax
  8026a1:	c1 e0 18             	shl    $0x18,%eax
  8026a4:	89 d6                	mov    %edx,%esi
  8026a6:	c1 e6 10             	shl    $0x10,%esi
  8026a9:	09 f0                	or     %esi,%eax
  8026ab:	09 c2                	or     %eax,%edx
  8026ad:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8026af:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8026b2:	89 d0                	mov    %edx,%eax
  8026b4:	fc                   	cld    
  8026b5:	f3 ab                	rep stos %eax,%es:(%edi)
  8026b7:	eb 06                	jmp    8026bf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8026b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bc:	fc                   	cld    
  8026bd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8026bf:	89 f8                	mov    %edi,%eax
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    

008026c6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	57                   	push   %edi
  8026ca:	56                   	push   %esi
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8026d4:	39 c6                	cmp    %eax,%esi
  8026d6:	73 32                	jae    80270a <memmove+0x44>
  8026d8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8026db:	39 c2                	cmp    %eax,%edx
  8026dd:	76 2b                	jbe    80270a <memmove+0x44>
		s += n;
		d += n;
  8026df:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8026e2:	89 fe                	mov    %edi,%esi
  8026e4:	09 ce                	or     %ecx,%esi
  8026e6:	09 d6                	or     %edx,%esi
  8026e8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8026ee:	75 0e                	jne    8026fe <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8026f0:	83 ef 04             	sub    $0x4,%edi
  8026f3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8026f6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8026f9:	fd                   	std    
  8026fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8026fc:	eb 09                	jmp    802707 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8026fe:	83 ef 01             	sub    $0x1,%edi
  802701:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  802704:	fd                   	std    
  802705:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802707:	fc                   	cld    
  802708:	eb 1a                	jmp    802724 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80270a:	89 c2                	mov    %eax,%edx
  80270c:	09 ca                	or     %ecx,%edx
  80270e:	09 f2                	or     %esi,%edx
  802710:	f6 c2 03             	test   $0x3,%dl
  802713:	75 0a                	jne    80271f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802715:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802718:	89 c7                	mov    %eax,%edi
  80271a:	fc                   	cld    
  80271b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80271d:	eb 05                	jmp    802724 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80271f:	89 c7                	mov    %eax,%edi
  802721:	fc                   	cld    
  802722:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802724:	5e                   	pop    %esi
  802725:	5f                   	pop    %edi
  802726:	5d                   	pop    %ebp
  802727:	c3                   	ret    

00802728 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80272e:	ff 75 10             	pushl  0x10(%ebp)
  802731:	ff 75 0c             	pushl  0xc(%ebp)
  802734:	ff 75 08             	pushl  0x8(%ebp)
  802737:	e8 8a ff ff ff       	call   8026c6 <memmove>
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	56                   	push   %esi
  802742:	53                   	push   %ebx
  802743:	8b 45 08             	mov    0x8(%ebp),%eax
  802746:	8b 55 0c             	mov    0xc(%ebp),%edx
  802749:	89 c6                	mov    %eax,%esi
  80274b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80274e:	39 f0                	cmp    %esi,%eax
  802750:	74 1c                	je     80276e <memcmp+0x30>
		if (*s1 != *s2)
  802752:	0f b6 08             	movzbl (%eax),%ecx
  802755:	0f b6 1a             	movzbl (%edx),%ebx
  802758:	38 d9                	cmp    %bl,%cl
  80275a:	75 08                	jne    802764 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80275c:	83 c0 01             	add    $0x1,%eax
  80275f:	83 c2 01             	add    $0x1,%edx
  802762:	eb ea                	jmp    80274e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  802764:	0f b6 c1             	movzbl %cl,%eax
  802767:	0f b6 db             	movzbl %bl,%ebx
  80276a:	29 d8                	sub    %ebx,%eax
  80276c:	eb 05                	jmp    802773 <memcmp+0x35>
	}

	return 0;
  80276e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802773:	5b                   	pop    %ebx
  802774:	5e                   	pop    %esi
  802775:	5d                   	pop    %ebp
  802776:	c3                   	ret    

00802777 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  802780:	89 c2                	mov    %eax,%edx
  802782:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802785:	39 d0                	cmp    %edx,%eax
  802787:	73 09                	jae    802792 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  802789:	38 08                	cmp    %cl,(%eax)
  80278b:	74 05                	je     802792 <memfind+0x1b>
	for (; s < ends; s++)
  80278d:	83 c0 01             	add    $0x1,%eax
  802790:	eb f3                	jmp    802785 <memfind+0xe>
			break;
	return (void *) s;
}
  802792:	5d                   	pop    %ebp
  802793:	c3                   	ret    

00802794 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	57                   	push   %edi
  802798:	56                   	push   %esi
  802799:	53                   	push   %ebx
  80279a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80279d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027a0:	eb 03                	jmp    8027a5 <strtol+0x11>
		s++;
  8027a2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8027a5:	0f b6 01             	movzbl (%ecx),%eax
  8027a8:	3c 20                	cmp    $0x20,%al
  8027aa:	74 f6                	je     8027a2 <strtol+0xe>
  8027ac:	3c 09                	cmp    $0x9,%al
  8027ae:	74 f2                	je     8027a2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8027b0:	3c 2b                	cmp    $0x2b,%al
  8027b2:	74 2a                	je     8027de <strtol+0x4a>
	int neg = 0;
  8027b4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8027b9:	3c 2d                	cmp    $0x2d,%al
  8027bb:	74 2b                	je     8027e8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8027bd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8027c3:	75 0f                	jne    8027d4 <strtol+0x40>
  8027c5:	80 39 30             	cmpb   $0x30,(%ecx)
  8027c8:	74 28                	je     8027f2 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8027ca:	85 db                	test   %ebx,%ebx
  8027cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027d1:	0f 44 d8             	cmove  %eax,%ebx
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8027dc:	eb 50                	jmp    80282e <strtol+0x9a>
		s++;
  8027de:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8027e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e6:	eb d5                	jmp    8027bd <strtol+0x29>
		s++, neg = 1;
  8027e8:	83 c1 01             	add    $0x1,%ecx
  8027eb:	bf 01 00 00 00       	mov    $0x1,%edi
  8027f0:	eb cb                	jmp    8027bd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8027f2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8027f6:	74 0e                	je     802806 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  8027f8:	85 db                	test   %ebx,%ebx
  8027fa:	75 d8                	jne    8027d4 <strtol+0x40>
		s++, base = 8;
  8027fc:	83 c1 01             	add    $0x1,%ecx
  8027ff:	bb 08 00 00 00       	mov    $0x8,%ebx
  802804:	eb ce                	jmp    8027d4 <strtol+0x40>
		s += 2, base = 16;
  802806:	83 c1 02             	add    $0x2,%ecx
  802809:	bb 10 00 00 00       	mov    $0x10,%ebx
  80280e:	eb c4                	jmp    8027d4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  802810:	8d 72 9f             	lea    -0x61(%edx),%esi
  802813:	89 f3                	mov    %esi,%ebx
  802815:	80 fb 19             	cmp    $0x19,%bl
  802818:	77 29                	ja     802843 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80281a:	0f be d2             	movsbl %dl,%edx
  80281d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802820:	3b 55 10             	cmp    0x10(%ebp),%edx
  802823:	7d 30                	jge    802855 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  802825:	83 c1 01             	add    $0x1,%ecx
  802828:	0f af 45 10          	imul   0x10(%ebp),%eax
  80282c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80282e:	0f b6 11             	movzbl (%ecx),%edx
  802831:	8d 72 d0             	lea    -0x30(%edx),%esi
  802834:	89 f3                	mov    %esi,%ebx
  802836:	80 fb 09             	cmp    $0x9,%bl
  802839:	77 d5                	ja     802810 <strtol+0x7c>
			dig = *s - '0';
  80283b:	0f be d2             	movsbl %dl,%edx
  80283e:	83 ea 30             	sub    $0x30,%edx
  802841:	eb dd                	jmp    802820 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  802843:	8d 72 bf             	lea    -0x41(%edx),%esi
  802846:	89 f3                	mov    %esi,%ebx
  802848:	80 fb 19             	cmp    $0x19,%bl
  80284b:	77 08                	ja     802855 <strtol+0xc1>
			dig = *s - 'A' + 10;
  80284d:	0f be d2             	movsbl %dl,%edx
  802850:	83 ea 37             	sub    $0x37,%edx
  802853:	eb cb                	jmp    802820 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  802855:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802859:	74 05                	je     802860 <strtol+0xcc>
		*endptr = (char *) s;
  80285b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80285e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802860:	89 c2                	mov    %eax,%edx
  802862:	f7 da                	neg    %edx
  802864:	85 ff                	test   %edi,%edi
  802866:	0f 45 c2             	cmovne %edx,%eax
}
  802869:	5b                   	pop    %ebx
  80286a:	5e                   	pop    %esi
  80286b:	5f                   	pop    %edi
  80286c:	5d                   	pop    %ebp
  80286d:	c3                   	ret    

0080286e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
  802871:	57                   	push   %edi
  802872:	56                   	push   %esi
  802873:	53                   	push   %ebx
	asm volatile("int %1\n"
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
  802879:	8b 55 08             	mov    0x8(%ebp),%edx
  80287c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80287f:	89 c3                	mov    %eax,%ebx
  802881:	89 c7                	mov    %eax,%edi
  802883:	89 c6                	mov    %eax,%esi
  802885:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  802887:	5b                   	pop    %ebx
  802888:	5e                   	pop    %esi
  802889:	5f                   	pop    %edi
  80288a:	5d                   	pop    %ebp
  80288b:	c3                   	ret    

0080288c <sys_cgetc>:

int
sys_cgetc(void)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
  80288f:	57                   	push   %edi
  802890:	56                   	push   %esi
  802891:	53                   	push   %ebx
	asm volatile("int %1\n"
  802892:	ba 00 00 00 00       	mov    $0x0,%edx
  802897:	b8 01 00 00 00       	mov    $0x1,%eax
  80289c:	89 d1                	mov    %edx,%ecx
  80289e:	89 d3                	mov    %edx,%ebx
  8028a0:	89 d7                	mov    %edx,%edi
  8028a2:	89 d6                	mov    %edx,%esi
  8028a4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8028a6:	5b                   	pop    %ebx
  8028a7:	5e                   	pop    %esi
  8028a8:	5f                   	pop    %edi
  8028a9:	5d                   	pop    %ebp
  8028aa:	c3                   	ret    

008028ab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	57                   	push   %edi
  8028af:	56                   	push   %esi
  8028b0:	53                   	push   %ebx
  8028b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8028b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8028b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8028c1:	89 cb                	mov    %ecx,%ebx
  8028c3:	89 cf                	mov    %ecx,%edi
  8028c5:	89 ce                	mov    %ecx,%esi
  8028c7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	7f 08                	jg     8028d5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8028cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028d0:	5b                   	pop    %ebx
  8028d1:	5e                   	pop    %esi
  8028d2:	5f                   	pop    %edi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8028d5:	83 ec 0c             	sub    $0xc,%esp
  8028d8:	50                   	push   %eax
  8028d9:	6a 03                	push   $0x3
  8028db:	68 24 4b 80 00       	push   $0x804b24
  8028e0:	6a 43                	push   $0x43
  8028e2:	68 41 4b 80 00       	push   $0x804b41
  8028e7:	e8 f7 f3 ff ff       	call   801ce3 <_panic>

008028ec <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	57                   	push   %edi
  8028f0:	56                   	push   %esi
  8028f1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8028fc:	89 d1                	mov    %edx,%ecx
  8028fe:	89 d3                	mov    %edx,%ebx
  802900:	89 d7                	mov    %edx,%edi
  802902:	89 d6                	mov    %edx,%esi
  802904:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  802906:	5b                   	pop    %ebx
  802907:	5e                   	pop    %esi
  802908:	5f                   	pop    %edi
  802909:	5d                   	pop    %ebp
  80290a:	c3                   	ret    

0080290b <sys_yield>:

void
sys_yield(void)
{
  80290b:	55                   	push   %ebp
  80290c:	89 e5                	mov    %esp,%ebp
  80290e:	57                   	push   %edi
  80290f:	56                   	push   %esi
  802910:	53                   	push   %ebx
	asm volatile("int %1\n"
  802911:	ba 00 00 00 00       	mov    $0x0,%edx
  802916:	b8 0b 00 00 00       	mov    $0xb,%eax
  80291b:	89 d1                	mov    %edx,%ecx
  80291d:	89 d3                	mov    %edx,%ebx
  80291f:	89 d7                	mov    %edx,%edi
  802921:	89 d6                	mov    %edx,%esi
  802923:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802925:	5b                   	pop    %ebx
  802926:	5e                   	pop    %esi
  802927:	5f                   	pop    %edi
  802928:	5d                   	pop    %ebp
  802929:	c3                   	ret    

0080292a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	57                   	push   %edi
  80292e:	56                   	push   %esi
  80292f:	53                   	push   %ebx
  802930:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802933:	be 00 00 00 00       	mov    $0x0,%esi
  802938:	8b 55 08             	mov    0x8(%ebp),%edx
  80293b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80293e:	b8 04 00 00 00       	mov    $0x4,%eax
  802943:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802946:	89 f7                	mov    %esi,%edi
  802948:	cd 30                	int    $0x30
	if(check && ret > 0)
  80294a:	85 c0                	test   %eax,%eax
  80294c:	7f 08                	jg     802956 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80294e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802956:	83 ec 0c             	sub    $0xc,%esp
  802959:	50                   	push   %eax
  80295a:	6a 04                	push   $0x4
  80295c:	68 24 4b 80 00       	push   $0x804b24
  802961:	6a 43                	push   $0x43
  802963:	68 41 4b 80 00       	push   $0x804b41
  802968:	e8 76 f3 ff ff       	call   801ce3 <_panic>

0080296d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80296d:	55                   	push   %ebp
  80296e:	89 e5                	mov    %esp,%ebp
  802970:	57                   	push   %edi
  802971:	56                   	push   %esi
  802972:	53                   	push   %ebx
  802973:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802976:	8b 55 08             	mov    0x8(%ebp),%edx
  802979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80297c:	b8 05 00 00 00       	mov    $0x5,%eax
  802981:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802984:	8b 7d 14             	mov    0x14(%ebp),%edi
  802987:	8b 75 18             	mov    0x18(%ebp),%esi
  80298a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80298c:	85 c0                	test   %eax,%eax
  80298e:	7f 08                	jg     802998 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802990:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802993:	5b                   	pop    %ebx
  802994:	5e                   	pop    %esi
  802995:	5f                   	pop    %edi
  802996:	5d                   	pop    %ebp
  802997:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802998:	83 ec 0c             	sub    $0xc,%esp
  80299b:	50                   	push   %eax
  80299c:	6a 05                	push   $0x5
  80299e:	68 24 4b 80 00       	push   $0x804b24
  8029a3:	6a 43                	push   $0x43
  8029a5:	68 41 4b 80 00       	push   $0x804b41
  8029aa:	e8 34 f3 ff ff       	call   801ce3 <_panic>

008029af <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8029af:	55                   	push   %ebp
  8029b0:	89 e5                	mov    %esp,%ebp
  8029b2:	57                   	push   %edi
  8029b3:	56                   	push   %esi
  8029b4:	53                   	push   %ebx
  8029b5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8029b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029c3:	b8 06 00 00 00       	mov    $0x6,%eax
  8029c8:	89 df                	mov    %ebx,%edi
  8029ca:	89 de                	mov    %ebx,%esi
  8029cc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	7f 08                	jg     8029da <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8029d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029d5:	5b                   	pop    %ebx
  8029d6:	5e                   	pop    %esi
  8029d7:	5f                   	pop    %edi
  8029d8:	5d                   	pop    %ebp
  8029d9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8029da:	83 ec 0c             	sub    $0xc,%esp
  8029dd:	50                   	push   %eax
  8029de:	6a 06                	push   $0x6
  8029e0:	68 24 4b 80 00       	push   $0x804b24
  8029e5:	6a 43                	push   $0x43
  8029e7:	68 41 4b 80 00       	push   $0x804b41
  8029ec:	e8 f2 f2 ff ff       	call   801ce3 <_panic>

008029f1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
  8029f4:	57                   	push   %edi
  8029f5:	56                   	push   %esi
  8029f6:	53                   	push   %ebx
  8029f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8029fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802a02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a05:	b8 08 00 00 00       	mov    $0x8,%eax
  802a0a:	89 df                	mov    %ebx,%edi
  802a0c:	89 de                	mov    %ebx,%esi
  802a0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a10:	85 c0                	test   %eax,%eax
  802a12:	7f 08                	jg     802a1c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802a14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a17:	5b                   	pop    %ebx
  802a18:	5e                   	pop    %esi
  802a19:	5f                   	pop    %edi
  802a1a:	5d                   	pop    %ebp
  802a1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802a1c:	83 ec 0c             	sub    $0xc,%esp
  802a1f:	50                   	push   %eax
  802a20:	6a 08                	push   $0x8
  802a22:	68 24 4b 80 00       	push   $0x804b24
  802a27:	6a 43                	push   $0x43
  802a29:	68 41 4b 80 00       	push   $0x804b41
  802a2e:	e8 b0 f2 ff ff       	call   801ce3 <_panic>

00802a33 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
  802a36:	57                   	push   %edi
  802a37:	56                   	push   %esi
  802a38:	53                   	push   %ebx
  802a39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a41:	8b 55 08             	mov    0x8(%ebp),%edx
  802a44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a47:	b8 09 00 00 00       	mov    $0x9,%eax
  802a4c:	89 df                	mov    %ebx,%edi
  802a4e:	89 de                	mov    %ebx,%esi
  802a50:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a52:	85 c0                	test   %eax,%eax
  802a54:	7f 08                	jg     802a5e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802a56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a59:	5b                   	pop    %ebx
  802a5a:	5e                   	pop    %esi
  802a5b:	5f                   	pop    %edi
  802a5c:	5d                   	pop    %ebp
  802a5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802a5e:	83 ec 0c             	sub    $0xc,%esp
  802a61:	50                   	push   %eax
  802a62:	6a 09                	push   $0x9
  802a64:	68 24 4b 80 00       	push   $0x804b24
  802a69:	6a 43                	push   $0x43
  802a6b:	68 41 4b 80 00       	push   $0x804b41
  802a70:	e8 6e f2 ff ff       	call   801ce3 <_panic>

00802a75 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802a75:	55                   	push   %ebp
  802a76:	89 e5                	mov    %esp,%ebp
  802a78:	57                   	push   %edi
  802a79:	56                   	push   %esi
  802a7a:	53                   	push   %ebx
  802a7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a83:	8b 55 08             	mov    0x8(%ebp),%edx
  802a86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a89:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a8e:	89 df                	mov    %ebx,%edi
  802a90:	89 de                	mov    %ebx,%esi
  802a92:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a94:	85 c0                	test   %eax,%eax
  802a96:	7f 08                	jg     802aa0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a9b:	5b                   	pop    %ebx
  802a9c:	5e                   	pop    %esi
  802a9d:	5f                   	pop    %edi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802aa0:	83 ec 0c             	sub    $0xc,%esp
  802aa3:	50                   	push   %eax
  802aa4:	6a 0a                	push   $0xa
  802aa6:	68 24 4b 80 00       	push   $0x804b24
  802aab:	6a 43                	push   $0x43
  802aad:	68 41 4b 80 00       	push   $0x804b41
  802ab2:	e8 2c f2 ff ff       	call   801ce3 <_panic>

00802ab7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802ab7:	55                   	push   %ebp
  802ab8:	89 e5                	mov    %esp,%ebp
  802aba:	57                   	push   %edi
  802abb:	56                   	push   %esi
  802abc:	53                   	push   %ebx
	asm volatile("int %1\n"
  802abd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ac3:	b8 0c 00 00 00       	mov    $0xc,%eax
  802ac8:	be 00 00 00 00       	mov    $0x0,%esi
  802acd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802ad0:	8b 7d 14             	mov    0x14(%ebp),%edi
  802ad3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802ad5:	5b                   	pop    %ebx
  802ad6:	5e                   	pop    %esi
  802ad7:	5f                   	pop    %edi
  802ad8:	5d                   	pop    %ebp
  802ad9:	c3                   	ret    

00802ada <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802ada:	55                   	push   %ebp
  802adb:	89 e5                	mov    %esp,%ebp
  802add:	57                   	push   %edi
  802ade:	56                   	push   %esi
  802adf:	53                   	push   %ebx
  802ae0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802ae3:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ae8:	8b 55 08             	mov    0x8(%ebp),%edx
  802aeb:	b8 0d 00 00 00       	mov    $0xd,%eax
  802af0:	89 cb                	mov    %ecx,%ebx
  802af2:	89 cf                	mov    %ecx,%edi
  802af4:	89 ce                	mov    %ecx,%esi
  802af6:	cd 30                	int    $0x30
	if(check && ret > 0)
  802af8:	85 c0                	test   %eax,%eax
  802afa:	7f 08                	jg     802b04 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802aff:	5b                   	pop    %ebx
  802b00:	5e                   	pop    %esi
  802b01:	5f                   	pop    %edi
  802b02:	5d                   	pop    %ebp
  802b03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802b04:	83 ec 0c             	sub    $0xc,%esp
  802b07:	50                   	push   %eax
  802b08:	6a 0d                	push   $0xd
  802b0a:	68 24 4b 80 00       	push   $0x804b24
  802b0f:	6a 43                	push   $0x43
  802b11:	68 41 4b 80 00       	push   $0x804b41
  802b16:	e8 c8 f1 ff ff       	call   801ce3 <_panic>

00802b1b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  802b1b:	55                   	push   %ebp
  802b1c:	89 e5                	mov    %esp,%ebp
  802b1e:	57                   	push   %edi
  802b1f:	56                   	push   %esi
  802b20:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b21:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b26:	8b 55 08             	mov    0x8(%ebp),%edx
  802b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b2c:	b8 0e 00 00 00       	mov    $0xe,%eax
  802b31:	89 df                	mov    %ebx,%edi
  802b33:	89 de                	mov    %ebx,%esi
  802b35:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  802b37:	5b                   	pop    %ebx
  802b38:	5e                   	pop    %esi
  802b39:	5f                   	pop    %edi
  802b3a:	5d                   	pop    %ebp
  802b3b:	c3                   	ret    

00802b3c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
  802b3f:	57                   	push   %edi
  802b40:	56                   	push   %esi
  802b41:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b42:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b47:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4a:	b8 0f 00 00 00       	mov    $0xf,%eax
  802b4f:	89 cb                	mov    %ecx,%ebx
  802b51:	89 cf                	mov    %ecx,%edi
  802b53:	89 ce                	mov    %ecx,%esi
  802b55:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  802b57:	5b                   	pop    %ebx
  802b58:	5e                   	pop    %esi
  802b59:	5f                   	pop    %edi
  802b5a:	5d                   	pop    %ebp
  802b5b:	c3                   	ret    

00802b5c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802b5c:	55                   	push   %ebp
  802b5d:	89 e5                	mov    %esp,%ebp
  802b5f:	57                   	push   %edi
  802b60:	56                   	push   %esi
  802b61:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b62:	ba 00 00 00 00       	mov    $0x0,%edx
  802b67:	b8 10 00 00 00       	mov    $0x10,%eax
  802b6c:	89 d1                	mov    %edx,%ecx
  802b6e:	89 d3                	mov    %edx,%ebx
  802b70:	89 d7                	mov    %edx,%edi
  802b72:	89 d6                	mov    %edx,%esi
  802b74:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802b76:	5b                   	pop    %ebx
  802b77:	5e                   	pop    %esi
  802b78:	5f                   	pop    %edi
  802b79:	5d                   	pop    %ebp
  802b7a:	c3                   	ret    

00802b7b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  802b7b:	55                   	push   %ebp
  802b7c:	89 e5                	mov    %esp,%ebp
  802b7e:	57                   	push   %edi
  802b7f:	56                   	push   %esi
  802b80:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b81:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b86:	8b 55 08             	mov    0x8(%ebp),%edx
  802b89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b8c:	b8 11 00 00 00       	mov    $0x11,%eax
  802b91:	89 df                	mov    %ebx,%edi
  802b93:	89 de                	mov    %ebx,%esi
  802b95:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  802b97:	5b                   	pop    %ebx
  802b98:	5e                   	pop    %esi
  802b99:	5f                   	pop    %edi
  802b9a:	5d                   	pop    %ebp
  802b9b:	c3                   	ret    

00802b9c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
  802b9f:	57                   	push   %edi
  802ba0:	56                   	push   %esi
  802ba1:	53                   	push   %ebx
	asm volatile("int %1\n"
  802ba2:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  802baa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bad:	b8 12 00 00 00       	mov    $0x12,%eax
  802bb2:	89 df                	mov    %ebx,%edi
  802bb4:	89 de                	mov    %ebx,%esi
  802bb6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  802bb8:	5b                   	pop    %ebx
  802bb9:	5e                   	pop    %esi
  802bba:	5f                   	pop    %edi
  802bbb:	5d                   	pop    %ebp
  802bbc:	c3                   	ret    

00802bbd <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  802bbd:	55                   	push   %ebp
  802bbe:	89 e5                	mov    %esp,%ebp
  802bc0:	57                   	push   %edi
  802bc1:	56                   	push   %esi
  802bc2:	53                   	push   %ebx
  802bc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802bc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  802bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bd1:	b8 13 00 00 00       	mov    $0x13,%eax
  802bd6:	89 df                	mov    %ebx,%edi
  802bd8:	89 de                	mov    %ebx,%esi
  802bda:	cd 30                	int    $0x30
	if(check && ret > 0)
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	7f 08                	jg     802be8 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802be3:	5b                   	pop    %ebx
  802be4:	5e                   	pop    %esi
  802be5:	5f                   	pop    %edi
  802be6:	5d                   	pop    %ebp
  802be7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802be8:	83 ec 0c             	sub    $0xc,%esp
  802beb:	50                   	push   %eax
  802bec:	6a 13                	push   $0x13
  802bee:	68 24 4b 80 00       	push   $0x804b24
  802bf3:	6a 43                	push   $0x43
  802bf5:	68 41 4b 80 00       	push   $0x804b41
  802bfa:	e8 e4 f0 ff ff       	call   801ce3 <_panic>

00802bff <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802bff:	55                   	push   %ebp
  802c00:	89 e5                	mov    %esp,%ebp
  802c02:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802c05:	83 3d 54 a0 80 00 00 	cmpl   $0x0,0x80a054
  802c0c:	74 0a                	je     802c18 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	a3 54 a0 80 00       	mov    %eax,0x80a054
}
  802c16:	c9                   	leave  
  802c17:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	6a 07                	push   $0x7
  802c1d:	68 00 f0 bf ee       	push   $0xeebff000
  802c22:	6a 00                	push   $0x0
  802c24:	e8 01 fd ff ff       	call   80292a <sys_page_alloc>
		if(r < 0)
  802c29:	83 c4 10             	add    $0x10,%esp
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	78 2a                	js     802c5a <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802c30:	83 ec 08             	sub    $0x8,%esp
  802c33:	68 6e 2c 80 00       	push   $0x802c6e
  802c38:	6a 00                	push   $0x0
  802c3a:	e8 36 fe ff ff       	call   802a75 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802c3f:	83 c4 10             	add    $0x10,%esp
  802c42:	85 c0                	test   %eax,%eax
  802c44:	79 c8                	jns    802c0e <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802c46:	83 ec 04             	sub    $0x4,%esp
  802c49:	68 80 4b 80 00       	push   $0x804b80
  802c4e:	6a 25                	push   $0x25
  802c50:	68 b9 4b 80 00       	push   $0x804bb9
  802c55:	e8 89 f0 ff ff       	call   801ce3 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802c5a:	83 ec 04             	sub    $0x4,%esp
  802c5d:	68 50 4b 80 00       	push   $0x804b50
  802c62:	6a 22                	push   $0x22
  802c64:	68 b9 4b 80 00       	push   $0x804bb9
  802c69:	e8 75 f0 ff ff       	call   801ce3 <_panic>

00802c6e <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c6e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c6f:	a1 54 a0 80 00       	mov    0x80a054,%eax
	call *%eax
  802c74:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c76:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802c79:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802c7d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802c81:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802c84:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802c86:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802c8a:	83 c4 08             	add    $0x8,%esp
	popal
  802c8d:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802c8e:	83 c4 04             	add    $0x4,%esp
	popfl
  802c91:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802c92:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802c93:	c3                   	ret    

00802c94 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	56                   	push   %esi
  802c98:	53                   	push   %ebx
  802c99:	8b 75 08             	mov    0x8(%ebp),%esi
  802c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802ca2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802ca4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802ca9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802cac:	83 ec 0c             	sub    $0xc,%esp
  802caf:	50                   	push   %eax
  802cb0:	e8 25 fe ff ff       	call   802ada <sys_ipc_recv>
	if(ret < 0){
  802cb5:	83 c4 10             	add    $0x10,%esp
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	78 2b                	js     802ce7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802cbc:	85 f6                	test   %esi,%esi
  802cbe:	74 0a                	je     802cca <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802cc0:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802cc5:	8b 40 74             	mov    0x74(%eax),%eax
  802cc8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802cca:	85 db                	test   %ebx,%ebx
  802ccc:	74 0a                	je     802cd8 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802cce:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802cd3:	8b 40 78             	mov    0x78(%eax),%eax
  802cd6:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802cd8:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802cdd:	8b 40 70             	mov    0x70(%eax),%eax
}
  802ce0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ce3:	5b                   	pop    %ebx
  802ce4:	5e                   	pop    %esi
  802ce5:	5d                   	pop    %ebp
  802ce6:	c3                   	ret    
		if(from_env_store)
  802ce7:	85 f6                	test   %esi,%esi
  802ce9:	74 06                	je     802cf1 <ipc_recv+0x5d>
			*from_env_store = 0;
  802ceb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802cf1:	85 db                	test   %ebx,%ebx
  802cf3:	74 eb                	je     802ce0 <ipc_recv+0x4c>
			*perm_store = 0;
  802cf5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802cfb:	eb e3                	jmp    802ce0 <ipc_recv+0x4c>

00802cfd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802cfd:	55                   	push   %ebp
  802cfe:	89 e5                	mov    %esp,%ebp
  802d00:	57                   	push   %edi
  802d01:	56                   	push   %esi
  802d02:	53                   	push   %ebx
  802d03:	83 ec 0c             	sub    $0xc,%esp
  802d06:	8b 7d 08             	mov    0x8(%ebp),%edi
  802d09:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802d0f:	85 db                	test   %ebx,%ebx
  802d11:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802d16:	0f 44 d8             	cmove  %eax,%ebx
  802d19:	eb 05                	jmp    802d20 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802d1b:	e8 eb fb ff ff       	call   80290b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802d20:	ff 75 14             	pushl  0x14(%ebp)
  802d23:	53                   	push   %ebx
  802d24:	56                   	push   %esi
  802d25:	57                   	push   %edi
  802d26:	e8 8c fd ff ff       	call   802ab7 <sys_ipc_try_send>
  802d2b:	83 c4 10             	add    $0x10,%esp
  802d2e:	85 c0                	test   %eax,%eax
  802d30:	74 1b                	je     802d4d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802d32:	79 e7                	jns    802d1b <ipc_send+0x1e>
  802d34:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d37:	74 e2                	je     802d1b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802d39:	83 ec 04             	sub    $0x4,%esp
  802d3c:	68 c7 4b 80 00       	push   $0x804bc7
  802d41:	6a 48                	push   $0x48
  802d43:	68 dc 4b 80 00       	push   $0x804bdc
  802d48:	e8 96 ef ff ff       	call   801ce3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d50:	5b                   	pop    %ebx
  802d51:	5e                   	pop    %esi
  802d52:	5f                   	pop    %edi
  802d53:	5d                   	pop    %ebp
  802d54:	c3                   	ret    

00802d55 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
  802d58:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d5b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d60:	89 c2                	mov    %eax,%edx
  802d62:	c1 e2 07             	shl    $0x7,%edx
  802d65:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d6b:	8b 52 50             	mov    0x50(%edx),%edx
  802d6e:	39 ca                	cmp    %ecx,%edx
  802d70:	74 11                	je     802d83 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802d72:	83 c0 01             	add    $0x1,%eax
  802d75:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d7a:	75 e4                	jne    802d60 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d81:	eb 0b                	jmp    802d8e <ipc_find_env+0x39>
			return envs[i].env_id;
  802d83:	c1 e0 07             	shl    $0x7,%eax
  802d86:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d8b:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d8e:	5d                   	pop    %ebp
  802d8f:	c3                   	ret    

00802d90 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802d90:	55                   	push   %ebp
  802d91:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	05 00 00 00 30       	add    $0x30000000,%eax
  802d9b:	c1 e8 0c             	shr    $0xc,%eax
}
  802d9e:	5d                   	pop    %ebp
  802d9f:	c3                   	ret    

00802da0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802dab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802db0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802db5:	5d                   	pop    %ebp
  802db6:	c3                   	ret    

00802db7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802db7:	55                   	push   %ebp
  802db8:	89 e5                	mov    %esp,%ebp
  802dba:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802dbf:	89 c2                	mov    %eax,%edx
  802dc1:	c1 ea 16             	shr    $0x16,%edx
  802dc4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802dcb:	f6 c2 01             	test   $0x1,%dl
  802dce:	74 2d                	je     802dfd <fd_alloc+0x46>
  802dd0:	89 c2                	mov    %eax,%edx
  802dd2:	c1 ea 0c             	shr    $0xc,%edx
  802dd5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802ddc:	f6 c2 01             	test   $0x1,%dl
  802ddf:	74 1c                	je     802dfd <fd_alloc+0x46>
  802de1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802de6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802deb:	75 d2                	jne    802dbf <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802df6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802dfb:	eb 0a                	jmp    802e07 <fd_alloc+0x50>
			*fd_store = fd;
  802dfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e00:	89 01                	mov    %eax,(%ecx)
			return 0;
  802e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e07:	5d                   	pop    %ebp
  802e08:	c3                   	ret    

00802e09 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802e09:	55                   	push   %ebp
  802e0a:	89 e5                	mov    %esp,%ebp
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802e0f:	83 f8 1f             	cmp    $0x1f,%eax
  802e12:	77 30                	ja     802e44 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802e14:	c1 e0 0c             	shl    $0xc,%eax
  802e17:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802e1c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802e22:	f6 c2 01             	test   $0x1,%dl
  802e25:	74 24                	je     802e4b <fd_lookup+0x42>
  802e27:	89 c2                	mov    %eax,%edx
  802e29:	c1 ea 0c             	shr    $0xc,%edx
  802e2c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e33:	f6 c2 01             	test   $0x1,%dl
  802e36:	74 1a                	je     802e52 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3b:	89 02                	mov    %eax,(%edx)
	return 0;
  802e3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e42:	5d                   	pop    %ebp
  802e43:	c3                   	ret    
		return -E_INVAL;
  802e44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e49:	eb f7                	jmp    802e42 <fd_lookup+0x39>
		return -E_INVAL;
  802e4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e50:	eb f0                	jmp    802e42 <fd_lookup+0x39>
  802e52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e57:	eb e9                	jmp    802e42 <fd_lookup+0x39>

00802e59 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
  802e5c:	83 ec 08             	sub    $0x8,%esp
  802e5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802e62:	ba 00 00 00 00       	mov    $0x0,%edx
  802e67:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802e6c:	39 08                	cmp    %ecx,(%eax)
  802e6e:	74 38                	je     802ea8 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  802e70:	83 c2 01             	add    $0x1,%edx
  802e73:	8b 04 95 68 4c 80 00 	mov    0x804c68(,%edx,4),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	75 ee                	jne    802e6c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802e7e:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802e83:	8b 40 48             	mov    0x48(%eax),%eax
  802e86:	83 ec 04             	sub    $0x4,%esp
  802e89:	51                   	push   %ecx
  802e8a:	50                   	push   %eax
  802e8b:	68 e8 4b 80 00       	push   $0x804be8
  802e90:	e8 44 ef ff ff       	call   801dd9 <cprintf>
	*dev = 0;
  802e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802e9e:	83 c4 10             	add    $0x10,%esp
  802ea1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ea6:	c9                   	leave  
  802ea7:	c3                   	ret    
			*dev = devtab[i];
  802ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802eab:	89 01                	mov    %eax,(%ecx)
			return 0;
  802ead:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb2:	eb f2                	jmp    802ea6 <dev_lookup+0x4d>

00802eb4 <fd_close>:
{
  802eb4:	55                   	push   %ebp
  802eb5:	89 e5                	mov    %esp,%ebp
  802eb7:	57                   	push   %edi
  802eb8:	56                   	push   %esi
  802eb9:	53                   	push   %ebx
  802eba:	83 ec 24             	sub    $0x24,%esp
  802ebd:	8b 75 08             	mov    0x8(%ebp),%esi
  802ec0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ec3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802ec6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ec7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802ecd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ed0:	50                   	push   %eax
  802ed1:	e8 33 ff ff ff       	call   802e09 <fd_lookup>
  802ed6:	89 c3                	mov    %eax,%ebx
  802ed8:	83 c4 10             	add    $0x10,%esp
  802edb:	85 c0                	test   %eax,%eax
  802edd:	78 05                	js     802ee4 <fd_close+0x30>
	    || fd != fd2)
  802edf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802ee2:	74 16                	je     802efa <fd_close+0x46>
		return (must_exist ? r : 0);
  802ee4:	89 f8                	mov    %edi,%eax
  802ee6:	84 c0                	test   %al,%al
  802ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  802eed:	0f 44 d8             	cmove  %eax,%ebx
}
  802ef0:	89 d8                	mov    %ebx,%eax
  802ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ef5:	5b                   	pop    %ebx
  802ef6:	5e                   	pop    %esi
  802ef7:	5f                   	pop    %edi
  802ef8:	5d                   	pop    %ebp
  802ef9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802efa:	83 ec 08             	sub    $0x8,%esp
  802efd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802f00:	50                   	push   %eax
  802f01:	ff 36                	pushl  (%esi)
  802f03:	e8 51 ff ff ff       	call   802e59 <dev_lookup>
  802f08:	89 c3                	mov    %eax,%ebx
  802f0a:	83 c4 10             	add    $0x10,%esp
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	78 1a                	js     802f2b <fd_close+0x77>
		if (dev->dev_close)
  802f11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f14:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802f17:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	74 0b                	je     802f2b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802f20:	83 ec 0c             	sub    $0xc,%esp
  802f23:	56                   	push   %esi
  802f24:	ff d0                	call   *%eax
  802f26:	89 c3                	mov    %eax,%ebx
  802f28:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802f2b:	83 ec 08             	sub    $0x8,%esp
  802f2e:	56                   	push   %esi
  802f2f:	6a 00                	push   $0x0
  802f31:	e8 79 fa ff ff       	call   8029af <sys_page_unmap>
	return r;
  802f36:	83 c4 10             	add    $0x10,%esp
  802f39:	eb b5                	jmp    802ef0 <fd_close+0x3c>

00802f3b <close>:

int
close(int fdnum)
{
  802f3b:	55                   	push   %ebp
  802f3c:	89 e5                	mov    %esp,%ebp
  802f3e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f44:	50                   	push   %eax
  802f45:	ff 75 08             	pushl  0x8(%ebp)
  802f48:	e8 bc fe ff ff       	call   802e09 <fd_lookup>
  802f4d:	83 c4 10             	add    $0x10,%esp
  802f50:	85 c0                	test   %eax,%eax
  802f52:	79 02                	jns    802f56 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    
		return fd_close(fd, 1);
  802f56:	83 ec 08             	sub    $0x8,%esp
  802f59:	6a 01                	push   $0x1
  802f5b:	ff 75 f4             	pushl  -0xc(%ebp)
  802f5e:	e8 51 ff ff ff       	call   802eb4 <fd_close>
  802f63:	83 c4 10             	add    $0x10,%esp
  802f66:	eb ec                	jmp    802f54 <close+0x19>

00802f68 <close_all>:

void
close_all(void)
{
  802f68:	55                   	push   %ebp
  802f69:	89 e5                	mov    %esp,%ebp
  802f6b:	53                   	push   %ebx
  802f6c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802f74:	83 ec 0c             	sub    $0xc,%esp
  802f77:	53                   	push   %ebx
  802f78:	e8 be ff ff ff       	call   802f3b <close>
	for (i = 0; i < MAXFD; i++)
  802f7d:	83 c3 01             	add    $0x1,%ebx
  802f80:	83 c4 10             	add    $0x10,%esp
  802f83:	83 fb 20             	cmp    $0x20,%ebx
  802f86:	75 ec                	jne    802f74 <close_all+0xc>
}
  802f88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f8b:	c9                   	leave  
  802f8c:	c3                   	ret    

00802f8d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802f8d:	55                   	push   %ebp
  802f8e:	89 e5                	mov    %esp,%ebp
  802f90:	57                   	push   %edi
  802f91:	56                   	push   %esi
  802f92:	53                   	push   %ebx
  802f93:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802f96:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802f99:	50                   	push   %eax
  802f9a:	ff 75 08             	pushl  0x8(%ebp)
  802f9d:	e8 67 fe ff ff       	call   802e09 <fd_lookup>
  802fa2:	89 c3                	mov    %eax,%ebx
  802fa4:	83 c4 10             	add    $0x10,%esp
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	0f 88 81 00 00 00    	js     803030 <dup+0xa3>
		return r;
	close(newfdnum);
  802faf:	83 ec 0c             	sub    $0xc,%esp
  802fb2:	ff 75 0c             	pushl  0xc(%ebp)
  802fb5:	e8 81 ff ff ff       	call   802f3b <close>

	newfd = INDEX2FD(newfdnum);
  802fba:	8b 75 0c             	mov    0xc(%ebp),%esi
  802fbd:	c1 e6 0c             	shl    $0xc,%esi
  802fc0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802fc6:	83 c4 04             	add    $0x4,%esp
  802fc9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fcc:	e8 cf fd ff ff       	call   802da0 <fd2data>
  802fd1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802fd3:	89 34 24             	mov    %esi,(%esp)
  802fd6:	e8 c5 fd ff ff       	call   802da0 <fd2data>
  802fdb:	83 c4 10             	add    $0x10,%esp
  802fde:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802fe0:	89 d8                	mov    %ebx,%eax
  802fe2:	c1 e8 16             	shr    $0x16,%eax
  802fe5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802fec:	a8 01                	test   $0x1,%al
  802fee:	74 11                	je     803001 <dup+0x74>
  802ff0:	89 d8                	mov    %ebx,%eax
  802ff2:	c1 e8 0c             	shr    $0xc,%eax
  802ff5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802ffc:	f6 c2 01             	test   $0x1,%dl
  802fff:	75 39                	jne    80303a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803001:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803004:	89 d0                	mov    %edx,%eax
  803006:	c1 e8 0c             	shr    $0xc,%eax
  803009:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803010:	83 ec 0c             	sub    $0xc,%esp
  803013:	25 07 0e 00 00       	and    $0xe07,%eax
  803018:	50                   	push   %eax
  803019:	56                   	push   %esi
  80301a:	6a 00                	push   $0x0
  80301c:	52                   	push   %edx
  80301d:	6a 00                	push   $0x0
  80301f:	e8 49 f9 ff ff       	call   80296d <sys_page_map>
  803024:	89 c3                	mov    %eax,%ebx
  803026:	83 c4 20             	add    $0x20,%esp
  803029:	85 c0                	test   %eax,%eax
  80302b:	78 31                	js     80305e <dup+0xd1>
		goto err;

	return newfdnum;
  80302d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  803030:	89 d8                	mov    %ebx,%eax
  803032:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803035:	5b                   	pop    %ebx
  803036:	5e                   	pop    %esi
  803037:	5f                   	pop    %edi
  803038:	5d                   	pop    %ebp
  803039:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80303a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803041:	83 ec 0c             	sub    $0xc,%esp
  803044:	25 07 0e 00 00       	and    $0xe07,%eax
  803049:	50                   	push   %eax
  80304a:	57                   	push   %edi
  80304b:	6a 00                	push   $0x0
  80304d:	53                   	push   %ebx
  80304e:	6a 00                	push   $0x0
  803050:	e8 18 f9 ff ff       	call   80296d <sys_page_map>
  803055:	89 c3                	mov    %eax,%ebx
  803057:	83 c4 20             	add    $0x20,%esp
  80305a:	85 c0                	test   %eax,%eax
  80305c:	79 a3                	jns    803001 <dup+0x74>
	sys_page_unmap(0, newfd);
  80305e:	83 ec 08             	sub    $0x8,%esp
  803061:	56                   	push   %esi
  803062:	6a 00                	push   $0x0
  803064:	e8 46 f9 ff ff       	call   8029af <sys_page_unmap>
	sys_page_unmap(0, nva);
  803069:	83 c4 08             	add    $0x8,%esp
  80306c:	57                   	push   %edi
  80306d:	6a 00                	push   $0x0
  80306f:	e8 3b f9 ff ff       	call   8029af <sys_page_unmap>
	return r;
  803074:	83 c4 10             	add    $0x10,%esp
  803077:	eb b7                	jmp    803030 <dup+0xa3>

00803079 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803079:	55                   	push   %ebp
  80307a:	89 e5                	mov    %esp,%ebp
  80307c:	53                   	push   %ebx
  80307d:	83 ec 1c             	sub    $0x1c,%esp
  803080:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803083:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803086:	50                   	push   %eax
  803087:	53                   	push   %ebx
  803088:	e8 7c fd ff ff       	call   802e09 <fd_lookup>
  80308d:	83 c4 10             	add    $0x10,%esp
  803090:	85 c0                	test   %eax,%eax
  803092:	78 3f                	js     8030d3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803094:	83 ec 08             	sub    $0x8,%esp
  803097:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80309a:	50                   	push   %eax
  80309b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309e:	ff 30                	pushl  (%eax)
  8030a0:	e8 b4 fd ff ff       	call   802e59 <dev_lookup>
  8030a5:	83 c4 10             	add    $0x10,%esp
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	78 27                	js     8030d3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8030ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030af:	8b 42 08             	mov    0x8(%edx),%eax
  8030b2:	83 e0 03             	and    $0x3,%eax
  8030b5:	83 f8 01             	cmp    $0x1,%eax
  8030b8:	74 1e                	je     8030d8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 40 08             	mov    0x8(%eax),%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 35                	je     8030f9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	ff 75 10             	pushl  0x10(%ebp)
  8030ca:	ff 75 0c             	pushl  0xc(%ebp)
  8030cd:	52                   	push   %edx
  8030ce:	ff d0                	call   *%eax
  8030d0:	83 c4 10             	add    $0x10,%esp
}
  8030d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030d6:	c9                   	leave  
  8030d7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8030d8:	a1 50 a0 80 00       	mov    0x80a050,%eax
  8030dd:	8b 40 48             	mov    0x48(%eax),%eax
  8030e0:	83 ec 04             	sub    $0x4,%esp
  8030e3:	53                   	push   %ebx
  8030e4:	50                   	push   %eax
  8030e5:	68 2c 4c 80 00       	push   $0x804c2c
  8030ea:	e8 ea ec ff ff       	call   801dd9 <cprintf>
		return -E_INVAL;
  8030ef:	83 c4 10             	add    $0x10,%esp
  8030f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030f7:	eb da                	jmp    8030d3 <read+0x5a>
		return -E_NOT_SUPP;
  8030f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8030fe:	eb d3                	jmp    8030d3 <read+0x5a>

00803100 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
  803103:	57                   	push   %edi
  803104:	56                   	push   %esi
  803105:	53                   	push   %ebx
  803106:	83 ec 0c             	sub    $0xc,%esp
  803109:	8b 7d 08             	mov    0x8(%ebp),%edi
  80310c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80310f:	bb 00 00 00 00       	mov    $0x0,%ebx
  803114:	39 f3                	cmp    %esi,%ebx
  803116:	73 23                	jae    80313b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803118:	83 ec 04             	sub    $0x4,%esp
  80311b:	89 f0                	mov    %esi,%eax
  80311d:	29 d8                	sub    %ebx,%eax
  80311f:	50                   	push   %eax
  803120:	89 d8                	mov    %ebx,%eax
  803122:	03 45 0c             	add    0xc(%ebp),%eax
  803125:	50                   	push   %eax
  803126:	57                   	push   %edi
  803127:	e8 4d ff ff ff       	call   803079 <read>
		if (m < 0)
  80312c:	83 c4 10             	add    $0x10,%esp
  80312f:	85 c0                	test   %eax,%eax
  803131:	78 06                	js     803139 <readn+0x39>
			return m;
		if (m == 0)
  803133:	74 06                	je     80313b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  803135:	01 c3                	add    %eax,%ebx
  803137:	eb db                	jmp    803114 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803139:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80313b:	89 d8                	mov    %ebx,%eax
  80313d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803140:	5b                   	pop    %ebx
  803141:	5e                   	pop    %esi
  803142:	5f                   	pop    %edi
  803143:	5d                   	pop    %ebp
  803144:	c3                   	ret    

00803145 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803145:	55                   	push   %ebp
  803146:	89 e5                	mov    %esp,%ebp
  803148:	53                   	push   %ebx
  803149:	83 ec 1c             	sub    $0x1c,%esp
  80314c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80314f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803152:	50                   	push   %eax
  803153:	53                   	push   %ebx
  803154:	e8 b0 fc ff ff       	call   802e09 <fd_lookup>
  803159:	83 c4 10             	add    $0x10,%esp
  80315c:	85 c0                	test   %eax,%eax
  80315e:	78 3a                	js     80319a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803160:	83 ec 08             	sub    $0x8,%esp
  803163:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803166:	50                   	push   %eax
  803167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316a:	ff 30                	pushl  (%eax)
  80316c:	e8 e8 fc ff ff       	call   802e59 <dev_lookup>
  803171:	83 c4 10             	add    $0x10,%esp
  803174:	85 c0                	test   %eax,%eax
  803176:	78 22                	js     80319a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80317f:	74 1e                	je     80319f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803181:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803184:	8b 52 0c             	mov    0xc(%edx),%edx
  803187:	85 d2                	test   %edx,%edx
  803189:	74 35                	je     8031c0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80318b:	83 ec 04             	sub    $0x4,%esp
  80318e:	ff 75 10             	pushl  0x10(%ebp)
  803191:	ff 75 0c             	pushl  0xc(%ebp)
  803194:	50                   	push   %eax
  803195:	ff d2                	call   *%edx
  803197:	83 c4 10             	add    $0x10,%esp
}
  80319a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80319d:	c9                   	leave  
  80319e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80319f:	a1 50 a0 80 00       	mov    0x80a050,%eax
  8031a4:	8b 40 48             	mov    0x48(%eax),%eax
  8031a7:	83 ec 04             	sub    $0x4,%esp
  8031aa:	53                   	push   %ebx
  8031ab:	50                   	push   %eax
  8031ac:	68 48 4c 80 00       	push   $0x804c48
  8031b1:	e8 23 ec ff ff       	call   801dd9 <cprintf>
		return -E_INVAL;
  8031b6:	83 c4 10             	add    $0x10,%esp
  8031b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031be:	eb da                	jmp    80319a <write+0x55>
		return -E_NOT_SUPP;
  8031c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8031c5:	eb d3                	jmp    80319a <write+0x55>

008031c7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8031c7:	55                   	push   %ebp
  8031c8:	89 e5                	mov    %esp,%ebp
  8031ca:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031d0:	50                   	push   %eax
  8031d1:	ff 75 08             	pushl  0x8(%ebp)
  8031d4:	e8 30 fc ff ff       	call   802e09 <fd_lookup>
  8031d9:	83 c4 10             	add    $0x10,%esp
  8031dc:	85 c0                	test   %eax,%eax
  8031de:	78 0e                	js     8031ee <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8031e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8031e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ee:	c9                   	leave  
  8031ef:	c3                   	ret    

008031f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8031f0:	55                   	push   %ebp
  8031f1:	89 e5                	mov    %esp,%ebp
  8031f3:	53                   	push   %ebx
  8031f4:	83 ec 1c             	sub    $0x1c,%esp
  8031f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031fd:	50                   	push   %eax
  8031fe:	53                   	push   %ebx
  8031ff:	e8 05 fc ff ff       	call   802e09 <fd_lookup>
  803204:	83 c4 10             	add    $0x10,%esp
  803207:	85 c0                	test   %eax,%eax
  803209:	78 37                	js     803242 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80320b:	83 ec 08             	sub    $0x8,%esp
  80320e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803211:	50                   	push   %eax
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	ff 30                	pushl  (%eax)
  803217:	e8 3d fc ff ff       	call   802e59 <dev_lookup>
  80321c:	83 c4 10             	add    $0x10,%esp
  80321f:	85 c0                	test   %eax,%eax
  803221:	78 1f                	js     803242 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803226:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80322a:	74 1b                	je     803247 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80322c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322f:	8b 52 18             	mov    0x18(%edx),%edx
  803232:	85 d2                	test   %edx,%edx
  803234:	74 32                	je     803268 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  803236:	83 ec 08             	sub    $0x8,%esp
  803239:	ff 75 0c             	pushl  0xc(%ebp)
  80323c:	50                   	push   %eax
  80323d:	ff d2                	call   *%edx
  80323f:	83 c4 10             	add    $0x10,%esp
}
  803242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803245:	c9                   	leave  
  803246:	c3                   	ret    
			thisenv->env_id, fdnum);
  803247:	a1 50 a0 80 00       	mov    0x80a050,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80324c:	8b 40 48             	mov    0x48(%eax),%eax
  80324f:	83 ec 04             	sub    $0x4,%esp
  803252:	53                   	push   %ebx
  803253:	50                   	push   %eax
  803254:	68 08 4c 80 00       	push   $0x804c08
  803259:	e8 7b eb ff ff       	call   801dd9 <cprintf>
		return -E_INVAL;
  80325e:	83 c4 10             	add    $0x10,%esp
  803261:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803266:	eb da                	jmp    803242 <ftruncate+0x52>
		return -E_NOT_SUPP;
  803268:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80326d:	eb d3                	jmp    803242 <ftruncate+0x52>

0080326f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80326f:	55                   	push   %ebp
  803270:	89 e5                	mov    %esp,%ebp
  803272:	53                   	push   %ebx
  803273:	83 ec 1c             	sub    $0x1c,%esp
  803276:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803279:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80327c:	50                   	push   %eax
  80327d:	ff 75 08             	pushl  0x8(%ebp)
  803280:	e8 84 fb ff ff       	call   802e09 <fd_lookup>
  803285:	83 c4 10             	add    $0x10,%esp
  803288:	85 c0                	test   %eax,%eax
  80328a:	78 4b                	js     8032d7 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80328c:	83 ec 08             	sub    $0x8,%esp
  80328f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803292:	50                   	push   %eax
  803293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803296:	ff 30                	pushl  (%eax)
  803298:	e8 bc fb ff ff       	call   802e59 <dev_lookup>
  80329d:	83 c4 10             	add    $0x10,%esp
  8032a0:	85 c0                	test   %eax,%eax
  8032a2:	78 33                	js     8032d7 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8032ab:	74 2f                	je     8032dc <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8032ad:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8032b0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8032b7:	00 00 00 
	stat->st_isdir = 0;
  8032ba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8032c1:	00 00 00 
	stat->st_dev = dev;
  8032c4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8032ca:	83 ec 08             	sub    $0x8,%esp
  8032cd:	53                   	push   %ebx
  8032ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8032d1:	ff 50 14             	call   *0x14(%eax)
  8032d4:	83 c4 10             	add    $0x10,%esp
}
  8032d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032da:	c9                   	leave  
  8032db:	c3                   	ret    
		return -E_NOT_SUPP;
  8032dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8032e1:	eb f4                	jmp    8032d7 <fstat+0x68>

008032e3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
  8032e6:	56                   	push   %esi
  8032e7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8032e8:	83 ec 08             	sub    $0x8,%esp
  8032eb:	6a 00                	push   $0x0
  8032ed:	ff 75 08             	pushl  0x8(%ebp)
  8032f0:	e8 22 02 00 00       	call   803517 <open>
  8032f5:	89 c3                	mov    %eax,%ebx
  8032f7:	83 c4 10             	add    $0x10,%esp
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	78 1b                	js     803319 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8032fe:	83 ec 08             	sub    $0x8,%esp
  803301:	ff 75 0c             	pushl  0xc(%ebp)
  803304:	50                   	push   %eax
  803305:	e8 65 ff ff ff       	call   80326f <fstat>
  80330a:	89 c6                	mov    %eax,%esi
	close(fd);
  80330c:	89 1c 24             	mov    %ebx,(%esp)
  80330f:	e8 27 fc ff ff       	call   802f3b <close>
	return r;
  803314:	83 c4 10             	add    $0x10,%esp
  803317:	89 f3                	mov    %esi,%ebx
}
  803319:	89 d8                	mov    %ebx,%eax
  80331b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80331e:	5b                   	pop    %ebx
  80331f:	5e                   	pop    %esi
  803320:	5d                   	pop    %ebp
  803321:	c3                   	ret    

00803322 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803322:	55                   	push   %ebp
  803323:	89 e5                	mov    %esp,%ebp
  803325:	56                   	push   %esi
  803326:	53                   	push   %ebx
  803327:	89 c6                	mov    %eax,%esi
  803329:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80332b:	83 3d 40 a0 80 00 00 	cmpl   $0x0,0x80a040
  803332:	74 27                	je     80335b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803334:	6a 07                	push   $0x7
  803336:	68 00 b0 80 00       	push   $0x80b000
  80333b:	56                   	push   %esi
  80333c:	ff 35 40 a0 80 00    	pushl  0x80a040
  803342:	e8 b6 f9 ff ff       	call   802cfd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  803347:	83 c4 0c             	add    $0xc,%esp
  80334a:	6a 00                	push   $0x0
  80334c:	53                   	push   %ebx
  80334d:	6a 00                	push   $0x0
  80334f:	e8 40 f9 ff ff       	call   802c94 <ipc_recv>
}
  803354:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803357:	5b                   	pop    %ebx
  803358:	5e                   	pop    %esi
  803359:	5d                   	pop    %ebp
  80335a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80335b:	83 ec 0c             	sub    $0xc,%esp
  80335e:	6a 01                	push   $0x1
  803360:	e8 f0 f9 ff ff       	call   802d55 <ipc_find_env>
  803365:	a3 40 a0 80 00       	mov    %eax,0x80a040
  80336a:	83 c4 10             	add    $0x10,%esp
  80336d:	eb c5                	jmp    803334 <fsipc+0x12>

0080336f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80336f:	55                   	push   %ebp
  803370:	89 e5                	mov    %esp,%ebp
  803372:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	8b 40 0c             	mov    0xc(%eax),%eax
  80337b:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  803380:	8b 45 0c             	mov    0xc(%ebp),%eax
  803383:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803388:	ba 00 00 00 00       	mov    $0x0,%edx
  80338d:	b8 02 00 00 00       	mov    $0x2,%eax
  803392:	e8 8b ff ff ff       	call   803322 <fsipc>
}
  803397:	c9                   	leave  
  803398:	c3                   	ret    

00803399 <devfile_flush>:
{
  803399:	55                   	push   %ebp
  80339a:	89 e5                	mov    %esp,%ebp
  80339c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a5:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  8033aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8033af:	b8 06 00 00 00       	mov    $0x6,%eax
  8033b4:	e8 69 ff ff ff       	call   803322 <fsipc>
}
  8033b9:	c9                   	leave  
  8033ba:	c3                   	ret    

008033bb <devfile_stat>:
{
  8033bb:	55                   	push   %ebp
  8033bc:	89 e5                	mov    %esp,%ebp
  8033be:	53                   	push   %ebx
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cb:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8033d5:	b8 05 00 00 00       	mov    $0x5,%eax
  8033da:	e8 43 ff ff ff       	call   803322 <fsipc>
  8033df:	85 c0                	test   %eax,%eax
  8033e1:	78 2c                	js     80340f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033e3:	83 ec 08             	sub    $0x8,%esp
  8033e6:	68 00 b0 80 00       	push   $0x80b000
  8033eb:	53                   	push   %ebx
  8033ec:	e8 47 f1 ff ff       	call   802538 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8033f1:	a1 80 b0 80 00       	mov    0x80b080,%eax
  8033f6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033fc:	a1 84 b0 80 00       	mov    0x80b084,%eax
  803401:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803407:	83 c4 10             	add    $0x10,%esp
  80340a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80340f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803412:	c9                   	leave  
  803413:	c3                   	ret    

00803414 <devfile_write>:
{
  803414:	55                   	push   %ebp
  803415:	89 e5                	mov    %esp,%ebp
  803417:	53                   	push   %ebx
  803418:	83 ec 08             	sub    $0x8,%esp
  80341b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	8b 40 0c             	mov    0xc(%eax),%eax
  803424:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  803429:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80342f:	53                   	push   %ebx
  803430:	ff 75 0c             	pushl  0xc(%ebp)
  803433:	68 08 b0 80 00       	push   $0x80b008
  803438:	e8 eb f2 ff ff       	call   802728 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80343d:	ba 00 00 00 00       	mov    $0x0,%edx
  803442:	b8 04 00 00 00       	mov    $0x4,%eax
  803447:	e8 d6 fe ff ff       	call   803322 <fsipc>
  80344c:	83 c4 10             	add    $0x10,%esp
  80344f:	85 c0                	test   %eax,%eax
  803451:	78 0b                	js     80345e <devfile_write+0x4a>
	assert(r <= n);
  803453:	39 d8                	cmp    %ebx,%eax
  803455:	77 0c                	ja     803463 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  803457:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80345c:	7f 1e                	jg     80347c <devfile_write+0x68>
}
  80345e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803461:	c9                   	leave  
  803462:	c3                   	ret    
	assert(r <= n);
  803463:	68 7c 4c 80 00       	push   $0x804c7c
  803468:	68 bd 41 80 00       	push   $0x8041bd
  80346d:	68 98 00 00 00       	push   $0x98
  803472:	68 83 4c 80 00       	push   $0x804c83
  803477:	e8 67 e8 ff ff       	call   801ce3 <_panic>
	assert(r <= PGSIZE);
  80347c:	68 8e 4c 80 00       	push   $0x804c8e
  803481:	68 bd 41 80 00       	push   $0x8041bd
  803486:	68 99 00 00 00       	push   $0x99
  80348b:	68 83 4c 80 00       	push   $0x804c83
  803490:	e8 4e e8 ff ff       	call   801ce3 <_panic>

00803495 <devfile_read>:
{
  803495:	55                   	push   %ebp
  803496:	89 e5                	mov    %esp,%ebp
  803498:	56                   	push   %esi
  803499:	53                   	push   %ebx
  80349a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a3:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  8034a8:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8034ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8034b8:	e8 65 fe ff ff       	call   803322 <fsipc>
  8034bd:	89 c3                	mov    %eax,%ebx
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	78 1f                	js     8034e2 <devfile_read+0x4d>
	assert(r <= n);
  8034c3:	39 f0                	cmp    %esi,%eax
  8034c5:	77 24                	ja     8034eb <devfile_read+0x56>
	assert(r <= PGSIZE);
  8034c7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8034cc:	7f 33                	jg     803501 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8034ce:	83 ec 04             	sub    $0x4,%esp
  8034d1:	50                   	push   %eax
  8034d2:	68 00 b0 80 00       	push   $0x80b000
  8034d7:	ff 75 0c             	pushl  0xc(%ebp)
  8034da:	e8 e7 f1 ff ff       	call   8026c6 <memmove>
	return r;
  8034df:	83 c4 10             	add    $0x10,%esp
}
  8034e2:	89 d8                	mov    %ebx,%eax
  8034e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034e7:	5b                   	pop    %ebx
  8034e8:	5e                   	pop    %esi
  8034e9:	5d                   	pop    %ebp
  8034ea:	c3                   	ret    
	assert(r <= n);
  8034eb:	68 7c 4c 80 00       	push   $0x804c7c
  8034f0:	68 bd 41 80 00       	push   $0x8041bd
  8034f5:	6a 7c                	push   $0x7c
  8034f7:	68 83 4c 80 00       	push   $0x804c83
  8034fc:	e8 e2 e7 ff ff       	call   801ce3 <_panic>
	assert(r <= PGSIZE);
  803501:	68 8e 4c 80 00       	push   $0x804c8e
  803506:	68 bd 41 80 00       	push   $0x8041bd
  80350b:	6a 7d                	push   $0x7d
  80350d:	68 83 4c 80 00       	push   $0x804c83
  803512:	e8 cc e7 ff ff       	call   801ce3 <_panic>

00803517 <open>:
{
  803517:	55                   	push   %ebp
  803518:	89 e5                	mov    %esp,%ebp
  80351a:	56                   	push   %esi
  80351b:	53                   	push   %ebx
  80351c:	83 ec 1c             	sub    $0x1c,%esp
  80351f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  803522:	56                   	push   %esi
  803523:	e8 d7 ef ff ff       	call   8024ff <strlen>
  803528:	83 c4 10             	add    $0x10,%esp
  80352b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803530:	7f 6c                	jg     80359e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  803532:	83 ec 0c             	sub    $0xc,%esp
  803535:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803538:	50                   	push   %eax
  803539:	e8 79 f8 ff ff       	call   802db7 <fd_alloc>
  80353e:	89 c3                	mov    %eax,%ebx
  803540:	83 c4 10             	add    $0x10,%esp
  803543:	85 c0                	test   %eax,%eax
  803545:	78 3c                	js     803583 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  803547:	83 ec 08             	sub    $0x8,%esp
  80354a:	56                   	push   %esi
  80354b:	68 00 b0 80 00       	push   $0x80b000
  803550:	e8 e3 ef ff ff       	call   802538 <strcpy>
	fsipcbuf.open.req_omode = mode;
  803555:	8b 45 0c             	mov    0xc(%ebp),%eax
  803558:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80355d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803560:	b8 01 00 00 00       	mov    $0x1,%eax
  803565:	e8 b8 fd ff ff       	call   803322 <fsipc>
  80356a:	89 c3                	mov    %eax,%ebx
  80356c:	83 c4 10             	add    $0x10,%esp
  80356f:	85 c0                	test   %eax,%eax
  803571:	78 19                	js     80358c <open+0x75>
	return fd2num(fd);
  803573:	83 ec 0c             	sub    $0xc,%esp
  803576:	ff 75 f4             	pushl  -0xc(%ebp)
  803579:	e8 12 f8 ff ff       	call   802d90 <fd2num>
  80357e:	89 c3                	mov    %eax,%ebx
  803580:	83 c4 10             	add    $0x10,%esp
}
  803583:	89 d8                	mov    %ebx,%eax
  803585:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803588:	5b                   	pop    %ebx
  803589:	5e                   	pop    %esi
  80358a:	5d                   	pop    %ebp
  80358b:	c3                   	ret    
		fd_close(fd, 0);
  80358c:	83 ec 08             	sub    $0x8,%esp
  80358f:	6a 00                	push   $0x0
  803591:	ff 75 f4             	pushl  -0xc(%ebp)
  803594:	e8 1b f9 ff ff       	call   802eb4 <fd_close>
		return r;
  803599:	83 c4 10             	add    $0x10,%esp
  80359c:	eb e5                	jmp    803583 <open+0x6c>
		return -E_BAD_PATH;
  80359e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8035a3:	eb de                	jmp    803583 <open+0x6c>

008035a5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8035a5:	55                   	push   %ebp
  8035a6:	89 e5                	mov    %esp,%ebp
  8035a8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8035ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8035b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8035b5:	e8 68 fd ff ff       	call   803322 <fsipc>
}
  8035ba:	c9                   	leave  
  8035bb:	c3                   	ret    

008035bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8035bc:	55                   	push   %ebp
  8035bd:	89 e5                	mov    %esp,%ebp
  8035bf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8035c2:	89 d0                	mov    %edx,%eax
  8035c4:	c1 e8 16             	shr    $0x16,%eax
  8035c7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8035ce:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8035d3:	f6 c1 01             	test   $0x1,%cl
  8035d6:	74 1d                	je     8035f5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8035d8:	c1 ea 0c             	shr    $0xc,%edx
  8035db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8035e2:	f6 c2 01             	test   $0x1,%dl
  8035e5:	74 0e                	je     8035f5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8035e7:	c1 ea 0c             	shr    $0xc,%edx
  8035ea:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8035f1:	ef 
  8035f2:	0f b7 c0             	movzwl %ax,%eax
}
  8035f5:	5d                   	pop    %ebp
  8035f6:	c3                   	ret    

008035f7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035f7:	55                   	push   %ebp
  8035f8:	89 e5                	mov    %esp,%ebp
  8035fa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8035fd:	68 9a 4c 80 00       	push   $0x804c9a
  803602:	ff 75 0c             	pushl  0xc(%ebp)
  803605:	e8 2e ef ff ff       	call   802538 <strcpy>
	return 0;
}
  80360a:	b8 00 00 00 00       	mov    $0x0,%eax
  80360f:	c9                   	leave  
  803610:	c3                   	ret    

00803611 <devsock_close>:
{
  803611:	55                   	push   %ebp
  803612:	89 e5                	mov    %esp,%ebp
  803614:	53                   	push   %ebx
  803615:	83 ec 10             	sub    $0x10,%esp
  803618:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80361b:	53                   	push   %ebx
  80361c:	e8 9b ff ff ff       	call   8035bc <pageref>
  803621:	83 c4 10             	add    $0x10,%esp
		return 0;
  803624:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803629:	83 f8 01             	cmp    $0x1,%eax
  80362c:	74 07                	je     803635 <devsock_close+0x24>
}
  80362e:	89 d0                	mov    %edx,%eax
  803630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803633:	c9                   	leave  
  803634:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  803635:	83 ec 0c             	sub    $0xc,%esp
  803638:	ff 73 0c             	pushl  0xc(%ebx)
  80363b:	e8 b9 02 00 00       	call   8038f9 <nsipc_close>
  803640:	89 c2                	mov    %eax,%edx
  803642:	83 c4 10             	add    $0x10,%esp
  803645:	eb e7                	jmp    80362e <devsock_close+0x1d>

00803647 <devsock_write>:
{
  803647:	55                   	push   %ebp
  803648:	89 e5                	mov    %esp,%ebp
  80364a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80364d:	6a 00                	push   $0x0
  80364f:	ff 75 10             	pushl  0x10(%ebp)
  803652:	ff 75 0c             	pushl  0xc(%ebp)
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	ff 70 0c             	pushl  0xc(%eax)
  80365b:	e8 76 03 00 00       	call   8039d6 <nsipc_send>
}
  803660:	c9                   	leave  
  803661:	c3                   	ret    

00803662 <devsock_read>:
{
  803662:	55                   	push   %ebp
  803663:	89 e5                	mov    %esp,%ebp
  803665:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803668:	6a 00                	push   $0x0
  80366a:	ff 75 10             	pushl  0x10(%ebp)
  80366d:	ff 75 0c             	pushl  0xc(%ebp)
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	ff 70 0c             	pushl  0xc(%eax)
  803676:	e8 ef 02 00 00       	call   80396a <nsipc_recv>
}
  80367b:	c9                   	leave  
  80367c:	c3                   	ret    

0080367d <fd2sockid>:
{
  80367d:	55                   	push   %ebp
  80367e:	89 e5                	mov    %esp,%ebp
  803680:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  803683:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803686:	52                   	push   %edx
  803687:	50                   	push   %eax
  803688:	e8 7c f7 ff ff       	call   802e09 <fd_lookup>
  80368d:	83 c4 10             	add    $0x10,%esp
  803690:	85 c0                	test   %eax,%eax
  803692:	78 10                	js     8036a4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  80369d:	39 08                	cmp    %ecx,(%eax)
  80369f:	75 05                	jne    8036a6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8036a1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8036a4:	c9                   	leave  
  8036a5:	c3                   	ret    
		return -E_NOT_SUPP;
  8036a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8036ab:	eb f7                	jmp    8036a4 <fd2sockid+0x27>

008036ad <alloc_sockfd>:
{
  8036ad:	55                   	push   %ebp
  8036ae:	89 e5                	mov    %esp,%ebp
  8036b0:	56                   	push   %esi
  8036b1:	53                   	push   %ebx
  8036b2:	83 ec 1c             	sub    $0x1c,%esp
  8036b5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8036b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036ba:	50                   	push   %eax
  8036bb:	e8 f7 f6 ff ff       	call   802db7 <fd_alloc>
  8036c0:	89 c3                	mov    %eax,%ebx
  8036c2:	83 c4 10             	add    $0x10,%esp
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	78 43                	js     80370c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8036c9:	83 ec 04             	sub    $0x4,%esp
  8036cc:	68 07 04 00 00       	push   $0x407
  8036d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8036d4:	6a 00                	push   $0x0
  8036d6:	e8 4f f2 ff ff       	call   80292a <sys_page_alloc>
  8036db:	89 c3                	mov    %eax,%ebx
  8036dd:	83 c4 10             	add    $0x10,%esp
  8036e0:	85 c0                	test   %eax,%eax
  8036e2:	78 28                	js     80370c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e7:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8036ed:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8036f9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8036fc:	83 ec 0c             	sub    $0xc,%esp
  8036ff:	50                   	push   %eax
  803700:	e8 8b f6 ff ff       	call   802d90 <fd2num>
  803705:	89 c3                	mov    %eax,%ebx
  803707:	83 c4 10             	add    $0x10,%esp
  80370a:	eb 0c                	jmp    803718 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80370c:	83 ec 0c             	sub    $0xc,%esp
  80370f:	56                   	push   %esi
  803710:	e8 e4 01 00 00       	call   8038f9 <nsipc_close>
		return r;
  803715:	83 c4 10             	add    $0x10,%esp
}
  803718:	89 d8                	mov    %ebx,%eax
  80371a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80371d:	5b                   	pop    %ebx
  80371e:	5e                   	pop    %esi
  80371f:	5d                   	pop    %ebp
  803720:	c3                   	ret    

00803721 <accept>:
{
  803721:	55                   	push   %ebp
  803722:	89 e5                	mov    %esp,%ebp
  803724:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803727:	8b 45 08             	mov    0x8(%ebp),%eax
  80372a:	e8 4e ff ff ff       	call   80367d <fd2sockid>
  80372f:	85 c0                	test   %eax,%eax
  803731:	78 1b                	js     80374e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	ff 75 10             	pushl  0x10(%ebp)
  803739:	ff 75 0c             	pushl  0xc(%ebp)
  80373c:	50                   	push   %eax
  80373d:	e8 0e 01 00 00       	call   803850 <nsipc_accept>
  803742:	83 c4 10             	add    $0x10,%esp
  803745:	85 c0                	test   %eax,%eax
  803747:	78 05                	js     80374e <accept+0x2d>
	return alloc_sockfd(r);
  803749:	e8 5f ff ff ff       	call   8036ad <alloc_sockfd>
}
  80374e:	c9                   	leave  
  80374f:	c3                   	ret    

00803750 <bind>:
{
  803750:	55                   	push   %ebp
  803751:	89 e5                	mov    %esp,%ebp
  803753:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	e8 1f ff ff ff       	call   80367d <fd2sockid>
  80375e:	85 c0                	test   %eax,%eax
  803760:	78 12                	js     803774 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  803762:	83 ec 04             	sub    $0x4,%esp
  803765:	ff 75 10             	pushl  0x10(%ebp)
  803768:	ff 75 0c             	pushl  0xc(%ebp)
  80376b:	50                   	push   %eax
  80376c:	e8 31 01 00 00       	call   8038a2 <nsipc_bind>
  803771:	83 c4 10             	add    $0x10,%esp
}
  803774:	c9                   	leave  
  803775:	c3                   	ret    

00803776 <shutdown>:
{
  803776:	55                   	push   %ebp
  803777:	89 e5                	mov    %esp,%ebp
  803779:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80377c:	8b 45 08             	mov    0x8(%ebp),%eax
  80377f:	e8 f9 fe ff ff       	call   80367d <fd2sockid>
  803784:	85 c0                	test   %eax,%eax
  803786:	78 0f                	js     803797 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  803788:	83 ec 08             	sub    $0x8,%esp
  80378b:	ff 75 0c             	pushl  0xc(%ebp)
  80378e:	50                   	push   %eax
  80378f:	e8 43 01 00 00       	call   8038d7 <nsipc_shutdown>
  803794:	83 c4 10             	add    $0x10,%esp
}
  803797:	c9                   	leave  
  803798:	c3                   	ret    

00803799 <connect>:
{
  803799:	55                   	push   %ebp
  80379a:	89 e5                	mov    %esp,%ebp
  80379c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80379f:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a2:	e8 d6 fe ff ff       	call   80367d <fd2sockid>
  8037a7:	85 c0                	test   %eax,%eax
  8037a9:	78 12                	js     8037bd <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8037ab:	83 ec 04             	sub    $0x4,%esp
  8037ae:	ff 75 10             	pushl  0x10(%ebp)
  8037b1:	ff 75 0c             	pushl  0xc(%ebp)
  8037b4:	50                   	push   %eax
  8037b5:	e8 59 01 00 00       	call   803913 <nsipc_connect>
  8037ba:	83 c4 10             	add    $0x10,%esp
}
  8037bd:	c9                   	leave  
  8037be:	c3                   	ret    

008037bf <listen>:
{
  8037bf:	55                   	push   %ebp
  8037c0:	89 e5                	mov    %esp,%ebp
  8037c2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c8:	e8 b0 fe ff ff       	call   80367d <fd2sockid>
  8037cd:	85 c0                	test   %eax,%eax
  8037cf:	78 0f                	js     8037e0 <listen+0x21>
	return nsipc_listen(r, backlog);
  8037d1:	83 ec 08             	sub    $0x8,%esp
  8037d4:	ff 75 0c             	pushl  0xc(%ebp)
  8037d7:	50                   	push   %eax
  8037d8:	e8 6b 01 00 00       	call   803948 <nsipc_listen>
  8037dd:	83 c4 10             	add    $0x10,%esp
}
  8037e0:	c9                   	leave  
  8037e1:	c3                   	ret    

008037e2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8037e2:	55                   	push   %ebp
  8037e3:	89 e5                	mov    %esp,%ebp
  8037e5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037e8:	ff 75 10             	pushl  0x10(%ebp)
  8037eb:	ff 75 0c             	pushl  0xc(%ebp)
  8037ee:	ff 75 08             	pushl  0x8(%ebp)
  8037f1:	e8 3e 02 00 00       	call   803a34 <nsipc_socket>
  8037f6:	83 c4 10             	add    $0x10,%esp
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	78 05                	js     803802 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8037fd:	e8 ab fe ff ff       	call   8036ad <alloc_sockfd>
}
  803802:	c9                   	leave  
  803803:	c3                   	ret    

00803804 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803804:	55                   	push   %ebp
  803805:	89 e5                	mov    %esp,%ebp
  803807:	53                   	push   %ebx
  803808:	83 ec 04             	sub    $0x4,%esp
  80380b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80380d:	83 3d 44 a0 80 00 00 	cmpl   $0x0,0x80a044
  803814:	74 26                	je     80383c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803816:	6a 07                	push   $0x7
  803818:	68 00 c0 80 00       	push   $0x80c000
  80381d:	53                   	push   %ebx
  80381e:	ff 35 44 a0 80 00    	pushl  0x80a044
  803824:	e8 d4 f4 ff ff       	call   802cfd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803829:	83 c4 0c             	add    $0xc,%esp
  80382c:	6a 00                	push   $0x0
  80382e:	6a 00                	push   $0x0
  803830:	6a 00                	push   $0x0
  803832:	e8 5d f4 ff ff       	call   802c94 <ipc_recv>
}
  803837:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80383a:	c9                   	leave  
  80383b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80383c:	83 ec 0c             	sub    $0xc,%esp
  80383f:	6a 02                	push   $0x2
  803841:	e8 0f f5 ff ff       	call   802d55 <ipc_find_env>
  803846:	a3 44 a0 80 00       	mov    %eax,0x80a044
  80384b:	83 c4 10             	add    $0x10,%esp
  80384e:	eb c6                	jmp    803816 <nsipc+0x12>

00803850 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803850:	55                   	push   %ebp
  803851:	89 e5                	mov    %esp,%ebp
  803853:	56                   	push   %esi
  803854:	53                   	push   %ebx
  803855:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803858:	8b 45 08             	mov    0x8(%ebp),%eax
  80385b:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  803860:	8b 06                	mov    (%esi),%eax
  803862:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803867:	b8 01 00 00 00       	mov    $0x1,%eax
  80386c:	e8 93 ff ff ff       	call   803804 <nsipc>
  803871:	89 c3                	mov    %eax,%ebx
  803873:	85 c0                	test   %eax,%eax
  803875:	79 09                	jns    803880 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  803877:	89 d8                	mov    %ebx,%eax
  803879:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80387c:	5b                   	pop    %ebx
  80387d:	5e                   	pop    %esi
  80387e:	5d                   	pop    %ebp
  80387f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803880:	83 ec 04             	sub    $0x4,%esp
  803883:	ff 35 10 c0 80 00    	pushl  0x80c010
  803889:	68 00 c0 80 00       	push   $0x80c000
  80388e:	ff 75 0c             	pushl  0xc(%ebp)
  803891:	e8 30 ee ff ff       	call   8026c6 <memmove>
		*addrlen = ret->ret_addrlen;
  803896:	a1 10 c0 80 00       	mov    0x80c010,%eax
  80389b:	89 06                	mov    %eax,(%esi)
  80389d:	83 c4 10             	add    $0x10,%esp
	return r;
  8038a0:	eb d5                	jmp    803877 <nsipc_accept+0x27>

008038a2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038a2:	55                   	push   %ebp
  8038a3:	89 e5                	mov    %esp,%ebp
  8038a5:	53                   	push   %ebx
  8038a6:	83 ec 08             	sub    $0x8,%esp
  8038a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038b4:	53                   	push   %ebx
  8038b5:	ff 75 0c             	pushl  0xc(%ebp)
  8038b8:	68 04 c0 80 00       	push   $0x80c004
  8038bd:	e8 04 ee ff ff       	call   8026c6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8038c2:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  8038c8:	b8 02 00 00 00       	mov    $0x2,%eax
  8038cd:	e8 32 ff ff ff       	call   803804 <nsipc>
}
  8038d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038d5:	c9                   	leave  
  8038d6:	c3                   	ret    

008038d7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
  8038da:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8038dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e0:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  8038e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e8:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  8038ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8038f2:	e8 0d ff ff ff       	call   803804 <nsipc>
}
  8038f7:	c9                   	leave  
  8038f8:	c3                   	ret    

008038f9 <nsipc_close>:

int
nsipc_close(int s)
{
  8038f9:	55                   	push   %ebp
  8038fa:	89 e5                	mov    %esp,%ebp
  8038fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8038ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803902:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  803907:	b8 04 00 00 00       	mov    $0x4,%eax
  80390c:	e8 f3 fe ff ff       	call   803804 <nsipc>
}
  803911:	c9                   	leave  
  803912:	c3                   	ret    

00803913 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803913:	55                   	push   %ebp
  803914:	89 e5                	mov    %esp,%ebp
  803916:	53                   	push   %ebx
  803917:	83 ec 08             	sub    $0x8,%esp
  80391a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80391d:	8b 45 08             	mov    0x8(%ebp),%eax
  803920:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803925:	53                   	push   %ebx
  803926:	ff 75 0c             	pushl  0xc(%ebp)
  803929:	68 04 c0 80 00       	push   $0x80c004
  80392e:	e8 93 ed ff ff       	call   8026c6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803933:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803939:	b8 05 00 00 00       	mov    $0x5,%eax
  80393e:	e8 c1 fe ff ff       	call   803804 <nsipc>
}
  803943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803946:	c9                   	leave  
  803947:	c3                   	ret    

00803948 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803948:	55                   	push   %ebp
  803949:	89 e5                	mov    %esp,%ebp
  80394b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80394e:	8b 45 08             	mov    0x8(%ebp),%eax
  803951:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  803956:	8b 45 0c             	mov    0xc(%ebp),%eax
  803959:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  80395e:	b8 06 00 00 00       	mov    $0x6,%eax
  803963:	e8 9c fe ff ff       	call   803804 <nsipc>
}
  803968:	c9                   	leave  
  803969:	c3                   	ret    

0080396a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80396a:	55                   	push   %ebp
  80396b:	89 e5                	mov    %esp,%ebp
  80396d:	56                   	push   %esi
  80396e:	53                   	push   %ebx
  80396f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803972:	8b 45 08             	mov    0x8(%ebp),%eax
  803975:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  80397a:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  803980:	8b 45 14             	mov    0x14(%ebp),%eax
  803983:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803988:	b8 07 00 00 00       	mov    $0x7,%eax
  80398d:	e8 72 fe ff ff       	call   803804 <nsipc>
  803992:	89 c3                	mov    %eax,%ebx
  803994:	85 c0                	test   %eax,%eax
  803996:	78 1f                	js     8039b7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  803998:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80399d:	7f 21                	jg     8039c0 <nsipc_recv+0x56>
  80399f:	39 c6                	cmp    %eax,%esi
  8039a1:	7c 1d                	jl     8039c0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8039a3:	83 ec 04             	sub    $0x4,%esp
  8039a6:	50                   	push   %eax
  8039a7:	68 00 c0 80 00       	push   $0x80c000
  8039ac:	ff 75 0c             	pushl  0xc(%ebp)
  8039af:	e8 12 ed ff ff       	call   8026c6 <memmove>
  8039b4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8039b7:	89 d8                	mov    %ebx,%eax
  8039b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8039bc:	5b                   	pop    %ebx
  8039bd:	5e                   	pop    %esi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8039c0:	68 a6 4c 80 00       	push   $0x804ca6
  8039c5:	68 bd 41 80 00       	push   $0x8041bd
  8039ca:	6a 62                	push   $0x62
  8039cc:	68 bb 4c 80 00       	push   $0x804cbb
  8039d1:	e8 0d e3 ff ff       	call   801ce3 <_panic>

008039d6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8039d6:	55                   	push   %ebp
  8039d7:	89 e5                	mov    %esp,%ebp
  8039d9:	53                   	push   %ebx
  8039da:	83 ec 04             	sub    $0x4,%esp
  8039dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8039e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e3:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  8039e8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8039ee:	7f 2e                	jg     803a1e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8039f0:	83 ec 04             	sub    $0x4,%esp
  8039f3:	53                   	push   %ebx
  8039f4:	ff 75 0c             	pushl  0xc(%ebp)
  8039f7:	68 0c c0 80 00       	push   $0x80c00c
  8039fc:	e8 c5 ec ff ff       	call   8026c6 <memmove>
	nsipcbuf.send.req_size = size;
  803a01:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  803a07:	8b 45 14             	mov    0x14(%ebp),%eax
  803a0a:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803a0f:	b8 08 00 00 00       	mov    $0x8,%eax
  803a14:	e8 eb fd ff ff       	call   803804 <nsipc>
}
  803a19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a1c:	c9                   	leave  
  803a1d:	c3                   	ret    
	assert(size < 1600);
  803a1e:	68 c7 4c 80 00       	push   $0x804cc7
  803a23:	68 bd 41 80 00       	push   $0x8041bd
  803a28:	6a 6d                	push   $0x6d
  803a2a:	68 bb 4c 80 00       	push   $0x804cbb
  803a2f:	e8 af e2 ff ff       	call   801ce3 <_panic>

00803a34 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a34:	55                   	push   %ebp
  803a35:	89 e5                	mov    %esp,%ebp
  803a37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3d:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a45:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  803a4d:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803a52:	b8 09 00 00 00       	mov    $0x9,%eax
  803a57:	e8 a8 fd ff ff       	call   803804 <nsipc>
}
  803a5c:	c9                   	leave  
  803a5d:	c3                   	ret    

00803a5e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a5e:	55                   	push   %ebp
  803a5f:	89 e5                	mov    %esp,%ebp
  803a61:	56                   	push   %esi
  803a62:	53                   	push   %ebx
  803a63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a66:	83 ec 0c             	sub    $0xc,%esp
  803a69:	ff 75 08             	pushl  0x8(%ebp)
  803a6c:	e8 2f f3 ff ff       	call   802da0 <fd2data>
  803a71:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803a73:	83 c4 08             	add    $0x8,%esp
  803a76:	68 d3 4c 80 00       	push   $0x804cd3
  803a7b:	53                   	push   %ebx
  803a7c:	e8 b7 ea ff ff       	call   802538 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803a81:	8b 46 04             	mov    0x4(%esi),%eax
  803a84:	2b 06                	sub    (%esi),%eax
  803a86:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803a8c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803a93:	00 00 00 
	stat->st_dev = &devpipe;
  803a96:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  803a9d:	90 80 00 
	return 0;
}
  803aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803aa8:	5b                   	pop    %ebx
  803aa9:	5e                   	pop    %esi
  803aaa:	5d                   	pop    %ebp
  803aab:	c3                   	ret    

00803aac <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803aac:	55                   	push   %ebp
  803aad:	89 e5                	mov    %esp,%ebp
  803aaf:	53                   	push   %ebx
  803ab0:	83 ec 0c             	sub    $0xc,%esp
  803ab3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803ab6:	53                   	push   %ebx
  803ab7:	6a 00                	push   $0x0
  803ab9:	e8 f1 ee ff ff       	call   8029af <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803abe:	89 1c 24             	mov    %ebx,(%esp)
  803ac1:	e8 da f2 ff ff       	call   802da0 <fd2data>
  803ac6:	83 c4 08             	add    $0x8,%esp
  803ac9:	50                   	push   %eax
  803aca:	6a 00                	push   $0x0
  803acc:	e8 de ee ff ff       	call   8029af <sys_page_unmap>
}
  803ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803ad4:	c9                   	leave  
  803ad5:	c3                   	ret    

00803ad6 <_pipeisclosed>:
{
  803ad6:	55                   	push   %ebp
  803ad7:	89 e5                	mov    %esp,%ebp
  803ad9:	57                   	push   %edi
  803ada:	56                   	push   %esi
  803adb:	53                   	push   %ebx
  803adc:	83 ec 1c             	sub    $0x1c,%esp
  803adf:	89 c7                	mov    %eax,%edi
  803ae1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803ae3:	a1 50 a0 80 00       	mov    0x80a050,%eax
  803ae8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803aeb:	83 ec 0c             	sub    $0xc,%esp
  803aee:	57                   	push   %edi
  803aef:	e8 c8 fa ff ff       	call   8035bc <pageref>
  803af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803af7:	89 34 24             	mov    %esi,(%esp)
  803afa:	e8 bd fa ff ff       	call   8035bc <pageref>
		nn = thisenv->env_runs;
  803aff:	8b 15 50 a0 80 00    	mov    0x80a050,%edx
  803b05:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803b08:	83 c4 10             	add    $0x10,%esp
  803b0b:	39 cb                	cmp    %ecx,%ebx
  803b0d:	74 1b                	je     803b2a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803b0f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803b12:	75 cf                	jne    803ae3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b14:	8b 42 58             	mov    0x58(%edx),%eax
  803b17:	6a 01                	push   $0x1
  803b19:	50                   	push   %eax
  803b1a:	53                   	push   %ebx
  803b1b:	68 da 4c 80 00       	push   $0x804cda
  803b20:	e8 b4 e2 ff ff       	call   801dd9 <cprintf>
  803b25:	83 c4 10             	add    $0x10,%esp
  803b28:	eb b9                	jmp    803ae3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803b2a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803b2d:	0f 94 c0             	sete   %al
  803b30:	0f b6 c0             	movzbl %al,%eax
}
  803b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803b36:	5b                   	pop    %ebx
  803b37:	5e                   	pop    %esi
  803b38:	5f                   	pop    %edi
  803b39:	5d                   	pop    %ebp
  803b3a:	c3                   	ret    

00803b3b <devpipe_write>:
{
  803b3b:	55                   	push   %ebp
  803b3c:	89 e5                	mov    %esp,%ebp
  803b3e:	57                   	push   %edi
  803b3f:	56                   	push   %esi
  803b40:	53                   	push   %ebx
  803b41:	83 ec 28             	sub    $0x28,%esp
  803b44:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803b47:	56                   	push   %esi
  803b48:	e8 53 f2 ff ff       	call   802da0 <fd2data>
  803b4d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803b4f:	83 c4 10             	add    $0x10,%esp
  803b52:	bf 00 00 00 00       	mov    $0x0,%edi
  803b57:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803b5a:	74 4f                	je     803bab <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b5c:	8b 43 04             	mov    0x4(%ebx),%eax
  803b5f:	8b 0b                	mov    (%ebx),%ecx
  803b61:	8d 51 20             	lea    0x20(%ecx),%edx
  803b64:	39 d0                	cmp    %edx,%eax
  803b66:	72 14                	jb     803b7c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803b68:	89 da                	mov    %ebx,%edx
  803b6a:	89 f0                	mov    %esi,%eax
  803b6c:	e8 65 ff ff ff       	call   803ad6 <_pipeisclosed>
  803b71:	85 c0                	test   %eax,%eax
  803b73:	75 3b                	jne    803bb0 <devpipe_write+0x75>
			sys_yield();
  803b75:	e8 91 ed ff ff       	call   80290b <sys_yield>
  803b7a:	eb e0                	jmp    803b5c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803b7f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803b83:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803b86:	89 c2                	mov    %eax,%edx
  803b88:	c1 fa 1f             	sar    $0x1f,%edx
  803b8b:	89 d1                	mov    %edx,%ecx
  803b8d:	c1 e9 1b             	shr    $0x1b,%ecx
  803b90:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803b93:	83 e2 1f             	and    $0x1f,%edx
  803b96:	29 ca                	sub    %ecx,%edx
  803b98:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803b9c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803ba0:	83 c0 01             	add    $0x1,%eax
  803ba3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803ba6:	83 c7 01             	add    $0x1,%edi
  803ba9:	eb ac                	jmp    803b57 <devpipe_write+0x1c>
	return i;
  803bab:	8b 45 10             	mov    0x10(%ebp),%eax
  803bae:	eb 05                	jmp    803bb5 <devpipe_write+0x7a>
				return 0;
  803bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803bb8:	5b                   	pop    %ebx
  803bb9:	5e                   	pop    %esi
  803bba:	5f                   	pop    %edi
  803bbb:	5d                   	pop    %ebp
  803bbc:	c3                   	ret    

00803bbd <devpipe_read>:
{
  803bbd:	55                   	push   %ebp
  803bbe:	89 e5                	mov    %esp,%ebp
  803bc0:	57                   	push   %edi
  803bc1:	56                   	push   %esi
  803bc2:	53                   	push   %ebx
  803bc3:	83 ec 18             	sub    $0x18,%esp
  803bc6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803bc9:	57                   	push   %edi
  803bca:	e8 d1 f1 ff ff       	call   802da0 <fd2data>
  803bcf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803bd1:	83 c4 10             	add    $0x10,%esp
  803bd4:	be 00 00 00 00       	mov    $0x0,%esi
  803bd9:	3b 75 10             	cmp    0x10(%ebp),%esi
  803bdc:	75 14                	jne    803bf2 <devpipe_read+0x35>
	return i;
  803bde:	8b 45 10             	mov    0x10(%ebp),%eax
  803be1:	eb 02                	jmp    803be5 <devpipe_read+0x28>
				return i;
  803be3:	89 f0                	mov    %esi,%eax
}
  803be5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803be8:	5b                   	pop    %ebx
  803be9:	5e                   	pop    %esi
  803bea:	5f                   	pop    %edi
  803beb:	5d                   	pop    %ebp
  803bec:	c3                   	ret    
			sys_yield();
  803bed:	e8 19 ed ff ff       	call   80290b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803bf2:	8b 03                	mov    (%ebx),%eax
  803bf4:	3b 43 04             	cmp    0x4(%ebx),%eax
  803bf7:	75 18                	jne    803c11 <devpipe_read+0x54>
			if (i > 0)
  803bf9:	85 f6                	test   %esi,%esi
  803bfb:	75 e6                	jne    803be3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  803bfd:	89 da                	mov    %ebx,%edx
  803bff:	89 f8                	mov    %edi,%eax
  803c01:	e8 d0 fe ff ff       	call   803ad6 <_pipeisclosed>
  803c06:	85 c0                	test   %eax,%eax
  803c08:	74 e3                	je     803bed <devpipe_read+0x30>
				return 0;
  803c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c0f:	eb d4                	jmp    803be5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c11:	99                   	cltd   
  803c12:	c1 ea 1b             	shr    $0x1b,%edx
  803c15:	01 d0                	add    %edx,%eax
  803c17:	83 e0 1f             	and    $0x1f,%eax
  803c1a:	29 d0                	sub    %edx,%eax
  803c1c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803c24:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803c27:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803c2a:	83 c6 01             	add    $0x1,%esi
  803c2d:	eb aa                	jmp    803bd9 <devpipe_read+0x1c>

00803c2f <pipe>:
{
  803c2f:	55                   	push   %ebp
  803c30:	89 e5                	mov    %esp,%ebp
  803c32:	56                   	push   %esi
  803c33:	53                   	push   %ebx
  803c34:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803c37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803c3a:	50                   	push   %eax
  803c3b:	e8 77 f1 ff ff       	call   802db7 <fd_alloc>
  803c40:	89 c3                	mov    %eax,%ebx
  803c42:	83 c4 10             	add    $0x10,%esp
  803c45:	85 c0                	test   %eax,%eax
  803c47:	0f 88 23 01 00 00    	js     803d70 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c4d:	83 ec 04             	sub    $0x4,%esp
  803c50:	68 07 04 00 00       	push   $0x407
  803c55:	ff 75 f4             	pushl  -0xc(%ebp)
  803c58:	6a 00                	push   $0x0
  803c5a:	e8 cb ec ff ff       	call   80292a <sys_page_alloc>
  803c5f:	89 c3                	mov    %eax,%ebx
  803c61:	83 c4 10             	add    $0x10,%esp
  803c64:	85 c0                	test   %eax,%eax
  803c66:	0f 88 04 01 00 00    	js     803d70 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  803c6c:	83 ec 0c             	sub    $0xc,%esp
  803c6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803c72:	50                   	push   %eax
  803c73:	e8 3f f1 ff ff       	call   802db7 <fd_alloc>
  803c78:	89 c3                	mov    %eax,%ebx
  803c7a:	83 c4 10             	add    $0x10,%esp
  803c7d:	85 c0                	test   %eax,%eax
  803c7f:	0f 88 db 00 00 00    	js     803d60 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c85:	83 ec 04             	sub    $0x4,%esp
  803c88:	68 07 04 00 00       	push   $0x407
  803c8d:	ff 75 f0             	pushl  -0x10(%ebp)
  803c90:	6a 00                	push   $0x0
  803c92:	e8 93 ec ff ff       	call   80292a <sys_page_alloc>
  803c97:	89 c3                	mov    %eax,%ebx
  803c99:	83 c4 10             	add    $0x10,%esp
  803c9c:	85 c0                	test   %eax,%eax
  803c9e:	0f 88 bc 00 00 00    	js     803d60 <pipe+0x131>
	va = fd2data(fd0);
  803ca4:	83 ec 0c             	sub    $0xc,%esp
  803ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  803caa:	e8 f1 f0 ff ff       	call   802da0 <fd2data>
  803caf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cb1:	83 c4 0c             	add    $0xc,%esp
  803cb4:	68 07 04 00 00       	push   $0x407
  803cb9:	50                   	push   %eax
  803cba:	6a 00                	push   $0x0
  803cbc:	e8 69 ec ff ff       	call   80292a <sys_page_alloc>
  803cc1:	89 c3                	mov    %eax,%ebx
  803cc3:	83 c4 10             	add    $0x10,%esp
  803cc6:	85 c0                	test   %eax,%eax
  803cc8:	0f 88 82 00 00 00    	js     803d50 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cce:	83 ec 0c             	sub    $0xc,%esp
  803cd1:	ff 75 f0             	pushl  -0x10(%ebp)
  803cd4:	e8 c7 f0 ff ff       	call   802da0 <fd2data>
  803cd9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803ce0:	50                   	push   %eax
  803ce1:	6a 00                	push   $0x0
  803ce3:	56                   	push   %esi
  803ce4:	6a 00                	push   $0x0
  803ce6:	e8 82 ec ff ff       	call   80296d <sys_page_map>
  803ceb:	89 c3                	mov    %eax,%ebx
  803ced:	83 c4 20             	add    $0x20,%esp
  803cf0:	85 c0                	test   %eax,%eax
  803cf2:	78 4e                	js     803d42 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  803cf4:	a1 9c 90 80 00       	mov    0x80909c,%eax
  803cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cfc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d01:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  803d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d0b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d10:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803d17:	83 ec 0c             	sub    $0xc,%esp
  803d1a:	ff 75 f4             	pushl  -0xc(%ebp)
  803d1d:	e8 6e f0 ff ff       	call   802d90 <fd2num>
  803d22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803d25:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803d27:	83 c4 04             	add    $0x4,%esp
  803d2a:	ff 75 f0             	pushl  -0x10(%ebp)
  803d2d:	e8 5e f0 ff ff       	call   802d90 <fd2num>
  803d32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803d35:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803d38:	83 c4 10             	add    $0x10,%esp
  803d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  803d40:	eb 2e                	jmp    803d70 <pipe+0x141>
	sys_page_unmap(0, va);
  803d42:	83 ec 08             	sub    $0x8,%esp
  803d45:	56                   	push   %esi
  803d46:	6a 00                	push   $0x0
  803d48:	e8 62 ec ff ff       	call   8029af <sys_page_unmap>
  803d4d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803d50:	83 ec 08             	sub    $0x8,%esp
  803d53:	ff 75 f0             	pushl  -0x10(%ebp)
  803d56:	6a 00                	push   $0x0
  803d58:	e8 52 ec ff ff       	call   8029af <sys_page_unmap>
  803d5d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803d60:	83 ec 08             	sub    $0x8,%esp
  803d63:	ff 75 f4             	pushl  -0xc(%ebp)
  803d66:	6a 00                	push   $0x0
  803d68:	e8 42 ec ff ff       	call   8029af <sys_page_unmap>
  803d6d:	83 c4 10             	add    $0x10,%esp
}
  803d70:	89 d8                	mov    %ebx,%eax
  803d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803d75:	5b                   	pop    %ebx
  803d76:	5e                   	pop    %esi
  803d77:	5d                   	pop    %ebp
  803d78:	c3                   	ret    

00803d79 <pipeisclosed>:
{
  803d79:	55                   	push   %ebp
  803d7a:	89 e5                	mov    %esp,%ebp
  803d7c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d82:	50                   	push   %eax
  803d83:	ff 75 08             	pushl  0x8(%ebp)
  803d86:	e8 7e f0 ff ff       	call   802e09 <fd_lookup>
  803d8b:	83 c4 10             	add    $0x10,%esp
  803d8e:	85 c0                	test   %eax,%eax
  803d90:	78 18                	js     803daa <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803d92:	83 ec 0c             	sub    $0xc,%esp
  803d95:	ff 75 f4             	pushl  -0xc(%ebp)
  803d98:	e8 03 f0 ff ff       	call   802da0 <fd2data>
	return _pipeisclosed(fd, p);
  803d9d:	89 c2                	mov    %eax,%edx
  803d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da2:	e8 2f fd ff ff       	call   803ad6 <_pipeisclosed>
  803da7:	83 c4 10             	add    $0x10,%esp
}
  803daa:	c9                   	leave  
  803dab:	c3                   	ret    

00803dac <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  803dac:	b8 00 00 00 00       	mov    $0x0,%eax
  803db1:	c3                   	ret    

00803db2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803db2:	55                   	push   %ebp
  803db3:	89 e5                	mov    %esp,%ebp
  803db5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803db8:	68 f2 4c 80 00       	push   $0x804cf2
  803dbd:	ff 75 0c             	pushl  0xc(%ebp)
  803dc0:	e8 73 e7 ff ff       	call   802538 <strcpy>
	return 0;
}
  803dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  803dca:	c9                   	leave  
  803dcb:	c3                   	ret    

00803dcc <devcons_write>:
{
  803dcc:	55                   	push   %ebp
  803dcd:	89 e5                	mov    %esp,%ebp
  803dcf:	57                   	push   %edi
  803dd0:	56                   	push   %esi
  803dd1:	53                   	push   %ebx
  803dd2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  803dd8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803ddd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803de3:	3b 75 10             	cmp    0x10(%ebp),%esi
  803de6:	73 31                	jae    803e19 <devcons_write+0x4d>
		m = n - tot;
  803de8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803deb:	29 f3                	sub    %esi,%ebx
  803ded:	83 fb 7f             	cmp    $0x7f,%ebx
  803df0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803df5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803df8:	83 ec 04             	sub    $0x4,%esp
  803dfb:	53                   	push   %ebx
  803dfc:	89 f0                	mov    %esi,%eax
  803dfe:	03 45 0c             	add    0xc(%ebp),%eax
  803e01:	50                   	push   %eax
  803e02:	57                   	push   %edi
  803e03:	e8 be e8 ff ff       	call   8026c6 <memmove>
		sys_cputs(buf, m);
  803e08:	83 c4 08             	add    $0x8,%esp
  803e0b:	53                   	push   %ebx
  803e0c:	57                   	push   %edi
  803e0d:	e8 5c ea ff ff       	call   80286e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803e12:	01 de                	add    %ebx,%esi
  803e14:	83 c4 10             	add    $0x10,%esp
  803e17:	eb ca                	jmp    803de3 <devcons_write+0x17>
}
  803e19:	89 f0                	mov    %esi,%eax
  803e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803e1e:	5b                   	pop    %ebx
  803e1f:	5e                   	pop    %esi
  803e20:	5f                   	pop    %edi
  803e21:	5d                   	pop    %ebp
  803e22:	c3                   	ret    

00803e23 <devcons_read>:
{
  803e23:	55                   	push   %ebp
  803e24:	89 e5                	mov    %esp,%ebp
  803e26:	83 ec 08             	sub    $0x8,%esp
  803e29:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803e2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e32:	74 21                	je     803e55 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  803e34:	e8 53 ea ff ff       	call   80288c <sys_cgetc>
  803e39:	85 c0                	test   %eax,%eax
  803e3b:	75 07                	jne    803e44 <devcons_read+0x21>
		sys_yield();
  803e3d:	e8 c9 ea ff ff       	call   80290b <sys_yield>
  803e42:	eb f0                	jmp    803e34 <devcons_read+0x11>
	if (c < 0)
  803e44:	78 0f                	js     803e55 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  803e46:	83 f8 04             	cmp    $0x4,%eax
  803e49:	74 0c                	je     803e57 <devcons_read+0x34>
	*(char*)vbuf = c;
  803e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e4e:	88 02                	mov    %al,(%edx)
	return 1;
  803e50:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e55:	c9                   	leave  
  803e56:	c3                   	ret    
		return 0;
  803e57:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5c:	eb f7                	jmp    803e55 <devcons_read+0x32>

00803e5e <cputchar>:
{
  803e5e:	55                   	push   %ebp
  803e5f:	89 e5                	mov    %esp,%ebp
  803e61:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803e64:	8b 45 08             	mov    0x8(%ebp),%eax
  803e67:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803e6a:	6a 01                	push   $0x1
  803e6c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e6f:	50                   	push   %eax
  803e70:	e8 f9 e9 ff ff       	call   80286e <sys_cputs>
}
  803e75:	83 c4 10             	add    $0x10,%esp
  803e78:	c9                   	leave  
  803e79:	c3                   	ret    

00803e7a <getchar>:
{
  803e7a:	55                   	push   %ebp
  803e7b:	89 e5                	mov    %esp,%ebp
  803e7d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803e80:	6a 01                	push   $0x1
  803e82:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e85:	50                   	push   %eax
  803e86:	6a 00                	push   $0x0
  803e88:	e8 ec f1 ff ff       	call   803079 <read>
	if (r < 0)
  803e8d:	83 c4 10             	add    $0x10,%esp
  803e90:	85 c0                	test   %eax,%eax
  803e92:	78 06                	js     803e9a <getchar+0x20>
	if (r < 1)
  803e94:	74 06                	je     803e9c <getchar+0x22>
	return c;
  803e96:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803e9a:	c9                   	leave  
  803e9b:	c3                   	ret    
		return -E_EOF;
  803e9c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803ea1:	eb f7                	jmp    803e9a <getchar+0x20>

00803ea3 <iscons>:
{
  803ea3:	55                   	push   %ebp
  803ea4:	89 e5                	mov    %esp,%ebp
  803ea6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ea9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803eac:	50                   	push   %eax
  803ead:	ff 75 08             	pushl  0x8(%ebp)
  803eb0:	e8 54 ef ff ff       	call   802e09 <fd_lookup>
  803eb5:	83 c4 10             	add    $0x10,%esp
  803eb8:	85 c0                	test   %eax,%eax
  803eba:	78 11                	js     803ecd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ebf:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803ec5:	39 10                	cmp    %edx,(%eax)
  803ec7:	0f 94 c0             	sete   %al
  803eca:	0f b6 c0             	movzbl %al,%eax
}
  803ecd:	c9                   	leave  
  803ece:	c3                   	ret    

00803ecf <opencons>:
{
  803ecf:	55                   	push   %ebp
  803ed0:	89 e5                	mov    %esp,%ebp
  803ed2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ed8:	50                   	push   %eax
  803ed9:	e8 d9 ee ff ff       	call   802db7 <fd_alloc>
  803ede:	83 c4 10             	add    $0x10,%esp
  803ee1:	85 c0                	test   %eax,%eax
  803ee3:	78 3a                	js     803f1f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ee5:	83 ec 04             	sub    $0x4,%esp
  803ee8:	68 07 04 00 00       	push   $0x407
  803eed:	ff 75 f4             	pushl  -0xc(%ebp)
  803ef0:	6a 00                	push   $0x0
  803ef2:	e8 33 ea ff ff       	call   80292a <sys_page_alloc>
  803ef7:	83 c4 10             	add    $0x10,%esp
  803efa:	85 c0                	test   %eax,%eax
  803efc:	78 21                	js     803f1f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f01:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803f07:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803f13:	83 ec 0c             	sub    $0xc,%esp
  803f16:	50                   	push   %eax
  803f17:	e8 74 ee ff ff       	call   802d90 <fd2num>
  803f1c:	83 c4 10             	add    $0x10,%esp
}
  803f1f:	c9                   	leave  
  803f20:	c3                   	ret    
  803f21:	66 90                	xchg   %ax,%ax
  803f23:	66 90                	xchg   %ax,%ax
  803f25:	66 90                	xchg   %ax,%ax
  803f27:	66 90                	xchg   %ax,%ax
  803f29:	66 90                	xchg   %ax,%ax
  803f2b:	66 90                	xchg   %ax,%ax
  803f2d:	66 90                	xchg   %ax,%ax
  803f2f:	90                   	nop

00803f30 <__udivdi3>:
  803f30:	55                   	push   %ebp
  803f31:	57                   	push   %edi
  803f32:	56                   	push   %esi
  803f33:	53                   	push   %ebx
  803f34:	83 ec 1c             	sub    $0x1c,%esp
  803f37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803f3b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803f3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f43:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803f47:	85 d2                	test   %edx,%edx
  803f49:	75 4d                	jne    803f98 <__udivdi3+0x68>
  803f4b:	39 f3                	cmp    %esi,%ebx
  803f4d:	76 19                	jbe    803f68 <__udivdi3+0x38>
  803f4f:	31 ff                	xor    %edi,%edi
  803f51:	89 e8                	mov    %ebp,%eax
  803f53:	89 f2                	mov    %esi,%edx
  803f55:	f7 f3                	div    %ebx
  803f57:	89 fa                	mov    %edi,%edx
  803f59:	83 c4 1c             	add    $0x1c,%esp
  803f5c:	5b                   	pop    %ebx
  803f5d:	5e                   	pop    %esi
  803f5e:	5f                   	pop    %edi
  803f5f:	5d                   	pop    %ebp
  803f60:	c3                   	ret    
  803f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f68:	89 d9                	mov    %ebx,%ecx
  803f6a:	85 db                	test   %ebx,%ebx
  803f6c:	75 0b                	jne    803f79 <__udivdi3+0x49>
  803f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f73:	31 d2                	xor    %edx,%edx
  803f75:	f7 f3                	div    %ebx
  803f77:	89 c1                	mov    %eax,%ecx
  803f79:	31 d2                	xor    %edx,%edx
  803f7b:	89 f0                	mov    %esi,%eax
  803f7d:	f7 f1                	div    %ecx
  803f7f:	89 c6                	mov    %eax,%esi
  803f81:	89 e8                	mov    %ebp,%eax
  803f83:	89 f7                	mov    %esi,%edi
  803f85:	f7 f1                	div    %ecx
  803f87:	89 fa                	mov    %edi,%edx
  803f89:	83 c4 1c             	add    $0x1c,%esp
  803f8c:	5b                   	pop    %ebx
  803f8d:	5e                   	pop    %esi
  803f8e:	5f                   	pop    %edi
  803f8f:	5d                   	pop    %ebp
  803f90:	c3                   	ret    
  803f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f98:	39 f2                	cmp    %esi,%edx
  803f9a:	77 1c                	ja     803fb8 <__udivdi3+0x88>
  803f9c:	0f bd fa             	bsr    %edx,%edi
  803f9f:	83 f7 1f             	xor    $0x1f,%edi
  803fa2:	75 2c                	jne    803fd0 <__udivdi3+0xa0>
  803fa4:	39 f2                	cmp    %esi,%edx
  803fa6:	72 06                	jb     803fae <__udivdi3+0x7e>
  803fa8:	31 c0                	xor    %eax,%eax
  803faa:	39 eb                	cmp    %ebp,%ebx
  803fac:	77 a9                	ja     803f57 <__udivdi3+0x27>
  803fae:	b8 01 00 00 00       	mov    $0x1,%eax
  803fb3:	eb a2                	jmp    803f57 <__udivdi3+0x27>
  803fb5:	8d 76 00             	lea    0x0(%esi),%esi
  803fb8:	31 ff                	xor    %edi,%edi
  803fba:	31 c0                	xor    %eax,%eax
  803fbc:	89 fa                	mov    %edi,%edx
  803fbe:	83 c4 1c             	add    $0x1c,%esp
  803fc1:	5b                   	pop    %ebx
  803fc2:	5e                   	pop    %esi
  803fc3:	5f                   	pop    %edi
  803fc4:	5d                   	pop    %ebp
  803fc5:	c3                   	ret    
  803fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803fcd:	8d 76 00             	lea    0x0(%esi),%esi
  803fd0:	89 f9                	mov    %edi,%ecx
  803fd2:	b8 20 00 00 00       	mov    $0x20,%eax
  803fd7:	29 f8                	sub    %edi,%eax
  803fd9:	d3 e2                	shl    %cl,%edx
  803fdb:	89 54 24 08          	mov    %edx,0x8(%esp)
  803fdf:	89 c1                	mov    %eax,%ecx
  803fe1:	89 da                	mov    %ebx,%edx
  803fe3:	d3 ea                	shr    %cl,%edx
  803fe5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803fe9:	09 d1                	or     %edx,%ecx
  803feb:	89 f2                	mov    %esi,%edx
  803fed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ff1:	89 f9                	mov    %edi,%ecx
  803ff3:	d3 e3                	shl    %cl,%ebx
  803ff5:	89 c1                	mov    %eax,%ecx
  803ff7:	d3 ea                	shr    %cl,%edx
  803ff9:	89 f9                	mov    %edi,%ecx
  803ffb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803fff:	89 eb                	mov    %ebp,%ebx
  804001:	d3 e6                	shl    %cl,%esi
  804003:	89 c1                	mov    %eax,%ecx
  804005:	d3 eb                	shr    %cl,%ebx
  804007:	09 de                	or     %ebx,%esi
  804009:	89 f0                	mov    %esi,%eax
  80400b:	f7 74 24 08          	divl   0x8(%esp)
  80400f:	89 d6                	mov    %edx,%esi
  804011:	89 c3                	mov    %eax,%ebx
  804013:	f7 64 24 0c          	mull   0xc(%esp)
  804017:	39 d6                	cmp    %edx,%esi
  804019:	72 15                	jb     804030 <__udivdi3+0x100>
  80401b:	89 f9                	mov    %edi,%ecx
  80401d:	d3 e5                	shl    %cl,%ebp
  80401f:	39 c5                	cmp    %eax,%ebp
  804021:	73 04                	jae    804027 <__udivdi3+0xf7>
  804023:	39 d6                	cmp    %edx,%esi
  804025:	74 09                	je     804030 <__udivdi3+0x100>
  804027:	89 d8                	mov    %ebx,%eax
  804029:	31 ff                	xor    %edi,%edi
  80402b:	e9 27 ff ff ff       	jmp    803f57 <__udivdi3+0x27>
  804030:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804033:	31 ff                	xor    %edi,%edi
  804035:	e9 1d ff ff ff       	jmp    803f57 <__udivdi3+0x27>
  80403a:	66 90                	xchg   %ax,%ax
  80403c:	66 90                	xchg   %ax,%ax
  80403e:	66 90                	xchg   %ax,%ax

00804040 <__umoddi3>:
  804040:	55                   	push   %ebp
  804041:	57                   	push   %edi
  804042:	56                   	push   %esi
  804043:	53                   	push   %ebx
  804044:	83 ec 1c             	sub    $0x1c,%esp
  804047:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80404b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80404f:	8b 74 24 30          	mov    0x30(%esp),%esi
  804053:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804057:	89 da                	mov    %ebx,%edx
  804059:	85 c0                	test   %eax,%eax
  80405b:	75 43                	jne    8040a0 <__umoddi3+0x60>
  80405d:	39 df                	cmp    %ebx,%edi
  80405f:	76 17                	jbe    804078 <__umoddi3+0x38>
  804061:	89 f0                	mov    %esi,%eax
  804063:	f7 f7                	div    %edi
  804065:	89 d0                	mov    %edx,%eax
  804067:	31 d2                	xor    %edx,%edx
  804069:	83 c4 1c             	add    $0x1c,%esp
  80406c:	5b                   	pop    %ebx
  80406d:	5e                   	pop    %esi
  80406e:	5f                   	pop    %edi
  80406f:	5d                   	pop    %ebp
  804070:	c3                   	ret    
  804071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804078:	89 fd                	mov    %edi,%ebp
  80407a:	85 ff                	test   %edi,%edi
  80407c:	75 0b                	jne    804089 <__umoddi3+0x49>
  80407e:	b8 01 00 00 00       	mov    $0x1,%eax
  804083:	31 d2                	xor    %edx,%edx
  804085:	f7 f7                	div    %edi
  804087:	89 c5                	mov    %eax,%ebp
  804089:	89 d8                	mov    %ebx,%eax
  80408b:	31 d2                	xor    %edx,%edx
  80408d:	f7 f5                	div    %ebp
  80408f:	89 f0                	mov    %esi,%eax
  804091:	f7 f5                	div    %ebp
  804093:	89 d0                	mov    %edx,%eax
  804095:	eb d0                	jmp    804067 <__umoddi3+0x27>
  804097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80409e:	66 90                	xchg   %ax,%ax
  8040a0:	89 f1                	mov    %esi,%ecx
  8040a2:	39 d8                	cmp    %ebx,%eax
  8040a4:	76 0a                	jbe    8040b0 <__umoddi3+0x70>
  8040a6:	89 f0                	mov    %esi,%eax
  8040a8:	83 c4 1c             	add    $0x1c,%esp
  8040ab:	5b                   	pop    %ebx
  8040ac:	5e                   	pop    %esi
  8040ad:	5f                   	pop    %edi
  8040ae:	5d                   	pop    %ebp
  8040af:	c3                   	ret    
  8040b0:	0f bd e8             	bsr    %eax,%ebp
  8040b3:	83 f5 1f             	xor    $0x1f,%ebp
  8040b6:	75 20                	jne    8040d8 <__umoddi3+0x98>
  8040b8:	39 d8                	cmp    %ebx,%eax
  8040ba:	0f 82 b0 00 00 00    	jb     804170 <__umoddi3+0x130>
  8040c0:	39 f7                	cmp    %esi,%edi
  8040c2:	0f 86 a8 00 00 00    	jbe    804170 <__umoddi3+0x130>
  8040c8:	89 c8                	mov    %ecx,%eax
  8040ca:	83 c4 1c             	add    $0x1c,%esp
  8040cd:	5b                   	pop    %ebx
  8040ce:	5e                   	pop    %esi
  8040cf:	5f                   	pop    %edi
  8040d0:	5d                   	pop    %ebp
  8040d1:	c3                   	ret    
  8040d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8040d8:	89 e9                	mov    %ebp,%ecx
  8040da:	ba 20 00 00 00       	mov    $0x20,%edx
  8040df:	29 ea                	sub    %ebp,%edx
  8040e1:	d3 e0                	shl    %cl,%eax
  8040e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8040e7:	89 d1                	mov    %edx,%ecx
  8040e9:	89 f8                	mov    %edi,%eax
  8040eb:	d3 e8                	shr    %cl,%eax
  8040ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8040f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8040f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040f9:	09 c1                	or     %eax,%ecx
  8040fb:	89 d8                	mov    %ebx,%eax
  8040fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804101:	89 e9                	mov    %ebp,%ecx
  804103:	d3 e7                	shl    %cl,%edi
  804105:	89 d1                	mov    %edx,%ecx
  804107:	d3 e8                	shr    %cl,%eax
  804109:	89 e9                	mov    %ebp,%ecx
  80410b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80410f:	d3 e3                	shl    %cl,%ebx
  804111:	89 c7                	mov    %eax,%edi
  804113:	89 d1                	mov    %edx,%ecx
  804115:	89 f0                	mov    %esi,%eax
  804117:	d3 e8                	shr    %cl,%eax
  804119:	89 e9                	mov    %ebp,%ecx
  80411b:	89 fa                	mov    %edi,%edx
  80411d:	d3 e6                	shl    %cl,%esi
  80411f:	09 d8                	or     %ebx,%eax
  804121:	f7 74 24 08          	divl   0x8(%esp)
  804125:	89 d1                	mov    %edx,%ecx
  804127:	89 f3                	mov    %esi,%ebx
  804129:	f7 64 24 0c          	mull   0xc(%esp)
  80412d:	89 c6                	mov    %eax,%esi
  80412f:	89 d7                	mov    %edx,%edi
  804131:	39 d1                	cmp    %edx,%ecx
  804133:	72 06                	jb     80413b <__umoddi3+0xfb>
  804135:	75 10                	jne    804147 <__umoddi3+0x107>
  804137:	39 c3                	cmp    %eax,%ebx
  804139:	73 0c                	jae    804147 <__umoddi3+0x107>
  80413b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80413f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  804143:	89 d7                	mov    %edx,%edi
  804145:	89 c6                	mov    %eax,%esi
  804147:	89 ca                	mov    %ecx,%edx
  804149:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80414e:	29 f3                	sub    %esi,%ebx
  804150:	19 fa                	sbb    %edi,%edx
  804152:	89 d0                	mov    %edx,%eax
  804154:	d3 e0                	shl    %cl,%eax
  804156:	89 e9                	mov    %ebp,%ecx
  804158:	d3 eb                	shr    %cl,%ebx
  80415a:	d3 ea                	shr    %cl,%edx
  80415c:	09 d8                	or     %ebx,%eax
  80415e:	83 c4 1c             	add    $0x1c,%esp
  804161:	5b                   	pop    %ebx
  804162:	5e                   	pop    %esi
  804163:	5f                   	pop    %edi
  804164:	5d                   	pop    %ebp
  804165:	c3                   	ret    
  804166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80416d:	8d 76 00             	lea    0x0(%esi),%esi
  804170:	89 da                	mov    %ebx,%edx
  804172:	29 fe                	sub    %edi,%esi
  804174:	19 c2                	sbb    %eax,%edx
  804176:	89 f1                	mov    %esi,%ecx
  804178:	89 c8                	mov    %ecx,%eax
  80417a:	e9 4b ff ff ff       	jmp    8040ca <__umoddi3+0x8a>
