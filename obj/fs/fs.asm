
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
  80002c:	e8 ff 1b 00 00       	call   801c30 <libmain>
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
  8000b0:	68 e0 41 80 00       	push   $0x8041e0
  8000b5:	e8 79 1d 00 00       	call   801e33 <cprintf>
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
  8000d9:	68 f7 41 80 00       	push   $0x8041f7
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 07 42 80 00       	push   $0x804207
  8000e5:	e8 53 1c 00 00       	call   801d3d <_panic>

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
  80018f:	68 10 42 80 00       	push   $0x804210
  800194:	68 1d 42 80 00       	push   $0x80421d
  800199:	6a 44                	push   $0x44
  80019b:	68 07 42 80 00       	push   $0x804207
  8001a0:	e8 98 1b 00 00       	call   801d3d <_panic>
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
  800257:	68 10 42 80 00       	push   $0x804210
  80025c:	68 1d 42 80 00       	push   $0x80421d
  800261:	6a 5d                	push   $0x5d
  800263:	68 07 42 80 00       	push   $0x804207
  800268:	e8 d0 1a 00 00       	call   801d3d <_panic>
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
  8002a1:	68 34 42 80 00       	push   $0x804234
  8002a6:	6a 0c                	push   $0xc
  8002a8:	68 10 43 80 00       	push   $0x804310
  8002ad:	e8 8b 1a 00 00       	call   801d3d <_panic>

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
  800377:	e8 4b 26 00 00       	call   8029c7 <sys_page_map>
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
  80038c:	68 18 43 80 00       	push   $0x804318
  800391:	6a 5a                	push   $0x5a
  800393:	68 10 43 80 00       	push   $0x804310
  800398:	e8 a0 19 00 00       	call   801d3d <_panic>
		panic("the ide_write panic!\n");
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 33 43 80 00       	push   $0x804333
  8003a5:	6a 64                	push   $0x64
  8003a7:	68 10 43 80 00       	push   $0x804310
  8003ac:	e8 8c 19 00 00       	call   801d3d <_panic>
		panic("the sys_page_map panic!\n");
  8003b1:	83 ec 04             	sub    $0x4,%esp
  8003b4:	68 49 43 80 00       	push   $0x804349
  8003b9:	6a 67                	push   $0x67
  8003bb:	68 10 43 80 00       	push   $0x804310
  8003c0:	e8 78 19 00 00       	call   801d3d <_panic>

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
  8003d4:	e8 80 28 00 00       	call   802c59 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8003d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003e0:	e8 95 fe ff ff       	call   80027a <diskaddr>
  8003e5:	83 c4 0c             	add    $0xc,%esp
  8003e8:	68 08 01 00 00       	push   $0x108
  8003ed:	50                   	push   %eax
  8003ee:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8003f4:	50                   	push   %eax
  8003f5:	e8 26 23 00 00       	call   802720 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  8003fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800401:	e8 74 fe ff ff       	call   80027a <diskaddr>
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	68 62 43 80 00       	push   $0x804362
  80040e:	50                   	push   %eax
  80040f:	e8 7e 21 00 00       	call   802592 <strcpy>
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
  800474:	e8 90 25 00 00       	call   802a09 <sys_page_unmap>
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
  8004a5:	68 62 43 80 00       	push   $0x804362
  8004aa:	50                   	push   %eax
  8004ab:	e8 8d 21 00 00       	call   80263d <strcmp>
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
  8004d5:	e8 46 22 00 00       	call   802720 <memmove>
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
  800504:	e8 17 22 00 00       	call   802720 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800509:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800510:	e8 65 fd ff ff       	call   80027a <diskaddr>
  800515:	83 c4 08             	add    $0x8,%esp
  800518:	68 62 43 80 00       	push   $0x804362
  80051d:	50                   	push   %eax
  80051e:	e8 6f 20 00 00       	call   802592 <strcpy>
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
  800569:	e8 9b 24 00 00       	call   802a09 <sys_page_unmap>
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
  80059a:	68 62 43 80 00       	push   $0x804362
  80059f:	50                   	push   %eax
  8005a0:	e8 98 20 00 00       	call   80263d <strcmp>
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
  8005ca:	e8 51 21 00 00       	call   802720 <memmove>
	flush_block(diskaddr(1));
  8005cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d6:	e8 9f fc ff ff       	call   80027a <diskaddr>
  8005db:	89 04 24             	mov    %eax,(%esp)
  8005de:	e8 2d fd ff ff       	call   800310 <flush_block>
	cprintf("block cache is good\n");
  8005e3:	c7 04 24 9e 43 80 00 	movl   $0x80439e,(%esp)
  8005ea:	e8 44 18 00 00       	call   801e33 <cprintf>
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
  80060b:	e8 10 21 00 00       	call   802720 <memmove>
}
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800616:	c9                   	leave  
  800617:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800618:	68 84 43 80 00       	push   $0x804384
  80061d:	68 1d 42 80 00       	push   $0x80421d
  800622:	6a 78                	push   $0x78
  800624:	68 10 43 80 00       	push   $0x804310
  800629:	e8 0f 17 00 00       	call   801d3d <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80062e:	68 69 43 80 00       	push   $0x804369
  800633:	68 1d 42 80 00       	push   $0x80421d
  800638:	6a 79                	push   $0x79
  80063a:	68 10 43 80 00       	push   $0x804310
  80063f:	e8 f9 16 00 00       	call   801d3d <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800644:	68 83 43 80 00       	push   $0x804383
  800649:	68 1d 42 80 00       	push   $0x80421d
  80064e:	6a 7d                	push   $0x7d
  800650:	68 10 43 80 00       	push   $0x804310
  800655:	e8 e3 16 00 00       	call   801d3d <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80065a:	68 58 42 80 00       	push   $0x804258
  80065f:	68 1d 42 80 00       	push   $0x80421d
  800664:	68 80 00 00 00       	push   $0x80
  800669:	68 10 43 80 00       	push   $0x804310
  80066e:	e8 ca 16 00 00       	call   801d3d <_panic>
	assert(va_is_mapped(diskaddr(1)));
  800673:	68 84 43 80 00       	push   $0x804384
  800678:	68 1d 42 80 00       	push   $0x80421d
  80067d:	68 91 00 00 00       	push   $0x91
  800682:	68 10 43 80 00       	push   $0x804310
  800687:	e8 b1 16 00 00       	call   801d3d <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  80068c:	68 83 43 80 00       	push   $0x804383
  800691:	68 1d 42 80 00       	push   $0x80421d
  800696:	68 99 00 00 00       	push   $0x99
  80069b:	68 10 43 80 00       	push   $0x804310
  8006a0:	e8 98 16 00 00       	call   801d3d <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006a5:	68 58 42 80 00       	push   $0x804258
  8006aa:	68 1d 42 80 00       	push   $0x80421d
  8006af:	68 9c 00 00 00       	push   $0x9c
  8006b4:	68 10 43 80 00       	push   $0x804310
  8006b9:	e8 7f 16 00 00       	call   801d3d <_panic>

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
  8006f2:	e8 20 25 00 00       	call   802c17 <sys_clear_access_bit>
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
  800762:	68 7c 42 80 00       	push   $0x80427c
  800767:	68 c1 00 00 00       	push   $0xc1
  80076c:	68 10 43 80 00       	push   $0x804310
  800771:	e8 c7 15 00 00       	call   801d3d <_panic>
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
  80080d:	e8 72 21 00 00       	call   802984 <sys_page_alloc>
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
  80084a:	e8 78 21 00 00       	call   8029c7 <sys_page_map>
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
  80088c:	68 9c 42 80 00       	push   $0x80429c
  800891:	6a 31                	push   $0x31
  800893:	68 10 43 80 00       	push   $0x804310
  800898:	e8 a0 14 00 00       	call   801d3d <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80089d:	56                   	push   %esi
  80089e:	68 cc 42 80 00       	push   $0x8042cc
  8008a3:	6a 34                	push   $0x34
  8008a5:	68 10 43 80 00       	push   $0x804310
  8008aa:	e8 8e 14 00 00       	call   801d3d <_panic>
		panic("the sys_page_alloc panic!\n");
  8008af:	83 ec 04             	sub    $0x4,%esp
  8008b2:	68 b3 43 80 00       	push   $0x8043b3
  8008b7:	6a 3f                	push   $0x3f
  8008b9:	68 10 43 80 00       	push   $0x804310
  8008be:	e8 7a 14 00 00       	call   801d3d <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8008c3:	50                   	push   %eax
  8008c4:	68 f0 42 80 00       	push   $0x8042f0
  8008c9:	6a 44                	push   $0x44
  8008cb:	68 10 43 80 00       	push   $0x804310
  8008d0:	e8 68 14 00 00       	call   801d3d <_panic>
		panic("reading free block %08x\n", blockno);
  8008d5:	56                   	push   %esi
  8008d6:	68 ce 43 80 00       	push   $0x8043ce
  8008db:	6a 49                	push   $0x49
  8008dd:	68 10 43 80 00       	push   $0x804310
  8008e2:	e8 56 14 00 00       	call   801d3d <_panic>

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
  800906:	68 25 44 80 00       	push   $0x804425
  80090b:	e8 23 15 00 00       	call   801e33 <cprintf>
}
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	c9                   	leave  
  800914:	c3                   	ret    
		panic("bad file system magic number");
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 e7 43 80 00       	push   $0x8043e7
  80091d:	6a 0f                	push   $0xf
  80091f:	68 04 44 80 00       	push   $0x804404
  800924:	e8 14 14 00 00       	call   801d3d <_panic>
		panic("file system is too large");
  800929:	83 ec 04             	sub    $0x4,%esp
  80092c:	68 0c 44 80 00       	push   $0x80440c
  800931:	6a 12                	push   $0x12
  800933:	68 04 44 80 00       	push   $0x804404
  800938:	e8 00 14 00 00       	call   801d3d <_panic>

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
  8009a5:	68 39 44 80 00       	push   $0x804439
  8009aa:	6a 2d                	push   $0x2d
  8009ac:	68 04 44 80 00       	push   $0x804404
  8009b1:	e8 87 13 00 00       	call   801d3d <_panic>

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
  800a8a:	e8 49 1c 00 00       	call   8026d8 <memset>
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
  800b10:	68 54 44 80 00       	push   $0x804454
  800b15:	68 1d 42 80 00       	push   $0x80421d
  800b1a:	6a 5b                	push   $0x5b
  800b1c:	68 04 44 80 00       	push   $0x804404
  800b21:	e8 17 12 00 00       	call   801d3d <_panic>
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
  800b4b:	68 8c 44 80 00       	push   $0x80448c
  800b50:	e8 de 12 00 00       	call   801e33 <cprintf>
}
  800b55:	83 c4 10             	add    $0x10,%esp
  800b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    
	assert(!block_is_free(0));
  800b5f:	68 68 44 80 00       	push   $0x804468
  800b64:	68 1d 42 80 00       	push   $0x80421d
  800b69:	6a 5e                	push   $0x5e
  800b6b:	68 04 44 80 00       	push   $0x804404
  800b70:	e8 c8 11 00 00       	call   801d3d <_panic>
	assert(!block_is_free(1));
  800b75:	68 7a 44 80 00       	push   $0x80447a
  800b7a:	68 1d 42 80 00       	push   $0x80421d
  800b7f:	6a 5f                	push   $0x5f
  800b81:	68 04 44 80 00       	push   $0x804404
  800b86:	e8 b2 11 00 00       	call   801d3d <_panic>

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
  800cd1:	e8 4a 1a 00 00       	call   802720 <memmove>
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
  800d83:	e8 b5 18 00 00       	call   80263d <strcmp>
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
  800da6:	68 9c 44 80 00       	push   $0x80449c
  800dab:	68 1d 42 80 00       	push   $0x80421d
  800db0:	68 d9 00 00 00       	push   $0xd9
  800db5:	68 04 44 80 00       	push   $0x804404
  800dba:	e8 7e 0f 00 00       	call   801d3d <_panic>
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
  800df4:	e8 99 17 00 00       	call   802592 <strcpy>
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
  800e85:	68 b9 44 80 00       	push   $0x8044b9
  800e8a:	e8 a4 0f 00 00       	call   801e33 <cprintf>
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
  800f3b:	e8 e0 17 00 00       	call   802720 <memmove>
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
  800fe4:	68 c6 44 80 00       	push   $0x8044c6
  800fe9:	e8 45 0e 00 00       	call   801e33 <cprintf>
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
  8010ad:	e8 6e 16 00 00       	call   802720 <memmove>
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
  80122a:	68 9c 44 80 00       	push   $0x80449c
  80122f:	68 1d 42 80 00       	push   $0x80421d
  801234:	68 f2 00 00 00       	push   $0xf2
  801239:	68 04 44 80 00       	push   $0x804404
  80123e:	e8 fa 0a 00 00       	call   801d3d <_panic>
				*file = &f[j];
  801243:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801259:	e8 34 13 00 00       	call   802592 <strcpy>
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
  80134b:	e8 c6 22 00 00       	call   803616 <pageref>
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
  801380:	e8 ff 15 00 00       	call   802984 <sys_page_alloc>
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
  8013b1:	e8 22 13 00 00       	call   8026d8 <memset>
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
  8013ea:	e8 27 22 00 00       	call   803616 <pageref>
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
  801526:	e8 67 10 00 00       	call   802592 <strcpy>
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
  8015b0:	e8 6b 11 00 00       	call   802720 <memmove>
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
  8016cf:	68 74 45 80 00       	push   $0x804574
  8016d4:	68 10 48 80 00       	push   $0x804810
  8016d9:	e8 55 07 00 00       	call   801e33 <cprintf>
  8016de:	83 c4 10             	add    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016e1:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8016e4:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8016e7:	e9 82 00 00 00       	jmp    80176e <serve+0xa7>
		if (!(perm & PTE_P)) {
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
  80173a:	68 48 45 80 00       	push   $0x804548
  80173f:	e8 ef 06 00 00       	call   801e33 <cprintf>
  801744:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801747:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80174c:	ff 75 f0             	pushl  -0x10(%ebp)
  80174f:	ff 75 ec             	pushl  -0x14(%ebp)
  801752:	50                   	push   %eax
  801753:	ff 75 f4             	pushl  -0xc(%ebp)
  801756:	e8 fc 15 00 00       	call   802d57 <ipc_send>
		sys_page_unmap(0, fsreq);
  80175b:	83 c4 08             	add    $0x8,%esp
  80175e:	ff 35 44 50 80 00    	pushl  0x805044
  801764:	6a 00                	push   $0x0
  801766:	e8 9e 12 00 00       	call   802a09 <sys_page_unmap>
  80176b:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  80176e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	53                   	push   %ebx
  801779:	ff 35 44 50 80 00    	pushl  0x805044
  80177f:	56                   	push   %esi
  801780:	e8 69 15 00 00       	call   802cee <ipc_recv>
		if (!(perm & PTE_P)) {
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  80178c:	0f 85 5a ff ff ff    	jne    8016ec <serve+0x25>
			cprintf("Invalid request from %08x: no argument page\n",
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	ff 75 f4             	pushl  -0xc(%ebp)
  801798:	68 18 45 80 00       	push   $0x804518
  80179d:	e8 91 06 00 00       	call   801e33 <cprintf>
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
  8017aa:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in serv.c %s\n", thisenv->env_id, __FUNCTION__);
  8017ad:	a1 50 a0 80 00       	mov    0x80a050,%eax
  8017b2:	8b 40 48             	mov    0x48(%eax),%eax
  8017b5:	68 6c 45 80 00       	push   $0x80456c
  8017ba:	50                   	push   %eax
  8017bb:	68 e3 44 80 00       	push   $0x8044e3
  8017c0:	e8 6e 06 00 00       	call   801e33 <cprintf>
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8017c5:	c7 05 60 90 80 00 f5 	movl   $0x8044f5,0x809060
  8017cc:	44 80 00 
	cprintf("FS is running\n");
  8017cf:	c7 04 24 f8 44 80 00 	movl   $0x8044f8,(%esp)
  8017d6:	e8 58 06 00 00       	call   801e33 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8017db:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8017e0:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8017e5:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8017e7:	c7 04 24 07 45 80 00 	movl   $0x804507,(%esp)
  8017ee:	e8 40 06 00 00       	call   801e33 <cprintf>

	serve_init();
  8017f3:	e8 0c fb ff ff       	call   801304 <serve_init>
	fs_init();
  8017f8:	e8 8e f3 ff ff       	call   800b8b <fs_init>
	serve();
  8017fd:	e8 c5 fe ff ff       	call   8016c7 <serve>

00801802 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	53                   	push   %ebx
  801806:	83 ec 1c             	sub    $0x1c,%esp
	cprintf("in %s\n", __FUNCTION__);
  801809:	68 ac 47 80 00       	push   $0x8047ac
  80180e:	68 10 48 80 00       	push   $0x804810
  801813:	e8 1b 06 00 00       	call   801e33 <cprintf>
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801818:	83 c4 0c             	add    $0xc,%esp
  80181b:	6a 07                	push   $0x7
  80181d:	68 00 10 00 00       	push   $0x1000
  801822:	6a 00                	push   $0x0
  801824:	e8 5b 11 00 00       	call   802984 <sys_page_alloc>
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	85 c0                	test   %eax,%eax
  80182e:	0f 88 68 02 00 00    	js     801a9c <fs_test+0x29a>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 00 10 00 00       	push   $0x1000
  80183c:	ff 35 48 a0 80 00    	pushl  0x80a048
  801842:	68 00 10 00 00       	push   $0x1000
  801847:	e8 d4 0e 00 00       	call   802720 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  80184c:	e8 65 f1 ff ff       	call   8009b6 <alloc_block>
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	0f 88 52 02 00 00    	js     801aae <fs_test+0x2ac>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  80185c:	8d 50 1f             	lea    0x1f(%eax),%edx
  80185f:	0f 49 d0             	cmovns %eax,%edx
  801862:	c1 fa 05             	sar    $0x5,%edx
  801865:	89 c3                	mov    %eax,%ebx
  801867:	c1 fb 1f             	sar    $0x1f,%ebx
  80186a:	c1 eb 1b             	shr    $0x1b,%ebx
  80186d:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  801870:	83 e1 1f             	and    $0x1f,%ecx
  801873:	29 d9                	sub    %ebx,%ecx
  801875:	b8 01 00 00 00       	mov    $0x1,%eax
  80187a:	d3 e0                	shl    %cl,%eax
  80187c:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  801883:	0f 84 37 02 00 00    	je     801ac0 <fs_test+0x2be>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801889:	8b 0d 48 a0 80 00    	mov    0x80a048,%ecx
  80188f:	85 04 91             	test   %eax,(%ecx,%edx,4)
  801892:	0f 85 3e 02 00 00    	jne    801ad6 <fs_test+0x2d4>
	cprintf("alloc_block is good\n");
  801898:	83 ec 0c             	sub    $0xc,%esp
  80189b:	68 c2 45 80 00       	push   $0x8045c2
  8018a0:	e8 8e 05 00 00       	call   801e33 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8018a5:	83 c4 08             	add    $0x8,%esp
  8018a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ab:	50                   	push   %eax
  8018ac:	68 d7 45 80 00       	push   $0x8045d7
  8018b1:	e8 c4 f5 ff ff       	call   800e7a <file_open>
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8018bc:	74 08                	je     8018c6 <fs_test+0xc4>
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	0f 88 26 02 00 00    	js     801aec <fs_test+0x2ea>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	0f 84 30 02 00 00    	je     801afe <fs_test+0x2fc>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  8018ce:	83 ec 08             	sub    $0x8,%esp
  8018d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d4:	50                   	push   %eax
  8018d5:	68 fb 45 80 00       	push   $0x8045fb
  8018da:	e8 9b f5 ff ff       	call   800e7a <file_open>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	0f 88 28 02 00 00    	js     801b12 <fs_test+0x310>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  8018ea:	83 ec 0c             	sub    $0xc,%esp
  8018ed:	68 1b 46 80 00       	push   $0x80461b
  8018f2:	e8 3c 05 00 00       	call   801e33 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018f7:	83 c4 0c             	add    $0xc,%esp
  8018fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fd:	50                   	push   %eax
  8018fe:	6a 00                	push   $0x0
  801900:	ff 75 f4             	pushl  -0xc(%ebp)
  801903:	e8 e2 f2 ff ff       	call   800bea <file_get_block>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	0f 88 11 02 00 00    	js     801b24 <fs_test+0x322>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  801913:	83 ec 08             	sub    $0x8,%esp
  801916:	68 60 47 80 00       	push   $0x804760
  80191b:	ff 75 f0             	pushl  -0x10(%ebp)
  80191e:	e8 1a 0d 00 00       	call   80263d <strcmp>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	0f 85 08 02 00 00    	jne    801b36 <fs_test+0x334>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	68 41 46 80 00       	push   $0x804641
  801936:	e8 f8 04 00 00       	call   801e33 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  80193b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193e:	0f b6 10             	movzbl (%eax),%edx
  801941:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801946:	c1 e8 0c             	shr    $0xc,%eax
  801949:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	a8 40                	test   $0x40,%al
  801955:	0f 84 ef 01 00 00    	je     801b4a <fs_test+0x348>
	file_flush(f);
  80195b:	83 ec 0c             	sub    $0xc,%esp
  80195e:	ff 75 f4             	pushl  -0xc(%ebp)
  801961:	e8 73 f7 ff ff       	call   8010d9 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801969:	c1 e8 0c             	shr    $0xc,%eax
  80196c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	a8 40                	test   $0x40,%al
  801978:	0f 85 e2 01 00 00    	jne    801b60 <fs_test+0x35e>
	cprintf("file_flush is good\n");
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	68 75 46 80 00       	push   $0x804675
  801986:	e8 a8 04 00 00       	call   801e33 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  80198b:	83 c4 08             	add    $0x8,%esp
  80198e:	6a 00                	push   $0x0
  801990:	ff 75 f4             	pushl  -0xc(%ebp)
  801993:	e8 bc f5 ff ff       	call   800f54 <file_set_size>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	0f 88 d3 01 00 00    	js     801b76 <fs_test+0x374>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  8019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a6:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  8019ad:	0f 85 d5 01 00 00    	jne    801b88 <fs_test+0x386>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019b3:	c1 e8 0c             	shr    $0xc,%eax
  8019b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019bd:	a8 40                	test   $0x40,%al
  8019bf:	0f 85 d9 01 00 00    	jne    801b9e <fs_test+0x39c>
	cprintf("file_truncate is good\n");
  8019c5:	83 ec 0c             	sub    $0xc,%esp
  8019c8:	68 c9 46 80 00       	push   $0x8046c9
  8019cd:	e8 61 04 00 00       	call   801e33 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8019d2:	c7 04 24 60 47 80 00 	movl   $0x804760,(%esp)
  8019d9:	e8 7b 0b 00 00       	call   802559 <strlen>
  8019de:	83 c4 08             	add    $0x8,%esp
  8019e1:	50                   	push   %eax
  8019e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e5:	e8 6a f5 ff ff       	call   800f54 <file_set_size>
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	0f 88 bf 01 00 00    	js     801bb4 <fs_test+0x3b2>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f8:	89 c2                	mov    %eax,%edx
  8019fa:	c1 ea 0c             	shr    $0xc,%edx
  8019fd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a04:	f6 c2 40             	test   $0x40,%dl
  801a07:	0f 85 b9 01 00 00    	jne    801bc6 <fs_test+0x3c4>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801a0d:	83 ec 04             	sub    $0x4,%esp
  801a10:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801a13:	52                   	push   %edx
  801a14:	6a 00                	push   $0x0
  801a16:	50                   	push   %eax
  801a17:	e8 ce f1 ff ff       	call   800bea <file_get_block>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	0f 88 b5 01 00 00    	js     801bdc <fs_test+0x3da>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  801a27:	83 ec 08             	sub    $0x8,%esp
  801a2a:	68 60 47 80 00       	push   $0x804760
  801a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a32:	e8 5b 0b 00 00       	call   802592 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	c1 e8 0c             	shr    $0xc,%eax
  801a3d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	a8 40                	test   $0x40,%al
  801a49:	0f 84 9f 01 00 00    	je     801bee <fs_test+0x3ec>
	file_flush(f);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 f4             	pushl  -0xc(%ebp)
  801a55:	e8 7f f6 ff ff       	call   8010d9 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5d:	c1 e8 0c             	shr    $0xc,%eax
  801a60:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a67:	83 c4 10             	add    $0x10,%esp
  801a6a:	a8 40                	test   $0x40,%al
  801a6c:	0f 85 92 01 00 00    	jne    801c04 <fs_test+0x402>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a75:	c1 e8 0c             	shr    $0xc,%eax
  801a78:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a7f:	a8 40                	test   $0x40,%al
  801a81:	0f 85 93 01 00 00    	jne    801c1a <fs_test+0x418>
	cprintf("file rewrite is good\n");
  801a87:	83 ec 0c             	sub    $0xc,%esp
  801a8a:	68 09 47 80 00       	push   $0x804709
  801a8f:	e8 9f 03 00 00       	call   801e33 <cprintf>
}
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801a9c:	50                   	push   %eax
  801a9d:	68 7a 45 80 00       	push   $0x80457a
  801aa2:	6a 13                	push   $0x13
  801aa4:	68 8d 45 80 00       	push   $0x80458d
  801aa9:	e8 8f 02 00 00       	call   801d3d <_panic>
		panic("alloc_block: %e", r);
  801aae:	50                   	push   %eax
  801aaf:	68 97 45 80 00       	push   $0x804597
  801ab4:	6a 18                	push   $0x18
  801ab6:	68 8d 45 80 00       	push   $0x80458d
  801abb:	e8 7d 02 00 00       	call   801d3d <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801ac0:	68 a7 45 80 00       	push   $0x8045a7
  801ac5:	68 1d 42 80 00       	push   $0x80421d
  801aca:	6a 1a                	push   $0x1a
  801acc:	68 8d 45 80 00       	push   $0x80458d
  801ad1:	e8 67 02 00 00       	call   801d3d <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801ad6:	68 20 47 80 00       	push   $0x804720
  801adb:	68 1d 42 80 00       	push   $0x80421d
  801ae0:	6a 1c                	push   $0x1c
  801ae2:	68 8d 45 80 00       	push   $0x80458d
  801ae7:	e8 51 02 00 00       	call   801d3d <_panic>
		panic("file_open /not-found: %e", r);
  801aec:	50                   	push   %eax
  801aed:	68 e2 45 80 00       	push   $0x8045e2
  801af2:	6a 20                	push   $0x20
  801af4:	68 8d 45 80 00       	push   $0x80458d
  801af9:	e8 3f 02 00 00       	call   801d3d <_panic>
		panic("file_open /not-found succeeded!");
  801afe:	83 ec 04             	sub    $0x4,%esp
  801b01:	68 40 47 80 00       	push   $0x804740
  801b06:	6a 22                	push   $0x22
  801b08:	68 8d 45 80 00       	push   $0x80458d
  801b0d:	e8 2b 02 00 00       	call   801d3d <_panic>
		panic("file_open /newmotd: %e", r);
  801b12:	50                   	push   %eax
  801b13:	68 04 46 80 00       	push   $0x804604
  801b18:	6a 24                	push   $0x24
  801b1a:	68 8d 45 80 00       	push   $0x80458d
  801b1f:	e8 19 02 00 00       	call   801d3d <_panic>
		panic("file_get_block: %e", r);
  801b24:	50                   	push   %eax
  801b25:	68 2e 46 80 00       	push   $0x80462e
  801b2a:	6a 28                	push   $0x28
  801b2c:	68 8d 45 80 00       	push   $0x80458d
  801b31:	e8 07 02 00 00       	call   801d3d <_panic>
		panic("file_get_block returned wrong data");
  801b36:	83 ec 04             	sub    $0x4,%esp
  801b39:	68 88 47 80 00       	push   $0x804788
  801b3e:	6a 2a                	push   $0x2a
  801b40:	68 8d 45 80 00       	push   $0x80458d
  801b45:	e8 f3 01 00 00       	call   801d3d <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b4a:	68 5a 46 80 00       	push   $0x80465a
  801b4f:	68 1d 42 80 00       	push   $0x80421d
  801b54:	6a 2e                	push   $0x2e
  801b56:	68 8d 45 80 00       	push   $0x80458d
  801b5b:	e8 dd 01 00 00       	call   801d3d <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b60:	68 59 46 80 00       	push   $0x804659
  801b65:	68 1d 42 80 00       	push   $0x80421d
  801b6a:	6a 30                	push   $0x30
  801b6c:	68 8d 45 80 00       	push   $0x80458d
  801b71:	e8 c7 01 00 00       	call   801d3d <_panic>
		panic("file_set_size: %e", r);
  801b76:	50                   	push   %eax
  801b77:	68 89 46 80 00       	push   $0x804689
  801b7c:	6a 34                	push   $0x34
  801b7e:	68 8d 45 80 00       	push   $0x80458d
  801b83:	e8 b5 01 00 00       	call   801d3d <_panic>
	assert(f->f_direct[0] == 0);
  801b88:	68 9b 46 80 00       	push   $0x80469b
  801b8d:	68 1d 42 80 00       	push   $0x80421d
  801b92:	6a 35                	push   $0x35
  801b94:	68 8d 45 80 00       	push   $0x80458d
  801b99:	e8 9f 01 00 00       	call   801d3d <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b9e:	68 af 46 80 00       	push   $0x8046af
  801ba3:	68 1d 42 80 00       	push   $0x80421d
  801ba8:	6a 36                	push   $0x36
  801baa:	68 8d 45 80 00       	push   $0x80458d
  801baf:	e8 89 01 00 00       	call   801d3d <_panic>
		panic("file_set_size 2: %e", r);
  801bb4:	50                   	push   %eax
  801bb5:	68 e0 46 80 00       	push   $0x8046e0
  801bba:	6a 3a                	push   $0x3a
  801bbc:	68 8d 45 80 00       	push   $0x80458d
  801bc1:	e8 77 01 00 00       	call   801d3d <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801bc6:	68 af 46 80 00       	push   $0x8046af
  801bcb:	68 1d 42 80 00       	push   $0x80421d
  801bd0:	6a 3b                	push   $0x3b
  801bd2:	68 8d 45 80 00       	push   $0x80458d
  801bd7:	e8 61 01 00 00       	call   801d3d <_panic>
		panic("file_get_block 2: %e", r);
  801bdc:	50                   	push   %eax
  801bdd:	68 f4 46 80 00       	push   $0x8046f4
  801be2:	6a 3d                	push   $0x3d
  801be4:	68 8d 45 80 00       	push   $0x80458d
  801be9:	e8 4f 01 00 00       	call   801d3d <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801bee:	68 5a 46 80 00       	push   $0x80465a
  801bf3:	68 1d 42 80 00       	push   $0x80421d
  801bf8:	6a 3f                	push   $0x3f
  801bfa:	68 8d 45 80 00       	push   $0x80458d
  801bff:	e8 39 01 00 00       	call   801d3d <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801c04:	68 59 46 80 00       	push   $0x804659
  801c09:	68 1d 42 80 00       	push   $0x80421d
  801c0e:	6a 41                	push   $0x41
  801c10:	68 8d 45 80 00       	push   $0x80458d
  801c15:	e8 23 01 00 00       	call   801d3d <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c1a:	68 af 46 80 00       	push   $0x8046af
  801c1f:	68 1d 42 80 00       	push   $0x80421d
  801c24:	6a 42                	push   $0x42
  801c26:	68 8d 45 80 00       	push   $0x80458d
  801c2b:	e8 0d 01 00 00       	call   801d3d <_panic>

00801c30 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	57                   	push   %edi
  801c34:	56                   	push   %esi
  801c35:	53                   	push   %ebx
  801c36:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  801c39:	c7 05 50 a0 80 00 00 	movl   $0x0,0x80a050
  801c40:	00 00 00 
	envid_t find = sys_getenvid();
  801c43:	e8 fe 0c 00 00       	call   802946 <sys_getenvid>
  801c48:	8b 1d 50 a0 80 00    	mov    0x80a050,%ebx
  801c4e:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  801c53:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  801c58:	bf 01 00 00 00       	mov    $0x1,%edi
  801c5d:	eb 0b                	jmp    801c6a <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  801c5f:	83 c2 01             	add    $0x1,%edx
  801c62:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  801c68:	74 21                	je     801c8b <libmain+0x5b>
		if(envs[i].env_id == find)
  801c6a:	89 d1                	mov    %edx,%ecx
  801c6c:	c1 e1 07             	shl    $0x7,%ecx
  801c6f:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  801c75:	8b 49 48             	mov    0x48(%ecx),%ecx
  801c78:	39 c1                	cmp    %eax,%ecx
  801c7a:	75 e3                	jne    801c5f <libmain+0x2f>
  801c7c:	89 d3                	mov    %edx,%ebx
  801c7e:	c1 e3 07             	shl    $0x7,%ebx
  801c81:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801c87:	89 fe                	mov    %edi,%esi
  801c89:	eb d4                	jmp    801c5f <libmain+0x2f>
  801c8b:	89 f0                	mov    %esi,%eax
  801c8d:	84 c0                	test   %al,%al
  801c8f:	74 06                	je     801c97 <libmain+0x67>
  801c91:	89 1d 50 a0 80 00    	mov    %ebx,0x80a050
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801c97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c9b:	7e 0a                	jle    801ca7 <libmain+0x77>
		binaryname = argv[0];
  801c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca0:	8b 00                	mov    (%eax),%eax
  801ca2:	a3 60 90 80 00       	mov    %eax,0x809060

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  801ca7:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801cac:	8b 40 48             	mov    0x48(%eax),%eax
  801caf:	83 ec 08             	sub    $0x8,%esp
  801cb2:	50                   	push   %eax
  801cb3:	68 b4 47 80 00       	push   $0x8047b4
  801cb8:	e8 76 01 00 00       	call   801e33 <cprintf>
	cprintf("before umain\n");
  801cbd:	c7 04 24 d2 47 80 00 	movl   $0x8047d2,(%esp)
  801cc4:	e8 6a 01 00 00       	call   801e33 <cprintf>
	// call user main routine
	umain(argc, argv);
  801cc9:	83 c4 08             	add    $0x8,%esp
  801ccc:	ff 75 0c             	pushl  0xc(%ebp)
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	e8 d0 fa ff ff       	call   8017a7 <umain>
	cprintf("after umain\n");
  801cd7:	c7 04 24 e0 47 80 00 	movl   $0x8047e0,(%esp)
  801cde:	e8 50 01 00 00       	call   801e33 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  801ce3:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801ce8:	8b 40 48             	mov    0x48(%eax),%eax
  801ceb:	83 c4 08             	add    $0x8,%esp
  801cee:	50                   	push   %eax
  801cef:	68 ed 47 80 00       	push   $0x8047ed
  801cf4:	e8 3a 01 00 00       	call   801e33 <cprintf>
	// exit gracefully
	exit();
  801cf9:	e8 0b 00 00 00       	call   801d09 <exit>
}
  801cfe:	83 c4 10             	add    $0x10,%esp
  801d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d04:	5b                   	pop    %ebx
  801d05:	5e                   	pop    %esi
  801d06:	5f                   	pop    %edi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801d0f:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801d14:	8b 40 48             	mov    0x48(%eax),%eax
  801d17:	68 18 48 80 00       	push   $0x804818
  801d1c:	50                   	push   %eax
  801d1d:	68 0c 48 80 00       	push   $0x80480c
  801d22:	e8 0c 01 00 00       	call   801e33 <cprintf>
	close_all();
  801d27:	e8 96 12 00 00       	call   802fc2 <close_all>
	sys_env_destroy(0);
  801d2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d33:	e8 cd 0b 00 00       	call   802905 <sys_env_destroy>
}
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	56                   	push   %esi
  801d41:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801d42:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801d47:	8b 40 48             	mov    0x48(%eax),%eax
  801d4a:	83 ec 04             	sub    $0x4,%esp
  801d4d:	68 44 48 80 00       	push   $0x804844
  801d52:	50                   	push   %eax
  801d53:	68 0c 48 80 00       	push   $0x80480c
  801d58:	e8 d6 00 00 00       	call   801e33 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  801d5d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d60:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801d66:	e8 db 0b 00 00       	call   802946 <sys_getenvid>
  801d6b:	83 c4 04             	add    $0x4,%esp
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	ff 75 08             	pushl  0x8(%ebp)
  801d74:	56                   	push   %esi
  801d75:	50                   	push   %eax
  801d76:	68 20 48 80 00       	push   $0x804820
  801d7b:	e8 b3 00 00 00       	call   801e33 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d80:	83 c4 18             	add    $0x18,%esp
  801d83:	53                   	push   %ebx
  801d84:	ff 75 10             	pushl  0x10(%ebp)
  801d87:	e8 56 00 00 00       	call   801de2 <vcprintf>
	cprintf("\n");
  801d8c:	c7 04 24 67 43 80 00 	movl   $0x804367,(%esp)
  801d93:	e8 9b 00 00 00       	call   801e33 <cprintf>
  801d98:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d9b:	cc                   	int3   
  801d9c:	eb fd                	jmp    801d9b <_panic+0x5e>

00801d9e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	53                   	push   %ebx
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801da8:	8b 13                	mov    (%ebx),%edx
  801daa:	8d 42 01             	lea    0x1(%edx),%eax
  801dad:	89 03                	mov    %eax,(%ebx)
  801daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801db6:	3d ff 00 00 00       	cmp    $0xff,%eax
  801dbb:	74 09                	je     801dc6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801dbd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801dc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801dc6:	83 ec 08             	sub    $0x8,%esp
  801dc9:	68 ff 00 00 00       	push   $0xff
  801dce:	8d 43 08             	lea    0x8(%ebx),%eax
  801dd1:	50                   	push   %eax
  801dd2:	e8 f1 0a 00 00       	call   8028c8 <sys_cputs>
		b->idx = 0;
  801dd7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	eb db                	jmp    801dbd <putch+0x1f>

00801de2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801deb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801df2:	00 00 00 
	b.cnt = 0;
  801df5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801dfc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801dff:	ff 75 0c             	pushl  0xc(%ebp)
  801e02:	ff 75 08             	pushl  0x8(%ebp)
  801e05:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e0b:	50                   	push   %eax
  801e0c:	68 9e 1d 80 00       	push   $0x801d9e
  801e11:	e8 4a 01 00 00       	call   801f60 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801e16:	83 c4 08             	add    $0x8,%esp
  801e19:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801e1f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801e25:	50                   	push   %eax
  801e26:	e8 9d 0a 00 00       	call   8028c8 <sys_cputs>

	return b.cnt;
}
  801e2b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801e39:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801e3c:	50                   	push   %eax
  801e3d:	ff 75 08             	pushl  0x8(%ebp)
  801e40:	e8 9d ff ff ff       	call   801de2 <vcprintf>
	va_end(ap);

	return cnt;
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	57                   	push   %edi
  801e4b:	56                   	push   %esi
  801e4c:	53                   	push   %ebx
  801e4d:	83 ec 1c             	sub    $0x1c,%esp
  801e50:	89 c6                	mov    %eax,%esi
  801e52:	89 d7                	mov    %edx,%edi
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e5d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801e60:	8b 45 10             	mov    0x10(%ebp),%eax
  801e63:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  801e66:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  801e6a:	74 2c                	je     801e98 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  801e6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801e76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801e7c:	39 c2                	cmp    %eax,%edx
  801e7e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  801e81:	73 43                	jae    801ec6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  801e83:	83 eb 01             	sub    $0x1,%ebx
  801e86:	85 db                	test   %ebx,%ebx
  801e88:	7e 6c                	jle    801ef6 <printnum+0xaf>
				putch(padc, putdat);
  801e8a:	83 ec 08             	sub    $0x8,%esp
  801e8d:	57                   	push   %edi
  801e8e:	ff 75 18             	pushl  0x18(%ebp)
  801e91:	ff d6                	call   *%esi
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	eb eb                	jmp    801e83 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	6a 20                	push   $0x20
  801e9d:	6a 00                	push   $0x0
  801e9f:	50                   	push   %eax
  801ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ea3:	ff 75 e0             	pushl  -0x20(%ebp)
  801ea6:	89 fa                	mov    %edi,%edx
  801ea8:	89 f0                	mov    %esi,%eax
  801eaa:	e8 98 ff ff ff       	call   801e47 <printnum>
		while (--width > 0)
  801eaf:	83 c4 20             	add    $0x20,%esp
  801eb2:	83 eb 01             	sub    $0x1,%ebx
  801eb5:	85 db                	test   %ebx,%ebx
  801eb7:	7e 65                	jle    801f1e <printnum+0xd7>
			putch(padc, putdat);
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	57                   	push   %edi
  801ebd:	6a 20                	push   $0x20
  801ebf:	ff d6                	call   *%esi
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	eb ec                	jmp    801eb2 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	ff 75 18             	pushl  0x18(%ebp)
  801ecc:	83 eb 01             	sub    $0x1,%ebx
  801ecf:	53                   	push   %ebx
  801ed0:	50                   	push   %eax
  801ed1:	83 ec 08             	sub    $0x8,%esp
  801ed4:	ff 75 dc             	pushl  -0x24(%ebp)
  801ed7:	ff 75 d8             	pushl  -0x28(%ebp)
  801eda:	ff 75 e4             	pushl  -0x1c(%ebp)
  801edd:	ff 75 e0             	pushl  -0x20(%ebp)
  801ee0:	e8 9b 20 00 00       	call   803f80 <__udivdi3>
  801ee5:	83 c4 18             	add    $0x18,%esp
  801ee8:	52                   	push   %edx
  801ee9:	50                   	push   %eax
  801eea:	89 fa                	mov    %edi,%edx
  801eec:	89 f0                	mov    %esi,%eax
  801eee:	e8 54 ff ff ff       	call   801e47 <printnum>
  801ef3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  801ef6:	83 ec 08             	sub    $0x8,%esp
  801ef9:	57                   	push   %edi
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	ff 75 dc             	pushl  -0x24(%ebp)
  801f00:	ff 75 d8             	pushl  -0x28(%ebp)
  801f03:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f06:	ff 75 e0             	pushl  -0x20(%ebp)
  801f09:	e8 82 21 00 00       	call   804090 <__umoddi3>
  801f0e:	83 c4 14             	add    $0x14,%esp
  801f11:	0f be 80 4b 48 80 00 	movsbl 0x80484b(%eax),%eax
  801f18:	50                   	push   %eax
  801f19:	ff d6                	call   *%esi
  801f1b:	83 c4 10             	add    $0x10,%esp
	}
}
  801f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    

00801f26 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801f2c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801f30:	8b 10                	mov    (%eax),%edx
  801f32:	3b 50 04             	cmp    0x4(%eax),%edx
  801f35:	73 0a                	jae    801f41 <sprintputch+0x1b>
		*b->buf++ = ch;
  801f37:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f3a:	89 08                	mov    %ecx,(%eax)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	88 02                	mov    %al,(%edx)
}
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    

00801f43 <printfmt>:
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801f49:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801f4c:	50                   	push   %eax
  801f4d:	ff 75 10             	pushl  0x10(%ebp)
  801f50:	ff 75 0c             	pushl  0xc(%ebp)
  801f53:	ff 75 08             	pushl  0x8(%ebp)
  801f56:	e8 05 00 00 00       	call   801f60 <vprintfmt>
}
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <vprintfmt>:
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	57                   	push   %edi
  801f64:	56                   	push   %esi
  801f65:	53                   	push   %ebx
  801f66:	83 ec 3c             	sub    $0x3c,%esp
  801f69:	8b 75 08             	mov    0x8(%ebp),%esi
  801f6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  801f72:	e9 32 04 00 00       	jmp    8023a9 <vprintfmt+0x449>
		padc = ' ';
  801f77:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  801f7b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  801f82:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  801f89:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801f90:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801f97:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  801f9e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801fa3:	8d 47 01             	lea    0x1(%edi),%eax
  801fa6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fa9:	0f b6 17             	movzbl (%edi),%edx
  801fac:	8d 42 dd             	lea    -0x23(%edx),%eax
  801faf:	3c 55                	cmp    $0x55,%al
  801fb1:	0f 87 12 05 00 00    	ja     8024c9 <vprintfmt+0x569>
  801fb7:	0f b6 c0             	movzbl %al,%eax
  801fba:	ff 24 85 20 4a 80 00 	jmp    *0x804a20(,%eax,4)
  801fc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801fc4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  801fc8:	eb d9                	jmp    801fa3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801fca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801fcd:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  801fd1:	eb d0                	jmp    801fa3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801fd3:	0f b6 d2             	movzbl %dl,%edx
  801fd6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	89 75 08             	mov    %esi,0x8(%ebp)
  801fe1:	eb 03                	jmp    801fe6 <vprintfmt+0x86>
  801fe3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801fe6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801fe9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801fed:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801ff0:	8d 72 d0             	lea    -0x30(%edx),%esi
  801ff3:	83 fe 09             	cmp    $0x9,%esi
  801ff6:	76 eb                	jbe    801fe3 <vprintfmt+0x83>
  801ff8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ffb:	8b 75 08             	mov    0x8(%ebp),%esi
  801ffe:	eb 14                	jmp    802014 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  802000:	8b 45 14             	mov    0x14(%ebp),%eax
  802003:	8b 00                	mov    (%eax),%eax
  802005:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802008:	8b 45 14             	mov    0x14(%ebp),%eax
  80200b:	8d 40 04             	lea    0x4(%eax),%eax
  80200e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  802011:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  802014:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802018:	79 89                	jns    801fa3 <vprintfmt+0x43>
				width = precision, precision = -1;
  80201a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80201d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802020:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  802027:	e9 77 ff ff ff       	jmp    801fa3 <vprintfmt+0x43>
  80202c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80202f:	85 c0                	test   %eax,%eax
  802031:	0f 48 c1             	cmovs  %ecx,%eax
  802034:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  802037:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80203a:	e9 64 ff ff ff       	jmp    801fa3 <vprintfmt+0x43>
  80203f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  802042:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  802049:	e9 55 ff ff ff       	jmp    801fa3 <vprintfmt+0x43>
			lflag++;
  80204e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  802052:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  802055:	e9 49 ff ff ff       	jmp    801fa3 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80205a:	8b 45 14             	mov    0x14(%ebp),%eax
  80205d:	8d 78 04             	lea    0x4(%eax),%edi
  802060:	83 ec 08             	sub    $0x8,%esp
  802063:	53                   	push   %ebx
  802064:	ff 30                	pushl  (%eax)
  802066:	ff d6                	call   *%esi
			break;
  802068:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80206b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80206e:	e9 33 03 00 00       	jmp    8023a6 <vprintfmt+0x446>
			err = va_arg(ap, int);
  802073:	8b 45 14             	mov    0x14(%ebp),%eax
  802076:	8d 78 04             	lea    0x4(%eax),%edi
  802079:	8b 00                	mov    (%eax),%eax
  80207b:	99                   	cltd   
  80207c:	31 d0                	xor    %edx,%eax
  80207e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802080:	83 f8 11             	cmp    $0x11,%eax
  802083:	7f 23                	jg     8020a8 <vprintfmt+0x148>
  802085:	8b 14 85 80 4b 80 00 	mov    0x804b80(,%eax,4),%edx
  80208c:	85 d2                	test   %edx,%edx
  80208e:	74 18                	je     8020a8 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  802090:	52                   	push   %edx
  802091:	68 2f 42 80 00       	push   $0x80422f
  802096:	53                   	push   %ebx
  802097:	56                   	push   %esi
  802098:	e8 a6 fe ff ff       	call   801f43 <printfmt>
  80209d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8020a0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8020a3:	e9 fe 02 00 00       	jmp    8023a6 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8020a8:	50                   	push   %eax
  8020a9:	68 63 48 80 00       	push   $0x804863
  8020ae:	53                   	push   %ebx
  8020af:	56                   	push   %esi
  8020b0:	e8 8e fe ff ff       	call   801f43 <printfmt>
  8020b5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8020b8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8020bb:	e9 e6 02 00 00       	jmp    8023a6 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8020c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c3:	83 c0 04             	add    $0x4,%eax
  8020c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8020c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8020cc:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8020ce:	85 c9                	test   %ecx,%ecx
  8020d0:	b8 5c 48 80 00       	mov    $0x80485c,%eax
  8020d5:	0f 45 c1             	cmovne %ecx,%eax
  8020d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8020db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020df:	7e 06                	jle    8020e7 <vprintfmt+0x187>
  8020e1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8020e5:	75 0d                	jne    8020f4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8020e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020ea:	89 c7                	mov    %eax,%edi
  8020ec:	03 45 e0             	add    -0x20(%ebp),%eax
  8020ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8020f2:	eb 53                	jmp    802147 <vprintfmt+0x1e7>
  8020f4:	83 ec 08             	sub    $0x8,%esp
  8020f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8020fa:	50                   	push   %eax
  8020fb:	e8 71 04 00 00       	call   802571 <strnlen>
  802100:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802103:	29 c1                	sub    %eax,%ecx
  802105:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80210d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  802111:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  802114:	eb 0f                	jmp    802125 <vprintfmt+0x1c5>
					putch(padc, putdat);
  802116:	83 ec 08             	sub    $0x8,%esp
  802119:	53                   	push   %ebx
  80211a:	ff 75 e0             	pushl  -0x20(%ebp)
  80211d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80211f:	83 ef 01             	sub    $0x1,%edi
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	85 ff                	test   %edi,%edi
  802127:	7f ed                	jg     802116 <vprintfmt+0x1b6>
  802129:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80212c:	85 c9                	test   %ecx,%ecx
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
  802133:	0f 49 c1             	cmovns %ecx,%eax
  802136:	29 c1                	sub    %eax,%ecx
  802138:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80213b:	eb aa                	jmp    8020e7 <vprintfmt+0x187>
					putch(ch, putdat);
  80213d:	83 ec 08             	sub    $0x8,%esp
  802140:	53                   	push   %ebx
  802141:	52                   	push   %edx
  802142:	ff d6                	call   *%esi
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80214a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80214c:	83 c7 01             	add    $0x1,%edi
  80214f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802153:	0f be d0             	movsbl %al,%edx
  802156:	85 d2                	test   %edx,%edx
  802158:	74 4b                	je     8021a5 <vprintfmt+0x245>
  80215a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80215e:	78 06                	js     802166 <vprintfmt+0x206>
  802160:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  802164:	78 1e                	js     802184 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  802166:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80216a:	74 d1                	je     80213d <vprintfmt+0x1dd>
  80216c:	0f be c0             	movsbl %al,%eax
  80216f:	83 e8 20             	sub    $0x20,%eax
  802172:	83 f8 5e             	cmp    $0x5e,%eax
  802175:	76 c6                	jbe    80213d <vprintfmt+0x1dd>
					putch('?', putdat);
  802177:	83 ec 08             	sub    $0x8,%esp
  80217a:	53                   	push   %ebx
  80217b:	6a 3f                	push   $0x3f
  80217d:	ff d6                	call   *%esi
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	eb c3                	jmp    802147 <vprintfmt+0x1e7>
  802184:	89 cf                	mov    %ecx,%edi
  802186:	eb 0e                	jmp    802196 <vprintfmt+0x236>
				putch(' ', putdat);
  802188:	83 ec 08             	sub    $0x8,%esp
  80218b:	53                   	push   %ebx
  80218c:	6a 20                	push   $0x20
  80218e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  802190:	83 ef 01             	sub    $0x1,%edi
  802193:	83 c4 10             	add    $0x10,%esp
  802196:	85 ff                	test   %edi,%edi
  802198:	7f ee                	jg     802188 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80219a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80219d:	89 45 14             	mov    %eax,0x14(%ebp)
  8021a0:	e9 01 02 00 00       	jmp    8023a6 <vprintfmt+0x446>
  8021a5:	89 cf                	mov    %ecx,%edi
  8021a7:	eb ed                	jmp    802196 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8021a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8021ac:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8021b3:	e9 eb fd ff ff       	jmp    801fa3 <vprintfmt+0x43>
	if (lflag >= 2)
  8021b8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8021bc:	7f 21                	jg     8021df <vprintfmt+0x27f>
	else if (lflag)
  8021be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8021c2:	74 68                	je     80222c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8021c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c7:	8b 00                	mov    (%eax),%eax
  8021c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8021cc:	89 c1                	mov    %eax,%ecx
  8021ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8021d1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8021d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d7:	8d 40 04             	lea    0x4(%eax),%eax
  8021da:	89 45 14             	mov    %eax,0x14(%ebp)
  8021dd:	eb 17                	jmp    8021f6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8021df:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e2:	8b 50 04             	mov    0x4(%eax),%edx
  8021e5:	8b 00                	mov    (%eax),%eax
  8021e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8021ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8021ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f0:	8d 40 08             	lea    0x8(%eax),%eax
  8021f3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8021f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  802202:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802206:	78 3f                	js     802247 <vprintfmt+0x2e7>
			base = 10;
  802208:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80220d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802211:	0f 84 71 01 00 00    	je     802388 <vprintfmt+0x428>
				putch('+', putdat);
  802217:	83 ec 08             	sub    $0x8,%esp
  80221a:	53                   	push   %ebx
  80221b:	6a 2b                	push   $0x2b
  80221d:	ff d6                	call   *%esi
  80221f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  802222:	b8 0a 00 00 00       	mov    $0xa,%eax
  802227:	e9 5c 01 00 00       	jmp    802388 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80222c:	8b 45 14             	mov    0x14(%ebp),%eax
  80222f:	8b 00                	mov    (%eax),%eax
  802231:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802234:	89 c1                	mov    %eax,%ecx
  802236:	c1 f9 1f             	sar    $0x1f,%ecx
  802239:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80223c:	8b 45 14             	mov    0x14(%ebp),%eax
  80223f:	8d 40 04             	lea    0x4(%eax),%eax
  802242:	89 45 14             	mov    %eax,0x14(%ebp)
  802245:	eb af                	jmp    8021f6 <vprintfmt+0x296>
				putch('-', putdat);
  802247:	83 ec 08             	sub    $0x8,%esp
  80224a:	53                   	push   %ebx
  80224b:	6a 2d                	push   $0x2d
  80224d:	ff d6                	call   *%esi
				num = -(long long) num;
  80224f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802252:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802255:	f7 d8                	neg    %eax
  802257:	83 d2 00             	adc    $0x0,%edx
  80225a:	f7 da                	neg    %edx
  80225c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80225f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802262:	83 c4 10             	add    $0x10,%esp
			base = 10;
  802265:	b8 0a 00 00 00       	mov    $0xa,%eax
  80226a:	e9 19 01 00 00       	jmp    802388 <vprintfmt+0x428>
	if (lflag >= 2)
  80226f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  802273:	7f 29                	jg     80229e <vprintfmt+0x33e>
	else if (lflag)
  802275:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802279:	74 44                	je     8022bf <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80227b:	8b 45 14             	mov    0x14(%ebp),%eax
  80227e:	8b 00                	mov    (%eax),%eax
  802280:	ba 00 00 00 00       	mov    $0x0,%edx
  802285:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802288:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80228b:	8b 45 14             	mov    0x14(%ebp),%eax
  80228e:	8d 40 04             	lea    0x4(%eax),%eax
  802291:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802294:	b8 0a 00 00 00       	mov    $0xa,%eax
  802299:	e9 ea 00 00 00       	jmp    802388 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80229e:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a1:	8b 50 04             	mov    0x4(%eax),%edx
  8022a4:	8b 00                	mov    (%eax),%eax
  8022a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8022ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8022af:	8d 40 08             	lea    0x8(%eax),%eax
  8022b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8022b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8022ba:	e9 c9 00 00 00       	jmp    802388 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8022bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c2:	8b 00                	mov    (%eax),%eax
  8022c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8022cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d2:	8d 40 04             	lea    0x4(%eax),%eax
  8022d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8022d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8022dd:	e9 a6 00 00 00       	jmp    802388 <vprintfmt+0x428>
			putch('0', putdat);
  8022e2:	83 ec 08             	sub    $0x8,%esp
  8022e5:	53                   	push   %ebx
  8022e6:	6a 30                	push   $0x30
  8022e8:	ff d6                	call   *%esi
	if (lflag >= 2)
  8022ea:	83 c4 10             	add    $0x10,%esp
  8022ed:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8022f1:	7f 26                	jg     802319 <vprintfmt+0x3b9>
	else if (lflag)
  8022f3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8022f7:	74 3e                	je     802337 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8022f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802303:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802306:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802309:	8b 45 14             	mov    0x14(%ebp),%eax
  80230c:	8d 40 04             	lea    0x4(%eax),%eax
  80230f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802312:	b8 08 00 00 00       	mov    $0x8,%eax
  802317:	eb 6f                	jmp    802388 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  802319:	8b 45 14             	mov    0x14(%ebp),%eax
  80231c:	8b 50 04             	mov    0x4(%eax),%edx
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802324:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802327:	8b 45 14             	mov    0x14(%ebp),%eax
  80232a:	8d 40 08             	lea    0x8(%eax),%eax
  80232d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802330:	b8 08 00 00 00       	mov    $0x8,%eax
  802335:	eb 51                	jmp    802388 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  802337:	8b 45 14             	mov    0x14(%ebp),%eax
  80233a:	8b 00                	mov    (%eax),%eax
  80233c:	ba 00 00 00 00       	mov    $0x0,%edx
  802341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802344:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802347:	8b 45 14             	mov    0x14(%ebp),%eax
  80234a:	8d 40 04             	lea    0x4(%eax),%eax
  80234d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802350:	b8 08 00 00 00       	mov    $0x8,%eax
  802355:	eb 31                	jmp    802388 <vprintfmt+0x428>
			putch('0', putdat);
  802357:	83 ec 08             	sub    $0x8,%esp
  80235a:	53                   	push   %ebx
  80235b:	6a 30                	push   $0x30
  80235d:	ff d6                	call   *%esi
			putch('x', putdat);
  80235f:	83 c4 08             	add    $0x8,%esp
  802362:	53                   	push   %ebx
  802363:	6a 78                	push   $0x78
  802365:	ff d6                	call   *%esi
			num = (unsigned long long)
  802367:	8b 45 14             	mov    0x14(%ebp),%eax
  80236a:	8b 00                	mov    (%eax),%eax
  80236c:	ba 00 00 00 00       	mov    $0x0,%edx
  802371:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802374:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  802377:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80237a:	8b 45 14             	mov    0x14(%ebp),%eax
  80237d:	8d 40 04             	lea    0x4(%eax),%eax
  802380:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802383:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  802388:	83 ec 0c             	sub    $0xc,%esp
  80238b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80238f:	52                   	push   %edx
  802390:	ff 75 e0             	pushl  -0x20(%ebp)
  802393:	50                   	push   %eax
  802394:	ff 75 dc             	pushl  -0x24(%ebp)
  802397:	ff 75 d8             	pushl  -0x28(%ebp)
  80239a:	89 da                	mov    %ebx,%edx
  80239c:	89 f0                	mov    %esi,%eax
  80239e:	e8 a4 fa ff ff       	call   801e47 <printnum>
			break;
  8023a3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8023a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8023a9:	83 c7 01             	add    $0x1,%edi
  8023ac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8023b0:	83 f8 25             	cmp    $0x25,%eax
  8023b3:	0f 84 be fb ff ff    	je     801f77 <vprintfmt+0x17>
			if (ch == '\0')
  8023b9:	85 c0                	test   %eax,%eax
  8023bb:	0f 84 28 01 00 00    	je     8024e9 <vprintfmt+0x589>
			putch(ch, putdat);
  8023c1:	83 ec 08             	sub    $0x8,%esp
  8023c4:	53                   	push   %ebx
  8023c5:	50                   	push   %eax
  8023c6:	ff d6                	call   *%esi
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	eb dc                	jmp    8023a9 <vprintfmt+0x449>
	if (lflag >= 2)
  8023cd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8023d1:	7f 26                	jg     8023f9 <vprintfmt+0x499>
	else if (lflag)
  8023d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8023d7:	74 41                	je     80241a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8023d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8023e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ec:	8d 40 04             	lea    0x4(%eax),%eax
  8023ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8023f2:	b8 10 00 00 00       	mov    $0x10,%eax
  8023f7:	eb 8f                	jmp    802388 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8023f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023fc:	8b 50 04             	mov    0x4(%eax),%edx
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802404:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802407:	8b 45 14             	mov    0x14(%ebp),%eax
  80240a:	8d 40 08             	lea    0x8(%eax),%eax
  80240d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802410:	b8 10 00 00 00       	mov    $0x10,%eax
  802415:	e9 6e ff ff ff       	jmp    802388 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80241a:	8b 45 14             	mov    0x14(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	ba 00 00 00 00       	mov    $0x0,%edx
  802424:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802427:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80242a:	8b 45 14             	mov    0x14(%ebp),%eax
  80242d:	8d 40 04             	lea    0x4(%eax),%eax
  802430:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802433:	b8 10 00 00 00       	mov    $0x10,%eax
  802438:	e9 4b ff ff ff       	jmp    802388 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80243d:	8b 45 14             	mov    0x14(%ebp),%eax
  802440:	83 c0 04             	add    $0x4,%eax
  802443:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802446:	8b 45 14             	mov    0x14(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	85 c0                	test   %eax,%eax
  80244d:	74 14                	je     802463 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80244f:	8b 13                	mov    (%ebx),%edx
  802451:	83 fa 7f             	cmp    $0x7f,%edx
  802454:	7f 37                	jg     80248d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  802456:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  802458:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80245b:	89 45 14             	mov    %eax,0x14(%ebp)
  80245e:	e9 43 ff ff ff       	jmp    8023a6 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  802463:	b8 0a 00 00 00       	mov    $0xa,%eax
  802468:	bf 81 49 80 00       	mov    $0x804981,%edi
							putch(ch, putdat);
  80246d:	83 ec 08             	sub    $0x8,%esp
  802470:	53                   	push   %ebx
  802471:	50                   	push   %eax
  802472:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  802474:	83 c7 01             	add    $0x1,%edi
  802477:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80247b:	83 c4 10             	add    $0x10,%esp
  80247e:	85 c0                	test   %eax,%eax
  802480:	75 eb                	jne    80246d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  802482:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802485:	89 45 14             	mov    %eax,0x14(%ebp)
  802488:	e9 19 ff ff ff       	jmp    8023a6 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80248d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80248f:	b8 0a 00 00 00       	mov    $0xa,%eax
  802494:	bf b9 49 80 00       	mov    $0x8049b9,%edi
							putch(ch, putdat);
  802499:	83 ec 08             	sub    $0x8,%esp
  80249c:	53                   	push   %ebx
  80249d:	50                   	push   %eax
  80249e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8024a0:	83 c7 01             	add    $0x1,%edi
  8024a3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8024a7:	83 c4 10             	add    $0x10,%esp
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	75 eb                	jne    802499 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8024ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8024b4:	e9 ed fe ff ff       	jmp    8023a6 <vprintfmt+0x446>
			putch(ch, putdat);
  8024b9:	83 ec 08             	sub    $0x8,%esp
  8024bc:	53                   	push   %ebx
  8024bd:	6a 25                	push   $0x25
  8024bf:	ff d6                	call   *%esi
			break;
  8024c1:	83 c4 10             	add    $0x10,%esp
  8024c4:	e9 dd fe ff ff       	jmp    8023a6 <vprintfmt+0x446>
			putch('%', putdat);
  8024c9:	83 ec 08             	sub    $0x8,%esp
  8024cc:	53                   	push   %ebx
  8024cd:	6a 25                	push   $0x25
  8024cf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8024d1:	83 c4 10             	add    $0x10,%esp
  8024d4:	89 f8                	mov    %edi,%eax
  8024d6:	eb 03                	jmp    8024db <vprintfmt+0x57b>
  8024d8:	83 e8 01             	sub    $0x1,%eax
  8024db:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8024df:	75 f7                	jne    8024d8 <vprintfmt+0x578>
  8024e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024e4:	e9 bd fe ff ff       	jmp    8023a6 <vprintfmt+0x446>
}
  8024e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    

008024f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 18             	sub    $0x18,%esp
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8024fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802500:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802504:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80250e:	85 c0                	test   %eax,%eax
  802510:	74 26                	je     802538 <vsnprintf+0x47>
  802512:	85 d2                	test   %edx,%edx
  802514:	7e 22                	jle    802538 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802516:	ff 75 14             	pushl  0x14(%ebp)
  802519:	ff 75 10             	pushl  0x10(%ebp)
  80251c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80251f:	50                   	push   %eax
  802520:	68 26 1f 80 00       	push   $0x801f26
  802525:	e8 36 fa ff ff       	call   801f60 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80252a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	83 c4 10             	add    $0x10,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    
		return -E_INVAL;
  802538:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80253d:	eb f7                	jmp    802536 <vsnprintf+0x45>

0080253f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
  802542:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802545:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802548:	50                   	push   %eax
  802549:	ff 75 10             	pushl  0x10(%ebp)
  80254c:	ff 75 0c             	pushl  0xc(%ebp)
  80254f:	ff 75 08             	pushl  0x8(%ebp)
  802552:	e8 9a ff ff ff       	call   8024f1 <vsnprintf>
	va_end(ap);

	return rc;
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80255f:	b8 00 00 00 00       	mov    $0x0,%eax
  802564:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802568:	74 05                	je     80256f <strlen+0x16>
		n++;
  80256a:	83 c0 01             	add    $0x1,%eax
  80256d:	eb f5                	jmp    802564 <strlen+0xb>
	return n;
}
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    

00802571 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802577:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80257a:	ba 00 00 00 00       	mov    $0x0,%edx
  80257f:	39 c2                	cmp    %eax,%edx
  802581:	74 0d                	je     802590 <strnlen+0x1f>
  802583:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  802587:	74 05                	je     80258e <strnlen+0x1d>
		n++;
  802589:	83 c2 01             	add    $0x1,%edx
  80258c:	eb f1                	jmp    80257f <strnlen+0xe>
  80258e:	89 d0                	mov    %edx,%eax
	return n;
}
  802590:	5d                   	pop    %ebp
  802591:	c3                   	ret    

00802592 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	53                   	push   %ebx
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80259c:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8025a5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8025a8:	83 c2 01             	add    $0x1,%edx
  8025ab:	84 c9                	test   %cl,%cl
  8025ad:	75 f2                	jne    8025a1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8025af:	5b                   	pop    %ebx
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    

008025b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
  8025b5:	53                   	push   %ebx
  8025b6:	83 ec 10             	sub    $0x10,%esp
  8025b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8025bc:	53                   	push   %ebx
  8025bd:	e8 97 ff ff ff       	call   802559 <strlen>
  8025c2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8025c5:	ff 75 0c             	pushl  0xc(%ebp)
  8025c8:	01 d8                	add    %ebx,%eax
  8025ca:	50                   	push   %eax
  8025cb:	e8 c2 ff ff ff       	call   802592 <strcpy>
	return dst;
}
  8025d0:	89 d8                	mov    %ebx,%eax
  8025d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
  8025da:	56                   	push   %esi
  8025db:	53                   	push   %ebx
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025e2:	89 c6                	mov    %eax,%esi
  8025e4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8025e7:	89 c2                	mov    %eax,%edx
  8025e9:	39 f2                	cmp    %esi,%edx
  8025eb:	74 11                	je     8025fe <strncpy+0x27>
		*dst++ = *src;
  8025ed:	83 c2 01             	add    $0x1,%edx
  8025f0:	0f b6 19             	movzbl (%ecx),%ebx
  8025f3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8025f6:	80 fb 01             	cmp    $0x1,%bl
  8025f9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8025fc:	eb eb                	jmp    8025e9 <strncpy+0x12>
	}
	return ret;
}
  8025fe:	5b                   	pop    %ebx
  8025ff:	5e                   	pop    %esi
  802600:	5d                   	pop    %ebp
  802601:	c3                   	ret    

00802602 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	56                   	push   %esi
  802606:	53                   	push   %ebx
  802607:	8b 75 08             	mov    0x8(%ebp),%esi
  80260a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80260d:	8b 55 10             	mov    0x10(%ebp),%edx
  802610:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802612:	85 d2                	test   %edx,%edx
  802614:	74 21                	je     802637 <strlcpy+0x35>
  802616:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80261a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80261c:	39 c2                	cmp    %eax,%edx
  80261e:	74 14                	je     802634 <strlcpy+0x32>
  802620:	0f b6 19             	movzbl (%ecx),%ebx
  802623:	84 db                	test   %bl,%bl
  802625:	74 0b                	je     802632 <strlcpy+0x30>
			*dst++ = *src++;
  802627:	83 c1 01             	add    $0x1,%ecx
  80262a:	83 c2 01             	add    $0x1,%edx
  80262d:	88 5a ff             	mov    %bl,-0x1(%edx)
  802630:	eb ea                	jmp    80261c <strlcpy+0x1a>
  802632:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  802634:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802637:	29 f0                	sub    %esi,%eax
}
  802639:	5b                   	pop    %ebx
  80263a:	5e                   	pop    %esi
  80263b:	5d                   	pop    %ebp
  80263c:	c3                   	ret    

0080263d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802643:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802646:	0f b6 01             	movzbl (%ecx),%eax
  802649:	84 c0                	test   %al,%al
  80264b:	74 0c                	je     802659 <strcmp+0x1c>
  80264d:	3a 02                	cmp    (%edx),%al
  80264f:	75 08                	jne    802659 <strcmp+0x1c>
		p++, q++;
  802651:	83 c1 01             	add    $0x1,%ecx
  802654:	83 c2 01             	add    $0x1,%edx
  802657:	eb ed                	jmp    802646 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802659:	0f b6 c0             	movzbl %al,%eax
  80265c:	0f b6 12             	movzbl (%edx),%edx
  80265f:	29 d0                	sub    %edx,%eax
}
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    

00802663 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	53                   	push   %ebx
  802667:	8b 45 08             	mov    0x8(%ebp),%eax
  80266a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266d:	89 c3                	mov    %eax,%ebx
  80266f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802672:	eb 06                	jmp    80267a <strncmp+0x17>
		n--, p++, q++;
  802674:	83 c0 01             	add    $0x1,%eax
  802677:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80267a:	39 d8                	cmp    %ebx,%eax
  80267c:	74 16                	je     802694 <strncmp+0x31>
  80267e:	0f b6 08             	movzbl (%eax),%ecx
  802681:	84 c9                	test   %cl,%cl
  802683:	74 04                	je     802689 <strncmp+0x26>
  802685:	3a 0a                	cmp    (%edx),%cl
  802687:	74 eb                	je     802674 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802689:	0f b6 00             	movzbl (%eax),%eax
  80268c:	0f b6 12             	movzbl (%edx),%edx
  80268f:	29 d0                	sub    %edx,%eax
}
  802691:	5b                   	pop    %ebx
  802692:	5d                   	pop    %ebp
  802693:	c3                   	ret    
		return 0;
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
  802699:	eb f6                	jmp    802691 <strncmp+0x2e>

0080269b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8026a5:	0f b6 10             	movzbl (%eax),%edx
  8026a8:	84 d2                	test   %dl,%dl
  8026aa:	74 09                	je     8026b5 <strchr+0x1a>
		if (*s == c)
  8026ac:	38 ca                	cmp    %cl,%dl
  8026ae:	74 0a                	je     8026ba <strchr+0x1f>
	for (; *s; s++)
  8026b0:	83 c0 01             	add    $0x1,%eax
  8026b3:	eb f0                	jmp    8026a5 <strchr+0xa>
			return (char *) s;
	return 0;
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ba:	5d                   	pop    %ebp
  8026bb:	c3                   	ret    

008026bc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8026c6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8026c9:	38 ca                	cmp    %cl,%dl
  8026cb:	74 09                	je     8026d6 <strfind+0x1a>
  8026cd:	84 d2                	test   %dl,%dl
  8026cf:	74 05                	je     8026d6 <strfind+0x1a>
	for (; *s; s++)
  8026d1:	83 c0 01             	add    $0x1,%eax
  8026d4:	eb f0                	jmp    8026c6 <strfind+0xa>
			break;
	return (char *) s;
}
  8026d6:	5d                   	pop    %ebp
  8026d7:	c3                   	ret    

008026d8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
  8026db:	57                   	push   %edi
  8026dc:	56                   	push   %esi
  8026dd:	53                   	push   %ebx
  8026de:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8026e4:	85 c9                	test   %ecx,%ecx
  8026e6:	74 31                	je     802719 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8026e8:	89 f8                	mov    %edi,%eax
  8026ea:	09 c8                	or     %ecx,%eax
  8026ec:	a8 03                	test   $0x3,%al
  8026ee:	75 23                	jne    802713 <memset+0x3b>
		c &= 0xFF;
  8026f0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8026f4:	89 d3                	mov    %edx,%ebx
  8026f6:	c1 e3 08             	shl    $0x8,%ebx
  8026f9:	89 d0                	mov    %edx,%eax
  8026fb:	c1 e0 18             	shl    $0x18,%eax
  8026fe:	89 d6                	mov    %edx,%esi
  802700:	c1 e6 10             	shl    $0x10,%esi
  802703:	09 f0                	or     %esi,%eax
  802705:	09 c2                	or     %eax,%edx
  802707:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802709:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80270c:	89 d0                	mov    %edx,%eax
  80270e:	fc                   	cld    
  80270f:	f3 ab                	rep stos %eax,%es:(%edi)
  802711:	eb 06                	jmp    802719 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802713:	8b 45 0c             	mov    0xc(%ebp),%eax
  802716:	fc                   	cld    
  802717:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802719:	89 f8                	mov    %edi,%eax
  80271b:	5b                   	pop    %ebx
  80271c:	5e                   	pop    %esi
  80271d:	5f                   	pop    %edi
  80271e:	5d                   	pop    %ebp
  80271f:	c3                   	ret    

00802720 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	57                   	push   %edi
  802724:	56                   	push   %esi
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	8b 75 0c             	mov    0xc(%ebp),%esi
  80272b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80272e:	39 c6                	cmp    %eax,%esi
  802730:	73 32                	jae    802764 <memmove+0x44>
  802732:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802735:	39 c2                	cmp    %eax,%edx
  802737:	76 2b                	jbe    802764 <memmove+0x44>
		s += n;
		d += n;
  802739:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80273c:	89 fe                	mov    %edi,%esi
  80273e:	09 ce                	or     %ecx,%esi
  802740:	09 d6                	or     %edx,%esi
  802742:	f7 c6 03 00 00 00    	test   $0x3,%esi
  802748:	75 0e                	jne    802758 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80274a:	83 ef 04             	sub    $0x4,%edi
  80274d:	8d 72 fc             	lea    -0x4(%edx),%esi
  802750:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  802753:	fd                   	std    
  802754:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802756:	eb 09                	jmp    802761 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802758:	83 ef 01             	sub    $0x1,%edi
  80275b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80275e:	fd                   	std    
  80275f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802761:	fc                   	cld    
  802762:	eb 1a                	jmp    80277e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802764:	89 c2                	mov    %eax,%edx
  802766:	09 ca                	or     %ecx,%edx
  802768:	09 f2                	or     %esi,%edx
  80276a:	f6 c2 03             	test   $0x3,%dl
  80276d:	75 0a                	jne    802779 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80276f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802772:	89 c7                	mov    %eax,%edi
  802774:	fc                   	cld    
  802775:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802777:	eb 05                	jmp    80277e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  802779:	89 c7                	mov    %eax,%edi
  80277b:	fc                   	cld    
  80277c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80277e:	5e                   	pop    %esi
  80277f:	5f                   	pop    %edi
  802780:	5d                   	pop    %ebp
  802781:	c3                   	ret    

00802782 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802788:	ff 75 10             	pushl  0x10(%ebp)
  80278b:	ff 75 0c             	pushl  0xc(%ebp)
  80278e:	ff 75 08             	pushl  0x8(%ebp)
  802791:	e8 8a ff ff ff       	call   802720 <memmove>
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	56                   	push   %esi
  80279c:	53                   	push   %ebx
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a3:	89 c6                	mov    %eax,%esi
  8027a5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8027a8:	39 f0                	cmp    %esi,%eax
  8027aa:	74 1c                	je     8027c8 <memcmp+0x30>
		if (*s1 != *s2)
  8027ac:	0f b6 08             	movzbl (%eax),%ecx
  8027af:	0f b6 1a             	movzbl (%edx),%ebx
  8027b2:	38 d9                	cmp    %bl,%cl
  8027b4:	75 08                	jne    8027be <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8027b6:	83 c0 01             	add    $0x1,%eax
  8027b9:	83 c2 01             	add    $0x1,%edx
  8027bc:	eb ea                	jmp    8027a8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8027be:	0f b6 c1             	movzbl %cl,%eax
  8027c1:	0f b6 db             	movzbl %bl,%ebx
  8027c4:	29 d8                	sub    %ebx,%eax
  8027c6:	eb 05                	jmp    8027cd <memcmp+0x35>
	}

	return 0;
  8027c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027cd:	5b                   	pop    %ebx
  8027ce:	5e                   	pop    %esi
  8027cf:	5d                   	pop    %ebp
  8027d0:	c3                   	ret    

008027d1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8027d1:	55                   	push   %ebp
  8027d2:	89 e5                	mov    %esp,%ebp
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8027da:	89 c2                	mov    %eax,%edx
  8027dc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8027df:	39 d0                	cmp    %edx,%eax
  8027e1:	73 09                	jae    8027ec <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8027e3:	38 08                	cmp    %cl,(%eax)
  8027e5:	74 05                	je     8027ec <memfind+0x1b>
	for (; s < ends; s++)
  8027e7:	83 c0 01             	add    $0x1,%eax
  8027ea:	eb f3                	jmp    8027df <memfind+0xe>
			break;
	return (void *) s;
}
  8027ec:	5d                   	pop    %ebp
  8027ed:	c3                   	ret    

008027ee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	57                   	push   %edi
  8027f2:	56                   	push   %esi
  8027f3:	53                   	push   %ebx
  8027f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027fa:	eb 03                	jmp    8027ff <strtol+0x11>
		s++;
  8027fc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8027ff:	0f b6 01             	movzbl (%ecx),%eax
  802802:	3c 20                	cmp    $0x20,%al
  802804:	74 f6                	je     8027fc <strtol+0xe>
  802806:	3c 09                	cmp    $0x9,%al
  802808:	74 f2                	je     8027fc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80280a:	3c 2b                	cmp    $0x2b,%al
  80280c:	74 2a                	je     802838 <strtol+0x4a>
	int neg = 0;
  80280e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  802813:	3c 2d                	cmp    $0x2d,%al
  802815:	74 2b                	je     802842 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802817:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80281d:	75 0f                	jne    80282e <strtol+0x40>
  80281f:	80 39 30             	cmpb   $0x30,(%ecx)
  802822:	74 28                	je     80284c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802824:	85 db                	test   %ebx,%ebx
  802826:	b8 0a 00 00 00       	mov    $0xa,%eax
  80282b:	0f 44 d8             	cmove  %eax,%ebx
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
  802833:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802836:	eb 50                	jmp    802888 <strtol+0x9a>
		s++;
  802838:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80283b:	bf 00 00 00 00       	mov    $0x0,%edi
  802840:	eb d5                	jmp    802817 <strtol+0x29>
		s++, neg = 1;
  802842:	83 c1 01             	add    $0x1,%ecx
  802845:	bf 01 00 00 00       	mov    $0x1,%edi
  80284a:	eb cb                	jmp    802817 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80284c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802850:	74 0e                	je     802860 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  802852:	85 db                	test   %ebx,%ebx
  802854:	75 d8                	jne    80282e <strtol+0x40>
		s++, base = 8;
  802856:	83 c1 01             	add    $0x1,%ecx
  802859:	bb 08 00 00 00       	mov    $0x8,%ebx
  80285e:	eb ce                	jmp    80282e <strtol+0x40>
		s += 2, base = 16;
  802860:	83 c1 02             	add    $0x2,%ecx
  802863:	bb 10 00 00 00       	mov    $0x10,%ebx
  802868:	eb c4                	jmp    80282e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80286a:	8d 72 9f             	lea    -0x61(%edx),%esi
  80286d:	89 f3                	mov    %esi,%ebx
  80286f:	80 fb 19             	cmp    $0x19,%bl
  802872:	77 29                	ja     80289d <strtol+0xaf>
			dig = *s - 'a' + 10;
  802874:	0f be d2             	movsbl %dl,%edx
  802877:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80287a:	3b 55 10             	cmp    0x10(%ebp),%edx
  80287d:	7d 30                	jge    8028af <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80287f:	83 c1 01             	add    $0x1,%ecx
  802882:	0f af 45 10          	imul   0x10(%ebp),%eax
  802886:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802888:	0f b6 11             	movzbl (%ecx),%edx
  80288b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80288e:	89 f3                	mov    %esi,%ebx
  802890:	80 fb 09             	cmp    $0x9,%bl
  802893:	77 d5                	ja     80286a <strtol+0x7c>
			dig = *s - '0';
  802895:	0f be d2             	movsbl %dl,%edx
  802898:	83 ea 30             	sub    $0x30,%edx
  80289b:	eb dd                	jmp    80287a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80289d:	8d 72 bf             	lea    -0x41(%edx),%esi
  8028a0:	89 f3                	mov    %esi,%ebx
  8028a2:	80 fb 19             	cmp    $0x19,%bl
  8028a5:	77 08                	ja     8028af <strtol+0xc1>
			dig = *s - 'A' + 10;
  8028a7:	0f be d2             	movsbl %dl,%edx
  8028aa:	83 ea 37             	sub    $0x37,%edx
  8028ad:	eb cb                	jmp    80287a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8028af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028b3:	74 05                	je     8028ba <strtol+0xcc>
		*endptr = (char *) s;
  8028b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028b8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8028ba:	89 c2                	mov    %eax,%edx
  8028bc:	f7 da                	neg    %edx
  8028be:	85 ff                	test   %edi,%edi
  8028c0:	0f 45 c2             	cmovne %edx,%eax
}
  8028c3:	5b                   	pop    %ebx
  8028c4:	5e                   	pop    %esi
  8028c5:	5f                   	pop    %edi
  8028c6:	5d                   	pop    %ebp
  8028c7:	c3                   	ret    

008028c8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8028c8:	55                   	push   %ebp
  8028c9:	89 e5                	mov    %esp,%ebp
  8028cb:	57                   	push   %edi
  8028cc:	56                   	push   %esi
  8028cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028d9:	89 c3                	mov    %eax,%ebx
  8028db:	89 c7                	mov    %eax,%edi
  8028dd:	89 c6                	mov    %eax,%esi
  8028df:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8028e1:	5b                   	pop    %ebx
  8028e2:	5e                   	pop    %esi
  8028e3:	5f                   	pop    %edi
  8028e4:	5d                   	pop    %ebp
  8028e5:	c3                   	ret    

008028e6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
  8028e9:	57                   	push   %edi
  8028ea:	56                   	push   %esi
  8028eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f6:	89 d1                	mov    %edx,%ecx
  8028f8:	89 d3                	mov    %edx,%ebx
  8028fa:	89 d7                	mov    %edx,%edi
  8028fc:	89 d6                	mov    %edx,%esi
  8028fe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802900:	5b                   	pop    %ebx
  802901:	5e                   	pop    %esi
  802902:	5f                   	pop    %edi
  802903:	5d                   	pop    %ebp
  802904:	c3                   	ret    

00802905 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
  802908:	57                   	push   %edi
  802909:	56                   	push   %esi
  80290a:	53                   	push   %ebx
  80290b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80290e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802913:	8b 55 08             	mov    0x8(%ebp),%edx
  802916:	b8 03 00 00 00       	mov    $0x3,%eax
  80291b:	89 cb                	mov    %ecx,%ebx
  80291d:	89 cf                	mov    %ecx,%edi
  80291f:	89 ce                	mov    %ecx,%esi
  802921:	cd 30                	int    $0x30
	if(check && ret > 0)
  802923:	85 c0                	test   %eax,%eax
  802925:	7f 08                	jg     80292f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  802927:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80292a:	5b                   	pop    %ebx
  80292b:	5e                   	pop    %esi
  80292c:	5f                   	pop    %edi
  80292d:	5d                   	pop    %ebp
  80292e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80292f:	83 ec 0c             	sub    $0xc,%esp
  802932:	50                   	push   %eax
  802933:	6a 03                	push   $0x3
  802935:	68 c8 4b 80 00       	push   $0x804bc8
  80293a:	6a 43                	push   $0x43
  80293c:	68 e5 4b 80 00       	push   $0x804be5
  802941:	e8 f7 f3 ff ff       	call   801d3d <_panic>

00802946 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	57                   	push   %edi
  80294a:	56                   	push   %esi
  80294b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80294c:	ba 00 00 00 00       	mov    $0x0,%edx
  802951:	b8 02 00 00 00       	mov    $0x2,%eax
  802956:	89 d1                	mov    %edx,%ecx
  802958:	89 d3                	mov    %edx,%ebx
  80295a:	89 d7                	mov    %edx,%edi
  80295c:	89 d6                	mov    %edx,%esi
  80295e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  802960:	5b                   	pop    %ebx
  802961:	5e                   	pop    %esi
  802962:	5f                   	pop    %edi
  802963:	5d                   	pop    %ebp
  802964:	c3                   	ret    

00802965 <sys_yield>:

void
sys_yield(void)
{
  802965:	55                   	push   %ebp
  802966:	89 e5                	mov    %esp,%ebp
  802968:	57                   	push   %edi
  802969:	56                   	push   %esi
  80296a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80296b:	ba 00 00 00 00       	mov    $0x0,%edx
  802970:	b8 0b 00 00 00       	mov    $0xb,%eax
  802975:	89 d1                	mov    %edx,%ecx
  802977:	89 d3                	mov    %edx,%ebx
  802979:	89 d7                	mov    %edx,%edi
  80297b:	89 d6                	mov    %edx,%esi
  80297d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80297f:	5b                   	pop    %ebx
  802980:	5e                   	pop    %esi
  802981:	5f                   	pop    %edi
  802982:	5d                   	pop    %ebp
  802983:	c3                   	ret    

00802984 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
  802987:	57                   	push   %edi
  802988:	56                   	push   %esi
  802989:	53                   	push   %ebx
  80298a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80298d:	be 00 00 00 00       	mov    $0x0,%esi
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802998:	b8 04 00 00 00       	mov    $0x4,%eax
  80299d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029a0:	89 f7                	mov    %esi,%edi
  8029a2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	7f 08                	jg     8029b0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8029a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ab:	5b                   	pop    %ebx
  8029ac:	5e                   	pop    %esi
  8029ad:	5f                   	pop    %edi
  8029ae:	5d                   	pop    %ebp
  8029af:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8029b0:	83 ec 0c             	sub    $0xc,%esp
  8029b3:	50                   	push   %eax
  8029b4:	6a 04                	push   $0x4
  8029b6:	68 c8 4b 80 00       	push   $0x804bc8
  8029bb:	6a 43                	push   $0x43
  8029bd:	68 e5 4b 80 00       	push   $0x804be5
  8029c2:	e8 76 f3 ff ff       	call   801d3d <_panic>

008029c7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	57                   	push   %edi
  8029cb:	56                   	push   %esi
  8029cc:	53                   	push   %ebx
  8029cd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8029d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029d6:	b8 05 00 00 00       	mov    $0x5,%eax
  8029db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8029e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8029e4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	7f 08                	jg     8029f2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8029ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ed:	5b                   	pop    %ebx
  8029ee:	5e                   	pop    %esi
  8029ef:	5f                   	pop    %edi
  8029f0:	5d                   	pop    %ebp
  8029f1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8029f2:	83 ec 0c             	sub    $0xc,%esp
  8029f5:	50                   	push   %eax
  8029f6:	6a 05                	push   $0x5
  8029f8:	68 c8 4b 80 00       	push   $0x804bc8
  8029fd:	6a 43                	push   $0x43
  8029ff:	68 e5 4b 80 00       	push   $0x804be5
  802a04:	e8 34 f3 ff ff       	call   801d3d <_panic>

00802a09 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802a09:	55                   	push   %ebp
  802a0a:	89 e5                	mov    %esp,%ebp
  802a0c:	57                   	push   %edi
  802a0d:	56                   	push   %esi
  802a0e:	53                   	push   %ebx
  802a0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a12:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a17:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a1d:	b8 06 00 00 00       	mov    $0x6,%eax
  802a22:	89 df                	mov    %ebx,%edi
  802a24:	89 de                	mov    %ebx,%esi
  802a26:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	7f 08                	jg     802a34 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a2f:	5b                   	pop    %ebx
  802a30:	5e                   	pop    %esi
  802a31:	5f                   	pop    %edi
  802a32:	5d                   	pop    %ebp
  802a33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802a34:	83 ec 0c             	sub    $0xc,%esp
  802a37:	50                   	push   %eax
  802a38:	6a 06                	push   $0x6
  802a3a:	68 c8 4b 80 00       	push   $0x804bc8
  802a3f:	6a 43                	push   $0x43
  802a41:	68 e5 4b 80 00       	push   $0x804be5
  802a46:	e8 f2 f2 ff ff       	call   801d3d <_panic>

00802a4b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	57                   	push   %edi
  802a4f:	56                   	push   %esi
  802a50:	53                   	push   %ebx
  802a51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a54:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a59:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a5f:	b8 08 00 00 00       	mov    $0x8,%eax
  802a64:	89 df                	mov    %ebx,%edi
  802a66:	89 de                	mov    %ebx,%esi
  802a68:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	7f 08                	jg     802a76 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a71:	5b                   	pop    %ebx
  802a72:	5e                   	pop    %esi
  802a73:	5f                   	pop    %edi
  802a74:	5d                   	pop    %ebp
  802a75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802a76:	83 ec 0c             	sub    $0xc,%esp
  802a79:	50                   	push   %eax
  802a7a:	6a 08                	push   $0x8
  802a7c:	68 c8 4b 80 00       	push   $0x804bc8
  802a81:	6a 43                	push   $0x43
  802a83:	68 e5 4b 80 00       	push   $0x804be5
  802a88:	e8 b0 f2 ff ff       	call   801d3d <_panic>

00802a8d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
  802a90:	57                   	push   %edi
  802a91:	56                   	push   %esi
  802a92:	53                   	push   %ebx
  802a93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a96:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802aa1:	b8 09 00 00 00       	mov    $0x9,%eax
  802aa6:	89 df                	mov    %ebx,%edi
  802aa8:	89 de                	mov    %ebx,%esi
  802aaa:	cd 30                	int    $0x30
	if(check && ret > 0)
  802aac:	85 c0                	test   %eax,%eax
  802aae:	7f 08                	jg     802ab8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ab3:	5b                   	pop    %ebx
  802ab4:	5e                   	pop    %esi
  802ab5:	5f                   	pop    %edi
  802ab6:	5d                   	pop    %ebp
  802ab7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802ab8:	83 ec 0c             	sub    $0xc,%esp
  802abb:	50                   	push   %eax
  802abc:	6a 09                	push   $0x9
  802abe:	68 c8 4b 80 00       	push   $0x804bc8
  802ac3:	6a 43                	push   $0x43
  802ac5:	68 e5 4b 80 00       	push   $0x804be5
  802aca:	e8 6e f2 ff ff       	call   801d3d <_panic>

00802acf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802acf:	55                   	push   %ebp
  802ad0:	89 e5                	mov    %esp,%ebp
  802ad2:	57                   	push   %edi
  802ad3:	56                   	push   %esi
  802ad4:	53                   	push   %ebx
  802ad5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802ad8:	bb 00 00 00 00       	mov    $0x0,%ebx
  802add:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ae3:	b8 0a 00 00 00       	mov    $0xa,%eax
  802ae8:	89 df                	mov    %ebx,%edi
  802aea:	89 de                	mov    %ebx,%esi
  802aec:	cd 30                	int    $0x30
	if(check && ret > 0)
  802aee:	85 c0                	test   %eax,%eax
  802af0:	7f 08                	jg     802afa <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802af2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802af5:	5b                   	pop    %ebx
  802af6:	5e                   	pop    %esi
  802af7:	5f                   	pop    %edi
  802af8:	5d                   	pop    %ebp
  802af9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802afa:	83 ec 0c             	sub    $0xc,%esp
  802afd:	50                   	push   %eax
  802afe:	6a 0a                	push   $0xa
  802b00:	68 c8 4b 80 00       	push   $0x804bc8
  802b05:	6a 43                	push   $0x43
  802b07:	68 e5 4b 80 00       	push   $0x804be5
  802b0c:	e8 2c f2 ff ff       	call   801d3d <_panic>

00802b11 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802b11:	55                   	push   %ebp
  802b12:	89 e5                	mov    %esp,%ebp
  802b14:	57                   	push   %edi
  802b15:	56                   	push   %esi
  802b16:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b17:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b1d:	b8 0c 00 00 00       	mov    $0xc,%eax
  802b22:	be 00 00 00 00       	mov    $0x0,%esi
  802b27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b2a:	8b 7d 14             	mov    0x14(%ebp),%edi
  802b2d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802b2f:	5b                   	pop    %ebx
  802b30:	5e                   	pop    %esi
  802b31:	5f                   	pop    %edi
  802b32:	5d                   	pop    %ebp
  802b33:	c3                   	ret    

00802b34 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802b34:	55                   	push   %ebp
  802b35:	89 e5                	mov    %esp,%ebp
  802b37:	57                   	push   %edi
  802b38:	56                   	push   %esi
  802b39:	53                   	push   %ebx
  802b3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802b3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b42:	8b 55 08             	mov    0x8(%ebp),%edx
  802b45:	b8 0d 00 00 00       	mov    $0xd,%eax
  802b4a:	89 cb                	mov    %ecx,%ebx
  802b4c:	89 cf                	mov    %ecx,%edi
  802b4e:	89 ce                	mov    %ecx,%esi
  802b50:	cd 30                	int    $0x30
	if(check && ret > 0)
  802b52:	85 c0                	test   %eax,%eax
  802b54:	7f 08                	jg     802b5e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802b56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b59:	5b                   	pop    %ebx
  802b5a:	5e                   	pop    %esi
  802b5b:	5f                   	pop    %edi
  802b5c:	5d                   	pop    %ebp
  802b5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802b5e:	83 ec 0c             	sub    $0xc,%esp
  802b61:	50                   	push   %eax
  802b62:	6a 0d                	push   $0xd
  802b64:	68 c8 4b 80 00       	push   $0x804bc8
  802b69:	6a 43                	push   $0x43
  802b6b:	68 e5 4b 80 00       	push   $0x804be5
  802b70:	e8 c8 f1 ff ff       	call   801d3d <_panic>

00802b75 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  802b75:	55                   	push   %ebp
  802b76:	89 e5                	mov    %esp,%ebp
  802b78:	57                   	push   %edi
  802b79:	56                   	push   %esi
  802b7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b80:	8b 55 08             	mov    0x8(%ebp),%edx
  802b83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b86:	b8 0e 00 00 00       	mov    $0xe,%eax
  802b8b:	89 df                	mov    %ebx,%edi
  802b8d:	89 de                	mov    %ebx,%esi
  802b8f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  802b91:	5b                   	pop    %ebx
  802b92:	5e                   	pop    %esi
  802b93:	5f                   	pop    %edi
  802b94:	5d                   	pop    %ebp
  802b95:	c3                   	ret    

00802b96 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  802b96:	55                   	push   %ebp
  802b97:	89 e5                	mov    %esp,%ebp
  802b99:	57                   	push   %edi
  802b9a:	56                   	push   %esi
  802b9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba4:	b8 0f 00 00 00       	mov    $0xf,%eax
  802ba9:	89 cb                	mov    %ecx,%ebx
  802bab:	89 cf                	mov    %ecx,%edi
  802bad:	89 ce                	mov    %ecx,%esi
  802baf:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  802bb1:	5b                   	pop    %ebx
  802bb2:	5e                   	pop    %esi
  802bb3:	5f                   	pop    %edi
  802bb4:	5d                   	pop    %ebp
  802bb5:	c3                   	ret    

00802bb6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	57                   	push   %edi
  802bba:	56                   	push   %esi
  802bbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  802bbc:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc1:	b8 10 00 00 00       	mov    $0x10,%eax
  802bc6:	89 d1                	mov    %edx,%ecx
  802bc8:	89 d3                	mov    %edx,%ebx
  802bca:	89 d7                	mov    %edx,%edi
  802bcc:	89 d6                	mov    %edx,%esi
  802bce:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802bd0:	5b                   	pop    %ebx
  802bd1:	5e                   	pop    %esi
  802bd2:	5f                   	pop    %edi
  802bd3:	5d                   	pop    %ebp
  802bd4:	c3                   	ret    

00802bd5 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  802bd5:	55                   	push   %ebp
  802bd6:	89 e5                	mov    %esp,%ebp
  802bd8:	57                   	push   %edi
  802bd9:	56                   	push   %esi
  802bda:	53                   	push   %ebx
	asm volatile("int %1\n"
  802bdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802be0:	8b 55 08             	mov    0x8(%ebp),%edx
  802be3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802be6:	b8 11 00 00 00       	mov    $0x11,%eax
  802beb:	89 df                	mov    %ebx,%edi
  802bed:	89 de                	mov    %ebx,%esi
  802bef:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  802bf1:	5b                   	pop    %ebx
  802bf2:	5e                   	pop    %esi
  802bf3:	5f                   	pop    %edi
  802bf4:	5d                   	pop    %ebp
  802bf5:	c3                   	ret    

00802bf6 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  802bf6:	55                   	push   %ebp
  802bf7:	89 e5                	mov    %esp,%ebp
  802bf9:	57                   	push   %edi
  802bfa:	56                   	push   %esi
  802bfb:	53                   	push   %ebx
	asm volatile("int %1\n"
  802bfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c01:	8b 55 08             	mov    0x8(%ebp),%edx
  802c04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c07:	b8 12 00 00 00       	mov    $0x12,%eax
  802c0c:	89 df                	mov    %ebx,%edi
  802c0e:	89 de                	mov    %ebx,%esi
  802c10:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  802c12:	5b                   	pop    %ebx
  802c13:	5e                   	pop    %esi
  802c14:	5f                   	pop    %edi
  802c15:	5d                   	pop    %ebp
  802c16:	c3                   	ret    

00802c17 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
  802c1a:	57                   	push   %edi
  802c1b:	56                   	push   %esi
  802c1c:	53                   	push   %ebx
  802c1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802c20:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c25:	8b 55 08             	mov    0x8(%ebp),%edx
  802c28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c2b:	b8 13 00 00 00       	mov    $0x13,%eax
  802c30:	89 df                	mov    %ebx,%edi
  802c32:	89 de                	mov    %ebx,%esi
  802c34:	cd 30                	int    $0x30
	if(check && ret > 0)
  802c36:	85 c0                	test   %eax,%eax
  802c38:	7f 08                	jg     802c42 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c3d:	5b                   	pop    %ebx
  802c3e:	5e                   	pop    %esi
  802c3f:	5f                   	pop    %edi
  802c40:	5d                   	pop    %ebp
  802c41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802c42:	83 ec 0c             	sub    $0xc,%esp
  802c45:	50                   	push   %eax
  802c46:	6a 13                	push   $0x13
  802c48:	68 c8 4b 80 00       	push   $0x804bc8
  802c4d:	6a 43                	push   $0x43
  802c4f:	68 e5 4b 80 00       	push   $0x804be5
  802c54:	e8 e4 f0 ff ff       	call   801d3d <_panic>

00802c59 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802c59:	55                   	push   %ebp
  802c5a:	89 e5                	mov    %esp,%ebp
  802c5c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802c5f:	83 3d 54 a0 80 00 00 	cmpl   $0x0,0x80a054
  802c66:	74 0a                	je     802c72 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	a3 54 a0 80 00       	mov    %eax,0x80a054
}
  802c70:	c9                   	leave  
  802c71:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802c72:	83 ec 04             	sub    $0x4,%esp
  802c75:	6a 07                	push   $0x7
  802c77:	68 00 f0 bf ee       	push   $0xeebff000
  802c7c:	6a 00                	push   $0x0
  802c7e:	e8 01 fd ff ff       	call   802984 <sys_page_alloc>
		if(r < 0)
  802c83:	83 c4 10             	add    $0x10,%esp
  802c86:	85 c0                	test   %eax,%eax
  802c88:	78 2a                	js     802cb4 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802c8a:	83 ec 08             	sub    $0x8,%esp
  802c8d:	68 c8 2c 80 00       	push   $0x802cc8
  802c92:	6a 00                	push   $0x0
  802c94:	e8 36 fe ff ff       	call   802acf <sys_env_set_pgfault_upcall>
		if(r < 0)
  802c99:	83 c4 10             	add    $0x10,%esp
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	79 c8                	jns    802c68 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	68 24 4c 80 00       	push   $0x804c24
  802ca8:	6a 25                	push   $0x25
  802caa:	68 5d 4c 80 00       	push   $0x804c5d
  802caf:	e8 89 f0 ff ff       	call   801d3d <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 f4 4b 80 00       	push   $0x804bf4
  802cbc:	6a 22                	push   $0x22
  802cbe:	68 5d 4c 80 00       	push   $0x804c5d
  802cc3:	e8 75 f0 ff ff       	call   801d3d <_panic>

00802cc8 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802cc8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802cc9:	a1 54 a0 80 00       	mov    0x80a054,%eax
	call *%eax
  802cce:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802cd0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802cd3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802cd7:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802cdb:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802cde:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802ce0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802ce4:	83 c4 08             	add    $0x8,%esp
	popal
  802ce7:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802ce8:	83 c4 04             	add    $0x4,%esp
	popfl
  802ceb:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802cec:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ced:	c3                   	ret    

00802cee <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802cee:	55                   	push   %ebp
  802cef:	89 e5                	mov    %esp,%ebp
  802cf1:	56                   	push   %esi
  802cf2:	53                   	push   %ebx
  802cf3:	8b 75 08             	mov    0x8(%ebp),%esi
  802cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802cfc:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802cfe:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802d03:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802d06:	83 ec 0c             	sub    $0xc,%esp
  802d09:	50                   	push   %eax
  802d0a:	e8 25 fe ff ff       	call   802b34 <sys_ipc_recv>
	if(ret < 0){
  802d0f:	83 c4 10             	add    $0x10,%esp
  802d12:	85 c0                	test   %eax,%eax
  802d14:	78 2b                	js     802d41 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802d16:	85 f6                	test   %esi,%esi
  802d18:	74 0a                	je     802d24 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802d1a:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802d1f:	8b 40 74             	mov    0x74(%eax),%eax
  802d22:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802d24:	85 db                	test   %ebx,%ebx
  802d26:	74 0a                	je     802d32 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802d28:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802d2d:	8b 40 78             	mov    0x78(%eax),%eax
  802d30:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802d32:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802d37:	8b 40 70             	mov    0x70(%eax),%eax
}
  802d3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d3d:	5b                   	pop    %ebx
  802d3e:	5e                   	pop    %esi
  802d3f:	5d                   	pop    %ebp
  802d40:	c3                   	ret    
		if(from_env_store)
  802d41:	85 f6                	test   %esi,%esi
  802d43:	74 06                	je     802d4b <ipc_recv+0x5d>
			*from_env_store = 0;
  802d45:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802d4b:	85 db                	test   %ebx,%ebx
  802d4d:	74 eb                	je     802d3a <ipc_recv+0x4c>
			*perm_store = 0;
  802d4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802d55:	eb e3                	jmp    802d3a <ipc_recv+0x4c>

00802d57 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802d57:	55                   	push   %ebp
  802d58:	89 e5                	mov    %esp,%ebp
  802d5a:	57                   	push   %edi
  802d5b:	56                   	push   %esi
  802d5c:	53                   	push   %ebx
  802d5d:	83 ec 0c             	sub    $0xc,%esp
  802d60:	8b 7d 08             	mov    0x8(%ebp),%edi
  802d63:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802d69:	85 db                	test   %ebx,%ebx
  802d6b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802d70:	0f 44 d8             	cmove  %eax,%ebx
  802d73:	eb 05                	jmp    802d7a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802d75:	e8 eb fb ff ff       	call   802965 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802d7a:	ff 75 14             	pushl  0x14(%ebp)
  802d7d:	53                   	push   %ebx
  802d7e:	56                   	push   %esi
  802d7f:	57                   	push   %edi
  802d80:	e8 8c fd ff ff       	call   802b11 <sys_ipc_try_send>
  802d85:	83 c4 10             	add    $0x10,%esp
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	74 1b                	je     802da7 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802d8c:	79 e7                	jns    802d75 <ipc_send+0x1e>
  802d8e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d91:	74 e2                	je     802d75 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	68 6b 4c 80 00       	push   $0x804c6b
  802d9b:	6a 46                	push   $0x46
  802d9d:	68 80 4c 80 00       	push   $0x804c80
  802da2:	e8 96 ef ff ff       	call   801d3d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802daa:	5b                   	pop    %ebx
  802dab:	5e                   	pop    %esi
  802dac:	5f                   	pop    %edi
  802dad:	5d                   	pop    %ebp
  802dae:	c3                   	ret    

00802daf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802daf:	55                   	push   %ebp
  802db0:	89 e5                	mov    %esp,%ebp
  802db2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802db5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802dba:	89 c2                	mov    %eax,%edx
  802dbc:	c1 e2 07             	shl    $0x7,%edx
  802dbf:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802dc5:	8b 52 50             	mov    0x50(%edx),%edx
  802dc8:	39 ca                	cmp    %ecx,%edx
  802dca:	74 11                	je     802ddd <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802dcc:	83 c0 01             	add    $0x1,%eax
  802dcf:	3d 00 04 00 00       	cmp    $0x400,%eax
  802dd4:	75 e4                	jne    802dba <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddb:	eb 0b                	jmp    802de8 <ipc_find_env+0x39>
			return envs[i].env_id;
  802ddd:	c1 e0 07             	shl    $0x7,%eax
  802de0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802de5:	8b 40 48             	mov    0x48(%eax),%eax
}
  802de8:	5d                   	pop    %ebp
  802de9:	c3                   	ret    

00802dea <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802dea:	55                   	push   %ebp
  802deb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	05 00 00 00 30       	add    $0x30000000,%eax
  802df5:	c1 e8 0c             	shr    $0xc,%eax
}
  802df8:	5d                   	pop    %ebp
  802df9:	c3                   	ret    

00802dfa <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802e05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e0a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802e0f:	5d                   	pop    %ebp
  802e10:	c3                   	ret    

00802e11 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802e11:	55                   	push   %ebp
  802e12:	89 e5                	mov    %esp,%ebp
  802e14:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802e19:	89 c2                	mov    %eax,%edx
  802e1b:	c1 ea 16             	shr    $0x16,%edx
  802e1e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802e25:	f6 c2 01             	test   $0x1,%dl
  802e28:	74 2d                	je     802e57 <fd_alloc+0x46>
  802e2a:	89 c2                	mov    %eax,%edx
  802e2c:	c1 ea 0c             	shr    $0xc,%edx
  802e2f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e36:	f6 c2 01             	test   $0x1,%dl
  802e39:	74 1c                	je     802e57 <fd_alloc+0x46>
  802e3b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802e40:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802e45:	75 d2                	jne    802e19 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802e50:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802e55:	eb 0a                	jmp    802e61 <fd_alloc+0x50>
			*fd_store = fd;
  802e57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e5a:	89 01                	mov    %eax,(%ecx)
			return 0;
  802e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e61:	5d                   	pop    %ebp
  802e62:	c3                   	ret    

00802e63 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802e63:	55                   	push   %ebp
  802e64:	89 e5                	mov    %esp,%ebp
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802e69:	83 f8 1f             	cmp    $0x1f,%eax
  802e6c:	77 30                	ja     802e9e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802e6e:	c1 e0 0c             	shl    $0xc,%eax
  802e71:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802e76:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802e7c:	f6 c2 01             	test   $0x1,%dl
  802e7f:	74 24                	je     802ea5 <fd_lookup+0x42>
  802e81:	89 c2                	mov    %eax,%edx
  802e83:	c1 ea 0c             	shr    $0xc,%edx
  802e86:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e8d:	f6 c2 01             	test   $0x1,%dl
  802e90:	74 1a                	je     802eac <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e95:	89 02                	mov    %eax,(%edx)
	return 0;
  802e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e9c:	5d                   	pop    %ebp
  802e9d:	c3                   	ret    
		return -E_INVAL;
  802e9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ea3:	eb f7                	jmp    802e9c <fd_lookup+0x39>
		return -E_INVAL;
  802ea5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802eaa:	eb f0                	jmp    802e9c <fd_lookup+0x39>
  802eac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802eb1:	eb e9                	jmp    802e9c <fd_lookup+0x39>

00802eb3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
  802eb6:	83 ec 08             	sub    $0x8,%esp
  802eb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ec1:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802ec6:	39 08                	cmp    %ecx,(%eax)
  802ec8:	74 38                	je     802f02 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  802eca:	83 c2 01             	add    $0x1,%edx
  802ecd:	8b 04 95 0c 4d 80 00 	mov    0x804d0c(,%edx,4),%eax
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	75 ee                	jne    802ec6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ed8:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802edd:	8b 40 48             	mov    0x48(%eax),%eax
  802ee0:	83 ec 04             	sub    $0x4,%esp
  802ee3:	51                   	push   %ecx
  802ee4:	50                   	push   %eax
  802ee5:	68 8c 4c 80 00       	push   $0x804c8c
  802eea:	e8 44 ef ff ff       	call   801e33 <cprintf>
	*dev = 0;
  802eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802ef8:	83 c4 10             	add    $0x10,%esp
  802efb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802f00:	c9                   	leave  
  802f01:	c3                   	ret    
			*dev = devtab[i];
  802f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f05:	89 01                	mov    %eax,(%ecx)
			return 0;
  802f07:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0c:	eb f2                	jmp    802f00 <dev_lookup+0x4d>

00802f0e <fd_close>:
{
  802f0e:	55                   	push   %ebp
  802f0f:	89 e5                	mov    %esp,%ebp
  802f11:	57                   	push   %edi
  802f12:	56                   	push   %esi
  802f13:	53                   	push   %ebx
  802f14:	83 ec 24             	sub    $0x24,%esp
  802f17:	8b 75 08             	mov    0x8(%ebp),%esi
  802f1a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802f1d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802f20:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802f21:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802f27:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802f2a:	50                   	push   %eax
  802f2b:	e8 33 ff ff ff       	call   802e63 <fd_lookup>
  802f30:	89 c3                	mov    %eax,%ebx
  802f32:	83 c4 10             	add    $0x10,%esp
  802f35:	85 c0                	test   %eax,%eax
  802f37:	78 05                	js     802f3e <fd_close+0x30>
	    || fd != fd2)
  802f39:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802f3c:	74 16                	je     802f54 <fd_close+0x46>
		return (must_exist ? r : 0);
  802f3e:	89 f8                	mov    %edi,%eax
  802f40:	84 c0                	test   %al,%al
  802f42:	b8 00 00 00 00       	mov    $0x0,%eax
  802f47:	0f 44 d8             	cmove  %eax,%ebx
}
  802f4a:	89 d8                	mov    %ebx,%eax
  802f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f4f:	5b                   	pop    %ebx
  802f50:	5e                   	pop    %esi
  802f51:	5f                   	pop    %edi
  802f52:	5d                   	pop    %ebp
  802f53:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802f54:	83 ec 08             	sub    $0x8,%esp
  802f57:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802f5a:	50                   	push   %eax
  802f5b:	ff 36                	pushl  (%esi)
  802f5d:	e8 51 ff ff ff       	call   802eb3 <dev_lookup>
  802f62:	89 c3                	mov    %eax,%ebx
  802f64:	83 c4 10             	add    $0x10,%esp
  802f67:	85 c0                	test   %eax,%eax
  802f69:	78 1a                	js     802f85 <fd_close+0x77>
		if (dev->dev_close)
  802f6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802f71:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802f76:	85 c0                	test   %eax,%eax
  802f78:	74 0b                	je     802f85 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802f7a:	83 ec 0c             	sub    $0xc,%esp
  802f7d:	56                   	push   %esi
  802f7e:	ff d0                	call   *%eax
  802f80:	89 c3                	mov    %eax,%ebx
  802f82:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802f85:	83 ec 08             	sub    $0x8,%esp
  802f88:	56                   	push   %esi
  802f89:	6a 00                	push   $0x0
  802f8b:	e8 79 fa ff ff       	call   802a09 <sys_page_unmap>
	return r;
  802f90:	83 c4 10             	add    $0x10,%esp
  802f93:	eb b5                	jmp    802f4a <fd_close+0x3c>

00802f95 <close>:

int
close(int fdnum)
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
  802f98:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f9e:	50                   	push   %eax
  802f9f:	ff 75 08             	pushl  0x8(%ebp)
  802fa2:	e8 bc fe ff ff       	call   802e63 <fd_lookup>
  802fa7:	83 c4 10             	add    $0x10,%esp
  802faa:	85 c0                	test   %eax,%eax
  802fac:	79 02                	jns    802fb0 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802fae:	c9                   	leave  
  802faf:	c3                   	ret    
		return fd_close(fd, 1);
  802fb0:	83 ec 08             	sub    $0x8,%esp
  802fb3:	6a 01                	push   $0x1
  802fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  802fb8:	e8 51 ff ff ff       	call   802f0e <fd_close>
  802fbd:	83 c4 10             	add    $0x10,%esp
  802fc0:	eb ec                	jmp    802fae <close+0x19>

00802fc2 <close_all>:

void
close_all(void)
{
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
  802fc5:	53                   	push   %ebx
  802fc6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802fc9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802fce:	83 ec 0c             	sub    $0xc,%esp
  802fd1:	53                   	push   %ebx
  802fd2:	e8 be ff ff ff       	call   802f95 <close>
	for (i = 0; i < MAXFD; i++)
  802fd7:	83 c3 01             	add    $0x1,%ebx
  802fda:	83 c4 10             	add    $0x10,%esp
  802fdd:	83 fb 20             	cmp    $0x20,%ebx
  802fe0:	75 ec                	jne    802fce <close_all+0xc>
}
  802fe2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fe5:	c9                   	leave  
  802fe6:	c3                   	ret    

00802fe7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802fe7:	55                   	push   %ebp
  802fe8:	89 e5                	mov    %esp,%ebp
  802fea:	57                   	push   %edi
  802feb:	56                   	push   %esi
  802fec:	53                   	push   %ebx
  802fed:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802ff0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802ff3:	50                   	push   %eax
  802ff4:	ff 75 08             	pushl  0x8(%ebp)
  802ff7:	e8 67 fe ff ff       	call   802e63 <fd_lookup>
  802ffc:	89 c3                	mov    %eax,%ebx
  802ffe:	83 c4 10             	add    $0x10,%esp
  803001:	85 c0                	test   %eax,%eax
  803003:	0f 88 81 00 00 00    	js     80308a <dup+0xa3>
		return r;
	close(newfdnum);
  803009:	83 ec 0c             	sub    $0xc,%esp
  80300c:	ff 75 0c             	pushl  0xc(%ebp)
  80300f:	e8 81 ff ff ff       	call   802f95 <close>

	newfd = INDEX2FD(newfdnum);
  803014:	8b 75 0c             	mov    0xc(%ebp),%esi
  803017:	c1 e6 0c             	shl    $0xc,%esi
  80301a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  803020:	83 c4 04             	add    $0x4,%esp
  803023:	ff 75 e4             	pushl  -0x1c(%ebp)
  803026:	e8 cf fd ff ff       	call   802dfa <fd2data>
  80302b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80302d:	89 34 24             	mov    %esi,(%esp)
  803030:	e8 c5 fd ff ff       	call   802dfa <fd2data>
  803035:	83 c4 10             	add    $0x10,%esp
  803038:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80303a:	89 d8                	mov    %ebx,%eax
  80303c:	c1 e8 16             	shr    $0x16,%eax
  80303f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  803046:	a8 01                	test   $0x1,%al
  803048:	74 11                	je     80305b <dup+0x74>
  80304a:	89 d8                	mov    %ebx,%eax
  80304c:	c1 e8 0c             	shr    $0xc,%eax
  80304f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  803056:	f6 c2 01             	test   $0x1,%dl
  803059:	75 39                	jne    803094 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80305b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80305e:	89 d0                	mov    %edx,%eax
  803060:	c1 e8 0c             	shr    $0xc,%eax
  803063:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80306a:	83 ec 0c             	sub    $0xc,%esp
  80306d:	25 07 0e 00 00       	and    $0xe07,%eax
  803072:	50                   	push   %eax
  803073:	56                   	push   %esi
  803074:	6a 00                	push   $0x0
  803076:	52                   	push   %edx
  803077:	6a 00                	push   $0x0
  803079:	e8 49 f9 ff ff       	call   8029c7 <sys_page_map>
  80307e:	89 c3                	mov    %eax,%ebx
  803080:	83 c4 20             	add    $0x20,%esp
  803083:	85 c0                	test   %eax,%eax
  803085:	78 31                	js     8030b8 <dup+0xd1>
		goto err;

	return newfdnum;
  803087:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80308a:	89 d8                	mov    %ebx,%eax
  80308c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80308f:	5b                   	pop    %ebx
  803090:	5e                   	pop    %esi
  803091:	5f                   	pop    %edi
  803092:	5d                   	pop    %ebp
  803093:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803094:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80309b:	83 ec 0c             	sub    $0xc,%esp
  80309e:	25 07 0e 00 00       	and    $0xe07,%eax
  8030a3:	50                   	push   %eax
  8030a4:	57                   	push   %edi
  8030a5:	6a 00                	push   $0x0
  8030a7:	53                   	push   %ebx
  8030a8:	6a 00                	push   $0x0
  8030aa:	e8 18 f9 ff ff       	call   8029c7 <sys_page_map>
  8030af:	89 c3                	mov    %eax,%ebx
  8030b1:	83 c4 20             	add    $0x20,%esp
  8030b4:	85 c0                	test   %eax,%eax
  8030b6:	79 a3                	jns    80305b <dup+0x74>
	sys_page_unmap(0, newfd);
  8030b8:	83 ec 08             	sub    $0x8,%esp
  8030bb:	56                   	push   %esi
  8030bc:	6a 00                	push   $0x0
  8030be:	e8 46 f9 ff ff       	call   802a09 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8030c3:	83 c4 08             	add    $0x8,%esp
  8030c6:	57                   	push   %edi
  8030c7:	6a 00                	push   $0x0
  8030c9:	e8 3b f9 ff ff       	call   802a09 <sys_page_unmap>
	return r;
  8030ce:	83 c4 10             	add    $0x10,%esp
  8030d1:	eb b7                	jmp    80308a <dup+0xa3>

008030d3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8030d3:	55                   	push   %ebp
  8030d4:	89 e5                	mov    %esp,%ebp
  8030d6:	53                   	push   %ebx
  8030d7:	83 ec 1c             	sub    $0x1c,%esp
  8030da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8030e0:	50                   	push   %eax
  8030e1:	53                   	push   %ebx
  8030e2:	e8 7c fd ff ff       	call   802e63 <fd_lookup>
  8030e7:	83 c4 10             	add    $0x10,%esp
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	78 3f                	js     80312d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030ee:	83 ec 08             	sub    $0x8,%esp
  8030f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030f4:	50                   	push   %eax
  8030f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f8:	ff 30                	pushl  (%eax)
  8030fa:	e8 b4 fd ff ff       	call   802eb3 <dev_lookup>
  8030ff:	83 c4 10             	add    $0x10,%esp
  803102:	85 c0                	test   %eax,%eax
  803104:	78 27                	js     80312d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803109:	8b 42 08             	mov    0x8(%edx),%eax
  80310c:	83 e0 03             	and    $0x3,%eax
  80310f:	83 f8 01             	cmp    $0x1,%eax
  803112:	74 1e                	je     803132 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  803114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803117:	8b 40 08             	mov    0x8(%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 35                	je     803153 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	ff 75 10             	pushl  0x10(%ebp)
  803124:	ff 75 0c             	pushl  0xc(%ebp)
  803127:	52                   	push   %edx
  803128:	ff d0                	call   *%eax
  80312a:	83 c4 10             	add    $0x10,%esp
}
  80312d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803130:	c9                   	leave  
  803131:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803132:	a1 50 a0 80 00       	mov    0x80a050,%eax
  803137:	8b 40 48             	mov    0x48(%eax),%eax
  80313a:	83 ec 04             	sub    $0x4,%esp
  80313d:	53                   	push   %ebx
  80313e:	50                   	push   %eax
  80313f:	68 d0 4c 80 00       	push   $0x804cd0
  803144:	e8 ea ec ff ff       	call   801e33 <cprintf>
		return -E_INVAL;
  803149:	83 c4 10             	add    $0x10,%esp
  80314c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803151:	eb da                	jmp    80312d <read+0x5a>
		return -E_NOT_SUPP;
  803153:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803158:	eb d3                	jmp    80312d <read+0x5a>

0080315a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80315a:	55                   	push   %ebp
  80315b:	89 e5                	mov    %esp,%ebp
  80315d:	57                   	push   %edi
  80315e:	56                   	push   %esi
  80315f:	53                   	push   %ebx
  803160:	83 ec 0c             	sub    $0xc,%esp
  803163:	8b 7d 08             	mov    0x8(%ebp),%edi
  803166:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803169:	bb 00 00 00 00       	mov    $0x0,%ebx
  80316e:	39 f3                	cmp    %esi,%ebx
  803170:	73 23                	jae    803195 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	89 f0                	mov    %esi,%eax
  803177:	29 d8                	sub    %ebx,%eax
  803179:	50                   	push   %eax
  80317a:	89 d8                	mov    %ebx,%eax
  80317c:	03 45 0c             	add    0xc(%ebp),%eax
  80317f:	50                   	push   %eax
  803180:	57                   	push   %edi
  803181:	e8 4d ff ff ff       	call   8030d3 <read>
		if (m < 0)
  803186:	83 c4 10             	add    $0x10,%esp
  803189:	85 c0                	test   %eax,%eax
  80318b:	78 06                	js     803193 <readn+0x39>
			return m;
		if (m == 0)
  80318d:	74 06                	je     803195 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80318f:	01 c3                	add    %eax,%ebx
  803191:	eb db                	jmp    80316e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803193:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  803195:	89 d8                	mov    %ebx,%eax
  803197:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80319a:	5b                   	pop    %ebx
  80319b:	5e                   	pop    %esi
  80319c:	5f                   	pop    %edi
  80319d:	5d                   	pop    %ebp
  80319e:	c3                   	ret    

0080319f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80319f:	55                   	push   %ebp
  8031a0:	89 e5                	mov    %esp,%ebp
  8031a2:	53                   	push   %ebx
  8031a3:	83 ec 1c             	sub    $0x1c,%esp
  8031a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031ac:	50                   	push   %eax
  8031ad:	53                   	push   %ebx
  8031ae:	e8 b0 fc ff ff       	call   802e63 <fd_lookup>
  8031b3:	83 c4 10             	add    $0x10,%esp
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	78 3a                	js     8031f4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031ba:	83 ec 08             	sub    $0x8,%esp
  8031bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031c0:	50                   	push   %eax
  8031c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c4:	ff 30                	pushl  (%eax)
  8031c6:	e8 e8 fc ff ff       	call   802eb3 <dev_lookup>
  8031cb:	83 c4 10             	add    $0x10,%esp
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	78 22                	js     8031f4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8031d9:	74 1e                	je     8031f9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8031db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031de:	8b 52 0c             	mov    0xc(%edx),%edx
  8031e1:	85 d2                	test   %edx,%edx
  8031e3:	74 35                	je     80321a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	ff 75 10             	pushl  0x10(%ebp)
  8031eb:	ff 75 0c             	pushl  0xc(%ebp)
  8031ee:	50                   	push   %eax
  8031ef:	ff d2                	call   *%edx
  8031f1:	83 c4 10             	add    $0x10,%esp
}
  8031f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8031f9:	a1 50 a0 80 00       	mov    0x80a050,%eax
  8031fe:	8b 40 48             	mov    0x48(%eax),%eax
  803201:	83 ec 04             	sub    $0x4,%esp
  803204:	53                   	push   %ebx
  803205:	50                   	push   %eax
  803206:	68 ec 4c 80 00       	push   $0x804cec
  80320b:	e8 23 ec ff ff       	call   801e33 <cprintf>
		return -E_INVAL;
  803210:	83 c4 10             	add    $0x10,%esp
  803213:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803218:	eb da                	jmp    8031f4 <write+0x55>
		return -E_NOT_SUPP;
  80321a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80321f:	eb d3                	jmp    8031f4 <write+0x55>

00803221 <seek>:

int
seek(int fdnum, off_t offset)
{
  803221:	55                   	push   %ebp
  803222:	89 e5                	mov    %esp,%ebp
  803224:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803227:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80322a:	50                   	push   %eax
  80322b:	ff 75 08             	pushl  0x8(%ebp)
  80322e:	e8 30 fc ff ff       	call   802e63 <fd_lookup>
  803233:	83 c4 10             	add    $0x10,%esp
  803236:	85 c0                	test   %eax,%eax
  803238:	78 0e                	js     803248 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80323a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  803243:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803248:	c9                   	leave  
  803249:	c3                   	ret    

0080324a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80324a:	55                   	push   %ebp
  80324b:	89 e5                	mov    %esp,%ebp
  80324d:	53                   	push   %ebx
  80324e:	83 ec 1c             	sub    $0x1c,%esp
  803251:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803254:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803257:	50                   	push   %eax
  803258:	53                   	push   %ebx
  803259:	e8 05 fc ff ff       	call   802e63 <fd_lookup>
  80325e:	83 c4 10             	add    $0x10,%esp
  803261:	85 c0                	test   %eax,%eax
  803263:	78 37                	js     80329c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803265:	83 ec 08             	sub    $0x8,%esp
  803268:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80326b:	50                   	push   %eax
  80326c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326f:	ff 30                	pushl  (%eax)
  803271:	e8 3d fc ff ff       	call   802eb3 <dev_lookup>
  803276:	83 c4 10             	add    $0x10,%esp
  803279:	85 c0                	test   %eax,%eax
  80327b:	78 1f                	js     80329c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80327d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803280:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  803284:	74 1b                	je     8032a1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  803286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803289:	8b 52 18             	mov    0x18(%edx),%edx
  80328c:	85 d2                	test   %edx,%edx
  80328e:	74 32                	je     8032c2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  803290:	83 ec 08             	sub    $0x8,%esp
  803293:	ff 75 0c             	pushl  0xc(%ebp)
  803296:	50                   	push   %eax
  803297:	ff d2                	call   *%edx
  803299:	83 c4 10             	add    $0x10,%esp
}
  80329c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80329f:	c9                   	leave  
  8032a0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8032a1:	a1 50 a0 80 00       	mov    0x80a050,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8032a6:	8b 40 48             	mov    0x48(%eax),%eax
  8032a9:	83 ec 04             	sub    $0x4,%esp
  8032ac:	53                   	push   %ebx
  8032ad:	50                   	push   %eax
  8032ae:	68 ac 4c 80 00       	push   $0x804cac
  8032b3:	e8 7b eb ff ff       	call   801e33 <cprintf>
		return -E_INVAL;
  8032b8:	83 c4 10             	add    $0x10,%esp
  8032bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032c0:	eb da                	jmp    80329c <ftruncate+0x52>
		return -E_NOT_SUPP;
  8032c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8032c7:	eb d3                	jmp    80329c <ftruncate+0x52>

008032c9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8032c9:	55                   	push   %ebp
  8032ca:	89 e5                	mov    %esp,%ebp
  8032cc:	53                   	push   %ebx
  8032cd:	83 ec 1c             	sub    $0x1c,%esp
  8032d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8032d6:	50                   	push   %eax
  8032d7:	ff 75 08             	pushl  0x8(%ebp)
  8032da:	e8 84 fb ff ff       	call   802e63 <fd_lookup>
  8032df:	83 c4 10             	add    $0x10,%esp
  8032e2:	85 c0                	test   %eax,%eax
  8032e4:	78 4b                	js     803331 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032e6:	83 ec 08             	sub    $0x8,%esp
  8032e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032ec:	50                   	push   %eax
  8032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f0:	ff 30                	pushl  (%eax)
  8032f2:	e8 bc fb ff ff       	call   802eb3 <dev_lookup>
  8032f7:	83 c4 10             	add    $0x10,%esp
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	78 33                	js     803331 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  803305:	74 2f                	je     803336 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  803307:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80330a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  803311:	00 00 00 
	stat->st_isdir = 0;
  803314:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80331b:	00 00 00 
	stat->st_dev = dev;
  80331e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  803324:	83 ec 08             	sub    $0x8,%esp
  803327:	53                   	push   %ebx
  803328:	ff 75 f0             	pushl  -0x10(%ebp)
  80332b:	ff 50 14             	call   *0x14(%eax)
  80332e:	83 c4 10             	add    $0x10,%esp
}
  803331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803334:	c9                   	leave  
  803335:	c3                   	ret    
		return -E_NOT_SUPP;
  803336:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80333b:	eb f4                	jmp    803331 <fstat+0x68>

0080333d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80333d:	55                   	push   %ebp
  80333e:	89 e5                	mov    %esp,%ebp
  803340:	56                   	push   %esi
  803341:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803342:	83 ec 08             	sub    $0x8,%esp
  803345:	6a 00                	push   $0x0
  803347:	ff 75 08             	pushl  0x8(%ebp)
  80334a:	e8 22 02 00 00       	call   803571 <open>
  80334f:	89 c3                	mov    %eax,%ebx
  803351:	83 c4 10             	add    $0x10,%esp
  803354:	85 c0                	test   %eax,%eax
  803356:	78 1b                	js     803373 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  803358:	83 ec 08             	sub    $0x8,%esp
  80335b:	ff 75 0c             	pushl  0xc(%ebp)
  80335e:	50                   	push   %eax
  80335f:	e8 65 ff ff ff       	call   8032c9 <fstat>
  803364:	89 c6                	mov    %eax,%esi
	close(fd);
  803366:	89 1c 24             	mov    %ebx,(%esp)
  803369:	e8 27 fc ff ff       	call   802f95 <close>
	return r;
  80336e:	83 c4 10             	add    $0x10,%esp
  803371:	89 f3                	mov    %esi,%ebx
}
  803373:	89 d8                	mov    %ebx,%eax
  803375:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803378:	5b                   	pop    %ebx
  803379:	5e                   	pop    %esi
  80337a:	5d                   	pop    %ebp
  80337b:	c3                   	ret    

0080337c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
  80337f:	56                   	push   %esi
  803380:	53                   	push   %ebx
  803381:	89 c6                	mov    %eax,%esi
  803383:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  803385:	83 3d 40 a0 80 00 00 	cmpl   $0x0,0x80a040
  80338c:	74 27                	je     8033b5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80338e:	6a 07                	push   $0x7
  803390:	68 00 b0 80 00       	push   $0x80b000
  803395:	56                   	push   %esi
  803396:	ff 35 40 a0 80 00    	pushl  0x80a040
  80339c:	e8 b6 f9 ff ff       	call   802d57 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8033a1:	83 c4 0c             	add    $0xc,%esp
  8033a4:	6a 00                	push   $0x0
  8033a6:	53                   	push   %ebx
  8033a7:	6a 00                	push   $0x0
  8033a9:	e8 40 f9 ff ff       	call   802cee <ipc_recv>
}
  8033ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8033b1:	5b                   	pop    %ebx
  8033b2:	5e                   	pop    %esi
  8033b3:	5d                   	pop    %ebp
  8033b4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033b5:	83 ec 0c             	sub    $0xc,%esp
  8033b8:	6a 01                	push   $0x1
  8033ba:	e8 f0 f9 ff ff       	call   802daf <ipc_find_env>
  8033bf:	a3 40 a0 80 00       	mov    %eax,0x80a040
  8033c4:	83 c4 10             	add    $0x10,%esp
  8033c7:	eb c5                	jmp    80338e <fsipc+0x12>

008033c9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8033c9:	55                   	push   %ebp
  8033ca:	89 e5                	mov    %esp,%ebp
  8033cc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d5:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  8033da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033dd:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8033e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8033ec:	e8 8b ff ff ff       	call   80337c <fsipc>
}
  8033f1:	c9                   	leave  
  8033f2:	c3                   	ret    

008033f3 <devfile_flush>:
{
  8033f3:	55                   	push   %ebp
  8033f4:	89 e5                	mov    %esp,%ebp
  8033f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ff:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803404:	ba 00 00 00 00       	mov    $0x0,%edx
  803409:	b8 06 00 00 00       	mov    $0x6,%eax
  80340e:	e8 69 ff ff ff       	call   80337c <fsipc>
}
  803413:	c9                   	leave  
  803414:	c3                   	ret    

00803415 <devfile_stat>:
{
  803415:	55                   	push   %ebp
  803416:	89 e5                	mov    %esp,%ebp
  803418:	53                   	push   %ebx
  803419:	83 ec 04             	sub    $0x4,%esp
  80341c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 40 0c             	mov    0xc(%eax),%eax
  803425:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80342a:	ba 00 00 00 00       	mov    $0x0,%edx
  80342f:	b8 05 00 00 00       	mov    $0x5,%eax
  803434:	e8 43 ff ff ff       	call   80337c <fsipc>
  803439:	85 c0                	test   %eax,%eax
  80343b:	78 2c                	js     803469 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80343d:	83 ec 08             	sub    $0x8,%esp
  803440:	68 00 b0 80 00       	push   $0x80b000
  803445:	53                   	push   %ebx
  803446:	e8 47 f1 ff ff       	call   802592 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80344b:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803450:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803456:	a1 84 b0 80 00       	mov    0x80b084,%eax
  80345b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803461:	83 c4 10             	add    $0x10,%esp
  803464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80346c:	c9                   	leave  
  80346d:	c3                   	ret    

0080346e <devfile_write>:
{
  80346e:	55                   	push   %ebp
  80346f:	89 e5                	mov    %esp,%ebp
  803471:	53                   	push   %ebx
  803472:	83 ec 08             	sub    $0x8,%esp
  803475:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	8b 40 0c             	mov    0xc(%eax),%eax
  80347e:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  803483:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  803489:	53                   	push   %ebx
  80348a:	ff 75 0c             	pushl  0xc(%ebp)
  80348d:	68 08 b0 80 00       	push   $0x80b008
  803492:	e8 eb f2 ff ff       	call   802782 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803497:	ba 00 00 00 00       	mov    $0x0,%edx
  80349c:	b8 04 00 00 00       	mov    $0x4,%eax
  8034a1:	e8 d6 fe ff ff       	call   80337c <fsipc>
  8034a6:	83 c4 10             	add    $0x10,%esp
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	78 0b                	js     8034b8 <devfile_write+0x4a>
	assert(r <= n);
  8034ad:	39 d8                	cmp    %ebx,%eax
  8034af:	77 0c                	ja     8034bd <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8034b1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8034b6:	7f 1e                	jg     8034d6 <devfile_write+0x68>
}
  8034b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034bb:	c9                   	leave  
  8034bc:	c3                   	ret    
	assert(r <= n);
  8034bd:	68 20 4d 80 00       	push   $0x804d20
  8034c2:	68 1d 42 80 00       	push   $0x80421d
  8034c7:	68 98 00 00 00       	push   $0x98
  8034cc:	68 27 4d 80 00       	push   $0x804d27
  8034d1:	e8 67 e8 ff ff       	call   801d3d <_panic>
	assert(r <= PGSIZE);
  8034d6:	68 32 4d 80 00       	push   $0x804d32
  8034db:	68 1d 42 80 00       	push   $0x80421d
  8034e0:	68 99 00 00 00       	push   $0x99
  8034e5:	68 27 4d 80 00       	push   $0x804d27
  8034ea:	e8 4e e8 ff ff       	call   801d3d <_panic>

008034ef <devfile_read>:
{
  8034ef:	55                   	push   %ebp
  8034f0:	89 e5                	mov    %esp,%ebp
  8034f2:	56                   	push   %esi
  8034f3:	53                   	push   %ebx
  8034f4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fd:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803502:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803508:	ba 00 00 00 00       	mov    $0x0,%edx
  80350d:	b8 03 00 00 00       	mov    $0x3,%eax
  803512:	e8 65 fe ff ff       	call   80337c <fsipc>
  803517:	89 c3                	mov    %eax,%ebx
  803519:	85 c0                	test   %eax,%eax
  80351b:	78 1f                	js     80353c <devfile_read+0x4d>
	assert(r <= n);
  80351d:	39 f0                	cmp    %esi,%eax
  80351f:	77 24                	ja     803545 <devfile_read+0x56>
	assert(r <= PGSIZE);
  803521:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803526:	7f 33                	jg     80355b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803528:	83 ec 04             	sub    $0x4,%esp
  80352b:	50                   	push   %eax
  80352c:	68 00 b0 80 00       	push   $0x80b000
  803531:	ff 75 0c             	pushl  0xc(%ebp)
  803534:	e8 e7 f1 ff ff       	call   802720 <memmove>
	return r;
  803539:	83 c4 10             	add    $0x10,%esp
}
  80353c:	89 d8                	mov    %ebx,%eax
  80353e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803541:	5b                   	pop    %ebx
  803542:	5e                   	pop    %esi
  803543:	5d                   	pop    %ebp
  803544:	c3                   	ret    
	assert(r <= n);
  803545:	68 20 4d 80 00       	push   $0x804d20
  80354a:	68 1d 42 80 00       	push   $0x80421d
  80354f:	6a 7c                	push   $0x7c
  803551:	68 27 4d 80 00       	push   $0x804d27
  803556:	e8 e2 e7 ff ff       	call   801d3d <_panic>
	assert(r <= PGSIZE);
  80355b:	68 32 4d 80 00       	push   $0x804d32
  803560:	68 1d 42 80 00       	push   $0x80421d
  803565:	6a 7d                	push   $0x7d
  803567:	68 27 4d 80 00       	push   $0x804d27
  80356c:	e8 cc e7 ff ff       	call   801d3d <_panic>

00803571 <open>:
{
  803571:	55                   	push   %ebp
  803572:	89 e5                	mov    %esp,%ebp
  803574:	56                   	push   %esi
  803575:	53                   	push   %ebx
  803576:	83 ec 1c             	sub    $0x1c,%esp
  803579:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80357c:	56                   	push   %esi
  80357d:	e8 d7 ef ff ff       	call   802559 <strlen>
  803582:	83 c4 10             	add    $0x10,%esp
  803585:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80358a:	7f 6c                	jg     8035f8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80358c:	83 ec 0c             	sub    $0xc,%esp
  80358f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803592:	50                   	push   %eax
  803593:	e8 79 f8 ff ff       	call   802e11 <fd_alloc>
  803598:	89 c3                	mov    %eax,%ebx
  80359a:	83 c4 10             	add    $0x10,%esp
  80359d:	85 c0                	test   %eax,%eax
  80359f:	78 3c                	js     8035dd <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8035a1:	83 ec 08             	sub    $0x8,%esp
  8035a4:	56                   	push   %esi
  8035a5:	68 00 b0 80 00       	push   $0x80b000
  8035aa:	e8 e3 ef ff ff       	call   802592 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8035af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b2:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8035b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8035bf:	e8 b8 fd ff ff       	call   80337c <fsipc>
  8035c4:	89 c3                	mov    %eax,%ebx
  8035c6:	83 c4 10             	add    $0x10,%esp
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	78 19                	js     8035e6 <open+0x75>
	return fd2num(fd);
  8035cd:	83 ec 0c             	sub    $0xc,%esp
  8035d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8035d3:	e8 12 f8 ff ff       	call   802dea <fd2num>
  8035d8:	89 c3                	mov    %eax,%ebx
  8035da:	83 c4 10             	add    $0x10,%esp
}
  8035dd:	89 d8                	mov    %ebx,%eax
  8035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8035e2:	5b                   	pop    %ebx
  8035e3:	5e                   	pop    %esi
  8035e4:	5d                   	pop    %ebp
  8035e5:	c3                   	ret    
		fd_close(fd, 0);
  8035e6:	83 ec 08             	sub    $0x8,%esp
  8035e9:	6a 00                	push   $0x0
  8035eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8035ee:	e8 1b f9 ff ff       	call   802f0e <fd_close>
		return r;
  8035f3:	83 c4 10             	add    $0x10,%esp
  8035f6:	eb e5                	jmp    8035dd <open+0x6c>
		return -E_BAD_PATH;
  8035f8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8035fd:	eb de                	jmp    8035dd <open+0x6c>

008035ff <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8035ff:	55                   	push   %ebp
  803600:	89 e5                	mov    %esp,%ebp
  803602:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803605:	ba 00 00 00 00       	mov    $0x0,%edx
  80360a:	b8 08 00 00 00       	mov    $0x8,%eax
  80360f:	e8 68 fd ff ff       	call   80337c <fsipc>
}
  803614:	c9                   	leave  
  803615:	c3                   	ret    

00803616 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803616:	55                   	push   %ebp
  803617:	89 e5                	mov    %esp,%ebp
  803619:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80361c:	89 d0                	mov    %edx,%eax
  80361e:	c1 e8 16             	shr    $0x16,%eax
  803621:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803628:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80362d:	f6 c1 01             	test   $0x1,%cl
  803630:	74 1d                	je     80364f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803632:	c1 ea 0c             	shr    $0xc,%edx
  803635:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80363c:	f6 c2 01             	test   $0x1,%dl
  80363f:	74 0e                	je     80364f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803641:	c1 ea 0c             	shr    $0xc,%edx
  803644:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80364b:	ef 
  80364c:	0f b7 c0             	movzwl %ax,%eax
}
  80364f:	5d                   	pop    %ebp
  803650:	c3                   	ret    

00803651 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803651:	55                   	push   %ebp
  803652:	89 e5                	mov    %esp,%ebp
  803654:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  803657:	68 3e 4d 80 00       	push   $0x804d3e
  80365c:	ff 75 0c             	pushl  0xc(%ebp)
  80365f:	e8 2e ef ff ff       	call   802592 <strcpy>
	return 0;
}
  803664:	b8 00 00 00 00       	mov    $0x0,%eax
  803669:	c9                   	leave  
  80366a:	c3                   	ret    

0080366b <devsock_close>:
{
  80366b:	55                   	push   %ebp
  80366c:	89 e5                	mov    %esp,%ebp
  80366e:	53                   	push   %ebx
  80366f:	83 ec 10             	sub    $0x10,%esp
  803672:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803675:	53                   	push   %ebx
  803676:	e8 9b ff ff ff       	call   803616 <pageref>
  80367b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80367e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  803683:	83 f8 01             	cmp    $0x1,%eax
  803686:	74 07                	je     80368f <devsock_close+0x24>
}
  803688:	89 d0                	mov    %edx,%eax
  80368a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80368d:	c9                   	leave  
  80368e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80368f:	83 ec 0c             	sub    $0xc,%esp
  803692:	ff 73 0c             	pushl  0xc(%ebx)
  803695:	e8 b9 02 00 00       	call   803953 <nsipc_close>
  80369a:	89 c2                	mov    %eax,%edx
  80369c:	83 c4 10             	add    $0x10,%esp
  80369f:	eb e7                	jmp    803688 <devsock_close+0x1d>

008036a1 <devsock_write>:
{
  8036a1:	55                   	push   %ebp
  8036a2:	89 e5                	mov    %esp,%ebp
  8036a4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8036a7:	6a 00                	push   $0x0
  8036a9:	ff 75 10             	pushl  0x10(%ebp)
  8036ac:	ff 75 0c             	pushl  0xc(%ebp)
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	ff 70 0c             	pushl  0xc(%eax)
  8036b5:	e8 76 03 00 00       	call   803a30 <nsipc_send>
}
  8036ba:	c9                   	leave  
  8036bb:	c3                   	ret    

008036bc <devsock_read>:
{
  8036bc:	55                   	push   %ebp
  8036bd:	89 e5                	mov    %esp,%ebp
  8036bf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036c2:	6a 00                	push   $0x0
  8036c4:	ff 75 10             	pushl  0x10(%ebp)
  8036c7:	ff 75 0c             	pushl  0xc(%ebp)
  8036ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cd:	ff 70 0c             	pushl  0xc(%eax)
  8036d0:	e8 ef 02 00 00       	call   8039c4 <nsipc_recv>
}
  8036d5:	c9                   	leave  
  8036d6:	c3                   	ret    

008036d7 <fd2sockid>:
{
  8036d7:	55                   	push   %ebp
  8036d8:	89 e5                	mov    %esp,%ebp
  8036da:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8036dd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8036e0:	52                   	push   %edx
  8036e1:	50                   	push   %eax
  8036e2:	e8 7c f7 ff ff       	call   802e63 <fd_lookup>
  8036e7:	83 c4 10             	add    $0x10,%esp
  8036ea:	85 c0                	test   %eax,%eax
  8036ec:	78 10                	js     8036fe <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f1:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  8036f7:	39 08                	cmp    %ecx,(%eax)
  8036f9:	75 05                	jne    803700 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8036fb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8036fe:	c9                   	leave  
  8036ff:	c3                   	ret    
		return -E_NOT_SUPP;
  803700:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803705:	eb f7                	jmp    8036fe <fd2sockid+0x27>

00803707 <alloc_sockfd>:
{
  803707:	55                   	push   %ebp
  803708:	89 e5                	mov    %esp,%ebp
  80370a:	56                   	push   %esi
  80370b:	53                   	push   %ebx
  80370c:	83 ec 1c             	sub    $0x1c,%esp
  80370f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  803711:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803714:	50                   	push   %eax
  803715:	e8 f7 f6 ff ff       	call   802e11 <fd_alloc>
  80371a:	89 c3                	mov    %eax,%ebx
  80371c:	83 c4 10             	add    $0x10,%esp
  80371f:	85 c0                	test   %eax,%eax
  803721:	78 43                	js     803766 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	68 07 04 00 00       	push   $0x407
  80372b:	ff 75 f4             	pushl  -0xc(%ebp)
  80372e:	6a 00                	push   $0x0
  803730:	e8 4f f2 ff ff       	call   802984 <sys_page_alloc>
  803735:	89 c3                	mov    %eax,%ebx
  803737:	83 c4 10             	add    $0x10,%esp
  80373a:	85 c0                	test   %eax,%eax
  80373c:	78 28                	js     803766 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80373e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803741:	8b 15 80 90 80 00    	mov    0x809080,%edx
  803747:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803753:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803756:	83 ec 0c             	sub    $0xc,%esp
  803759:	50                   	push   %eax
  80375a:	e8 8b f6 ff ff       	call   802dea <fd2num>
  80375f:	89 c3                	mov    %eax,%ebx
  803761:	83 c4 10             	add    $0x10,%esp
  803764:	eb 0c                	jmp    803772 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  803766:	83 ec 0c             	sub    $0xc,%esp
  803769:	56                   	push   %esi
  80376a:	e8 e4 01 00 00       	call   803953 <nsipc_close>
		return r;
  80376f:	83 c4 10             	add    $0x10,%esp
}
  803772:	89 d8                	mov    %ebx,%eax
  803774:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803777:	5b                   	pop    %ebx
  803778:	5e                   	pop    %esi
  803779:	5d                   	pop    %ebp
  80377a:	c3                   	ret    

0080377b <accept>:
{
  80377b:	55                   	push   %ebp
  80377c:	89 e5                	mov    %esp,%ebp
  80377e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803781:	8b 45 08             	mov    0x8(%ebp),%eax
  803784:	e8 4e ff ff ff       	call   8036d7 <fd2sockid>
  803789:	85 c0                	test   %eax,%eax
  80378b:	78 1b                	js     8037a8 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80378d:	83 ec 04             	sub    $0x4,%esp
  803790:	ff 75 10             	pushl  0x10(%ebp)
  803793:	ff 75 0c             	pushl  0xc(%ebp)
  803796:	50                   	push   %eax
  803797:	e8 0e 01 00 00       	call   8038aa <nsipc_accept>
  80379c:	83 c4 10             	add    $0x10,%esp
  80379f:	85 c0                	test   %eax,%eax
  8037a1:	78 05                	js     8037a8 <accept+0x2d>
	return alloc_sockfd(r);
  8037a3:	e8 5f ff ff ff       	call   803707 <alloc_sockfd>
}
  8037a8:	c9                   	leave  
  8037a9:	c3                   	ret    

008037aa <bind>:
{
  8037aa:	55                   	push   %ebp
  8037ab:	89 e5                	mov    %esp,%ebp
  8037ad:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b3:	e8 1f ff ff ff       	call   8036d7 <fd2sockid>
  8037b8:	85 c0                	test   %eax,%eax
  8037ba:	78 12                	js     8037ce <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8037bc:	83 ec 04             	sub    $0x4,%esp
  8037bf:	ff 75 10             	pushl  0x10(%ebp)
  8037c2:	ff 75 0c             	pushl  0xc(%ebp)
  8037c5:	50                   	push   %eax
  8037c6:	e8 31 01 00 00       	call   8038fc <nsipc_bind>
  8037cb:	83 c4 10             	add    $0x10,%esp
}
  8037ce:	c9                   	leave  
  8037cf:	c3                   	ret    

008037d0 <shutdown>:
{
  8037d0:	55                   	push   %ebp
  8037d1:	89 e5                	mov    %esp,%ebp
  8037d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d9:	e8 f9 fe ff ff       	call   8036d7 <fd2sockid>
  8037de:	85 c0                	test   %eax,%eax
  8037e0:	78 0f                	js     8037f1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8037e2:	83 ec 08             	sub    $0x8,%esp
  8037e5:	ff 75 0c             	pushl  0xc(%ebp)
  8037e8:	50                   	push   %eax
  8037e9:	e8 43 01 00 00       	call   803931 <nsipc_shutdown>
  8037ee:	83 c4 10             	add    $0x10,%esp
}
  8037f1:	c9                   	leave  
  8037f2:	c3                   	ret    

008037f3 <connect>:
{
  8037f3:	55                   	push   %ebp
  8037f4:	89 e5                	mov    %esp,%ebp
  8037f6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fc:	e8 d6 fe ff ff       	call   8036d7 <fd2sockid>
  803801:	85 c0                	test   %eax,%eax
  803803:	78 12                	js     803817 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  803805:	83 ec 04             	sub    $0x4,%esp
  803808:	ff 75 10             	pushl  0x10(%ebp)
  80380b:	ff 75 0c             	pushl  0xc(%ebp)
  80380e:	50                   	push   %eax
  80380f:	e8 59 01 00 00       	call   80396d <nsipc_connect>
  803814:	83 c4 10             	add    $0x10,%esp
}
  803817:	c9                   	leave  
  803818:	c3                   	ret    

00803819 <listen>:
{
  803819:	55                   	push   %ebp
  80381a:	89 e5                	mov    %esp,%ebp
  80381c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	e8 b0 fe ff ff       	call   8036d7 <fd2sockid>
  803827:	85 c0                	test   %eax,%eax
  803829:	78 0f                	js     80383a <listen+0x21>
	return nsipc_listen(r, backlog);
  80382b:	83 ec 08             	sub    $0x8,%esp
  80382e:	ff 75 0c             	pushl  0xc(%ebp)
  803831:	50                   	push   %eax
  803832:	e8 6b 01 00 00       	call   8039a2 <nsipc_listen>
  803837:	83 c4 10             	add    $0x10,%esp
}
  80383a:	c9                   	leave  
  80383b:	c3                   	ret    

0080383c <socket>:

int
socket(int domain, int type, int protocol)
{
  80383c:	55                   	push   %ebp
  80383d:	89 e5                	mov    %esp,%ebp
  80383f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803842:	ff 75 10             	pushl  0x10(%ebp)
  803845:	ff 75 0c             	pushl  0xc(%ebp)
  803848:	ff 75 08             	pushl  0x8(%ebp)
  80384b:	e8 3e 02 00 00       	call   803a8e <nsipc_socket>
  803850:	83 c4 10             	add    $0x10,%esp
  803853:	85 c0                	test   %eax,%eax
  803855:	78 05                	js     80385c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  803857:	e8 ab fe ff ff       	call   803707 <alloc_sockfd>
}
  80385c:	c9                   	leave  
  80385d:	c3                   	ret    

0080385e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80385e:	55                   	push   %ebp
  80385f:	89 e5                	mov    %esp,%ebp
  803861:	53                   	push   %ebx
  803862:	83 ec 04             	sub    $0x4,%esp
  803865:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  803867:	83 3d 44 a0 80 00 00 	cmpl   $0x0,0x80a044
  80386e:	74 26                	je     803896 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803870:	6a 07                	push   $0x7
  803872:	68 00 c0 80 00       	push   $0x80c000
  803877:	53                   	push   %ebx
  803878:	ff 35 44 a0 80 00    	pushl  0x80a044
  80387e:	e8 d4 f4 ff ff       	call   802d57 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803883:	83 c4 0c             	add    $0xc,%esp
  803886:	6a 00                	push   $0x0
  803888:	6a 00                	push   $0x0
  80388a:	6a 00                	push   $0x0
  80388c:	e8 5d f4 ff ff       	call   802cee <ipc_recv>
}
  803891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803894:	c9                   	leave  
  803895:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803896:	83 ec 0c             	sub    $0xc,%esp
  803899:	6a 02                	push   $0x2
  80389b:	e8 0f f5 ff ff       	call   802daf <ipc_find_env>
  8038a0:	a3 44 a0 80 00       	mov    %eax,0x80a044
  8038a5:	83 c4 10             	add    $0x10,%esp
  8038a8:	eb c6                	jmp    803870 <nsipc+0x12>

008038aa <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038aa:	55                   	push   %ebp
  8038ab:	89 e5                	mov    %esp,%ebp
  8038ad:	56                   	push   %esi
  8038ae:	53                   	push   %ebx
  8038af:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8038b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b5:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8038ba:	8b 06                	mov    (%esi),%eax
  8038bc:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c6:	e8 93 ff ff ff       	call   80385e <nsipc>
  8038cb:	89 c3                	mov    %eax,%ebx
  8038cd:	85 c0                	test   %eax,%eax
  8038cf:	79 09                	jns    8038da <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8038d1:	89 d8                	mov    %ebx,%eax
  8038d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8038d6:	5b                   	pop    %ebx
  8038d7:	5e                   	pop    %esi
  8038d8:	5d                   	pop    %ebp
  8038d9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8038da:	83 ec 04             	sub    $0x4,%esp
  8038dd:	ff 35 10 c0 80 00    	pushl  0x80c010
  8038e3:	68 00 c0 80 00       	push   $0x80c000
  8038e8:	ff 75 0c             	pushl  0xc(%ebp)
  8038eb:	e8 30 ee ff ff       	call   802720 <memmove>
		*addrlen = ret->ret_addrlen;
  8038f0:	a1 10 c0 80 00       	mov    0x80c010,%eax
  8038f5:	89 06                	mov    %eax,(%esi)
  8038f7:	83 c4 10             	add    $0x10,%esp
	return r;
  8038fa:	eb d5                	jmp    8038d1 <nsipc_accept+0x27>

008038fc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038fc:	55                   	push   %ebp
  8038fd:	89 e5                	mov    %esp,%ebp
  8038ff:	53                   	push   %ebx
  803900:	83 ec 08             	sub    $0x8,%esp
  803903:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803906:	8b 45 08             	mov    0x8(%ebp),%eax
  803909:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80390e:	53                   	push   %ebx
  80390f:	ff 75 0c             	pushl  0xc(%ebp)
  803912:	68 04 c0 80 00       	push   $0x80c004
  803917:	e8 04 ee ff ff       	call   802720 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80391c:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  803922:	b8 02 00 00 00       	mov    $0x2,%eax
  803927:	e8 32 ff ff ff       	call   80385e <nsipc>
}
  80392c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80392f:	c9                   	leave  
  803930:	c3                   	ret    

00803931 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803931:	55                   	push   %ebp
  803932:	89 e5                	mov    %esp,%ebp
  803934:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803937:	8b 45 08             	mov    0x8(%ebp),%eax
  80393a:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  80393f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803942:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  803947:	b8 03 00 00 00       	mov    $0x3,%eax
  80394c:	e8 0d ff ff ff       	call   80385e <nsipc>
}
  803951:	c9                   	leave  
  803952:	c3                   	ret    

00803953 <nsipc_close>:

int
nsipc_close(int s)
{
  803953:	55                   	push   %ebp
  803954:	89 e5                	mov    %esp,%ebp
  803956:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803959:	8b 45 08             	mov    0x8(%ebp),%eax
  80395c:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  803961:	b8 04 00 00 00       	mov    $0x4,%eax
  803966:	e8 f3 fe ff ff       	call   80385e <nsipc>
}
  80396b:	c9                   	leave  
  80396c:	c3                   	ret    

0080396d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80396d:	55                   	push   %ebp
  80396e:	89 e5                	mov    %esp,%ebp
  803970:	53                   	push   %ebx
  803971:	83 ec 08             	sub    $0x8,%esp
  803974:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80397f:	53                   	push   %ebx
  803980:	ff 75 0c             	pushl  0xc(%ebp)
  803983:	68 04 c0 80 00       	push   $0x80c004
  803988:	e8 93 ed ff ff       	call   802720 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80398d:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803993:	b8 05 00 00 00       	mov    $0x5,%eax
  803998:	e8 c1 fe ff ff       	call   80385e <nsipc>
}
  80399d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039a0:	c9                   	leave  
  8039a1:	c3                   	ret    

008039a2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8039a2:	55                   	push   %ebp
  8039a3:	89 e5                	mov    %esp,%ebp
  8039a5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8039a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ab:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  8039b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b3:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  8039b8:	b8 06 00 00 00       	mov    $0x6,%eax
  8039bd:	e8 9c fe ff ff       	call   80385e <nsipc>
}
  8039c2:	c9                   	leave  
  8039c3:	c3                   	ret    

008039c4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8039c4:	55                   	push   %ebp
  8039c5:	89 e5                	mov    %esp,%ebp
  8039c7:	56                   	push   %esi
  8039c8:	53                   	push   %ebx
  8039c9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8039cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cf:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  8039d4:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  8039da:	8b 45 14             	mov    0x14(%ebp),%eax
  8039dd:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8039e2:	b8 07 00 00 00       	mov    $0x7,%eax
  8039e7:	e8 72 fe ff ff       	call   80385e <nsipc>
  8039ec:	89 c3                	mov    %eax,%ebx
  8039ee:	85 c0                	test   %eax,%eax
  8039f0:	78 1f                	js     803a11 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8039f2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8039f7:	7f 21                	jg     803a1a <nsipc_recv+0x56>
  8039f9:	39 c6                	cmp    %eax,%esi
  8039fb:	7c 1d                	jl     803a1a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8039fd:	83 ec 04             	sub    $0x4,%esp
  803a00:	50                   	push   %eax
  803a01:	68 00 c0 80 00       	push   $0x80c000
  803a06:	ff 75 0c             	pushl  0xc(%ebp)
  803a09:	e8 12 ed ff ff       	call   802720 <memmove>
  803a0e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803a11:	89 d8                	mov    %ebx,%eax
  803a13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803a16:	5b                   	pop    %ebx
  803a17:	5e                   	pop    %esi
  803a18:	5d                   	pop    %ebp
  803a19:	c3                   	ret    
		assert(r < 1600 && r <= len);
  803a1a:	68 4a 4d 80 00       	push   $0x804d4a
  803a1f:	68 1d 42 80 00       	push   $0x80421d
  803a24:	6a 62                	push   $0x62
  803a26:	68 5f 4d 80 00       	push   $0x804d5f
  803a2b:	e8 0d e3 ff ff       	call   801d3d <_panic>

00803a30 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a30:	55                   	push   %ebp
  803a31:	89 e5                	mov    %esp,%ebp
  803a33:	53                   	push   %ebx
  803a34:	83 ec 04             	sub    $0x4,%esp
  803a37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3d:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  803a42:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803a48:	7f 2e                	jg     803a78 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a4a:	83 ec 04             	sub    $0x4,%esp
  803a4d:	53                   	push   %ebx
  803a4e:	ff 75 0c             	pushl  0xc(%ebp)
  803a51:	68 0c c0 80 00       	push   $0x80c00c
  803a56:	e8 c5 ec ff ff       	call   802720 <memmove>
	nsipcbuf.send.req_size = size;
  803a5b:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  803a61:	8b 45 14             	mov    0x14(%ebp),%eax
  803a64:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803a69:	b8 08 00 00 00       	mov    $0x8,%eax
  803a6e:	e8 eb fd ff ff       	call   80385e <nsipc>
}
  803a73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a76:	c9                   	leave  
  803a77:	c3                   	ret    
	assert(size < 1600);
  803a78:	68 6b 4d 80 00       	push   $0x804d6b
  803a7d:	68 1d 42 80 00       	push   $0x80421d
  803a82:	6a 6d                	push   $0x6d
  803a84:	68 5f 4d 80 00       	push   $0x804d5f
  803a89:	e8 af e2 ff ff       	call   801d3d <_panic>

00803a8e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a8e:	55                   	push   %ebp
  803a8f:	89 e5                	mov    %esp,%ebp
  803a91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803a94:	8b 45 08             	mov    0x8(%ebp),%eax
  803a97:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a9f:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803aa4:	8b 45 10             	mov    0x10(%ebp),%eax
  803aa7:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803aac:	b8 09 00 00 00       	mov    $0x9,%eax
  803ab1:	e8 a8 fd ff ff       	call   80385e <nsipc>
}
  803ab6:	c9                   	leave  
  803ab7:	c3                   	ret    

00803ab8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ab8:	55                   	push   %ebp
  803ab9:	89 e5                	mov    %esp,%ebp
  803abb:	56                   	push   %esi
  803abc:	53                   	push   %ebx
  803abd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ac0:	83 ec 0c             	sub    $0xc,%esp
  803ac3:	ff 75 08             	pushl  0x8(%ebp)
  803ac6:	e8 2f f3 ff ff       	call   802dfa <fd2data>
  803acb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803acd:	83 c4 08             	add    $0x8,%esp
  803ad0:	68 77 4d 80 00       	push   $0x804d77
  803ad5:	53                   	push   %ebx
  803ad6:	e8 b7 ea ff ff       	call   802592 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803adb:	8b 46 04             	mov    0x4(%esi),%eax
  803ade:	2b 06                	sub    (%esi),%eax
  803ae0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803ae6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803aed:	00 00 00 
	stat->st_dev = &devpipe;
  803af0:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  803af7:	90 80 00 
	return 0;
}
  803afa:	b8 00 00 00 00       	mov    $0x0,%eax
  803aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803b02:	5b                   	pop    %ebx
  803b03:	5e                   	pop    %esi
  803b04:	5d                   	pop    %ebp
  803b05:	c3                   	ret    

00803b06 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b06:	55                   	push   %ebp
  803b07:	89 e5                	mov    %esp,%ebp
  803b09:	53                   	push   %ebx
  803b0a:	83 ec 0c             	sub    $0xc,%esp
  803b0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803b10:	53                   	push   %ebx
  803b11:	6a 00                	push   $0x0
  803b13:	e8 f1 ee ff ff       	call   802a09 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803b18:	89 1c 24             	mov    %ebx,(%esp)
  803b1b:	e8 da f2 ff ff       	call   802dfa <fd2data>
  803b20:	83 c4 08             	add    $0x8,%esp
  803b23:	50                   	push   %eax
  803b24:	6a 00                	push   $0x0
  803b26:	e8 de ee ff ff       	call   802a09 <sys_page_unmap>
}
  803b2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803b2e:	c9                   	leave  
  803b2f:	c3                   	ret    

00803b30 <_pipeisclosed>:
{
  803b30:	55                   	push   %ebp
  803b31:	89 e5                	mov    %esp,%ebp
  803b33:	57                   	push   %edi
  803b34:	56                   	push   %esi
  803b35:	53                   	push   %ebx
  803b36:	83 ec 1c             	sub    $0x1c,%esp
  803b39:	89 c7                	mov    %eax,%edi
  803b3b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803b3d:	a1 50 a0 80 00       	mov    0x80a050,%eax
  803b42:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803b45:	83 ec 0c             	sub    $0xc,%esp
  803b48:	57                   	push   %edi
  803b49:	e8 c8 fa ff ff       	call   803616 <pageref>
  803b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803b51:	89 34 24             	mov    %esi,(%esp)
  803b54:	e8 bd fa ff ff       	call   803616 <pageref>
		nn = thisenv->env_runs;
  803b59:	8b 15 50 a0 80 00    	mov    0x80a050,%edx
  803b5f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803b62:	83 c4 10             	add    $0x10,%esp
  803b65:	39 cb                	cmp    %ecx,%ebx
  803b67:	74 1b                	je     803b84 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803b69:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803b6c:	75 cf                	jne    803b3d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b6e:	8b 42 58             	mov    0x58(%edx),%eax
  803b71:	6a 01                	push   $0x1
  803b73:	50                   	push   %eax
  803b74:	53                   	push   %ebx
  803b75:	68 7e 4d 80 00       	push   $0x804d7e
  803b7a:	e8 b4 e2 ff ff       	call   801e33 <cprintf>
  803b7f:	83 c4 10             	add    $0x10,%esp
  803b82:	eb b9                	jmp    803b3d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803b84:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803b87:	0f 94 c0             	sete   %al
  803b8a:	0f b6 c0             	movzbl %al,%eax
}
  803b8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803b90:	5b                   	pop    %ebx
  803b91:	5e                   	pop    %esi
  803b92:	5f                   	pop    %edi
  803b93:	5d                   	pop    %ebp
  803b94:	c3                   	ret    

00803b95 <devpipe_write>:
{
  803b95:	55                   	push   %ebp
  803b96:	89 e5                	mov    %esp,%ebp
  803b98:	57                   	push   %edi
  803b99:	56                   	push   %esi
  803b9a:	53                   	push   %ebx
  803b9b:	83 ec 28             	sub    $0x28,%esp
  803b9e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803ba1:	56                   	push   %esi
  803ba2:	e8 53 f2 ff ff       	call   802dfa <fd2data>
  803ba7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803ba9:	83 c4 10             	add    $0x10,%esp
  803bac:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803bb4:	74 4f                	je     803c05 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bb6:	8b 43 04             	mov    0x4(%ebx),%eax
  803bb9:	8b 0b                	mov    (%ebx),%ecx
  803bbb:	8d 51 20             	lea    0x20(%ecx),%edx
  803bbe:	39 d0                	cmp    %edx,%eax
  803bc0:	72 14                	jb     803bd6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803bc2:	89 da                	mov    %ebx,%edx
  803bc4:	89 f0                	mov    %esi,%eax
  803bc6:	e8 65 ff ff ff       	call   803b30 <_pipeisclosed>
  803bcb:	85 c0                	test   %eax,%eax
  803bcd:	75 3b                	jne    803c0a <devpipe_write+0x75>
			sys_yield();
  803bcf:	e8 91 ed ff ff       	call   802965 <sys_yield>
  803bd4:	eb e0                	jmp    803bb6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803bd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803bd9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803bdd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803be0:	89 c2                	mov    %eax,%edx
  803be2:	c1 fa 1f             	sar    $0x1f,%edx
  803be5:	89 d1                	mov    %edx,%ecx
  803be7:	c1 e9 1b             	shr    $0x1b,%ecx
  803bea:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803bed:	83 e2 1f             	and    $0x1f,%edx
  803bf0:	29 ca                	sub    %ecx,%edx
  803bf2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803bf6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803bfa:	83 c0 01             	add    $0x1,%eax
  803bfd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803c00:	83 c7 01             	add    $0x1,%edi
  803c03:	eb ac                	jmp    803bb1 <devpipe_write+0x1c>
	return i;
  803c05:	8b 45 10             	mov    0x10(%ebp),%eax
  803c08:	eb 05                	jmp    803c0f <devpipe_write+0x7a>
				return 0;
  803c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803c12:	5b                   	pop    %ebx
  803c13:	5e                   	pop    %esi
  803c14:	5f                   	pop    %edi
  803c15:	5d                   	pop    %ebp
  803c16:	c3                   	ret    

00803c17 <devpipe_read>:
{
  803c17:	55                   	push   %ebp
  803c18:	89 e5                	mov    %esp,%ebp
  803c1a:	57                   	push   %edi
  803c1b:	56                   	push   %esi
  803c1c:	53                   	push   %ebx
  803c1d:	83 ec 18             	sub    $0x18,%esp
  803c20:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803c23:	57                   	push   %edi
  803c24:	e8 d1 f1 ff ff       	call   802dfa <fd2data>
  803c29:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803c2b:	83 c4 10             	add    $0x10,%esp
  803c2e:	be 00 00 00 00       	mov    $0x0,%esi
  803c33:	3b 75 10             	cmp    0x10(%ebp),%esi
  803c36:	75 14                	jne    803c4c <devpipe_read+0x35>
	return i;
  803c38:	8b 45 10             	mov    0x10(%ebp),%eax
  803c3b:	eb 02                	jmp    803c3f <devpipe_read+0x28>
				return i;
  803c3d:	89 f0                	mov    %esi,%eax
}
  803c3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803c42:	5b                   	pop    %ebx
  803c43:	5e                   	pop    %esi
  803c44:	5f                   	pop    %edi
  803c45:	5d                   	pop    %ebp
  803c46:	c3                   	ret    
			sys_yield();
  803c47:	e8 19 ed ff ff       	call   802965 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803c4c:	8b 03                	mov    (%ebx),%eax
  803c4e:	3b 43 04             	cmp    0x4(%ebx),%eax
  803c51:	75 18                	jne    803c6b <devpipe_read+0x54>
			if (i > 0)
  803c53:	85 f6                	test   %esi,%esi
  803c55:	75 e6                	jne    803c3d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  803c57:	89 da                	mov    %ebx,%edx
  803c59:	89 f8                	mov    %edi,%eax
  803c5b:	e8 d0 fe ff ff       	call   803b30 <_pipeisclosed>
  803c60:	85 c0                	test   %eax,%eax
  803c62:	74 e3                	je     803c47 <devpipe_read+0x30>
				return 0;
  803c64:	b8 00 00 00 00       	mov    $0x0,%eax
  803c69:	eb d4                	jmp    803c3f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c6b:	99                   	cltd   
  803c6c:	c1 ea 1b             	shr    $0x1b,%edx
  803c6f:	01 d0                	add    %edx,%eax
  803c71:	83 e0 1f             	and    $0x1f,%eax
  803c74:	29 d0                	sub    %edx,%eax
  803c76:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803c7e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803c81:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803c84:	83 c6 01             	add    $0x1,%esi
  803c87:	eb aa                	jmp    803c33 <devpipe_read+0x1c>

00803c89 <pipe>:
{
  803c89:	55                   	push   %ebp
  803c8a:	89 e5                	mov    %esp,%ebp
  803c8c:	56                   	push   %esi
  803c8d:	53                   	push   %ebx
  803c8e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803c91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803c94:	50                   	push   %eax
  803c95:	e8 77 f1 ff ff       	call   802e11 <fd_alloc>
  803c9a:	89 c3                	mov    %eax,%ebx
  803c9c:	83 c4 10             	add    $0x10,%esp
  803c9f:	85 c0                	test   %eax,%eax
  803ca1:	0f 88 23 01 00 00    	js     803dca <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ca7:	83 ec 04             	sub    $0x4,%esp
  803caa:	68 07 04 00 00       	push   $0x407
  803caf:	ff 75 f4             	pushl  -0xc(%ebp)
  803cb2:	6a 00                	push   $0x0
  803cb4:	e8 cb ec ff ff       	call   802984 <sys_page_alloc>
  803cb9:	89 c3                	mov    %eax,%ebx
  803cbb:	83 c4 10             	add    $0x10,%esp
  803cbe:	85 c0                	test   %eax,%eax
  803cc0:	0f 88 04 01 00 00    	js     803dca <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  803cc6:	83 ec 0c             	sub    $0xc,%esp
  803cc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803ccc:	50                   	push   %eax
  803ccd:	e8 3f f1 ff ff       	call   802e11 <fd_alloc>
  803cd2:	89 c3                	mov    %eax,%ebx
  803cd4:	83 c4 10             	add    $0x10,%esp
  803cd7:	85 c0                	test   %eax,%eax
  803cd9:	0f 88 db 00 00 00    	js     803dba <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cdf:	83 ec 04             	sub    $0x4,%esp
  803ce2:	68 07 04 00 00       	push   $0x407
  803ce7:	ff 75 f0             	pushl  -0x10(%ebp)
  803cea:	6a 00                	push   $0x0
  803cec:	e8 93 ec ff ff       	call   802984 <sys_page_alloc>
  803cf1:	89 c3                	mov    %eax,%ebx
  803cf3:	83 c4 10             	add    $0x10,%esp
  803cf6:	85 c0                	test   %eax,%eax
  803cf8:	0f 88 bc 00 00 00    	js     803dba <pipe+0x131>
	va = fd2data(fd0);
  803cfe:	83 ec 0c             	sub    $0xc,%esp
  803d01:	ff 75 f4             	pushl  -0xc(%ebp)
  803d04:	e8 f1 f0 ff ff       	call   802dfa <fd2data>
  803d09:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d0b:	83 c4 0c             	add    $0xc,%esp
  803d0e:	68 07 04 00 00       	push   $0x407
  803d13:	50                   	push   %eax
  803d14:	6a 00                	push   $0x0
  803d16:	e8 69 ec ff ff       	call   802984 <sys_page_alloc>
  803d1b:	89 c3                	mov    %eax,%ebx
  803d1d:	83 c4 10             	add    $0x10,%esp
  803d20:	85 c0                	test   %eax,%eax
  803d22:	0f 88 82 00 00 00    	js     803daa <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d28:	83 ec 0c             	sub    $0xc,%esp
  803d2b:	ff 75 f0             	pushl  -0x10(%ebp)
  803d2e:	e8 c7 f0 ff ff       	call   802dfa <fd2data>
  803d33:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803d3a:	50                   	push   %eax
  803d3b:	6a 00                	push   $0x0
  803d3d:	56                   	push   %esi
  803d3e:	6a 00                	push   $0x0
  803d40:	e8 82 ec ff ff       	call   8029c7 <sys_page_map>
  803d45:	89 c3                	mov    %eax,%ebx
  803d47:	83 c4 20             	add    $0x20,%esp
  803d4a:	85 c0                	test   %eax,%eax
  803d4c:	78 4e                	js     803d9c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  803d4e:	a1 9c 90 80 00       	mov    0x80909c,%eax
  803d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d56:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d5b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  803d62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d65:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d6a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803d71:	83 ec 0c             	sub    $0xc,%esp
  803d74:	ff 75 f4             	pushl  -0xc(%ebp)
  803d77:	e8 6e f0 ff ff       	call   802dea <fd2num>
  803d7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803d7f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803d81:	83 c4 04             	add    $0x4,%esp
  803d84:	ff 75 f0             	pushl  -0x10(%ebp)
  803d87:	e8 5e f0 ff ff       	call   802dea <fd2num>
  803d8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803d8f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803d92:	83 c4 10             	add    $0x10,%esp
  803d95:	bb 00 00 00 00       	mov    $0x0,%ebx
  803d9a:	eb 2e                	jmp    803dca <pipe+0x141>
	sys_page_unmap(0, va);
  803d9c:	83 ec 08             	sub    $0x8,%esp
  803d9f:	56                   	push   %esi
  803da0:	6a 00                	push   $0x0
  803da2:	e8 62 ec ff ff       	call   802a09 <sys_page_unmap>
  803da7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803daa:	83 ec 08             	sub    $0x8,%esp
  803dad:	ff 75 f0             	pushl  -0x10(%ebp)
  803db0:	6a 00                	push   $0x0
  803db2:	e8 52 ec ff ff       	call   802a09 <sys_page_unmap>
  803db7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803dba:	83 ec 08             	sub    $0x8,%esp
  803dbd:	ff 75 f4             	pushl  -0xc(%ebp)
  803dc0:	6a 00                	push   $0x0
  803dc2:	e8 42 ec ff ff       	call   802a09 <sys_page_unmap>
  803dc7:	83 c4 10             	add    $0x10,%esp
}
  803dca:	89 d8                	mov    %ebx,%eax
  803dcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803dcf:	5b                   	pop    %ebx
  803dd0:	5e                   	pop    %esi
  803dd1:	5d                   	pop    %ebp
  803dd2:	c3                   	ret    

00803dd3 <pipeisclosed>:
{
  803dd3:	55                   	push   %ebp
  803dd4:	89 e5                	mov    %esp,%ebp
  803dd6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ddc:	50                   	push   %eax
  803ddd:	ff 75 08             	pushl  0x8(%ebp)
  803de0:	e8 7e f0 ff ff       	call   802e63 <fd_lookup>
  803de5:	83 c4 10             	add    $0x10,%esp
  803de8:	85 c0                	test   %eax,%eax
  803dea:	78 18                	js     803e04 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803dec:	83 ec 0c             	sub    $0xc,%esp
  803def:	ff 75 f4             	pushl  -0xc(%ebp)
  803df2:	e8 03 f0 ff ff       	call   802dfa <fd2data>
	return _pipeisclosed(fd, p);
  803df7:	89 c2                	mov    %eax,%edx
  803df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfc:	e8 2f fd ff ff       	call   803b30 <_pipeisclosed>
  803e01:	83 c4 10             	add    $0x10,%esp
}
  803e04:	c9                   	leave  
  803e05:	c3                   	ret    

00803e06 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  803e06:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0b:	c3                   	ret    

00803e0c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e0c:	55                   	push   %ebp
  803e0d:	89 e5                	mov    %esp,%ebp
  803e0f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803e12:	68 96 4d 80 00       	push   $0x804d96
  803e17:	ff 75 0c             	pushl  0xc(%ebp)
  803e1a:	e8 73 e7 ff ff       	call   802592 <strcpy>
	return 0;
}
  803e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  803e24:	c9                   	leave  
  803e25:	c3                   	ret    

00803e26 <devcons_write>:
{
  803e26:	55                   	push   %ebp
  803e27:	89 e5                	mov    %esp,%ebp
  803e29:	57                   	push   %edi
  803e2a:	56                   	push   %esi
  803e2b:	53                   	push   %ebx
  803e2c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  803e32:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803e37:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803e3d:	3b 75 10             	cmp    0x10(%ebp),%esi
  803e40:	73 31                	jae    803e73 <devcons_write+0x4d>
		m = n - tot;
  803e42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803e45:	29 f3                	sub    %esi,%ebx
  803e47:	83 fb 7f             	cmp    $0x7f,%ebx
  803e4a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803e4f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803e52:	83 ec 04             	sub    $0x4,%esp
  803e55:	53                   	push   %ebx
  803e56:	89 f0                	mov    %esi,%eax
  803e58:	03 45 0c             	add    0xc(%ebp),%eax
  803e5b:	50                   	push   %eax
  803e5c:	57                   	push   %edi
  803e5d:	e8 be e8 ff ff       	call   802720 <memmove>
		sys_cputs(buf, m);
  803e62:	83 c4 08             	add    $0x8,%esp
  803e65:	53                   	push   %ebx
  803e66:	57                   	push   %edi
  803e67:	e8 5c ea ff ff       	call   8028c8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803e6c:	01 de                	add    %ebx,%esi
  803e6e:	83 c4 10             	add    $0x10,%esp
  803e71:	eb ca                	jmp    803e3d <devcons_write+0x17>
}
  803e73:	89 f0                	mov    %esi,%eax
  803e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803e78:	5b                   	pop    %ebx
  803e79:	5e                   	pop    %esi
  803e7a:	5f                   	pop    %edi
  803e7b:	5d                   	pop    %ebp
  803e7c:	c3                   	ret    

00803e7d <devcons_read>:
{
  803e7d:	55                   	push   %ebp
  803e7e:	89 e5                	mov    %esp,%ebp
  803e80:	83 ec 08             	sub    $0x8,%esp
  803e83:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e8c:	74 21                	je     803eaf <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  803e8e:	e8 53 ea ff ff       	call   8028e6 <sys_cgetc>
  803e93:	85 c0                	test   %eax,%eax
  803e95:	75 07                	jne    803e9e <devcons_read+0x21>
		sys_yield();
  803e97:	e8 c9 ea ff ff       	call   802965 <sys_yield>
  803e9c:	eb f0                	jmp    803e8e <devcons_read+0x11>
	if (c < 0)
  803e9e:	78 0f                	js     803eaf <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  803ea0:	83 f8 04             	cmp    $0x4,%eax
  803ea3:	74 0c                	je     803eb1 <devcons_read+0x34>
	*(char*)vbuf = c;
  803ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ea8:	88 02                	mov    %al,(%edx)
	return 1;
  803eaa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803eaf:	c9                   	leave  
  803eb0:	c3                   	ret    
		return 0;
  803eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb6:	eb f7                	jmp    803eaf <devcons_read+0x32>

00803eb8 <cputchar>:
{
  803eb8:	55                   	push   %ebp
  803eb9:	89 e5                	mov    %esp,%ebp
  803ebb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803ec4:	6a 01                	push   $0x1
  803ec6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803ec9:	50                   	push   %eax
  803eca:	e8 f9 e9 ff ff       	call   8028c8 <sys_cputs>
}
  803ecf:	83 c4 10             	add    $0x10,%esp
  803ed2:	c9                   	leave  
  803ed3:	c3                   	ret    

00803ed4 <getchar>:
{
  803ed4:	55                   	push   %ebp
  803ed5:	89 e5                	mov    %esp,%ebp
  803ed7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803eda:	6a 01                	push   $0x1
  803edc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803edf:	50                   	push   %eax
  803ee0:	6a 00                	push   $0x0
  803ee2:	e8 ec f1 ff ff       	call   8030d3 <read>
	if (r < 0)
  803ee7:	83 c4 10             	add    $0x10,%esp
  803eea:	85 c0                	test   %eax,%eax
  803eec:	78 06                	js     803ef4 <getchar+0x20>
	if (r < 1)
  803eee:	74 06                	je     803ef6 <getchar+0x22>
	return c;
  803ef0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803ef4:	c9                   	leave  
  803ef5:	c3                   	ret    
		return -E_EOF;
  803ef6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803efb:	eb f7                	jmp    803ef4 <getchar+0x20>

00803efd <iscons>:
{
  803efd:	55                   	push   %ebp
  803efe:	89 e5                	mov    %esp,%ebp
  803f00:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f06:	50                   	push   %eax
  803f07:	ff 75 08             	pushl  0x8(%ebp)
  803f0a:	e8 54 ef ff ff       	call   802e63 <fd_lookup>
  803f0f:	83 c4 10             	add    $0x10,%esp
  803f12:	85 c0                	test   %eax,%eax
  803f14:	78 11                	js     803f27 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f19:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803f1f:	39 10                	cmp    %edx,(%eax)
  803f21:	0f 94 c0             	sete   %al
  803f24:	0f b6 c0             	movzbl %al,%eax
}
  803f27:	c9                   	leave  
  803f28:	c3                   	ret    

00803f29 <opencons>:
{
  803f29:	55                   	push   %ebp
  803f2a:	89 e5                	mov    %esp,%ebp
  803f2c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803f2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f32:	50                   	push   %eax
  803f33:	e8 d9 ee ff ff       	call   802e11 <fd_alloc>
  803f38:	83 c4 10             	add    $0x10,%esp
  803f3b:	85 c0                	test   %eax,%eax
  803f3d:	78 3a                	js     803f79 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f3f:	83 ec 04             	sub    $0x4,%esp
  803f42:	68 07 04 00 00       	push   $0x407
  803f47:	ff 75 f4             	pushl  -0xc(%ebp)
  803f4a:	6a 00                	push   $0x0
  803f4c:	e8 33 ea ff ff       	call   802984 <sys_page_alloc>
  803f51:	83 c4 10             	add    $0x10,%esp
  803f54:	85 c0                	test   %eax,%eax
  803f56:	78 21                	js     803f79 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f5b:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803f61:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f66:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803f6d:	83 ec 0c             	sub    $0xc,%esp
  803f70:	50                   	push   %eax
  803f71:	e8 74 ee ff ff       	call   802dea <fd2num>
  803f76:	83 c4 10             	add    $0x10,%esp
}
  803f79:	c9                   	leave  
  803f7a:	c3                   	ret    
  803f7b:	66 90                	xchg   %ax,%ax
  803f7d:	66 90                	xchg   %ax,%ax
  803f7f:	90                   	nop

00803f80 <__udivdi3>:
  803f80:	55                   	push   %ebp
  803f81:	57                   	push   %edi
  803f82:	56                   	push   %esi
  803f83:	53                   	push   %ebx
  803f84:	83 ec 1c             	sub    $0x1c,%esp
  803f87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803f8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803f8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803f97:	85 d2                	test   %edx,%edx
  803f99:	75 4d                	jne    803fe8 <__udivdi3+0x68>
  803f9b:	39 f3                	cmp    %esi,%ebx
  803f9d:	76 19                	jbe    803fb8 <__udivdi3+0x38>
  803f9f:	31 ff                	xor    %edi,%edi
  803fa1:	89 e8                	mov    %ebp,%eax
  803fa3:	89 f2                	mov    %esi,%edx
  803fa5:	f7 f3                	div    %ebx
  803fa7:	89 fa                	mov    %edi,%edx
  803fa9:	83 c4 1c             	add    $0x1c,%esp
  803fac:	5b                   	pop    %ebx
  803fad:	5e                   	pop    %esi
  803fae:	5f                   	pop    %edi
  803faf:	5d                   	pop    %ebp
  803fb0:	c3                   	ret    
  803fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803fb8:	89 d9                	mov    %ebx,%ecx
  803fba:	85 db                	test   %ebx,%ebx
  803fbc:	75 0b                	jne    803fc9 <__udivdi3+0x49>
  803fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803fc3:	31 d2                	xor    %edx,%edx
  803fc5:	f7 f3                	div    %ebx
  803fc7:	89 c1                	mov    %eax,%ecx
  803fc9:	31 d2                	xor    %edx,%edx
  803fcb:	89 f0                	mov    %esi,%eax
  803fcd:	f7 f1                	div    %ecx
  803fcf:	89 c6                	mov    %eax,%esi
  803fd1:	89 e8                	mov    %ebp,%eax
  803fd3:	89 f7                	mov    %esi,%edi
  803fd5:	f7 f1                	div    %ecx
  803fd7:	89 fa                	mov    %edi,%edx
  803fd9:	83 c4 1c             	add    $0x1c,%esp
  803fdc:	5b                   	pop    %ebx
  803fdd:	5e                   	pop    %esi
  803fde:	5f                   	pop    %edi
  803fdf:	5d                   	pop    %ebp
  803fe0:	c3                   	ret    
  803fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803fe8:	39 f2                	cmp    %esi,%edx
  803fea:	77 1c                	ja     804008 <__udivdi3+0x88>
  803fec:	0f bd fa             	bsr    %edx,%edi
  803fef:	83 f7 1f             	xor    $0x1f,%edi
  803ff2:	75 2c                	jne    804020 <__udivdi3+0xa0>
  803ff4:	39 f2                	cmp    %esi,%edx
  803ff6:	72 06                	jb     803ffe <__udivdi3+0x7e>
  803ff8:	31 c0                	xor    %eax,%eax
  803ffa:	39 eb                	cmp    %ebp,%ebx
  803ffc:	77 a9                	ja     803fa7 <__udivdi3+0x27>
  803ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  804003:	eb a2                	jmp    803fa7 <__udivdi3+0x27>
  804005:	8d 76 00             	lea    0x0(%esi),%esi
  804008:	31 ff                	xor    %edi,%edi
  80400a:	31 c0                	xor    %eax,%eax
  80400c:	89 fa                	mov    %edi,%edx
  80400e:	83 c4 1c             	add    $0x1c,%esp
  804011:	5b                   	pop    %ebx
  804012:	5e                   	pop    %esi
  804013:	5f                   	pop    %edi
  804014:	5d                   	pop    %ebp
  804015:	c3                   	ret    
  804016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80401d:	8d 76 00             	lea    0x0(%esi),%esi
  804020:	89 f9                	mov    %edi,%ecx
  804022:	b8 20 00 00 00       	mov    $0x20,%eax
  804027:	29 f8                	sub    %edi,%eax
  804029:	d3 e2                	shl    %cl,%edx
  80402b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80402f:	89 c1                	mov    %eax,%ecx
  804031:	89 da                	mov    %ebx,%edx
  804033:	d3 ea                	shr    %cl,%edx
  804035:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  804039:	09 d1                	or     %edx,%ecx
  80403b:	89 f2                	mov    %esi,%edx
  80403d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804041:	89 f9                	mov    %edi,%ecx
  804043:	d3 e3                	shl    %cl,%ebx
  804045:	89 c1                	mov    %eax,%ecx
  804047:	d3 ea                	shr    %cl,%edx
  804049:	89 f9                	mov    %edi,%ecx
  80404b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80404f:	89 eb                	mov    %ebp,%ebx
  804051:	d3 e6                	shl    %cl,%esi
  804053:	89 c1                	mov    %eax,%ecx
  804055:	d3 eb                	shr    %cl,%ebx
  804057:	09 de                	or     %ebx,%esi
  804059:	89 f0                	mov    %esi,%eax
  80405b:	f7 74 24 08          	divl   0x8(%esp)
  80405f:	89 d6                	mov    %edx,%esi
  804061:	89 c3                	mov    %eax,%ebx
  804063:	f7 64 24 0c          	mull   0xc(%esp)
  804067:	39 d6                	cmp    %edx,%esi
  804069:	72 15                	jb     804080 <__udivdi3+0x100>
  80406b:	89 f9                	mov    %edi,%ecx
  80406d:	d3 e5                	shl    %cl,%ebp
  80406f:	39 c5                	cmp    %eax,%ebp
  804071:	73 04                	jae    804077 <__udivdi3+0xf7>
  804073:	39 d6                	cmp    %edx,%esi
  804075:	74 09                	je     804080 <__udivdi3+0x100>
  804077:	89 d8                	mov    %ebx,%eax
  804079:	31 ff                	xor    %edi,%edi
  80407b:	e9 27 ff ff ff       	jmp    803fa7 <__udivdi3+0x27>
  804080:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804083:	31 ff                	xor    %edi,%edi
  804085:	e9 1d ff ff ff       	jmp    803fa7 <__udivdi3+0x27>
  80408a:	66 90                	xchg   %ax,%ax
  80408c:	66 90                	xchg   %ax,%ax
  80408e:	66 90                	xchg   %ax,%ax

00804090 <__umoddi3>:
  804090:	55                   	push   %ebp
  804091:	57                   	push   %edi
  804092:	56                   	push   %esi
  804093:	53                   	push   %ebx
  804094:	83 ec 1c             	sub    $0x1c,%esp
  804097:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80409b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80409f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8040a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040a7:	89 da                	mov    %ebx,%edx
  8040a9:	85 c0                	test   %eax,%eax
  8040ab:	75 43                	jne    8040f0 <__umoddi3+0x60>
  8040ad:	39 df                	cmp    %ebx,%edi
  8040af:	76 17                	jbe    8040c8 <__umoddi3+0x38>
  8040b1:	89 f0                	mov    %esi,%eax
  8040b3:	f7 f7                	div    %edi
  8040b5:	89 d0                	mov    %edx,%eax
  8040b7:	31 d2                	xor    %edx,%edx
  8040b9:	83 c4 1c             	add    $0x1c,%esp
  8040bc:	5b                   	pop    %ebx
  8040bd:	5e                   	pop    %esi
  8040be:	5f                   	pop    %edi
  8040bf:	5d                   	pop    %ebp
  8040c0:	c3                   	ret    
  8040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8040c8:	89 fd                	mov    %edi,%ebp
  8040ca:	85 ff                	test   %edi,%edi
  8040cc:	75 0b                	jne    8040d9 <__umoddi3+0x49>
  8040ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8040d3:	31 d2                	xor    %edx,%edx
  8040d5:	f7 f7                	div    %edi
  8040d7:	89 c5                	mov    %eax,%ebp
  8040d9:	89 d8                	mov    %ebx,%eax
  8040db:	31 d2                	xor    %edx,%edx
  8040dd:	f7 f5                	div    %ebp
  8040df:	89 f0                	mov    %esi,%eax
  8040e1:	f7 f5                	div    %ebp
  8040e3:	89 d0                	mov    %edx,%eax
  8040e5:	eb d0                	jmp    8040b7 <__umoddi3+0x27>
  8040e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8040ee:	66 90                	xchg   %ax,%ax
  8040f0:	89 f1                	mov    %esi,%ecx
  8040f2:	39 d8                	cmp    %ebx,%eax
  8040f4:	76 0a                	jbe    804100 <__umoddi3+0x70>
  8040f6:	89 f0                	mov    %esi,%eax
  8040f8:	83 c4 1c             	add    $0x1c,%esp
  8040fb:	5b                   	pop    %ebx
  8040fc:	5e                   	pop    %esi
  8040fd:	5f                   	pop    %edi
  8040fe:	5d                   	pop    %ebp
  8040ff:	c3                   	ret    
  804100:	0f bd e8             	bsr    %eax,%ebp
  804103:	83 f5 1f             	xor    $0x1f,%ebp
  804106:	75 20                	jne    804128 <__umoddi3+0x98>
  804108:	39 d8                	cmp    %ebx,%eax
  80410a:	0f 82 b0 00 00 00    	jb     8041c0 <__umoddi3+0x130>
  804110:	39 f7                	cmp    %esi,%edi
  804112:	0f 86 a8 00 00 00    	jbe    8041c0 <__umoddi3+0x130>
  804118:	89 c8                	mov    %ecx,%eax
  80411a:	83 c4 1c             	add    $0x1c,%esp
  80411d:	5b                   	pop    %ebx
  80411e:	5e                   	pop    %esi
  80411f:	5f                   	pop    %edi
  804120:	5d                   	pop    %ebp
  804121:	c3                   	ret    
  804122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804128:	89 e9                	mov    %ebp,%ecx
  80412a:	ba 20 00 00 00       	mov    $0x20,%edx
  80412f:	29 ea                	sub    %ebp,%edx
  804131:	d3 e0                	shl    %cl,%eax
  804133:	89 44 24 08          	mov    %eax,0x8(%esp)
  804137:	89 d1                	mov    %edx,%ecx
  804139:	89 f8                	mov    %edi,%eax
  80413b:	d3 e8                	shr    %cl,%eax
  80413d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  804141:	89 54 24 04          	mov    %edx,0x4(%esp)
  804145:	8b 54 24 04          	mov    0x4(%esp),%edx
  804149:	09 c1                	or     %eax,%ecx
  80414b:	89 d8                	mov    %ebx,%eax
  80414d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804151:	89 e9                	mov    %ebp,%ecx
  804153:	d3 e7                	shl    %cl,%edi
  804155:	89 d1                	mov    %edx,%ecx
  804157:	d3 e8                	shr    %cl,%eax
  804159:	89 e9                	mov    %ebp,%ecx
  80415b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80415f:	d3 e3                	shl    %cl,%ebx
  804161:	89 c7                	mov    %eax,%edi
  804163:	89 d1                	mov    %edx,%ecx
  804165:	89 f0                	mov    %esi,%eax
  804167:	d3 e8                	shr    %cl,%eax
  804169:	89 e9                	mov    %ebp,%ecx
  80416b:	89 fa                	mov    %edi,%edx
  80416d:	d3 e6                	shl    %cl,%esi
  80416f:	09 d8                	or     %ebx,%eax
  804171:	f7 74 24 08          	divl   0x8(%esp)
  804175:	89 d1                	mov    %edx,%ecx
  804177:	89 f3                	mov    %esi,%ebx
  804179:	f7 64 24 0c          	mull   0xc(%esp)
  80417d:	89 c6                	mov    %eax,%esi
  80417f:	89 d7                	mov    %edx,%edi
  804181:	39 d1                	cmp    %edx,%ecx
  804183:	72 06                	jb     80418b <__umoddi3+0xfb>
  804185:	75 10                	jne    804197 <__umoddi3+0x107>
  804187:	39 c3                	cmp    %eax,%ebx
  804189:	73 0c                	jae    804197 <__umoddi3+0x107>
  80418b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80418f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  804193:	89 d7                	mov    %edx,%edi
  804195:	89 c6                	mov    %eax,%esi
  804197:	89 ca                	mov    %ecx,%edx
  804199:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80419e:	29 f3                	sub    %esi,%ebx
  8041a0:	19 fa                	sbb    %edi,%edx
  8041a2:	89 d0                	mov    %edx,%eax
  8041a4:	d3 e0                	shl    %cl,%eax
  8041a6:	89 e9                	mov    %ebp,%ecx
  8041a8:	d3 eb                	shr    %cl,%ebx
  8041aa:	d3 ea                	shr    %cl,%edx
  8041ac:	09 d8                	or     %ebx,%eax
  8041ae:	83 c4 1c             	add    $0x1c,%esp
  8041b1:	5b                   	pop    %ebx
  8041b2:	5e                   	pop    %esi
  8041b3:	5f                   	pop    %edi
  8041b4:	5d                   	pop    %ebp
  8041b5:	c3                   	ret    
  8041b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8041bd:	8d 76 00             	lea    0x0(%esi),%esi
  8041c0:	89 da                	mov    %ebx,%edx
  8041c2:	29 fe                	sub    %edi,%esi
  8041c4:	19 c2                	sbb    %eax,%edx
  8041c6:	89 f1                	mov    %esi,%ecx
  8041c8:	89 c8                	mov    %ecx,%eax
  8041ca:	e9 4b ff ff ff       	jmp    80411a <__umoddi3+0x8a>
