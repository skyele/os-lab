
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
  8000b0:	68 00 42 80 00       	push   $0x804200
  8000b5:	e8 7b 1d 00 00       	call   801e35 <cprintf>
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
  8000d9:	68 17 42 80 00       	push   $0x804217
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 27 42 80 00       	push   $0x804227
  8000e5:	e8 55 1c 00 00       	call   801d3f <_panic>

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
  80018f:	68 30 42 80 00       	push   $0x804230
  800194:	68 3d 42 80 00       	push   $0x80423d
  800199:	6a 44                	push   $0x44
  80019b:	68 27 42 80 00       	push   $0x804227
  8001a0:	e8 9a 1b 00 00       	call   801d3f <_panic>
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
  800257:	68 30 42 80 00       	push   $0x804230
  80025c:	68 3d 42 80 00       	push   $0x80423d
  800261:	6a 5d                	push   $0x5d
  800263:	68 27 42 80 00       	push   $0x804227
  800268:	e8 d2 1a 00 00       	call   801d3f <_panic>
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
  8002a1:	68 54 42 80 00       	push   $0x804254
  8002a6:	6a 0c                	push   $0xc
  8002a8:	68 30 43 80 00       	push   $0x804330
  8002ad:	e8 8d 1a 00 00       	call   801d3f <_panic>

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
  800377:	e8 4d 26 00 00       	call   8029c9 <sys_page_map>
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
  80038c:	68 38 43 80 00       	push   $0x804338
  800391:	6a 5a                	push   $0x5a
  800393:	68 30 43 80 00       	push   $0x804330
  800398:	e8 a2 19 00 00       	call   801d3f <_panic>
		panic("the ide_write panic!\n");
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 53 43 80 00       	push   $0x804353
  8003a5:	6a 64                	push   $0x64
  8003a7:	68 30 43 80 00       	push   $0x804330
  8003ac:	e8 8e 19 00 00       	call   801d3f <_panic>
		panic("the sys_page_map panic!\n");
  8003b1:	83 ec 04             	sub    $0x4,%esp
  8003b4:	68 69 43 80 00       	push   $0x804369
  8003b9:	6a 67                	push   $0x67
  8003bb:	68 30 43 80 00       	push   $0x804330
  8003c0:	e8 7a 19 00 00       	call   801d3f <_panic>

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
  8003d4:	e8 a2 28 00 00       	call   802c7b <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8003d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003e0:	e8 95 fe ff ff       	call   80027a <diskaddr>
  8003e5:	83 c4 0c             	add    $0xc,%esp
  8003e8:	68 08 01 00 00       	push   $0x108
  8003ed:	50                   	push   %eax
  8003ee:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8003f4:	50                   	push   %eax
  8003f5:	e8 28 23 00 00       	call   802722 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  8003fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800401:	e8 74 fe ff ff       	call   80027a <diskaddr>
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	68 82 43 80 00       	push   $0x804382
  80040e:	50                   	push   %eax
  80040f:	e8 80 21 00 00       	call   802594 <strcpy>
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
  800474:	e8 92 25 00 00       	call   802a0b <sys_page_unmap>
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
  8004a5:	68 82 43 80 00       	push   $0x804382
  8004aa:	50                   	push   %eax
  8004ab:	e8 8f 21 00 00       	call   80263f <strcmp>
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
  8004d5:	e8 48 22 00 00       	call   802722 <memmove>
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
  800504:	e8 19 22 00 00       	call   802722 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800509:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800510:	e8 65 fd ff ff       	call   80027a <diskaddr>
  800515:	83 c4 08             	add    $0x8,%esp
  800518:	68 82 43 80 00       	push   $0x804382
  80051d:	50                   	push   %eax
  80051e:	e8 71 20 00 00       	call   802594 <strcpy>
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
  800569:	e8 9d 24 00 00       	call   802a0b <sys_page_unmap>
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
  80059a:	68 82 43 80 00       	push   $0x804382
  80059f:	50                   	push   %eax
  8005a0:	e8 9a 20 00 00       	call   80263f <strcmp>
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
  8005ca:	e8 53 21 00 00       	call   802722 <memmove>
	flush_block(diskaddr(1));
  8005cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d6:	e8 9f fc ff ff       	call   80027a <diskaddr>
  8005db:	89 04 24             	mov    %eax,(%esp)
  8005de:	e8 2d fd ff ff       	call   800310 <flush_block>
	cprintf("block cache is good\n");
  8005e3:	c7 04 24 be 43 80 00 	movl   $0x8043be,(%esp)
  8005ea:	e8 46 18 00 00       	call   801e35 <cprintf>
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
  80060b:	e8 12 21 00 00       	call   802722 <memmove>
}
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800616:	c9                   	leave  
  800617:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800618:	68 a4 43 80 00       	push   $0x8043a4
  80061d:	68 3d 42 80 00       	push   $0x80423d
  800622:	6a 78                	push   $0x78
  800624:	68 30 43 80 00       	push   $0x804330
  800629:	e8 11 17 00 00       	call   801d3f <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80062e:	68 89 43 80 00       	push   $0x804389
  800633:	68 3d 42 80 00       	push   $0x80423d
  800638:	6a 79                	push   $0x79
  80063a:	68 30 43 80 00       	push   $0x804330
  80063f:	e8 fb 16 00 00       	call   801d3f <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800644:	68 a3 43 80 00       	push   $0x8043a3
  800649:	68 3d 42 80 00       	push   $0x80423d
  80064e:	6a 7d                	push   $0x7d
  800650:	68 30 43 80 00       	push   $0x804330
  800655:	e8 e5 16 00 00       	call   801d3f <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80065a:	68 78 42 80 00       	push   $0x804278
  80065f:	68 3d 42 80 00       	push   $0x80423d
  800664:	68 80 00 00 00       	push   $0x80
  800669:	68 30 43 80 00       	push   $0x804330
  80066e:	e8 cc 16 00 00       	call   801d3f <_panic>
	assert(va_is_mapped(diskaddr(1)));
  800673:	68 a4 43 80 00       	push   $0x8043a4
  800678:	68 3d 42 80 00       	push   $0x80423d
  80067d:	68 91 00 00 00       	push   $0x91
  800682:	68 30 43 80 00       	push   $0x804330
  800687:	e8 b3 16 00 00       	call   801d3f <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  80068c:	68 a3 43 80 00       	push   $0x8043a3
  800691:	68 3d 42 80 00       	push   $0x80423d
  800696:	68 99 00 00 00       	push   $0x99
  80069b:	68 30 43 80 00       	push   $0x804330
  8006a0:	e8 9a 16 00 00       	call   801d3f <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006a5:	68 78 42 80 00       	push   $0x804278
  8006aa:	68 3d 42 80 00       	push   $0x80423d
  8006af:	68 9c 00 00 00       	push   $0x9c
  8006b4:	68 30 43 80 00       	push   $0x804330
  8006b9:	e8 81 16 00 00       	call   801d3f <_panic>

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
  8006f2:	e8 22 25 00 00       	call   802c19 <sys_clear_access_bit>
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
  800762:	68 9c 42 80 00       	push   $0x80429c
  800767:	68 c1 00 00 00       	push   $0xc1
  80076c:	68 30 43 80 00       	push   $0x804330
  800771:	e8 c9 15 00 00       	call   801d3f <_panic>
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
  80080d:	e8 74 21 00 00       	call   802986 <sys_page_alloc>
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
  80084a:	e8 7a 21 00 00       	call   8029c9 <sys_page_map>
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
  80088c:	68 bc 42 80 00       	push   $0x8042bc
  800891:	6a 31                	push   $0x31
  800893:	68 30 43 80 00       	push   $0x804330
  800898:	e8 a2 14 00 00       	call   801d3f <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80089d:	56                   	push   %esi
  80089e:	68 ec 42 80 00       	push   $0x8042ec
  8008a3:	6a 34                	push   $0x34
  8008a5:	68 30 43 80 00       	push   $0x804330
  8008aa:	e8 90 14 00 00       	call   801d3f <_panic>
		panic("the sys_page_alloc panic!\n");
  8008af:	83 ec 04             	sub    $0x4,%esp
  8008b2:	68 d3 43 80 00       	push   $0x8043d3
  8008b7:	6a 3f                	push   $0x3f
  8008b9:	68 30 43 80 00       	push   $0x804330
  8008be:	e8 7c 14 00 00       	call   801d3f <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8008c3:	50                   	push   %eax
  8008c4:	68 10 43 80 00       	push   $0x804310
  8008c9:	6a 44                	push   $0x44
  8008cb:	68 30 43 80 00       	push   $0x804330
  8008d0:	e8 6a 14 00 00       	call   801d3f <_panic>
		panic("reading free block %08x\n", blockno);
  8008d5:	56                   	push   %esi
  8008d6:	68 ee 43 80 00       	push   $0x8043ee
  8008db:	6a 49                	push   $0x49
  8008dd:	68 30 43 80 00       	push   $0x804330
  8008e2:	e8 58 14 00 00       	call   801d3f <_panic>

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
  800906:	68 45 44 80 00       	push   $0x804445
  80090b:	e8 25 15 00 00       	call   801e35 <cprintf>
}
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	c9                   	leave  
  800914:	c3                   	ret    
		panic("bad file system magic number");
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 07 44 80 00       	push   $0x804407
  80091d:	6a 0f                	push   $0xf
  80091f:	68 24 44 80 00       	push   $0x804424
  800924:	e8 16 14 00 00       	call   801d3f <_panic>
		panic("file system is too large");
  800929:	83 ec 04             	sub    $0x4,%esp
  80092c:	68 2c 44 80 00       	push   $0x80442c
  800931:	6a 12                	push   $0x12
  800933:	68 24 44 80 00       	push   $0x804424
  800938:	e8 02 14 00 00       	call   801d3f <_panic>

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
  8009a5:	68 59 44 80 00       	push   $0x804459
  8009aa:	6a 2d                	push   $0x2d
  8009ac:	68 24 44 80 00       	push   $0x804424
  8009b1:	e8 89 13 00 00       	call   801d3f <_panic>

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
  800a8a:	e8 4b 1c 00 00       	call   8026da <memset>
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
  800b10:	68 74 44 80 00       	push   $0x804474
  800b15:	68 3d 42 80 00       	push   $0x80423d
  800b1a:	6a 5b                	push   $0x5b
  800b1c:	68 24 44 80 00       	push   $0x804424
  800b21:	e8 19 12 00 00       	call   801d3f <_panic>
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
  800b4b:	68 ac 44 80 00       	push   $0x8044ac
  800b50:	e8 e0 12 00 00       	call   801e35 <cprintf>
}
  800b55:	83 c4 10             	add    $0x10,%esp
  800b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    
	assert(!block_is_free(0));
  800b5f:	68 88 44 80 00       	push   $0x804488
  800b64:	68 3d 42 80 00       	push   $0x80423d
  800b69:	6a 5e                	push   $0x5e
  800b6b:	68 24 44 80 00       	push   $0x804424
  800b70:	e8 ca 11 00 00       	call   801d3f <_panic>
	assert(!block_is_free(1));
  800b75:	68 9a 44 80 00       	push   $0x80449a
  800b7a:	68 3d 42 80 00       	push   $0x80423d
  800b7f:	6a 5f                	push   $0x5f
  800b81:	68 24 44 80 00       	push   $0x804424
  800b86:	e8 b4 11 00 00       	call   801d3f <_panic>

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
  800cd1:	e8 4c 1a 00 00       	call   802722 <memmove>
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
  800d83:	e8 b7 18 00 00       	call   80263f <strcmp>
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
  800da6:	68 bc 44 80 00       	push   $0x8044bc
  800dab:	68 3d 42 80 00       	push   $0x80423d
  800db0:	68 d9 00 00 00       	push   $0xd9
  800db5:	68 24 44 80 00       	push   $0x804424
  800dba:	e8 80 0f 00 00       	call   801d3f <_panic>
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
  800df4:	e8 9b 17 00 00       	call   802594 <strcpy>
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
  800e85:	68 d9 44 80 00       	push   $0x8044d9
  800e8a:	e8 a6 0f 00 00       	call   801e35 <cprintf>
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
  800f3b:	e8 e2 17 00 00       	call   802722 <memmove>
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
  800fe4:	68 e6 44 80 00       	push   $0x8044e6
  800fe9:	e8 47 0e 00 00       	call   801e35 <cprintf>
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
  8010ad:	e8 70 16 00 00       	call   802722 <memmove>
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
  80122a:	68 bc 44 80 00       	push   $0x8044bc
  80122f:	68 3d 42 80 00       	push   $0x80423d
  801234:	68 f2 00 00 00       	push   $0xf2
  801239:	68 24 44 80 00       	push   $0x804424
  80123e:	e8 fc 0a 00 00       	call   801d3f <_panic>
				*file = &f[j];
  801243:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801259:	e8 36 13 00 00       	call   802594 <strcpy>
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
  80134b:	e8 ec 22 00 00       	call   80363c <pageref>
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
  801380:	e8 01 16 00 00       	call   802986 <sys_page_alloc>
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
  8013b1:	e8 24 13 00 00       	call   8026da <memset>
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
  8013ea:	e8 4d 22 00 00       	call   80363c <pageref>
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
  801526:	e8 69 10 00 00       	call   802594 <strcpy>
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
  8015b0:	e8 6d 11 00 00       	call   802722 <memmove>
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
  8016cf:	68 94 45 80 00       	push   $0x804594
  8016d4:	68 30 48 80 00       	push   $0x804830
  8016d9:	e8 57 07 00 00       	call   801e35 <cprintf>
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
  80173a:	68 68 45 80 00       	push   $0x804568
  80173f:	e8 f1 06 00 00       	call   801e35 <cprintf>
  801744:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801747:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80174c:	ff 75 f0             	pushl  -0x10(%ebp)
  80174f:	ff 75 ec             	pushl  -0x14(%ebp)
  801752:	50                   	push   %eax
  801753:	ff 75 f4             	pushl  -0xc(%ebp)
  801756:	e8 1e 16 00 00       	call   802d79 <ipc_send>
		sys_page_unmap(0, fsreq);
  80175b:	83 c4 08             	add    $0x8,%esp
  80175e:	ff 35 44 50 80 00    	pushl  0x805044
  801764:	6a 00                	push   $0x0
  801766:	e8 a0 12 00 00       	call   802a0b <sys_page_unmap>
  80176b:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  80176e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	53                   	push   %ebx
  801779:	ff 35 44 50 80 00    	pushl  0x805044
  80177f:	56                   	push   %esi
  801780:	e8 8b 15 00 00       	call   802d10 <ipc_recv>
		if (!(perm & PTE_P)) {
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  80178c:	0f 85 5a ff ff ff    	jne    8016ec <serve+0x25>
			cprintf("Invalid request from %08x: no argument page\n",
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	ff 75 f4             	pushl  -0xc(%ebp)
  801798:	68 38 45 80 00       	push   $0x804538
  80179d:	e8 93 06 00 00       	call   801e35 <cprintf>
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
  8017b5:	68 8c 45 80 00       	push   $0x80458c
  8017ba:	50                   	push   %eax
  8017bb:	68 03 45 80 00       	push   $0x804503
  8017c0:	e8 70 06 00 00       	call   801e35 <cprintf>
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8017c5:	c7 05 60 90 80 00 15 	movl   $0x804515,0x809060
  8017cc:	45 80 00 
	cprintf("FS is running\n");
  8017cf:	c7 04 24 18 45 80 00 	movl   $0x804518,(%esp)
  8017d6:	e8 5a 06 00 00       	call   801e35 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8017db:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8017e0:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8017e5:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8017e7:	c7 04 24 27 45 80 00 	movl   $0x804527,(%esp)
  8017ee:	e8 42 06 00 00       	call   801e35 <cprintf>

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
  801809:	68 cc 47 80 00       	push   $0x8047cc
  80180e:	68 30 48 80 00       	push   $0x804830
  801813:	e8 1d 06 00 00       	call   801e35 <cprintf>
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801818:	83 c4 0c             	add    $0xc,%esp
  80181b:	6a 07                	push   $0x7
  80181d:	68 00 10 00 00       	push   $0x1000
  801822:	6a 00                	push   $0x0
  801824:	e8 5d 11 00 00       	call   802986 <sys_page_alloc>
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
  801847:	e8 d6 0e 00 00       	call   802722 <memmove>
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
  80189b:	68 e2 45 80 00       	push   $0x8045e2
  8018a0:	e8 90 05 00 00       	call   801e35 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8018a5:	83 c4 08             	add    $0x8,%esp
  8018a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ab:	50                   	push   %eax
  8018ac:	68 f7 45 80 00       	push   $0x8045f7
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
  8018d5:	68 1b 46 80 00       	push   $0x80461b
  8018da:	e8 9b f5 ff ff       	call   800e7a <file_open>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	0f 88 28 02 00 00    	js     801b12 <fs_test+0x310>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  8018ea:	83 ec 0c             	sub    $0xc,%esp
  8018ed:	68 3b 46 80 00       	push   $0x80463b
  8018f2:	e8 3e 05 00 00       	call   801e35 <cprintf>

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
  801916:	68 80 47 80 00       	push   $0x804780
  80191b:	ff 75 f0             	pushl  -0x10(%ebp)
  80191e:	e8 1c 0d 00 00       	call   80263f <strcmp>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	0f 85 08 02 00 00    	jne    801b36 <fs_test+0x334>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	68 61 46 80 00       	push   $0x804661
  801936:	e8 fa 04 00 00       	call   801e35 <cprintf>

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
  801981:	68 95 46 80 00       	push   $0x804695
  801986:	e8 aa 04 00 00       	call   801e35 <cprintf>

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
  8019c8:	68 e9 46 80 00       	push   $0x8046e9
  8019cd:	e8 63 04 00 00       	call   801e35 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8019d2:	c7 04 24 80 47 80 00 	movl   $0x804780,(%esp)
  8019d9:	e8 7d 0b 00 00       	call   80255b <strlen>
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
  801a2a:	68 80 47 80 00       	push   $0x804780
  801a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a32:	e8 5d 0b 00 00       	call   802594 <strcpy>
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
  801a8a:	68 29 47 80 00       	push   $0x804729
  801a8f:	e8 a1 03 00 00       	call   801e35 <cprintf>
}
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801a9c:	50                   	push   %eax
  801a9d:	68 9a 45 80 00       	push   $0x80459a
  801aa2:	6a 13                	push   $0x13
  801aa4:	68 ad 45 80 00       	push   $0x8045ad
  801aa9:	e8 91 02 00 00       	call   801d3f <_panic>
		panic("alloc_block: %e", r);
  801aae:	50                   	push   %eax
  801aaf:	68 b7 45 80 00       	push   $0x8045b7
  801ab4:	6a 18                	push   $0x18
  801ab6:	68 ad 45 80 00       	push   $0x8045ad
  801abb:	e8 7f 02 00 00       	call   801d3f <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801ac0:	68 c7 45 80 00       	push   $0x8045c7
  801ac5:	68 3d 42 80 00       	push   $0x80423d
  801aca:	6a 1a                	push   $0x1a
  801acc:	68 ad 45 80 00       	push   $0x8045ad
  801ad1:	e8 69 02 00 00       	call   801d3f <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801ad6:	68 40 47 80 00       	push   $0x804740
  801adb:	68 3d 42 80 00       	push   $0x80423d
  801ae0:	6a 1c                	push   $0x1c
  801ae2:	68 ad 45 80 00       	push   $0x8045ad
  801ae7:	e8 53 02 00 00       	call   801d3f <_panic>
		panic("file_open /not-found: %e", r);
  801aec:	50                   	push   %eax
  801aed:	68 02 46 80 00       	push   $0x804602
  801af2:	6a 20                	push   $0x20
  801af4:	68 ad 45 80 00       	push   $0x8045ad
  801af9:	e8 41 02 00 00       	call   801d3f <_panic>
		panic("file_open /not-found succeeded!");
  801afe:	83 ec 04             	sub    $0x4,%esp
  801b01:	68 60 47 80 00       	push   $0x804760
  801b06:	6a 22                	push   $0x22
  801b08:	68 ad 45 80 00       	push   $0x8045ad
  801b0d:	e8 2d 02 00 00       	call   801d3f <_panic>
		panic("file_open /newmotd: %e", r);
  801b12:	50                   	push   %eax
  801b13:	68 24 46 80 00       	push   $0x804624
  801b18:	6a 24                	push   $0x24
  801b1a:	68 ad 45 80 00       	push   $0x8045ad
  801b1f:	e8 1b 02 00 00       	call   801d3f <_panic>
		panic("file_get_block: %e", r);
  801b24:	50                   	push   %eax
  801b25:	68 4e 46 80 00       	push   $0x80464e
  801b2a:	6a 28                	push   $0x28
  801b2c:	68 ad 45 80 00       	push   $0x8045ad
  801b31:	e8 09 02 00 00       	call   801d3f <_panic>
		panic("file_get_block returned wrong data");
  801b36:	83 ec 04             	sub    $0x4,%esp
  801b39:	68 a8 47 80 00       	push   $0x8047a8
  801b3e:	6a 2a                	push   $0x2a
  801b40:	68 ad 45 80 00       	push   $0x8045ad
  801b45:	e8 f5 01 00 00       	call   801d3f <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b4a:	68 7a 46 80 00       	push   $0x80467a
  801b4f:	68 3d 42 80 00       	push   $0x80423d
  801b54:	6a 2e                	push   $0x2e
  801b56:	68 ad 45 80 00       	push   $0x8045ad
  801b5b:	e8 df 01 00 00       	call   801d3f <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b60:	68 79 46 80 00       	push   $0x804679
  801b65:	68 3d 42 80 00       	push   $0x80423d
  801b6a:	6a 30                	push   $0x30
  801b6c:	68 ad 45 80 00       	push   $0x8045ad
  801b71:	e8 c9 01 00 00       	call   801d3f <_panic>
		panic("file_set_size: %e", r);
  801b76:	50                   	push   %eax
  801b77:	68 a9 46 80 00       	push   $0x8046a9
  801b7c:	6a 34                	push   $0x34
  801b7e:	68 ad 45 80 00       	push   $0x8045ad
  801b83:	e8 b7 01 00 00       	call   801d3f <_panic>
	assert(f->f_direct[0] == 0);
  801b88:	68 bb 46 80 00       	push   $0x8046bb
  801b8d:	68 3d 42 80 00       	push   $0x80423d
  801b92:	6a 35                	push   $0x35
  801b94:	68 ad 45 80 00       	push   $0x8045ad
  801b99:	e8 a1 01 00 00       	call   801d3f <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b9e:	68 cf 46 80 00       	push   $0x8046cf
  801ba3:	68 3d 42 80 00       	push   $0x80423d
  801ba8:	6a 36                	push   $0x36
  801baa:	68 ad 45 80 00       	push   $0x8045ad
  801baf:	e8 8b 01 00 00       	call   801d3f <_panic>
		panic("file_set_size 2: %e", r);
  801bb4:	50                   	push   %eax
  801bb5:	68 00 47 80 00       	push   $0x804700
  801bba:	6a 3a                	push   $0x3a
  801bbc:	68 ad 45 80 00       	push   $0x8045ad
  801bc1:	e8 79 01 00 00       	call   801d3f <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801bc6:	68 cf 46 80 00       	push   $0x8046cf
  801bcb:	68 3d 42 80 00       	push   $0x80423d
  801bd0:	6a 3b                	push   $0x3b
  801bd2:	68 ad 45 80 00       	push   $0x8045ad
  801bd7:	e8 63 01 00 00       	call   801d3f <_panic>
		panic("file_get_block 2: %e", r);
  801bdc:	50                   	push   %eax
  801bdd:	68 14 47 80 00       	push   $0x804714
  801be2:	6a 3d                	push   $0x3d
  801be4:	68 ad 45 80 00       	push   $0x8045ad
  801be9:	e8 51 01 00 00       	call   801d3f <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801bee:	68 7a 46 80 00       	push   $0x80467a
  801bf3:	68 3d 42 80 00       	push   $0x80423d
  801bf8:	6a 3f                	push   $0x3f
  801bfa:	68 ad 45 80 00       	push   $0x8045ad
  801bff:	e8 3b 01 00 00       	call   801d3f <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801c04:	68 79 46 80 00       	push   $0x804679
  801c09:	68 3d 42 80 00       	push   $0x80423d
  801c0e:	6a 41                	push   $0x41
  801c10:	68 ad 45 80 00       	push   $0x8045ad
  801c15:	e8 25 01 00 00       	call   801d3f <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c1a:	68 cf 46 80 00       	push   $0x8046cf
  801c1f:	68 3d 42 80 00       	push   $0x80423d
  801c24:	6a 42                	push   $0x42
  801c26:	68 ad 45 80 00       	push   $0x8045ad
  801c2b:	e8 0f 01 00 00       	call   801d3f <_panic>

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
  801c43:	e8 00 0d 00 00       	call   802948 <sys_getenvid>
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
  801c68:	74 23                	je     801c8d <libmain+0x5d>
		if(envs[i].env_id == find)
  801c6a:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  801c70:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  801c76:	8b 49 48             	mov    0x48(%ecx),%ecx
  801c79:	39 c1                	cmp    %eax,%ecx
  801c7b:	75 e2                	jne    801c5f <libmain+0x2f>
  801c7d:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  801c83:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801c89:	89 fe                	mov    %edi,%esi
  801c8b:	eb d2                	jmp    801c5f <libmain+0x2f>
  801c8d:	89 f0                	mov    %esi,%eax
  801c8f:	84 c0                	test   %al,%al
  801c91:	74 06                	je     801c99 <libmain+0x69>
  801c93:	89 1d 50 a0 80 00    	mov    %ebx,0x80a050
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801c99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c9d:	7e 0a                	jle    801ca9 <libmain+0x79>
		binaryname = argv[0];
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	8b 00                	mov    (%eax),%eax
  801ca4:	a3 60 90 80 00       	mov    %eax,0x809060

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  801ca9:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801cae:	8b 40 48             	mov    0x48(%eax),%eax
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	50                   	push   %eax
  801cb5:	68 d4 47 80 00       	push   $0x8047d4
  801cba:	e8 76 01 00 00       	call   801e35 <cprintf>
	cprintf("before umain\n");
  801cbf:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  801cc6:	e8 6a 01 00 00       	call   801e35 <cprintf>
	// call user main routine
	umain(argc, argv);
  801ccb:	83 c4 08             	add    $0x8,%esp
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	e8 ce fa ff ff       	call   8017a7 <umain>
	cprintf("after umain\n");
  801cd9:	c7 04 24 00 48 80 00 	movl   $0x804800,(%esp)
  801ce0:	e8 50 01 00 00       	call   801e35 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  801ce5:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801cea:	8b 40 48             	mov    0x48(%eax),%eax
  801ced:	83 c4 08             	add    $0x8,%esp
  801cf0:	50                   	push   %eax
  801cf1:	68 0d 48 80 00       	push   $0x80480d
  801cf6:	e8 3a 01 00 00       	call   801e35 <cprintf>
	// exit gracefully
	exit();
  801cfb:	e8 0b 00 00 00       	call   801d0b <exit>
}
  801d00:	83 c4 10             	add    $0x10,%esp
  801d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d06:	5b                   	pop    %ebx
  801d07:	5e                   	pop    %esi
  801d08:	5f                   	pop    %edi
  801d09:	5d                   	pop    %ebp
  801d0a:	c3                   	ret    

00801d0b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801d11:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801d16:	8b 40 48             	mov    0x48(%eax),%eax
  801d19:	68 38 48 80 00       	push   $0x804838
  801d1e:	50                   	push   %eax
  801d1f:	68 2c 48 80 00       	push   $0x80482c
  801d24:	e8 0c 01 00 00       	call   801e35 <cprintf>
	close_all();
  801d29:	e8 ba 12 00 00       	call   802fe8 <close_all>
	sys_env_destroy(0);
  801d2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d35:	e8 cd 0b 00 00       	call   802907 <sys_env_destroy>
}
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801d44:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801d49:	8b 40 48             	mov    0x48(%eax),%eax
  801d4c:	83 ec 04             	sub    $0x4,%esp
  801d4f:	68 64 48 80 00       	push   $0x804864
  801d54:	50                   	push   %eax
  801d55:	68 2c 48 80 00       	push   $0x80482c
  801d5a:	e8 d6 00 00 00       	call   801e35 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  801d5f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d62:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801d68:	e8 db 0b 00 00       	call   802948 <sys_getenvid>
  801d6d:	83 c4 04             	add    $0x4,%esp
  801d70:	ff 75 0c             	pushl  0xc(%ebp)
  801d73:	ff 75 08             	pushl  0x8(%ebp)
  801d76:	56                   	push   %esi
  801d77:	50                   	push   %eax
  801d78:	68 40 48 80 00       	push   $0x804840
  801d7d:	e8 b3 00 00 00       	call   801e35 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d82:	83 c4 18             	add    $0x18,%esp
  801d85:	53                   	push   %ebx
  801d86:	ff 75 10             	pushl  0x10(%ebp)
  801d89:	e8 56 00 00 00       	call   801de4 <vcprintf>
	cprintf("\n");
  801d8e:	c7 04 24 87 43 80 00 	movl   $0x804387,(%esp)
  801d95:	e8 9b 00 00 00       	call   801e35 <cprintf>
  801d9a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d9d:	cc                   	int3   
  801d9e:	eb fd                	jmp    801d9d <_panic+0x5e>

00801da0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	53                   	push   %ebx
  801da4:	83 ec 04             	sub    $0x4,%esp
  801da7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801daa:	8b 13                	mov    (%ebx),%edx
  801dac:	8d 42 01             	lea    0x1(%edx),%eax
  801daf:	89 03                	mov    %eax,(%ebx)
  801db1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801db8:	3d ff 00 00 00       	cmp    $0xff,%eax
  801dbd:	74 09                	je     801dc8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801dbf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801dc8:	83 ec 08             	sub    $0x8,%esp
  801dcb:	68 ff 00 00 00       	push   $0xff
  801dd0:	8d 43 08             	lea    0x8(%ebx),%eax
  801dd3:	50                   	push   %eax
  801dd4:	e8 f1 0a 00 00       	call   8028ca <sys_cputs>
		b->idx = 0;
  801dd9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	eb db                	jmp    801dbf <putch+0x1f>

00801de4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801ded:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801df4:	00 00 00 
	b.cnt = 0;
  801df7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801dfe:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801e01:	ff 75 0c             	pushl  0xc(%ebp)
  801e04:	ff 75 08             	pushl  0x8(%ebp)
  801e07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e0d:	50                   	push   %eax
  801e0e:	68 a0 1d 80 00       	push   $0x801da0
  801e13:	e8 4a 01 00 00       	call   801f62 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801e18:	83 c4 08             	add    $0x8,%esp
  801e1b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801e21:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801e27:	50                   	push   %eax
  801e28:	e8 9d 0a 00 00       	call   8028ca <sys_cputs>

	return b.cnt;
}
  801e2d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801e3b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801e3e:	50                   	push   %eax
  801e3f:	ff 75 08             	pushl  0x8(%ebp)
  801e42:	e8 9d ff ff ff       	call   801de4 <vcprintf>
	va_end(ap);

	return cnt;
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	57                   	push   %edi
  801e4d:	56                   	push   %esi
  801e4e:	53                   	push   %ebx
  801e4f:	83 ec 1c             	sub    $0x1c,%esp
  801e52:	89 c6                	mov    %eax,%esi
  801e54:	89 d7                	mov    %edx,%edi
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801e62:	8b 45 10             	mov    0x10(%ebp),%eax
  801e65:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  801e68:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  801e6c:	74 2c                	je     801e9a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  801e6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801e78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e7b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801e7e:	39 c2                	cmp    %eax,%edx
  801e80:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  801e83:	73 43                	jae    801ec8 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  801e85:	83 eb 01             	sub    $0x1,%ebx
  801e88:	85 db                	test   %ebx,%ebx
  801e8a:	7e 6c                	jle    801ef8 <printnum+0xaf>
				putch(padc, putdat);
  801e8c:	83 ec 08             	sub    $0x8,%esp
  801e8f:	57                   	push   %edi
  801e90:	ff 75 18             	pushl  0x18(%ebp)
  801e93:	ff d6                	call   *%esi
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	eb eb                	jmp    801e85 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	6a 20                	push   $0x20
  801e9f:	6a 00                	push   $0x0
  801ea1:	50                   	push   %eax
  801ea2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ea5:	ff 75 e0             	pushl  -0x20(%ebp)
  801ea8:	89 fa                	mov    %edi,%edx
  801eaa:	89 f0                	mov    %esi,%eax
  801eac:	e8 98 ff ff ff       	call   801e49 <printnum>
		while (--width > 0)
  801eb1:	83 c4 20             	add    $0x20,%esp
  801eb4:	83 eb 01             	sub    $0x1,%ebx
  801eb7:	85 db                	test   %ebx,%ebx
  801eb9:	7e 65                	jle    801f20 <printnum+0xd7>
			putch(padc, putdat);
  801ebb:	83 ec 08             	sub    $0x8,%esp
  801ebe:	57                   	push   %edi
  801ebf:	6a 20                	push   $0x20
  801ec1:	ff d6                	call   *%esi
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	eb ec                	jmp    801eb4 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	ff 75 18             	pushl  0x18(%ebp)
  801ece:	83 eb 01             	sub    $0x1,%ebx
  801ed1:	53                   	push   %ebx
  801ed2:	50                   	push   %eax
  801ed3:	83 ec 08             	sub    $0x8,%esp
  801ed6:	ff 75 dc             	pushl  -0x24(%ebp)
  801ed9:	ff 75 d8             	pushl  -0x28(%ebp)
  801edc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801edf:	ff 75 e0             	pushl  -0x20(%ebp)
  801ee2:	e8 c9 20 00 00       	call   803fb0 <__udivdi3>
  801ee7:	83 c4 18             	add    $0x18,%esp
  801eea:	52                   	push   %edx
  801eeb:	50                   	push   %eax
  801eec:	89 fa                	mov    %edi,%edx
  801eee:	89 f0                	mov    %esi,%eax
  801ef0:	e8 54 ff ff ff       	call   801e49 <printnum>
  801ef5:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  801ef8:	83 ec 08             	sub    $0x8,%esp
  801efb:	57                   	push   %edi
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	ff 75 dc             	pushl  -0x24(%ebp)
  801f02:	ff 75 d8             	pushl  -0x28(%ebp)
  801f05:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f08:	ff 75 e0             	pushl  -0x20(%ebp)
  801f0b:	e8 b0 21 00 00       	call   8040c0 <__umoddi3>
  801f10:	83 c4 14             	add    $0x14,%esp
  801f13:	0f be 80 6b 48 80 00 	movsbl 0x80486b(%eax),%eax
  801f1a:	50                   	push   %eax
  801f1b:	ff d6                	call   *%esi
  801f1d:	83 c4 10             	add    $0x10,%esp
	}
}
  801f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5f                   	pop    %edi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    

00801f28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801f2e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801f32:	8b 10                	mov    (%eax),%edx
  801f34:	3b 50 04             	cmp    0x4(%eax),%edx
  801f37:	73 0a                	jae    801f43 <sprintputch+0x1b>
		*b->buf++ = ch;
  801f39:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f3c:	89 08                	mov    %ecx,(%eax)
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	88 02                	mov    %al,(%edx)
}
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    

00801f45 <printfmt>:
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801f4b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801f4e:	50                   	push   %eax
  801f4f:	ff 75 10             	pushl  0x10(%ebp)
  801f52:	ff 75 0c             	pushl  0xc(%ebp)
  801f55:	ff 75 08             	pushl  0x8(%ebp)
  801f58:	e8 05 00 00 00       	call   801f62 <vprintfmt>
}
  801f5d:	83 c4 10             	add    $0x10,%esp
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <vprintfmt>:
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	57                   	push   %edi
  801f66:	56                   	push   %esi
  801f67:	53                   	push   %ebx
  801f68:	83 ec 3c             	sub    $0x3c,%esp
  801f6b:	8b 75 08             	mov    0x8(%ebp),%esi
  801f6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f71:	8b 7d 10             	mov    0x10(%ebp),%edi
  801f74:	e9 32 04 00 00       	jmp    8023ab <vprintfmt+0x449>
		padc = ' ';
  801f79:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  801f7d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  801f84:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  801f8b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801f92:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801f99:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  801fa0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801fa5:	8d 47 01             	lea    0x1(%edi),%eax
  801fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fab:	0f b6 17             	movzbl (%edi),%edx
  801fae:	8d 42 dd             	lea    -0x23(%edx),%eax
  801fb1:	3c 55                	cmp    $0x55,%al
  801fb3:	0f 87 12 05 00 00    	ja     8024cb <vprintfmt+0x569>
  801fb9:	0f b6 c0             	movzbl %al,%eax
  801fbc:	ff 24 85 40 4a 80 00 	jmp    *0x804a40(,%eax,4)
  801fc3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801fc6:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  801fca:	eb d9                	jmp    801fa5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801fcc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801fcf:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  801fd3:	eb d0                	jmp    801fa5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801fd5:	0f b6 d2             	movzbl %dl,%edx
  801fd8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe0:	89 75 08             	mov    %esi,0x8(%ebp)
  801fe3:	eb 03                	jmp    801fe8 <vprintfmt+0x86>
  801fe5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801fe8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801feb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801fef:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801ff2:	8d 72 d0             	lea    -0x30(%edx),%esi
  801ff5:	83 fe 09             	cmp    $0x9,%esi
  801ff8:	76 eb                	jbe    801fe5 <vprintfmt+0x83>
  801ffa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ffd:	8b 75 08             	mov    0x8(%ebp),%esi
  802000:	eb 14                	jmp    802016 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  802002:	8b 45 14             	mov    0x14(%ebp),%eax
  802005:	8b 00                	mov    (%eax),%eax
  802007:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80200a:	8b 45 14             	mov    0x14(%ebp),%eax
  80200d:	8d 40 04             	lea    0x4(%eax),%eax
  802010:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  802013:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  802016:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80201a:	79 89                	jns    801fa5 <vprintfmt+0x43>
				width = precision, precision = -1;
  80201c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80201f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802022:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  802029:	e9 77 ff ff ff       	jmp    801fa5 <vprintfmt+0x43>
  80202e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802031:	85 c0                	test   %eax,%eax
  802033:	0f 48 c1             	cmovs  %ecx,%eax
  802036:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  802039:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80203c:	e9 64 ff ff ff       	jmp    801fa5 <vprintfmt+0x43>
  802041:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  802044:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80204b:	e9 55 ff ff ff       	jmp    801fa5 <vprintfmt+0x43>
			lflag++;
  802050:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  802054:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  802057:	e9 49 ff ff ff       	jmp    801fa5 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80205c:	8b 45 14             	mov    0x14(%ebp),%eax
  80205f:	8d 78 04             	lea    0x4(%eax),%edi
  802062:	83 ec 08             	sub    $0x8,%esp
  802065:	53                   	push   %ebx
  802066:	ff 30                	pushl  (%eax)
  802068:	ff d6                	call   *%esi
			break;
  80206a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80206d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  802070:	e9 33 03 00 00       	jmp    8023a8 <vprintfmt+0x446>
			err = va_arg(ap, int);
  802075:	8b 45 14             	mov    0x14(%ebp),%eax
  802078:	8d 78 04             	lea    0x4(%eax),%edi
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	99                   	cltd   
  80207e:	31 d0                	xor    %edx,%eax
  802080:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802082:	83 f8 11             	cmp    $0x11,%eax
  802085:	7f 23                	jg     8020aa <vprintfmt+0x148>
  802087:	8b 14 85 a0 4b 80 00 	mov    0x804ba0(,%eax,4),%edx
  80208e:	85 d2                	test   %edx,%edx
  802090:	74 18                	je     8020aa <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  802092:	52                   	push   %edx
  802093:	68 4f 42 80 00       	push   $0x80424f
  802098:	53                   	push   %ebx
  802099:	56                   	push   %esi
  80209a:	e8 a6 fe ff ff       	call   801f45 <printfmt>
  80209f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8020a2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8020a5:	e9 fe 02 00 00       	jmp    8023a8 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8020aa:	50                   	push   %eax
  8020ab:	68 83 48 80 00       	push   $0x804883
  8020b0:	53                   	push   %ebx
  8020b1:	56                   	push   %esi
  8020b2:	e8 8e fe ff ff       	call   801f45 <printfmt>
  8020b7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8020ba:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8020bd:	e9 e6 02 00 00       	jmp    8023a8 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8020c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c5:	83 c0 04             	add    $0x4,%eax
  8020c8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8020cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ce:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8020d0:	85 c9                	test   %ecx,%ecx
  8020d2:	b8 7c 48 80 00       	mov    $0x80487c,%eax
  8020d7:	0f 45 c1             	cmovne %ecx,%eax
  8020da:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8020dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020e1:	7e 06                	jle    8020e9 <vprintfmt+0x187>
  8020e3:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8020e7:	75 0d                	jne    8020f6 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8020e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020ec:	89 c7                	mov    %eax,%edi
  8020ee:	03 45 e0             	add    -0x20(%ebp),%eax
  8020f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8020f4:	eb 53                	jmp    802149 <vprintfmt+0x1e7>
  8020f6:	83 ec 08             	sub    $0x8,%esp
  8020f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8020fc:	50                   	push   %eax
  8020fd:	e8 71 04 00 00       	call   802573 <strnlen>
  802102:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802105:	29 c1                	sub    %eax,%ecx
  802107:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80210a:	83 c4 10             	add    $0x10,%esp
  80210d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80210f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  802113:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  802116:	eb 0f                	jmp    802127 <vprintfmt+0x1c5>
					putch(padc, putdat);
  802118:	83 ec 08             	sub    $0x8,%esp
  80211b:	53                   	push   %ebx
  80211c:	ff 75 e0             	pushl  -0x20(%ebp)
  80211f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  802121:	83 ef 01             	sub    $0x1,%edi
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	85 ff                	test   %edi,%edi
  802129:	7f ed                	jg     802118 <vprintfmt+0x1b6>
  80212b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80212e:	85 c9                	test   %ecx,%ecx
  802130:	b8 00 00 00 00       	mov    $0x0,%eax
  802135:	0f 49 c1             	cmovns %ecx,%eax
  802138:	29 c1                	sub    %eax,%ecx
  80213a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80213d:	eb aa                	jmp    8020e9 <vprintfmt+0x187>
					putch(ch, putdat);
  80213f:	83 ec 08             	sub    $0x8,%esp
  802142:	53                   	push   %ebx
  802143:	52                   	push   %edx
  802144:	ff d6                	call   *%esi
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80214c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80214e:	83 c7 01             	add    $0x1,%edi
  802151:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802155:	0f be d0             	movsbl %al,%edx
  802158:	85 d2                	test   %edx,%edx
  80215a:	74 4b                	je     8021a7 <vprintfmt+0x245>
  80215c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802160:	78 06                	js     802168 <vprintfmt+0x206>
  802162:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  802166:	78 1e                	js     802186 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  802168:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80216c:	74 d1                	je     80213f <vprintfmt+0x1dd>
  80216e:	0f be c0             	movsbl %al,%eax
  802171:	83 e8 20             	sub    $0x20,%eax
  802174:	83 f8 5e             	cmp    $0x5e,%eax
  802177:	76 c6                	jbe    80213f <vprintfmt+0x1dd>
					putch('?', putdat);
  802179:	83 ec 08             	sub    $0x8,%esp
  80217c:	53                   	push   %ebx
  80217d:	6a 3f                	push   $0x3f
  80217f:	ff d6                	call   *%esi
  802181:	83 c4 10             	add    $0x10,%esp
  802184:	eb c3                	jmp    802149 <vprintfmt+0x1e7>
  802186:	89 cf                	mov    %ecx,%edi
  802188:	eb 0e                	jmp    802198 <vprintfmt+0x236>
				putch(' ', putdat);
  80218a:	83 ec 08             	sub    $0x8,%esp
  80218d:	53                   	push   %ebx
  80218e:	6a 20                	push   $0x20
  802190:	ff d6                	call   *%esi
			for (; width > 0; width--)
  802192:	83 ef 01             	sub    $0x1,%edi
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	85 ff                	test   %edi,%edi
  80219a:	7f ee                	jg     80218a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80219c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80219f:	89 45 14             	mov    %eax,0x14(%ebp)
  8021a2:	e9 01 02 00 00       	jmp    8023a8 <vprintfmt+0x446>
  8021a7:	89 cf                	mov    %ecx,%edi
  8021a9:	eb ed                	jmp    802198 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8021ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8021ae:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8021b5:	e9 eb fd ff ff       	jmp    801fa5 <vprintfmt+0x43>
	if (lflag >= 2)
  8021ba:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8021be:	7f 21                	jg     8021e1 <vprintfmt+0x27f>
	else if (lflag)
  8021c0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8021c4:	74 68                	je     80222e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8021c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8021ce:	89 c1                	mov    %eax,%ecx
  8021d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8021d3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8021d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d9:	8d 40 04             	lea    0x4(%eax),%eax
  8021dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8021df:	eb 17                	jmp    8021f8 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8021e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e4:	8b 50 04             	mov    0x4(%eax),%edx
  8021e7:	8b 00                	mov    (%eax),%eax
  8021e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8021ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8021ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f2:	8d 40 08             	lea    0x8(%eax),%eax
  8021f5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8021f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802201:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  802204:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802208:	78 3f                	js     802249 <vprintfmt+0x2e7>
			base = 10;
  80220a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80220f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802213:	0f 84 71 01 00 00    	je     80238a <vprintfmt+0x428>
				putch('+', putdat);
  802219:	83 ec 08             	sub    $0x8,%esp
  80221c:	53                   	push   %ebx
  80221d:	6a 2b                	push   $0x2b
  80221f:	ff d6                	call   *%esi
  802221:	83 c4 10             	add    $0x10,%esp
			base = 10;
  802224:	b8 0a 00 00 00       	mov    $0xa,%eax
  802229:	e9 5c 01 00 00       	jmp    80238a <vprintfmt+0x428>
		return va_arg(*ap, int);
  80222e:	8b 45 14             	mov    0x14(%ebp),%eax
  802231:	8b 00                	mov    (%eax),%eax
  802233:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802236:	89 c1                	mov    %eax,%ecx
  802238:	c1 f9 1f             	sar    $0x1f,%ecx
  80223b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80223e:	8b 45 14             	mov    0x14(%ebp),%eax
  802241:	8d 40 04             	lea    0x4(%eax),%eax
  802244:	89 45 14             	mov    %eax,0x14(%ebp)
  802247:	eb af                	jmp    8021f8 <vprintfmt+0x296>
				putch('-', putdat);
  802249:	83 ec 08             	sub    $0x8,%esp
  80224c:	53                   	push   %ebx
  80224d:	6a 2d                	push   $0x2d
  80224f:	ff d6                	call   *%esi
				num = -(long long) num;
  802251:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802254:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802257:	f7 d8                	neg    %eax
  802259:	83 d2 00             	adc    $0x0,%edx
  80225c:	f7 da                	neg    %edx
  80225e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802261:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802264:	83 c4 10             	add    $0x10,%esp
			base = 10;
  802267:	b8 0a 00 00 00       	mov    $0xa,%eax
  80226c:	e9 19 01 00 00       	jmp    80238a <vprintfmt+0x428>
	if (lflag >= 2)
  802271:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  802275:	7f 29                	jg     8022a0 <vprintfmt+0x33e>
	else if (lflag)
  802277:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80227b:	74 44                	je     8022c1 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80227d:	8b 45 14             	mov    0x14(%ebp),%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	ba 00 00 00 00       	mov    $0x0,%edx
  802287:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80228a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80228d:	8b 45 14             	mov    0x14(%ebp),%eax
  802290:	8d 40 04             	lea    0x4(%eax),%eax
  802293:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802296:	b8 0a 00 00 00       	mov    $0xa,%eax
  80229b:	e9 ea 00 00 00       	jmp    80238a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8022a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a3:	8b 50 04             	mov    0x4(%eax),%edx
  8022a6:	8b 00                	mov    (%eax),%eax
  8022a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8022ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b1:	8d 40 08             	lea    0x8(%eax),%eax
  8022b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8022b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8022bc:	e9 c9 00 00 00       	jmp    80238a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8022c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8022cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8022d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d4:	8d 40 04             	lea    0x4(%eax),%eax
  8022d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8022da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8022df:	e9 a6 00 00 00       	jmp    80238a <vprintfmt+0x428>
			putch('0', putdat);
  8022e4:	83 ec 08             	sub    $0x8,%esp
  8022e7:	53                   	push   %ebx
  8022e8:	6a 30                	push   $0x30
  8022ea:	ff d6                	call   *%esi
	if (lflag >= 2)
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8022f3:	7f 26                	jg     80231b <vprintfmt+0x3b9>
	else if (lflag)
  8022f5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8022f9:	74 3e                	je     802339 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8022fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	ba 00 00 00 00       	mov    $0x0,%edx
  802305:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802308:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80230b:	8b 45 14             	mov    0x14(%ebp),%eax
  80230e:	8d 40 04             	lea    0x4(%eax),%eax
  802311:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802314:	b8 08 00 00 00       	mov    $0x8,%eax
  802319:	eb 6f                	jmp    80238a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80231b:	8b 45 14             	mov    0x14(%ebp),%eax
  80231e:	8b 50 04             	mov    0x4(%eax),%edx
  802321:	8b 00                	mov    (%eax),%eax
  802323:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802326:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802329:	8b 45 14             	mov    0x14(%ebp),%eax
  80232c:	8d 40 08             	lea    0x8(%eax),%eax
  80232f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802332:	b8 08 00 00 00       	mov    $0x8,%eax
  802337:	eb 51                	jmp    80238a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  802339:	8b 45 14             	mov    0x14(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	ba 00 00 00 00       	mov    $0x0,%edx
  802343:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802346:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802349:	8b 45 14             	mov    0x14(%ebp),%eax
  80234c:	8d 40 04             	lea    0x4(%eax),%eax
  80234f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802352:	b8 08 00 00 00       	mov    $0x8,%eax
  802357:	eb 31                	jmp    80238a <vprintfmt+0x428>
			putch('0', putdat);
  802359:	83 ec 08             	sub    $0x8,%esp
  80235c:	53                   	push   %ebx
  80235d:	6a 30                	push   $0x30
  80235f:	ff d6                	call   *%esi
			putch('x', putdat);
  802361:	83 c4 08             	add    $0x8,%esp
  802364:	53                   	push   %ebx
  802365:	6a 78                	push   $0x78
  802367:	ff d6                	call   *%esi
			num = (unsigned long long)
  802369:	8b 45 14             	mov    0x14(%ebp),%eax
  80236c:	8b 00                	mov    (%eax),%eax
  80236e:	ba 00 00 00 00       	mov    $0x0,%edx
  802373:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802376:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  802379:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80237c:	8b 45 14             	mov    0x14(%ebp),%eax
  80237f:	8d 40 04             	lea    0x4(%eax),%eax
  802382:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802385:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80238a:	83 ec 0c             	sub    $0xc,%esp
  80238d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  802391:	52                   	push   %edx
  802392:	ff 75 e0             	pushl  -0x20(%ebp)
  802395:	50                   	push   %eax
  802396:	ff 75 dc             	pushl  -0x24(%ebp)
  802399:	ff 75 d8             	pushl  -0x28(%ebp)
  80239c:	89 da                	mov    %ebx,%edx
  80239e:	89 f0                	mov    %esi,%eax
  8023a0:	e8 a4 fa ff ff       	call   801e49 <printnum>
			break;
  8023a5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8023a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8023ab:	83 c7 01             	add    $0x1,%edi
  8023ae:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8023b2:	83 f8 25             	cmp    $0x25,%eax
  8023b5:	0f 84 be fb ff ff    	je     801f79 <vprintfmt+0x17>
			if (ch == '\0')
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	0f 84 28 01 00 00    	je     8024eb <vprintfmt+0x589>
			putch(ch, putdat);
  8023c3:	83 ec 08             	sub    $0x8,%esp
  8023c6:	53                   	push   %ebx
  8023c7:	50                   	push   %eax
  8023c8:	ff d6                	call   *%esi
  8023ca:	83 c4 10             	add    $0x10,%esp
  8023cd:	eb dc                	jmp    8023ab <vprintfmt+0x449>
	if (lflag >= 2)
  8023cf:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8023d3:	7f 26                	jg     8023fb <vprintfmt+0x499>
	else if (lflag)
  8023d5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8023d9:	74 41                	je     80241c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8023db:	8b 45 14             	mov    0x14(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8023eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ee:	8d 40 04             	lea    0x4(%eax),%eax
  8023f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8023f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8023f9:	eb 8f                	jmp    80238a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8023fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8023fe:	8b 50 04             	mov    0x4(%eax),%edx
  802401:	8b 00                	mov    (%eax),%eax
  802403:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802406:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802409:	8b 45 14             	mov    0x14(%ebp),%eax
  80240c:	8d 40 08             	lea    0x8(%eax),%eax
  80240f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802412:	b8 10 00 00 00       	mov    $0x10,%eax
  802417:	e9 6e ff ff ff       	jmp    80238a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80241c:	8b 45 14             	mov    0x14(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	ba 00 00 00 00       	mov    $0x0,%edx
  802426:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802429:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80242c:	8b 45 14             	mov    0x14(%ebp),%eax
  80242f:	8d 40 04             	lea    0x4(%eax),%eax
  802432:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802435:	b8 10 00 00 00       	mov    $0x10,%eax
  80243a:	e9 4b ff ff ff       	jmp    80238a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80243f:	8b 45 14             	mov    0x14(%ebp),%eax
  802442:	83 c0 04             	add    $0x4,%eax
  802445:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802448:	8b 45 14             	mov    0x14(%ebp),%eax
  80244b:	8b 00                	mov    (%eax),%eax
  80244d:	85 c0                	test   %eax,%eax
  80244f:	74 14                	je     802465 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  802451:	8b 13                	mov    (%ebx),%edx
  802453:	83 fa 7f             	cmp    $0x7f,%edx
  802456:	7f 37                	jg     80248f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  802458:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80245a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80245d:	89 45 14             	mov    %eax,0x14(%ebp)
  802460:	e9 43 ff ff ff       	jmp    8023a8 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  802465:	b8 0a 00 00 00       	mov    $0xa,%eax
  80246a:	bf a1 49 80 00       	mov    $0x8049a1,%edi
							putch(ch, putdat);
  80246f:	83 ec 08             	sub    $0x8,%esp
  802472:	53                   	push   %ebx
  802473:	50                   	push   %eax
  802474:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  802476:	83 c7 01             	add    $0x1,%edi
  802479:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80247d:	83 c4 10             	add    $0x10,%esp
  802480:	85 c0                	test   %eax,%eax
  802482:	75 eb                	jne    80246f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  802484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802487:	89 45 14             	mov    %eax,0x14(%ebp)
  80248a:	e9 19 ff ff ff       	jmp    8023a8 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80248f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  802491:	b8 0a 00 00 00       	mov    $0xa,%eax
  802496:	bf d9 49 80 00       	mov    $0x8049d9,%edi
							putch(ch, putdat);
  80249b:	83 ec 08             	sub    $0x8,%esp
  80249e:	53                   	push   %ebx
  80249f:	50                   	push   %eax
  8024a0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8024a2:	83 c7 01             	add    $0x1,%edi
  8024a5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8024a9:	83 c4 10             	add    $0x10,%esp
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	75 eb                	jne    80249b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8024b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8024b6:	e9 ed fe ff ff       	jmp    8023a8 <vprintfmt+0x446>
			putch(ch, putdat);
  8024bb:	83 ec 08             	sub    $0x8,%esp
  8024be:	53                   	push   %ebx
  8024bf:	6a 25                	push   $0x25
  8024c1:	ff d6                	call   *%esi
			break;
  8024c3:	83 c4 10             	add    $0x10,%esp
  8024c6:	e9 dd fe ff ff       	jmp    8023a8 <vprintfmt+0x446>
			putch('%', putdat);
  8024cb:	83 ec 08             	sub    $0x8,%esp
  8024ce:	53                   	push   %ebx
  8024cf:	6a 25                	push   $0x25
  8024d1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	89 f8                	mov    %edi,%eax
  8024d8:	eb 03                	jmp    8024dd <vprintfmt+0x57b>
  8024da:	83 e8 01             	sub    $0x1,%eax
  8024dd:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8024e1:	75 f7                	jne    8024da <vprintfmt+0x578>
  8024e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024e6:	e9 bd fe ff ff       	jmp    8023a8 <vprintfmt+0x446>
}
  8024eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ee:	5b                   	pop    %ebx
  8024ef:	5e                   	pop    %esi
  8024f0:	5f                   	pop    %edi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    

008024f3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	83 ec 18             	sub    $0x18,%esp
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8024ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802502:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802506:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802509:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802510:	85 c0                	test   %eax,%eax
  802512:	74 26                	je     80253a <vsnprintf+0x47>
  802514:	85 d2                	test   %edx,%edx
  802516:	7e 22                	jle    80253a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802518:	ff 75 14             	pushl  0x14(%ebp)
  80251b:	ff 75 10             	pushl  0x10(%ebp)
  80251e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802521:	50                   	push   %eax
  802522:	68 28 1f 80 00       	push   $0x801f28
  802527:	e8 36 fa ff ff       	call   801f62 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80252c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	83 c4 10             	add    $0x10,%esp
}
  802538:	c9                   	leave  
  802539:	c3                   	ret    
		return -E_INVAL;
  80253a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80253f:	eb f7                	jmp    802538 <vsnprintf+0x45>

00802541 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802547:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80254a:	50                   	push   %eax
  80254b:	ff 75 10             	pushl  0x10(%ebp)
  80254e:	ff 75 0c             	pushl  0xc(%ebp)
  802551:	ff 75 08             	pushl  0x8(%ebp)
  802554:	e8 9a ff ff ff       	call   8024f3 <vsnprintf>
	va_end(ap);

	return rc;
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802561:	b8 00 00 00 00       	mov    $0x0,%eax
  802566:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80256a:	74 05                	je     802571 <strlen+0x16>
		n++;
  80256c:	83 c0 01             	add    $0x1,%eax
  80256f:	eb f5                	jmp    802566 <strlen+0xb>
	return n;
}
  802571:	5d                   	pop    %ebp
  802572:	c3                   	ret    

00802573 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802579:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80257c:	ba 00 00 00 00       	mov    $0x0,%edx
  802581:	39 c2                	cmp    %eax,%edx
  802583:	74 0d                	je     802592 <strnlen+0x1f>
  802585:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  802589:	74 05                	je     802590 <strnlen+0x1d>
		n++;
  80258b:	83 c2 01             	add    $0x1,%edx
  80258e:	eb f1                	jmp    802581 <strnlen+0xe>
  802590:	89 d0                	mov    %edx,%eax
	return n;
}
  802592:	5d                   	pop    %ebp
  802593:	c3                   	ret    

00802594 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
  802597:	53                   	push   %ebx
  802598:	8b 45 08             	mov    0x8(%ebp),%eax
  80259b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80259e:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8025a7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8025aa:	83 c2 01             	add    $0x1,%edx
  8025ad:	84 c9                	test   %cl,%cl
  8025af:	75 f2                	jne    8025a3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8025b1:	5b                   	pop    %ebx
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    

008025b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
  8025b7:	53                   	push   %ebx
  8025b8:	83 ec 10             	sub    $0x10,%esp
  8025bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8025be:	53                   	push   %ebx
  8025bf:	e8 97 ff ff ff       	call   80255b <strlen>
  8025c4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8025c7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ca:	01 d8                	add    %ebx,%eax
  8025cc:	50                   	push   %eax
  8025cd:	e8 c2 ff ff ff       	call   802594 <strcpy>
	return dst;
}
  8025d2:	89 d8                	mov    %ebx,%eax
  8025d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	56                   	push   %esi
  8025dd:	53                   	push   %ebx
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025e4:	89 c6                	mov    %eax,%esi
  8025e6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8025e9:	89 c2                	mov    %eax,%edx
  8025eb:	39 f2                	cmp    %esi,%edx
  8025ed:	74 11                	je     802600 <strncpy+0x27>
		*dst++ = *src;
  8025ef:	83 c2 01             	add    $0x1,%edx
  8025f2:	0f b6 19             	movzbl (%ecx),%ebx
  8025f5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8025f8:	80 fb 01             	cmp    $0x1,%bl
  8025fb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8025fe:	eb eb                	jmp    8025eb <strncpy+0x12>
	}
	return ret;
}
  802600:	5b                   	pop    %ebx
  802601:	5e                   	pop    %esi
  802602:	5d                   	pop    %ebp
  802603:	c3                   	ret    

00802604 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
  802607:	56                   	push   %esi
  802608:	53                   	push   %ebx
  802609:	8b 75 08             	mov    0x8(%ebp),%esi
  80260c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80260f:	8b 55 10             	mov    0x10(%ebp),%edx
  802612:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802614:	85 d2                	test   %edx,%edx
  802616:	74 21                	je     802639 <strlcpy+0x35>
  802618:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80261c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80261e:	39 c2                	cmp    %eax,%edx
  802620:	74 14                	je     802636 <strlcpy+0x32>
  802622:	0f b6 19             	movzbl (%ecx),%ebx
  802625:	84 db                	test   %bl,%bl
  802627:	74 0b                	je     802634 <strlcpy+0x30>
			*dst++ = *src++;
  802629:	83 c1 01             	add    $0x1,%ecx
  80262c:	83 c2 01             	add    $0x1,%edx
  80262f:	88 5a ff             	mov    %bl,-0x1(%edx)
  802632:	eb ea                	jmp    80261e <strlcpy+0x1a>
  802634:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  802636:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802639:	29 f0                	sub    %esi,%eax
}
  80263b:	5b                   	pop    %ebx
  80263c:	5e                   	pop    %esi
  80263d:	5d                   	pop    %ebp
  80263e:	c3                   	ret    

0080263f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802645:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802648:	0f b6 01             	movzbl (%ecx),%eax
  80264b:	84 c0                	test   %al,%al
  80264d:	74 0c                	je     80265b <strcmp+0x1c>
  80264f:	3a 02                	cmp    (%edx),%al
  802651:	75 08                	jne    80265b <strcmp+0x1c>
		p++, q++;
  802653:	83 c1 01             	add    $0x1,%ecx
  802656:	83 c2 01             	add    $0x1,%edx
  802659:	eb ed                	jmp    802648 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80265b:	0f b6 c0             	movzbl %al,%eax
  80265e:	0f b6 12             	movzbl (%edx),%edx
  802661:	29 d0                	sub    %edx,%eax
}
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    

00802665 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	53                   	push   %ebx
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266f:	89 c3                	mov    %eax,%ebx
  802671:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802674:	eb 06                	jmp    80267c <strncmp+0x17>
		n--, p++, q++;
  802676:	83 c0 01             	add    $0x1,%eax
  802679:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80267c:	39 d8                	cmp    %ebx,%eax
  80267e:	74 16                	je     802696 <strncmp+0x31>
  802680:	0f b6 08             	movzbl (%eax),%ecx
  802683:	84 c9                	test   %cl,%cl
  802685:	74 04                	je     80268b <strncmp+0x26>
  802687:	3a 0a                	cmp    (%edx),%cl
  802689:	74 eb                	je     802676 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80268b:	0f b6 00             	movzbl (%eax),%eax
  80268e:	0f b6 12             	movzbl (%edx),%edx
  802691:	29 d0                	sub    %edx,%eax
}
  802693:	5b                   	pop    %ebx
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    
		return 0;
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
  80269b:	eb f6                	jmp    802693 <strncmp+0x2e>

0080269d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8026a7:	0f b6 10             	movzbl (%eax),%edx
  8026aa:	84 d2                	test   %dl,%dl
  8026ac:	74 09                	je     8026b7 <strchr+0x1a>
		if (*s == c)
  8026ae:	38 ca                	cmp    %cl,%dl
  8026b0:	74 0a                	je     8026bc <strchr+0x1f>
	for (; *s; s++)
  8026b2:	83 c0 01             	add    $0x1,%eax
  8026b5:	eb f0                	jmp    8026a7 <strchr+0xa>
			return (char *) s;
	return 0;
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bc:	5d                   	pop    %ebp
  8026bd:	c3                   	ret    

008026be <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8026c8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8026cb:	38 ca                	cmp    %cl,%dl
  8026cd:	74 09                	je     8026d8 <strfind+0x1a>
  8026cf:	84 d2                	test   %dl,%dl
  8026d1:	74 05                	je     8026d8 <strfind+0x1a>
	for (; *s; s++)
  8026d3:	83 c0 01             	add    $0x1,%eax
  8026d6:	eb f0                	jmp    8026c8 <strfind+0xa>
			break;
	return (char *) s;
}
  8026d8:	5d                   	pop    %ebp
  8026d9:	c3                   	ret    

008026da <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
  8026dd:	57                   	push   %edi
  8026de:	56                   	push   %esi
  8026df:	53                   	push   %ebx
  8026e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8026e6:	85 c9                	test   %ecx,%ecx
  8026e8:	74 31                	je     80271b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8026ea:	89 f8                	mov    %edi,%eax
  8026ec:	09 c8                	or     %ecx,%eax
  8026ee:	a8 03                	test   $0x3,%al
  8026f0:	75 23                	jne    802715 <memset+0x3b>
		c &= 0xFF;
  8026f2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8026f6:	89 d3                	mov    %edx,%ebx
  8026f8:	c1 e3 08             	shl    $0x8,%ebx
  8026fb:	89 d0                	mov    %edx,%eax
  8026fd:	c1 e0 18             	shl    $0x18,%eax
  802700:	89 d6                	mov    %edx,%esi
  802702:	c1 e6 10             	shl    $0x10,%esi
  802705:	09 f0                	or     %esi,%eax
  802707:	09 c2                	or     %eax,%edx
  802709:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80270b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80270e:	89 d0                	mov    %edx,%eax
  802710:	fc                   	cld    
  802711:	f3 ab                	rep stos %eax,%es:(%edi)
  802713:	eb 06                	jmp    80271b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802715:	8b 45 0c             	mov    0xc(%ebp),%eax
  802718:	fc                   	cld    
  802719:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80271b:	89 f8                	mov    %edi,%eax
  80271d:	5b                   	pop    %ebx
  80271e:	5e                   	pop    %esi
  80271f:	5f                   	pop    %edi
  802720:	5d                   	pop    %ebp
  802721:	c3                   	ret    

00802722 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80272d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802730:	39 c6                	cmp    %eax,%esi
  802732:	73 32                	jae    802766 <memmove+0x44>
  802734:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802737:	39 c2                	cmp    %eax,%edx
  802739:	76 2b                	jbe    802766 <memmove+0x44>
		s += n;
		d += n;
  80273b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80273e:	89 fe                	mov    %edi,%esi
  802740:	09 ce                	or     %ecx,%esi
  802742:	09 d6                	or     %edx,%esi
  802744:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80274a:	75 0e                	jne    80275a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80274c:	83 ef 04             	sub    $0x4,%edi
  80274f:	8d 72 fc             	lea    -0x4(%edx),%esi
  802752:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  802755:	fd                   	std    
  802756:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802758:	eb 09                	jmp    802763 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80275a:	83 ef 01             	sub    $0x1,%edi
  80275d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  802760:	fd                   	std    
  802761:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802763:	fc                   	cld    
  802764:	eb 1a                	jmp    802780 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802766:	89 c2                	mov    %eax,%edx
  802768:	09 ca                	or     %ecx,%edx
  80276a:	09 f2                	or     %esi,%edx
  80276c:	f6 c2 03             	test   $0x3,%dl
  80276f:	75 0a                	jne    80277b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802771:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802774:	89 c7                	mov    %eax,%edi
  802776:	fc                   	cld    
  802777:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802779:	eb 05                	jmp    802780 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  80277b:	89 c7                	mov    %eax,%edi
  80277d:	fc                   	cld    
  80277e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802780:	5e                   	pop    %esi
  802781:	5f                   	pop    %edi
  802782:	5d                   	pop    %ebp
  802783:	c3                   	ret    

00802784 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  80278a:	ff 75 10             	pushl  0x10(%ebp)
  80278d:	ff 75 0c             	pushl  0xc(%ebp)
  802790:	ff 75 08             	pushl  0x8(%ebp)
  802793:	e8 8a ff ff ff       	call   802722 <memmove>
}
  802798:	c9                   	leave  
  802799:	c3                   	ret    

0080279a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	56                   	push   %esi
  80279e:	53                   	push   %ebx
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a5:	89 c6                	mov    %eax,%esi
  8027a7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8027aa:	39 f0                	cmp    %esi,%eax
  8027ac:	74 1c                	je     8027ca <memcmp+0x30>
		if (*s1 != *s2)
  8027ae:	0f b6 08             	movzbl (%eax),%ecx
  8027b1:	0f b6 1a             	movzbl (%edx),%ebx
  8027b4:	38 d9                	cmp    %bl,%cl
  8027b6:	75 08                	jne    8027c0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8027b8:	83 c0 01             	add    $0x1,%eax
  8027bb:	83 c2 01             	add    $0x1,%edx
  8027be:	eb ea                	jmp    8027aa <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8027c0:	0f b6 c1             	movzbl %cl,%eax
  8027c3:	0f b6 db             	movzbl %bl,%ebx
  8027c6:	29 d8                	sub    %ebx,%eax
  8027c8:	eb 05                	jmp    8027cf <memcmp+0x35>
	}

	return 0;
  8027ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027cf:	5b                   	pop    %ebx
  8027d0:	5e                   	pop    %esi
  8027d1:	5d                   	pop    %ebp
  8027d2:	c3                   	ret    

008027d3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8027dc:	89 c2                	mov    %eax,%edx
  8027de:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8027e1:	39 d0                	cmp    %edx,%eax
  8027e3:	73 09                	jae    8027ee <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8027e5:	38 08                	cmp    %cl,(%eax)
  8027e7:	74 05                	je     8027ee <memfind+0x1b>
	for (; s < ends; s++)
  8027e9:	83 c0 01             	add    $0x1,%eax
  8027ec:	eb f3                	jmp    8027e1 <memfind+0xe>
			break;
	return (void *) s;
}
  8027ee:	5d                   	pop    %ebp
  8027ef:	c3                   	ret    

008027f0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	57                   	push   %edi
  8027f4:	56                   	push   %esi
  8027f5:	53                   	push   %ebx
  8027f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027fc:	eb 03                	jmp    802801 <strtol+0x11>
		s++;
  8027fe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  802801:	0f b6 01             	movzbl (%ecx),%eax
  802804:	3c 20                	cmp    $0x20,%al
  802806:	74 f6                	je     8027fe <strtol+0xe>
  802808:	3c 09                	cmp    $0x9,%al
  80280a:	74 f2                	je     8027fe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80280c:	3c 2b                	cmp    $0x2b,%al
  80280e:	74 2a                	je     80283a <strtol+0x4a>
	int neg = 0;
  802810:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  802815:	3c 2d                	cmp    $0x2d,%al
  802817:	74 2b                	je     802844 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802819:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80281f:	75 0f                	jne    802830 <strtol+0x40>
  802821:	80 39 30             	cmpb   $0x30,(%ecx)
  802824:	74 28                	je     80284e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802826:	85 db                	test   %ebx,%ebx
  802828:	b8 0a 00 00 00       	mov    $0xa,%eax
  80282d:	0f 44 d8             	cmove  %eax,%ebx
  802830:	b8 00 00 00 00       	mov    $0x0,%eax
  802835:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802838:	eb 50                	jmp    80288a <strtol+0x9a>
		s++;
  80283a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80283d:	bf 00 00 00 00       	mov    $0x0,%edi
  802842:	eb d5                	jmp    802819 <strtol+0x29>
		s++, neg = 1;
  802844:	83 c1 01             	add    $0x1,%ecx
  802847:	bf 01 00 00 00       	mov    $0x1,%edi
  80284c:	eb cb                	jmp    802819 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80284e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  802852:	74 0e                	je     802862 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  802854:	85 db                	test   %ebx,%ebx
  802856:	75 d8                	jne    802830 <strtol+0x40>
		s++, base = 8;
  802858:	83 c1 01             	add    $0x1,%ecx
  80285b:	bb 08 00 00 00       	mov    $0x8,%ebx
  802860:	eb ce                	jmp    802830 <strtol+0x40>
		s += 2, base = 16;
  802862:	83 c1 02             	add    $0x2,%ecx
  802865:	bb 10 00 00 00       	mov    $0x10,%ebx
  80286a:	eb c4                	jmp    802830 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80286c:	8d 72 9f             	lea    -0x61(%edx),%esi
  80286f:	89 f3                	mov    %esi,%ebx
  802871:	80 fb 19             	cmp    $0x19,%bl
  802874:	77 29                	ja     80289f <strtol+0xaf>
			dig = *s - 'a' + 10;
  802876:	0f be d2             	movsbl %dl,%edx
  802879:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80287c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80287f:	7d 30                	jge    8028b1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  802881:	83 c1 01             	add    $0x1,%ecx
  802884:	0f af 45 10          	imul   0x10(%ebp),%eax
  802888:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80288a:	0f b6 11             	movzbl (%ecx),%edx
  80288d:	8d 72 d0             	lea    -0x30(%edx),%esi
  802890:	89 f3                	mov    %esi,%ebx
  802892:	80 fb 09             	cmp    $0x9,%bl
  802895:	77 d5                	ja     80286c <strtol+0x7c>
			dig = *s - '0';
  802897:	0f be d2             	movsbl %dl,%edx
  80289a:	83 ea 30             	sub    $0x30,%edx
  80289d:	eb dd                	jmp    80287c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  80289f:	8d 72 bf             	lea    -0x41(%edx),%esi
  8028a2:	89 f3                	mov    %esi,%ebx
  8028a4:	80 fb 19             	cmp    $0x19,%bl
  8028a7:	77 08                	ja     8028b1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  8028a9:	0f be d2             	movsbl %dl,%edx
  8028ac:	83 ea 37             	sub    $0x37,%edx
  8028af:	eb cb                	jmp    80287c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8028b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028b5:	74 05                	je     8028bc <strtol+0xcc>
		*endptr = (char *) s;
  8028b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028ba:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8028bc:	89 c2                	mov    %eax,%edx
  8028be:	f7 da                	neg    %edx
  8028c0:	85 ff                	test   %edi,%edi
  8028c2:	0f 45 c2             	cmovne %edx,%eax
}
  8028c5:	5b                   	pop    %ebx
  8028c6:	5e                   	pop    %esi
  8028c7:	5f                   	pop    %edi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    

008028ca <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
  8028cd:	57                   	push   %edi
  8028ce:	56                   	push   %esi
  8028cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028db:	89 c3                	mov    %eax,%ebx
  8028dd:	89 c7                	mov    %eax,%edi
  8028df:	89 c6                	mov    %eax,%esi
  8028e1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8028e3:	5b                   	pop    %ebx
  8028e4:	5e                   	pop    %esi
  8028e5:	5f                   	pop    %edi
  8028e6:	5d                   	pop    %ebp
  8028e7:	c3                   	ret    

008028e8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8028e8:	55                   	push   %ebp
  8028e9:	89 e5                	mov    %esp,%ebp
  8028eb:	57                   	push   %edi
  8028ec:	56                   	push   %esi
  8028ed:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f8:	89 d1                	mov    %edx,%ecx
  8028fa:	89 d3                	mov    %edx,%ebx
  8028fc:	89 d7                	mov    %edx,%edi
  8028fe:	89 d6                	mov    %edx,%esi
  802900:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802902:	5b                   	pop    %ebx
  802903:	5e                   	pop    %esi
  802904:	5f                   	pop    %edi
  802905:	5d                   	pop    %ebp
  802906:	c3                   	ret    

00802907 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
  80290a:	57                   	push   %edi
  80290b:	56                   	push   %esi
  80290c:	53                   	push   %ebx
  80290d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802910:	b9 00 00 00 00       	mov    $0x0,%ecx
  802915:	8b 55 08             	mov    0x8(%ebp),%edx
  802918:	b8 03 00 00 00       	mov    $0x3,%eax
  80291d:	89 cb                	mov    %ecx,%ebx
  80291f:	89 cf                	mov    %ecx,%edi
  802921:	89 ce                	mov    %ecx,%esi
  802923:	cd 30                	int    $0x30
	if(check && ret > 0)
  802925:	85 c0                	test   %eax,%eax
  802927:	7f 08                	jg     802931 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  802929:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80292c:	5b                   	pop    %ebx
  80292d:	5e                   	pop    %esi
  80292e:	5f                   	pop    %edi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802931:	83 ec 0c             	sub    $0xc,%esp
  802934:	50                   	push   %eax
  802935:	6a 03                	push   $0x3
  802937:	68 e8 4b 80 00       	push   $0x804be8
  80293c:	6a 43                	push   $0x43
  80293e:	68 05 4c 80 00       	push   $0x804c05
  802943:	e8 f7 f3 ff ff       	call   801d3f <_panic>

00802948 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
  80294b:	57                   	push   %edi
  80294c:	56                   	push   %esi
  80294d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80294e:	ba 00 00 00 00       	mov    $0x0,%edx
  802953:	b8 02 00 00 00       	mov    $0x2,%eax
  802958:	89 d1                	mov    %edx,%ecx
  80295a:	89 d3                	mov    %edx,%ebx
  80295c:	89 d7                	mov    %edx,%edi
  80295e:	89 d6                	mov    %edx,%esi
  802960:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  802962:	5b                   	pop    %ebx
  802963:	5e                   	pop    %esi
  802964:	5f                   	pop    %edi
  802965:	5d                   	pop    %ebp
  802966:	c3                   	ret    

00802967 <sys_yield>:

void
sys_yield(void)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
  80296a:	57                   	push   %edi
  80296b:	56                   	push   %esi
  80296c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80296d:	ba 00 00 00 00       	mov    $0x0,%edx
  802972:	b8 0b 00 00 00       	mov    $0xb,%eax
  802977:	89 d1                	mov    %edx,%ecx
  802979:	89 d3                	mov    %edx,%ebx
  80297b:	89 d7                	mov    %edx,%edi
  80297d:	89 d6                	mov    %edx,%esi
  80297f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    

00802986 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	57                   	push   %edi
  80298a:	56                   	push   %esi
  80298b:	53                   	push   %ebx
  80298c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80298f:	be 00 00 00 00       	mov    $0x0,%esi
  802994:	8b 55 08             	mov    0x8(%ebp),%edx
  802997:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80299a:	b8 04 00 00 00       	mov    $0x4,%eax
  80299f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029a2:	89 f7                	mov    %esi,%edi
  8029a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	7f 08                	jg     8029b2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8029aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ad:	5b                   	pop    %ebx
  8029ae:	5e                   	pop    %esi
  8029af:	5f                   	pop    %edi
  8029b0:	5d                   	pop    %ebp
  8029b1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8029b2:	83 ec 0c             	sub    $0xc,%esp
  8029b5:	50                   	push   %eax
  8029b6:	6a 04                	push   $0x4
  8029b8:	68 e8 4b 80 00       	push   $0x804be8
  8029bd:	6a 43                	push   $0x43
  8029bf:	68 05 4c 80 00       	push   $0x804c05
  8029c4:	e8 76 f3 ff ff       	call   801d3f <_panic>

008029c9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8029c9:	55                   	push   %ebp
  8029ca:	89 e5                	mov    %esp,%ebp
  8029cc:	57                   	push   %edi
  8029cd:	56                   	push   %esi
  8029ce:	53                   	push   %ebx
  8029cf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8029d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029d8:	b8 05 00 00 00       	mov    $0x5,%eax
  8029dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029e0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8029e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8029e6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	7f 08                	jg     8029f4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8029ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ef:	5b                   	pop    %ebx
  8029f0:	5e                   	pop    %esi
  8029f1:	5f                   	pop    %edi
  8029f2:	5d                   	pop    %ebp
  8029f3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8029f4:	83 ec 0c             	sub    $0xc,%esp
  8029f7:	50                   	push   %eax
  8029f8:	6a 05                	push   $0x5
  8029fa:	68 e8 4b 80 00       	push   $0x804be8
  8029ff:	6a 43                	push   $0x43
  802a01:	68 05 4c 80 00       	push   $0x804c05
  802a06:	e8 34 f3 ff ff       	call   801d3f <_panic>

00802a0b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	57                   	push   %edi
  802a0f:	56                   	push   %esi
  802a10:	53                   	push   %ebx
  802a11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a14:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a19:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a1f:	b8 06 00 00 00       	mov    $0x6,%eax
  802a24:	89 df                	mov    %ebx,%edi
  802a26:	89 de                	mov    %ebx,%esi
  802a28:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	7f 08                	jg     802a36 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a31:	5b                   	pop    %ebx
  802a32:	5e                   	pop    %esi
  802a33:	5f                   	pop    %edi
  802a34:	5d                   	pop    %ebp
  802a35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802a36:	83 ec 0c             	sub    $0xc,%esp
  802a39:	50                   	push   %eax
  802a3a:	6a 06                	push   $0x6
  802a3c:	68 e8 4b 80 00       	push   $0x804be8
  802a41:	6a 43                	push   $0x43
  802a43:	68 05 4c 80 00       	push   $0x804c05
  802a48:	e8 f2 f2 ff ff       	call   801d3f <_panic>

00802a4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802a4d:	55                   	push   %ebp
  802a4e:	89 e5                	mov    %esp,%ebp
  802a50:	57                   	push   %edi
  802a51:	56                   	push   %esi
  802a52:	53                   	push   %ebx
  802a53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a56:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a61:	b8 08 00 00 00       	mov    $0x8,%eax
  802a66:	89 df                	mov    %ebx,%edi
  802a68:	89 de                	mov    %ebx,%esi
  802a6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	7f 08                	jg     802a78 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a73:	5b                   	pop    %ebx
  802a74:	5e                   	pop    %esi
  802a75:	5f                   	pop    %edi
  802a76:	5d                   	pop    %ebp
  802a77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802a78:	83 ec 0c             	sub    $0xc,%esp
  802a7b:	50                   	push   %eax
  802a7c:	6a 08                	push   $0x8
  802a7e:	68 e8 4b 80 00       	push   $0x804be8
  802a83:	6a 43                	push   $0x43
  802a85:	68 05 4c 80 00       	push   $0x804c05
  802a8a:	e8 b0 f2 ff ff       	call   801d3f <_panic>

00802a8f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802a8f:	55                   	push   %ebp
  802a90:	89 e5                	mov    %esp,%ebp
  802a92:	57                   	push   %edi
  802a93:	56                   	push   %esi
  802a94:	53                   	push   %ebx
  802a95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a98:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802aa3:	b8 09 00 00 00       	mov    $0x9,%eax
  802aa8:	89 df                	mov    %ebx,%edi
  802aaa:	89 de                	mov    %ebx,%esi
  802aac:	cd 30                	int    $0x30
	if(check && ret > 0)
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	7f 08                	jg     802aba <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802ab2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ab5:	5b                   	pop    %ebx
  802ab6:	5e                   	pop    %esi
  802ab7:	5f                   	pop    %edi
  802ab8:	5d                   	pop    %ebp
  802ab9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802aba:	83 ec 0c             	sub    $0xc,%esp
  802abd:	50                   	push   %eax
  802abe:	6a 09                	push   $0x9
  802ac0:	68 e8 4b 80 00       	push   $0x804be8
  802ac5:	6a 43                	push   $0x43
  802ac7:	68 05 4c 80 00       	push   $0x804c05
  802acc:	e8 6e f2 ff ff       	call   801d3f <_panic>

00802ad1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802ad1:	55                   	push   %ebp
  802ad2:	89 e5                	mov    %esp,%ebp
  802ad4:	57                   	push   %edi
  802ad5:	56                   	push   %esi
  802ad6:	53                   	push   %ebx
  802ad7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802ada:	bb 00 00 00 00       	mov    $0x0,%ebx
  802adf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ae5:	b8 0a 00 00 00       	mov    $0xa,%eax
  802aea:	89 df                	mov    %ebx,%edi
  802aec:	89 de                	mov    %ebx,%esi
  802aee:	cd 30                	int    $0x30
	if(check && ret > 0)
  802af0:	85 c0                	test   %eax,%eax
  802af2:	7f 08                	jg     802afc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802af4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802af7:	5b                   	pop    %ebx
  802af8:	5e                   	pop    %esi
  802af9:	5f                   	pop    %edi
  802afa:	5d                   	pop    %ebp
  802afb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802afc:	83 ec 0c             	sub    $0xc,%esp
  802aff:	50                   	push   %eax
  802b00:	6a 0a                	push   $0xa
  802b02:	68 e8 4b 80 00       	push   $0x804be8
  802b07:	6a 43                	push   $0x43
  802b09:	68 05 4c 80 00       	push   $0x804c05
  802b0e:	e8 2c f2 ff ff       	call   801d3f <_panic>

00802b13 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802b13:	55                   	push   %ebp
  802b14:	89 e5                	mov    %esp,%ebp
  802b16:	57                   	push   %edi
  802b17:	56                   	push   %esi
  802b18:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b19:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b1f:	b8 0c 00 00 00       	mov    $0xc,%eax
  802b24:	be 00 00 00 00       	mov    $0x0,%esi
  802b29:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b2c:	8b 7d 14             	mov    0x14(%ebp),%edi
  802b2f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802b31:	5b                   	pop    %ebx
  802b32:	5e                   	pop    %esi
  802b33:	5f                   	pop    %edi
  802b34:	5d                   	pop    %ebp
  802b35:	c3                   	ret    

00802b36 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
  802b39:	57                   	push   %edi
  802b3a:	56                   	push   %esi
  802b3b:	53                   	push   %ebx
  802b3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802b3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b44:	8b 55 08             	mov    0x8(%ebp),%edx
  802b47:	b8 0d 00 00 00       	mov    $0xd,%eax
  802b4c:	89 cb                	mov    %ecx,%ebx
  802b4e:	89 cf                	mov    %ecx,%edi
  802b50:	89 ce                	mov    %ecx,%esi
  802b52:	cd 30                	int    $0x30
	if(check && ret > 0)
  802b54:	85 c0                	test   %eax,%eax
  802b56:	7f 08                	jg     802b60 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b5b:	5b                   	pop    %ebx
  802b5c:	5e                   	pop    %esi
  802b5d:	5f                   	pop    %edi
  802b5e:	5d                   	pop    %ebp
  802b5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802b60:	83 ec 0c             	sub    $0xc,%esp
  802b63:	50                   	push   %eax
  802b64:	6a 0d                	push   $0xd
  802b66:	68 e8 4b 80 00       	push   $0x804be8
  802b6b:	6a 43                	push   $0x43
  802b6d:	68 05 4c 80 00       	push   $0x804c05
  802b72:	e8 c8 f1 ff ff       	call   801d3f <_panic>

00802b77 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  802b77:	55                   	push   %ebp
  802b78:	89 e5                	mov    %esp,%ebp
  802b7a:	57                   	push   %edi
  802b7b:	56                   	push   %esi
  802b7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b82:	8b 55 08             	mov    0x8(%ebp),%edx
  802b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b88:	b8 0e 00 00 00       	mov    $0xe,%eax
  802b8d:	89 df                	mov    %ebx,%edi
  802b8f:	89 de                	mov    %ebx,%esi
  802b91:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  802b93:	5b                   	pop    %ebx
  802b94:	5e                   	pop    %esi
  802b95:	5f                   	pop    %edi
  802b96:	5d                   	pop    %ebp
  802b97:	c3                   	ret    

00802b98 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  802b98:	55                   	push   %ebp
  802b99:	89 e5                	mov    %esp,%ebp
  802b9b:	57                   	push   %edi
  802b9c:	56                   	push   %esi
  802b9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ba3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba6:	b8 0f 00 00 00       	mov    $0xf,%eax
  802bab:	89 cb                	mov    %ecx,%ebx
  802bad:	89 cf                	mov    %ecx,%edi
  802baf:	89 ce                	mov    %ecx,%esi
  802bb1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  802bb3:	5b                   	pop    %ebx
  802bb4:	5e                   	pop    %esi
  802bb5:	5f                   	pop    %edi
  802bb6:	5d                   	pop    %ebp
  802bb7:	c3                   	ret    

00802bb8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
  802bbb:	57                   	push   %edi
  802bbc:	56                   	push   %esi
  802bbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  802bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc3:	b8 10 00 00 00       	mov    $0x10,%eax
  802bc8:	89 d1                	mov    %edx,%ecx
  802bca:	89 d3                	mov    %edx,%ebx
  802bcc:	89 d7                	mov    %edx,%edi
  802bce:	89 d6                	mov    %edx,%esi
  802bd0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802bd2:	5b                   	pop    %ebx
  802bd3:	5e                   	pop    %esi
  802bd4:	5f                   	pop    %edi
  802bd5:	5d                   	pop    %ebp
  802bd6:	c3                   	ret    

00802bd7 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  802bd7:	55                   	push   %ebp
  802bd8:	89 e5                	mov    %esp,%ebp
  802bda:	57                   	push   %edi
  802bdb:	56                   	push   %esi
  802bdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  802bdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  802be2:	8b 55 08             	mov    0x8(%ebp),%edx
  802be5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802be8:	b8 11 00 00 00       	mov    $0x11,%eax
  802bed:	89 df                	mov    %ebx,%edi
  802bef:	89 de                	mov    %ebx,%esi
  802bf1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  802bf3:	5b                   	pop    %ebx
  802bf4:	5e                   	pop    %esi
  802bf5:	5f                   	pop    %edi
  802bf6:	5d                   	pop    %ebp
  802bf7:	c3                   	ret    

00802bf8 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
  802bfb:	57                   	push   %edi
  802bfc:	56                   	push   %esi
  802bfd:	53                   	push   %ebx
	asm volatile("int %1\n"
  802bfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c03:	8b 55 08             	mov    0x8(%ebp),%edx
  802c06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c09:	b8 12 00 00 00       	mov    $0x12,%eax
  802c0e:	89 df                	mov    %ebx,%edi
  802c10:	89 de                	mov    %ebx,%esi
  802c12:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  802c14:	5b                   	pop    %ebx
  802c15:	5e                   	pop    %esi
  802c16:	5f                   	pop    %edi
  802c17:	5d                   	pop    %ebp
  802c18:	c3                   	ret    

00802c19 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  802c19:	55                   	push   %ebp
  802c1a:	89 e5                	mov    %esp,%ebp
  802c1c:	57                   	push   %edi
  802c1d:	56                   	push   %esi
  802c1e:	53                   	push   %ebx
  802c1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802c22:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c27:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c2d:	b8 13 00 00 00       	mov    $0x13,%eax
  802c32:	89 df                	mov    %ebx,%edi
  802c34:	89 de                	mov    %ebx,%esi
  802c36:	cd 30                	int    $0x30
	if(check && ret > 0)
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	7f 08                	jg     802c44 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c3f:	5b                   	pop    %ebx
  802c40:	5e                   	pop    %esi
  802c41:	5f                   	pop    %edi
  802c42:	5d                   	pop    %ebp
  802c43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802c44:	83 ec 0c             	sub    $0xc,%esp
  802c47:	50                   	push   %eax
  802c48:	6a 13                	push   $0x13
  802c4a:	68 e8 4b 80 00       	push   $0x804be8
  802c4f:	6a 43                	push   $0x43
  802c51:	68 05 4c 80 00       	push   $0x804c05
  802c56:	e8 e4 f0 ff ff       	call   801d3f <_panic>

00802c5b <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  802c5b:	55                   	push   %ebp
  802c5c:	89 e5                	mov    %esp,%ebp
  802c5e:	57                   	push   %edi
  802c5f:	56                   	push   %esi
  802c60:	53                   	push   %ebx
	asm volatile("int %1\n"
  802c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c66:	8b 55 08             	mov    0x8(%ebp),%edx
  802c69:	b8 14 00 00 00       	mov    $0x14,%eax
  802c6e:	89 cb                	mov    %ecx,%ebx
  802c70:	89 cf                	mov    %ecx,%edi
  802c72:	89 ce                	mov    %ecx,%esi
  802c74:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  802c76:	5b                   	pop    %ebx
  802c77:	5e                   	pop    %esi
  802c78:	5f                   	pop    %edi
  802c79:	5d                   	pop    %ebp
  802c7a:	c3                   	ret    

00802c7b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
  802c7e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802c81:	83 3d 54 a0 80 00 00 	cmpl   $0x0,0x80a054
  802c88:	74 0a                	je     802c94 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	a3 54 a0 80 00       	mov    %eax,0x80a054
}
  802c92:	c9                   	leave  
  802c93:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802c94:	83 ec 04             	sub    $0x4,%esp
  802c97:	6a 07                	push   $0x7
  802c99:	68 00 f0 bf ee       	push   $0xeebff000
  802c9e:	6a 00                	push   $0x0
  802ca0:	e8 e1 fc ff ff       	call   802986 <sys_page_alloc>
		if(r < 0)
  802ca5:	83 c4 10             	add    $0x10,%esp
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	78 2a                	js     802cd6 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802cac:	83 ec 08             	sub    $0x8,%esp
  802caf:	68 ea 2c 80 00       	push   $0x802cea
  802cb4:	6a 00                	push   $0x0
  802cb6:	e8 16 fe ff ff       	call   802ad1 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802cbb:	83 c4 10             	add    $0x10,%esp
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	79 c8                	jns    802c8a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802cc2:	83 ec 04             	sub    $0x4,%esp
  802cc5:	68 44 4c 80 00       	push   $0x804c44
  802cca:	6a 25                	push   $0x25
  802ccc:	68 7d 4c 80 00       	push   $0x804c7d
  802cd1:	e8 69 f0 ff ff       	call   801d3f <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	68 14 4c 80 00       	push   $0x804c14
  802cde:	6a 22                	push   $0x22
  802ce0:	68 7d 4c 80 00       	push   $0x804c7d
  802ce5:	e8 55 f0 ff ff       	call   801d3f <_panic>

00802cea <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802cea:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ceb:	a1 54 a0 80 00       	mov    0x80a054,%eax
	call *%eax
  802cf0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802cf2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802cf5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802cf9:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802cfd:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802d00:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802d02:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802d06:	83 c4 08             	add    $0x8,%esp
	popal
  802d09:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802d0a:	83 c4 04             	add    $0x4,%esp
	popfl
  802d0d:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802d0e:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802d0f:	c3                   	ret    

00802d10 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d10:	55                   	push   %ebp
  802d11:	89 e5                	mov    %esp,%ebp
  802d13:	56                   	push   %esi
  802d14:	53                   	push   %ebx
  802d15:	8b 75 08             	mov    0x8(%ebp),%esi
  802d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802d1e:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802d20:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802d25:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802d28:	83 ec 0c             	sub    $0xc,%esp
  802d2b:	50                   	push   %eax
  802d2c:	e8 05 fe ff ff       	call   802b36 <sys_ipc_recv>
	if(ret < 0){
  802d31:	83 c4 10             	add    $0x10,%esp
  802d34:	85 c0                	test   %eax,%eax
  802d36:	78 2b                	js     802d63 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802d38:	85 f6                	test   %esi,%esi
  802d3a:	74 0a                	je     802d46 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802d3c:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802d41:	8b 40 78             	mov    0x78(%eax),%eax
  802d44:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802d46:	85 db                	test   %ebx,%ebx
  802d48:	74 0a                	je     802d54 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802d4a:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802d4f:	8b 40 7c             	mov    0x7c(%eax),%eax
  802d52:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802d54:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802d59:	8b 40 74             	mov    0x74(%eax),%eax
}
  802d5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d5f:	5b                   	pop    %ebx
  802d60:	5e                   	pop    %esi
  802d61:	5d                   	pop    %ebp
  802d62:	c3                   	ret    
		if(from_env_store)
  802d63:	85 f6                	test   %esi,%esi
  802d65:	74 06                	je     802d6d <ipc_recv+0x5d>
			*from_env_store = 0;
  802d67:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802d6d:	85 db                	test   %ebx,%ebx
  802d6f:	74 eb                	je     802d5c <ipc_recv+0x4c>
			*perm_store = 0;
  802d71:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802d77:	eb e3                	jmp    802d5c <ipc_recv+0x4c>

00802d79 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802d79:	55                   	push   %ebp
  802d7a:	89 e5                	mov    %esp,%ebp
  802d7c:	57                   	push   %edi
  802d7d:	56                   	push   %esi
  802d7e:	53                   	push   %ebx
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	8b 7d 08             	mov    0x8(%ebp),%edi
  802d85:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d88:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802d8b:	85 db                	test   %ebx,%ebx
  802d8d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802d92:	0f 44 d8             	cmove  %eax,%ebx
  802d95:	eb 05                	jmp    802d9c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802d97:	e8 cb fb ff ff       	call   802967 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802d9c:	ff 75 14             	pushl  0x14(%ebp)
  802d9f:	53                   	push   %ebx
  802da0:	56                   	push   %esi
  802da1:	57                   	push   %edi
  802da2:	e8 6c fd ff ff       	call   802b13 <sys_ipc_try_send>
  802da7:	83 c4 10             	add    $0x10,%esp
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 1b                	je     802dc9 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802dae:	79 e7                	jns    802d97 <ipc_send+0x1e>
  802db0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802db3:	74 e2                	je     802d97 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802db5:	83 ec 04             	sub    $0x4,%esp
  802db8:	68 8b 4c 80 00       	push   $0x804c8b
  802dbd:	6a 46                	push   $0x46
  802dbf:	68 a0 4c 80 00       	push   $0x804ca0
  802dc4:	e8 76 ef ff ff       	call   801d3f <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dcc:	5b                   	pop    %ebx
  802dcd:	5e                   	pop    %esi
  802dce:	5f                   	pop    %edi
  802dcf:	5d                   	pop    %ebp
  802dd0:	c3                   	ret    

00802dd1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802dd1:	55                   	push   %ebp
  802dd2:	89 e5                	mov    %esp,%ebp
  802dd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802dd7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802ddc:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802de2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802de8:	8b 52 50             	mov    0x50(%edx),%edx
  802deb:	39 ca                	cmp    %ecx,%edx
  802ded:	74 11                	je     802e00 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802def:	83 c0 01             	add    $0x1,%eax
  802df2:	3d 00 04 00 00       	cmp    $0x400,%eax
  802df7:	75 e3                	jne    802ddc <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802df9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfe:	eb 0e                	jmp    802e0e <ipc_find_env+0x3d>
			return envs[i].env_id;
  802e00:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802e06:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802e0b:	8b 40 48             	mov    0x48(%eax),%eax
}
  802e0e:	5d                   	pop    %ebp
  802e0f:	c3                   	ret    

00802e10 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	05 00 00 00 30       	add    $0x30000000,%eax
  802e1b:	c1 e8 0c             	shr    $0xc,%eax
}
  802e1e:	5d                   	pop    %ebp
  802e1f:	c3                   	ret    

00802e20 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802e2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e30:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802e35:	5d                   	pop    %ebp
  802e36:	c3                   	ret    

00802e37 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802e37:	55                   	push   %ebp
  802e38:	89 e5                	mov    %esp,%ebp
  802e3a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802e3f:	89 c2                	mov    %eax,%edx
  802e41:	c1 ea 16             	shr    $0x16,%edx
  802e44:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802e4b:	f6 c2 01             	test   $0x1,%dl
  802e4e:	74 2d                	je     802e7d <fd_alloc+0x46>
  802e50:	89 c2                	mov    %eax,%edx
  802e52:	c1 ea 0c             	shr    $0xc,%edx
  802e55:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e5c:	f6 c2 01             	test   $0x1,%dl
  802e5f:	74 1c                	je     802e7d <fd_alloc+0x46>
  802e61:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802e66:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802e6b:	75 d2                	jne    802e3f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802e76:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802e7b:	eb 0a                	jmp    802e87 <fd_alloc+0x50>
			*fd_store = fd;
  802e7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e80:	89 01                	mov    %eax,(%ecx)
			return 0;
  802e82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e87:	5d                   	pop    %ebp
  802e88:	c3                   	ret    

00802e89 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802e89:	55                   	push   %ebp
  802e8a:	89 e5                	mov    %esp,%ebp
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802e8f:	83 f8 1f             	cmp    $0x1f,%eax
  802e92:	77 30                	ja     802ec4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802e94:	c1 e0 0c             	shl    $0xc,%eax
  802e97:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802e9c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802ea2:	f6 c2 01             	test   $0x1,%dl
  802ea5:	74 24                	je     802ecb <fd_lookup+0x42>
  802ea7:	89 c2                	mov    %eax,%edx
  802ea9:	c1 ea 0c             	shr    $0xc,%edx
  802eac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802eb3:	f6 c2 01             	test   $0x1,%dl
  802eb6:	74 1a                	je     802ed2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebb:	89 02                	mov    %eax,(%edx)
	return 0;
  802ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ec2:	5d                   	pop    %ebp
  802ec3:	c3                   	ret    
		return -E_INVAL;
  802ec4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ec9:	eb f7                	jmp    802ec2 <fd_lookup+0x39>
		return -E_INVAL;
  802ecb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ed0:	eb f0                	jmp    802ec2 <fd_lookup+0x39>
  802ed2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ed7:	eb e9                	jmp    802ec2 <fd_lookup+0x39>

00802ed9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ed9:	55                   	push   %ebp
  802eda:	89 e5                	mov    %esp,%ebp
  802edc:	83 ec 08             	sub    $0x8,%esp
  802edf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802ee2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee7:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802eec:	39 08                	cmp    %ecx,(%eax)
  802eee:	74 38                	je     802f28 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  802ef0:	83 c2 01             	add    $0x1,%edx
  802ef3:	8b 04 95 2c 4d 80 00 	mov    0x804d2c(,%edx,4),%eax
  802efa:	85 c0                	test   %eax,%eax
  802efc:	75 ee                	jne    802eec <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802efe:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802f03:	8b 40 48             	mov    0x48(%eax),%eax
  802f06:	83 ec 04             	sub    $0x4,%esp
  802f09:	51                   	push   %ecx
  802f0a:	50                   	push   %eax
  802f0b:	68 ac 4c 80 00       	push   $0x804cac
  802f10:	e8 20 ef ff ff       	call   801e35 <cprintf>
	*dev = 0;
  802f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802f1e:	83 c4 10             	add    $0x10,%esp
  802f21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802f26:	c9                   	leave  
  802f27:	c3                   	ret    
			*dev = devtab[i];
  802f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f2b:	89 01                	mov    %eax,(%ecx)
			return 0;
  802f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f32:	eb f2                	jmp    802f26 <dev_lookup+0x4d>

00802f34 <fd_close>:
{
  802f34:	55                   	push   %ebp
  802f35:	89 e5                	mov    %esp,%ebp
  802f37:	57                   	push   %edi
  802f38:	56                   	push   %esi
  802f39:	53                   	push   %ebx
  802f3a:	83 ec 24             	sub    $0x24,%esp
  802f3d:	8b 75 08             	mov    0x8(%ebp),%esi
  802f40:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802f43:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802f46:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802f47:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802f4d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802f50:	50                   	push   %eax
  802f51:	e8 33 ff ff ff       	call   802e89 <fd_lookup>
  802f56:	89 c3                	mov    %eax,%ebx
  802f58:	83 c4 10             	add    $0x10,%esp
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	78 05                	js     802f64 <fd_close+0x30>
	    || fd != fd2)
  802f5f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802f62:	74 16                	je     802f7a <fd_close+0x46>
		return (must_exist ? r : 0);
  802f64:	89 f8                	mov    %edi,%eax
  802f66:	84 c0                	test   %al,%al
  802f68:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6d:	0f 44 d8             	cmove  %eax,%ebx
}
  802f70:	89 d8                	mov    %ebx,%eax
  802f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f75:	5b                   	pop    %ebx
  802f76:	5e                   	pop    %esi
  802f77:	5f                   	pop    %edi
  802f78:	5d                   	pop    %ebp
  802f79:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802f7a:	83 ec 08             	sub    $0x8,%esp
  802f7d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802f80:	50                   	push   %eax
  802f81:	ff 36                	pushl  (%esi)
  802f83:	e8 51 ff ff ff       	call   802ed9 <dev_lookup>
  802f88:	89 c3                	mov    %eax,%ebx
  802f8a:	83 c4 10             	add    $0x10,%esp
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	78 1a                	js     802fab <fd_close+0x77>
		if (dev->dev_close)
  802f91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f94:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802f97:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	74 0b                	je     802fab <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802fa0:	83 ec 0c             	sub    $0xc,%esp
  802fa3:	56                   	push   %esi
  802fa4:	ff d0                	call   *%eax
  802fa6:	89 c3                	mov    %eax,%ebx
  802fa8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802fab:	83 ec 08             	sub    $0x8,%esp
  802fae:	56                   	push   %esi
  802faf:	6a 00                	push   $0x0
  802fb1:	e8 55 fa ff ff       	call   802a0b <sys_page_unmap>
	return r;
  802fb6:	83 c4 10             	add    $0x10,%esp
  802fb9:	eb b5                	jmp    802f70 <fd_close+0x3c>

00802fbb <close>:

int
close(int fdnum)
{
  802fbb:	55                   	push   %ebp
  802fbc:	89 e5                	mov    %esp,%ebp
  802fbe:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fc4:	50                   	push   %eax
  802fc5:	ff 75 08             	pushl  0x8(%ebp)
  802fc8:	e8 bc fe ff ff       	call   802e89 <fd_lookup>
  802fcd:	83 c4 10             	add    $0x10,%esp
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	79 02                	jns    802fd6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802fd4:	c9                   	leave  
  802fd5:	c3                   	ret    
		return fd_close(fd, 1);
  802fd6:	83 ec 08             	sub    $0x8,%esp
  802fd9:	6a 01                	push   $0x1
  802fdb:	ff 75 f4             	pushl  -0xc(%ebp)
  802fde:	e8 51 ff ff ff       	call   802f34 <fd_close>
  802fe3:	83 c4 10             	add    $0x10,%esp
  802fe6:	eb ec                	jmp    802fd4 <close+0x19>

00802fe8 <close_all>:

void
close_all(void)
{
  802fe8:	55                   	push   %ebp
  802fe9:	89 e5                	mov    %esp,%ebp
  802feb:	53                   	push   %ebx
  802fec:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802fef:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802ff4:	83 ec 0c             	sub    $0xc,%esp
  802ff7:	53                   	push   %ebx
  802ff8:	e8 be ff ff ff       	call   802fbb <close>
	for (i = 0; i < MAXFD; i++)
  802ffd:	83 c3 01             	add    $0x1,%ebx
  803000:	83 c4 10             	add    $0x10,%esp
  803003:	83 fb 20             	cmp    $0x20,%ebx
  803006:	75 ec                	jne    802ff4 <close_all+0xc>
}
  803008:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80300b:	c9                   	leave  
  80300c:	c3                   	ret    

0080300d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80300d:	55                   	push   %ebp
  80300e:	89 e5                	mov    %esp,%ebp
  803010:	57                   	push   %edi
  803011:	56                   	push   %esi
  803012:	53                   	push   %ebx
  803013:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803016:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803019:	50                   	push   %eax
  80301a:	ff 75 08             	pushl  0x8(%ebp)
  80301d:	e8 67 fe ff ff       	call   802e89 <fd_lookup>
  803022:	89 c3                	mov    %eax,%ebx
  803024:	83 c4 10             	add    $0x10,%esp
  803027:	85 c0                	test   %eax,%eax
  803029:	0f 88 81 00 00 00    	js     8030b0 <dup+0xa3>
		return r;
	close(newfdnum);
  80302f:	83 ec 0c             	sub    $0xc,%esp
  803032:	ff 75 0c             	pushl  0xc(%ebp)
  803035:	e8 81 ff ff ff       	call   802fbb <close>

	newfd = INDEX2FD(newfdnum);
  80303a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80303d:	c1 e6 0c             	shl    $0xc,%esi
  803040:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  803046:	83 c4 04             	add    $0x4,%esp
  803049:	ff 75 e4             	pushl  -0x1c(%ebp)
  80304c:	e8 cf fd ff ff       	call   802e20 <fd2data>
  803051:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  803053:	89 34 24             	mov    %esi,(%esp)
  803056:	e8 c5 fd ff ff       	call   802e20 <fd2data>
  80305b:	83 c4 10             	add    $0x10,%esp
  80305e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803060:	89 d8                	mov    %ebx,%eax
  803062:	c1 e8 16             	shr    $0x16,%eax
  803065:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80306c:	a8 01                	test   $0x1,%al
  80306e:	74 11                	je     803081 <dup+0x74>
  803070:	89 d8                	mov    %ebx,%eax
  803072:	c1 e8 0c             	shr    $0xc,%eax
  803075:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80307c:	f6 c2 01             	test   $0x1,%dl
  80307f:	75 39                	jne    8030ba <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803081:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803084:	89 d0                	mov    %edx,%eax
  803086:	c1 e8 0c             	shr    $0xc,%eax
  803089:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  803090:	83 ec 0c             	sub    $0xc,%esp
  803093:	25 07 0e 00 00       	and    $0xe07,%eax
  803098:	50                   	push   %eax
  803099:	56                   	push   %esi
  80309a:	6a 00                	push   $0x0
  80309c:	52                   	push   %edx
  80309d:	6a 00                	push   $0x0
  80309f:	e8 25 f9 ff ff       	call   8029c9 <sys_page_map>
  8030a4:	89 c3                	mov    %eax,%ebx
  8030a6:	83 c4 20             	add    $0x20,%esp
  8030a9:	85 c0                	test   %eax,%eax
  8030ab:	78 31                	js     8030de <dup+0xd1>
		goto err;

	return newfdnum;
  8030ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8030b0:	89 d8                	mov    %ebx,%eax
  8030b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8030b5:	5b                   	pop    %ebx
  8030b6:	5e                   	pop    %esi
  8030b7:	5f                   	pop    %edi
  8030b8:	5d                   	pop    %ebp
  8030b9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8030ba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8030c1:	83 ec 0c             	sub    $0xc,%esp
  8030c4:	25 07 0e 00 00       	and    $0xe07,%eax
  8030c9:	50                   	push   %eax
  8030ca:	57                   	push   %edi
  8030cb:	6a 00                	push   $0x0
  8030cd:	53                   	push   %ebx
  8030ce:	6a 00                	push   $0x0
  8030d0:	e8 f4 f8 ff ff       	call   8029c9 <sys_page_map>
  8030d5:	89 c3                	mov    %eax,%ebx
  8030d7:	83 c4 20             	add    $0x20,%esp
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	79 a3                	jns    803081 <dup+0x74>
	sys_page_unmap(0, newfd);
  8030de:	83 ec 08             	sub    $0x8,%esp
  8030e1:	56                   	push   %esi
  8030e2:	6a 00                	push   $0x0
  8030e4:	e8 22 f9 ff ff       	call   802a0b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8030e9:	83 c4 08             	add    $0x8,%esp
  8030ec:	57                   	push   %edi
  8030ed:	6a 00                	push   $0x0
  8030ef:	e8 17 f9 ff ff       	call   802a0b <sys_page_unmap>
	return r;
  8030f4:	83 c4 10             	add    $0x10,%esp
  8030f7:	eb b7                	jmp    8030b0 <dup+0xa3>

008030f9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8030f9:	55                   	push   %ebp
  8030fa:	89 e5                	mov    %esp,%ebp
  8030fc:	53                   	push   %ebx
  8030fd:	83 ec 1c             	sub    $0x1c,%esp
  803100:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803103:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803106:	50                   	push   %eax
  803107:	53                   	push   %ebx
  803108:	e8 7c fd ff ff       	call   802e89 <fd_lookup>
  80310d:	83 c4 10             	add    $0x10,%esp
  803110:	85 c0                	test   %eax,%eax
  803112:	78 3f                	js     803153 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803114:	83 ec 08             	sub    $0x8,%esp
  803117:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80311a:	50                   	push   %eax
  80311b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311e:	ff 30                	pushl  (%eax)
  803120:	e8 b4 fd ff ff       	call   802ed9 <dev_lookup>
  803125:	83 c4 10             	add    $0x10,%esp
  803128:	85 c0                	test   %eax,%eax
  80312a:	78 27                	js     803153 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80312c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80312f:	8b 42 08             	mov    0x8(%edx),%eax
  803132:	83 e0 03             	and    $0x3,%eax
  803135:	83 f8 01             	cmp    $0x1,%eax
  803138:	74 1e                	je     803158 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 08             	mov    0x8(%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	74 35                	je     803179 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  803144:	83 ec 04             	sub    $0x4,%esp
  803147:	ff 75 10             	pushl  0x10(%ebp)
  80314a:	ff 75 0c             	pushl  0xc(%ebp)
  80314d:	52                   	push   %edx
  80314e:	ff d0                	call   *%eax
  803150:	83 c4 10             	add    $0x10,%esp
}
  803153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803156:	c9                   	leave  
  803157:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803158:	a1 50 a0 80 00       	mov    0x80a050,%eax
  80315d:	8b 40 48             	mov    0x48(%eax),%eax
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	53                   	push   %ebx
  803164:	50                   	push   %eax
  803165:	68 f0 4c 80 00       	push   $0x804cf0
  80316a:	e8 c6 ec ff ff       	call   801e35 <cprintf>
		return -E_INVAL;
  80316f:	83 c4 10             	add    $0x10,%esp
  803172:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803177:	eb da                	jmp    803153 <read+0x5a>
		return -E_NOT_SUPP;
  803179:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80317e:	eb d3                	jmp    803153 <read+0x5a>

00803180 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803180:	55                   	push   %ebp
  803181:	89 e5                	mov    %esp,%ebp
  803183:	57                   	push   %edi
  803184:	56                   	push   %esi
  803185:	53                   	push   %ebx
  803186:	83 ec 0c             	sub    $0xc,%esp
  803189:	8b 7d 08             	mov    0x8(%ebp),%edi
  80318c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80318f:	bb 00 00 00 00       	mov    $0x0,%ebx
  803194:	39 f3                	cmp    %esi,%ebx
  803196:	73 23                	jae    8031bb <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803198:	83 ec 04             	sub    $0x4,%esp
  80319b:	89 f0                	mov    %esi,%eax
  80319d:	29 d8                	sub    %ebx,%eax
  80319f:	50                   	push   %eax
  8031a0:	89 d8                	mov    %ebx,%eax
  8031a2:	03 45 0c             	add    0xc(%ebp),%eax
  8031a5:	50                   	push   %eax
  8031a6:	57                   	push   %edi
  8031a7:	e8 4d ff ff ff       	call   8030f9 <read>
		if (m < 0)
  8031ac:	83 c4 10             	add    $0x10,%esp
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	78 06                	js     8031b9 <readn+0x39>
			return m;
		if (m == 0)
  8031b3:	74 06                	je     8031bb <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8031b5:	01 c3                	add    %eax,%ebx
  8031b7:	eb db                	jmp    803194 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8031b9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8031bb:	89 d8                	mov    %ebx,%eax
  8031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8031c0:	5b                   	pop    %ebx
  8031c1:	5e                   	pop    %esi
  8031c2:	5f                   	pop    %edi
  8031c3:	5d                   	pop    %ebp
  8031c4:	c3                   	ret    

008031c5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8031c5:	55                   	push   %ebp
  8031c6:	89 e5                	mov    %esp,%ebp
  8031c8:	53                   	push   %ebx
  8031c9:	83 ec 1c             	sub    $0x1c,%esp
  8031cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031d2:	50                   	push   %eax
  8031d3:	53                   	push   %ebx
  8031d4:	e8 b0 fc ff ff       	call   802e89 <fd_lookup>
  8031d9:	83 c4 10             	add    $0x10,%esp
  8031dc:	85 c0                	test   %eax,%eax
  8031de:	78 3a                	js     80321a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031e0:	83 ec 08             	sub    $0x8,%esp
  8031e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031e6:	50                   	push   %eax
  8031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ea:	ff 30                	pushl  (%eax)
  8031ec:	e8 e8 fc ff ff       	call   802ed9 <dev_lookup>
  8031f1:	83 c4 10             	add    $0x10,%esp
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	78 22                	js     80321a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8031ff:	74 1e                	je     80321f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803204:	8b 52 0c             	mov    0xc(%edx),%edx
  803207:	85 d2                	test   %edx,%edx
  803209:	74 35                	je     803240 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80320b:	83 ec 04             	sub    $0x4,%esp
  80320e:	ff 75 10             	pushl  0x10(%ebp)
  803211:	ff 75 0c             	pushl  0xc(%ebp)
  803214:	50                   	push   %eax
  803215:	ff d2                	call   *%edx
  803217:	83 c4 10             	add    $0x10,%esp
}
  80321a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80321d:	c9                   	leave  
  80321e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80321f:	a1 50 a0 80 00       	mov    0x80a050,%eax
  803224:	8b 40 48             	mov    0x48(%eax),%eax
  803227:	83 ec 04             	sub    $0x4,%esp
  80322a:	53                   	push   %ebx
  80322b:	50                   	push   %eax
  80322c:	68 0c 4d 80 00       	push   $0x804d0c
  803231:	e8 ff eb ff ff       	call   801e35 <cprintf>
		return -E_INVAL;
  803236:	83 c4 10             	add    $0x10,%esp
  803239:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80323e:	eb da                	jmp    80321a <write+0x55>
		return -E_NOT_SUPP;
  803240:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803245:	eb d3                	jmp    80321a <write+0x55>

00803247 <seek>:

int
seek(int fdnum, off_t offset)
{
  803247:	55                   	push   %ebp
  803248:	89 e5                	mov    %esp,%ebp
  80324a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80324d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803250:	50                   	push   %eax
  803251:	ff 75 08             	pushl  0x8(%ebp)
  803254:	e8 30 fc ff ff       	call   802e89 <fd_lookup>
  803259:	83 c4 10             	add    $0x10,%esp
  80325c:	85 c0                	test   %eax,%eax
  80325e:	78 0e                	js     80326e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  803260:	8b 55 0c             	mov    0xc(%ebp),%edx
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  803269:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326e:	c9                   	leave  
  80326f:	c3                   	ret    

00803270 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
  803273:	53                   	push   %ebx
  803274:	83 ec 1c             	sub    $0x1c,%esp
  803277:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80327a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80327d:	50                   	push   %eax
  80327e:	53                   	push   %ebx
  80327f:	e8 05 fc ff ff       	call   802e89 <fd_lookup>
  803284:	83 c4 10             	add    $0x10,%esp
  803287:	85 c0                	test   %eax,%eax
  803289:	78 37                	js     8032c2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80328b:	83 ec 08             	sub    $0x8,%esp
  80328e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803291:	50                   	push   %eax
  803292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803295:	ff 30                	pushl  (%eax)
  803297:	e8 3d fc ff ff       	call   802ed9 <dev_lookup>
  80329c:	83 c4 10             	add    $0x10,%esp
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	78 1f                	js     8032c2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8032a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8032aa:	74 1b                	je     8032c7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8032ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032af:	8b 52 18             	mov    0x18(%edx),%edx
  8032b2:	85 d2                	test   %edx,%edx
  8032b4:	74 32                	je     8032e8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8032b6:	83 ec 08             	sub    $0x8,%esp
  8032b9:	ff 75 0c             	pushl  0xc(%ebp)
  8032bc:	50                   	push   %eax
  8032bd:	ff d2                	call   *%edx
  8032bf:	83 c4 10             	add    $0x10,%esp
}
  8032c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032c5:	c9                   	leave  
  8032c6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8032c7:	a1 50 a0 80 00       	mov    0x80a050,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8032cc:	8b 40 48             	mov    0x48(%eax),%eax
  8032cf:	83 ec 04             	sub    $0x4,%esp
  8032d2:	53                   	push   %ebx
  8032d3:	50                   	push   %eax
  8032d4:	68 cc 4c 80 00       	push   $0x804ccc
  8032d9:	e8 57 eb ff ff       	call   801e35 <cprintf>
		return -E_INVAL;
  8032de:	83 c4 10             	add    $0x10,%esp
  8032e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032e6:	eb da                	jmp    8032c2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8032e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8032ed:	eb d3                	jmp    8032c2 <ftruncate+0x52>

008032ef <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8032ef:	55                   	push   %ebp
  8032f0:	89 e5                	mov    %esp,%ebp
  8032f2:	53                   	push   %ebx
  8032f3:	83 ec 1c             	sub    $0x1c,%esp
  8032f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8032fc:	50                   	push   %eax
  8032fd:	ff 75 08             	pushl  0x8(%ebp)
  803300:	e8 84 fb ff ff       	call   802e89 <fd_lookup>
  803305:	83 c4 10             	add    $0x10,%esp
  803308:	85 c0                	test   %eax,%eax
  80330a:	78 4b                	js     803357 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80330c:	83 ec 08             	sub    $0x8,%esp
  80330f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803312:	50                   	push   %eax
  803313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803316:	ff 30                	pushl  (%eax)
  803318:	e8 bc fb ff ff       	call   802ed9 <dev_lookup>
  80331d:	83 c4 10             	add    $0x10,%esp
  803320:	85 c0                	test   %eax,%eax
  803322:	78 33                	js     803357 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80332b:	74 2f                	je     80335c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80332d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  803330:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  803337:	00 00 00 
	stat->st_isdir = 0;
  80333a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803341:	00 00 00 
	stat->st_dev = dev;
  803344:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80334a:	83 ec 08             	sub    $0x8,%esp
  80334d:	53                   	push   %ebx
  80334e:	ff 75 f0             	pushl  -0x10(%ebp)
  803351:	ff 50 14             	call   *0x14(%eax)
  803354:	83 c4 10             	add    $0x10,%esp
}
  803357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80335a:	c9                   	leave  
  80335b:	c3                   	ret    
		return -E_NOT_SUPP;
  80335c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803361:	eb f4                	jmp    803357 <fstat+0x68>

00803363 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803363:	55                   	push   %ebp
  803364:	89 e5                	mov    %esp,%ebp
  803366:	56                   	push   %esi
  803367:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803368:	83 ec 08             	sub    $0x8,%esp
  80336b:	6a 00                	push   $0x0
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	e8 22 02 00 00       	call   803597 <open>
  803375:	89 c3                	mov    %eax,%ebx
  803377:	83 c4 10             	add    $0x10,%esp
  80337a:	85 c0                	test   %eax,%eax
  80337c:	78 1b                	js     803399 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80337e:	83 ec 08             	sub    $0x8,%esp
  803381:	ff 75 0c             	pushl  0xc(%ebp)
  803384:	50                   	push   %eax
  803385:	e8 65 ff ff ff       	call   8032ef <fstat>
  80338a:	89 c6                	mov    %eax,%esi
	close(fd);
  80338c:	89 1c 24             	mov    %ebx,(%esp)
  80338f:	e8 27 fc ff ff       	call   802fbb <close>
	return r;
  803394:	83 c4 10             	add    $0x10,%esp
  803397:	89 f3                	mov    %esi,%ebx
}
  803399:	89 d8                	mov    %ebx,%eax
  80339b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80339e:	5b                   	pop    %ebx
  80339f:	5e                   	pop    %esi
  8033a0:	5d                   	pop    %ebp
  8033a1:	c3                   	ret    

008033a2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8033a2:	55                   	push   %ebp
  8033a3:	89 e5                	mov    %esp,%ebp
  8033a5:	56                   	push   %esi
  8033a6:	53                   	push   %ebx
  8033a7:	89 c6                	mov    %eax,%esi
  8033a9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8033ab:	83 3d 40 a0 80 00 00 	cmpl   $0x0,0x80a040
  8033b2:	74 27                	je     8033db <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8033b4:	6a 07                	push   $0x7
  8033b6:	68 00 b0 80 00       	push   $0x80b000
  8033bb:	56                   	push   %esi
  8033bc:	ff 35 40 a0 80 00    	pushl  0x80a040
  8033c2:	e8 b2 f9 ff ff       	call   802d79 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8033c7:	83 c4 0c             	add    $0xc,%esp
  8033ca:	6a 00                	push   $0x0
  8033cc:	53                   	push   %ebx
  8033cd:	6a 00                	push   $0x0
  8033cf:	e8 3c f9 ff ff       	call   802d10 <ipc_recv>
}
  8033d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8033d7:	5b                   	pop    %ebx
  8033d8:	5e                   	pop    %esi
  8033d9:	5d                   	pop    %ebp
  8033da:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033db:	83 ec 0c             	sub    $0xc,%esp
  8033de:	6a 01                	push   $0x1
  8033e0:	e8 ec f9 ff ff       	call   802dd1 <ipc_find_env>
  8033e5:	a3 40 a0 80 00       	mov    %eax,0x80a040
  8033ea:	83 c4 10             	add    $0x10,%esp
  8033ed:	eb c5                	jmp    8033b4 <fsipc+0x12>

008033ef <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8033ef:	55                   	push   %ebp
  8033f0:	89 e5                	mov    %esp,%ebp
  8033f2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fb:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  803400:	8b 45 0c             	mov    0xc(%ebp),%eax
  803403:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803408:	ba 00 00 00 00       	mov    $0x0,%edx
  80340d:	b8 02 00 00 00       	mov    $0x2,%eax
  803412:	e8 8b ff ff ff       	call   8033a2 <fsipc>
}
  803417:	c9                   	leave  
  803418:	c3                   	ret    

00803419 <devfile_flush>:
{
  803419:	55                   	push   %ebp
  80341a:	89 e5                	mov    %esp,%ebp
  80341c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 40 0c             	mov    0xc(%eax),%eax
  803425:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  80342a:	ba 00 00 00 00       	mov    $0x0,%edx
  80342f:	b8 06 00 00 00       	mov    $0x6,%eax
  803434:	e8 69 ff ff ff       	call   8033a2 <fsipc>
}
  803439:	c9                   	leave  
  80343a:	c3                   	ret    

0080343b <devfile_stat>:
{
  80343b:	55                   	push   %ebp
  80343c:	89 e5                	mov    %esp,%ebp
  80343e:	53                   	push   %ebx
  80343f:	83 ec 04             	sub    $0x4,%esp
  803442:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	8b 40 0c             	mov    0xc(%eax),%eax
  80344b:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803450:	ba 00 00 00 00       	mov    $0x0,%edx
  803455:	b8 05 00 00 00       	mov    $0x5,%eax
  80345a:	e8 43 ff ff ff       	call   8033a2 <fsipc>
  80345f:	85 c0                	test   %eax,%eax
  803461:	78 2c                	js     80348f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803463:	83 ec 08             	sub    $0x8,%esp
  803466:	68 00 b0 80 00       	push   $0x80b000
  80346b:	53                   	push   %ebx
  80346c:	e8 23 f1 ff ff       	call   802594 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  803471:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803476:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80347c:	a1 84 b0 80 00       	mov    0x80b084,%eax
  803481:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803487:	83 c4 10             	add    $0x10,%esp
  80348a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803492:	c9                   	leave  
  803493:	c3                   	ret    

00803494 <devfile_write>:
{
  803494:	55                   	push   %ebp
  803495:	89 e5                	mov    %esp,%ebp
  803497:	53                   	push   %ebx
  803498:	83 ec 08             	sub    $0x8,%esp
  80349b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a4:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  8034a9:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8034af:	53                   	push   %ebx
  8034b0:	ff 75 0c             	pushl  0xc(%ebp)
  8034b3:	68 08 b0 80 00       	push   $0x80b008
  8034b8:	e8 c7 f2 ff ff       	call   802784 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8034bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8034c2:	b8 04 00 00 00       	mov    $0x4,%eax
  8034c7:	e8 d6 fe ff ff       	call   8033a2 <fsipc>
  8034cc:	83 c4 10             	add    $0x10,%esp
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	78 0b                	js     8034de <devfile_write+0x4a>
	assert(r <= n);
  8034d3:	39 d8                	cmp    %ebx,%eax
  8034d5:	77 0c                	ja     8034e3 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8034d7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8034dc:	7f 1e                	jg     8034fc <devfile_write+0x68>
}
  8034de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034e1:	c9                   	leave  
  8034e2:	c3                   	ret    
	assert(r <= n);
  8034e3:	68 40 4d 80 00       	push   $0x804d40
  8034e8:	68 3d 42 80 00       	push   $0x80423d
  8034ed:	68 98 00 00 00       	push   $0x98
  8034f2:	68 47 4d 80 00       	push   $0x804d47
  8034f7:	e8 43 e8 ff ff       	call   801d3f <_panic>
	assert(r <= PGSIZE);
  8034fc:	68 52 4d 80 00       	push   $0x804d52
  803501:	68 3d 42 80 00       	push   $0x80423d
  803506:	68 99 00 00 00       	push   $0x99
  80350b:	68 47 4d 80 00       	push   $0x804d47
  803510:	e8 2a e8 ff ff       	call   801d3f <_panic>

00803515 <devfile_read>:
{
  803515:	55                   	push   %ebp
  803516:	89 e5                	mov    %esp,%ebp
  803518:	56                   	push   %esi
  803519:	53                   	push   %ebx
  80351a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	8b 40 0c             	mov    0xc(%eax),%eax
  803523:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803528:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80352e:	ba 00 00 00 00       	mov    $0x0,%edx
  803533:	b8 03 00 00 00       	mov    $0x3,%eax
  803538:	e8 65 fe ff ff       	call   8033a2 <fsipc>
  80353d:	89 c3                	mov    %eax,%ebx
  80353f:	85 c0                	test   %eax,%eax
  803541:	78 1f                	js     803562 <devfile_read+0x4d>
	assert(r <= n);
  803543:	39 f0                	cmp    %esi,%eax
  803545:	77 24                	ja     80356b <devfile_read+0x56>
	assert(r <= PGSIZE);
  803547:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80354c:	7f 33                	jg     803581 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80354e:	83 ec 04             	sub    $0x4,%esp
  803551:	50                   	push   %eax
  803552:	68 00 b0 80 00       	push   $0x80b000
  803557:	ff 75 0c             	pushl  0xc(%ebp)
  80355a:	e8 c3 f1 ff ff       	call   802722 <memmove>
	return r;
  80355f:	83 c4 10             	add    $0x10,%esp
}
  803562:	89 d8                	mov    %ebx,%eax
  803564:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5d                   	pop    %ebp
  80356a:	c3                   	ret    
	assert(r <= n);
  80356b:	68 40 4d 80 00       	push   $0x804d40
  803570:	68 3d 42 80 00       	push   $0x80423d
  803575:	6a 7c                	push   $0x7c
  803577:	68 47 4d 80 00       	push   $0x804d47
  80357c:	e8 be e7 ff ff       	call   801d3f <_panic>
	assert(r <= PGSIZE);
  803581:	68 52 4d 80 00       	push   $0x804d52
  803586:	68 3d 42 80 00       	push   $0x80423d
  80358b:	6a 7d                	push   $0x7d
  80358d:	68 47 4d 80 00       	push   $0x804d47
  803592:	e8 a8 e7 ff ff       	call   801d3f <_panic>

00803597 <open>:
{
  803597:	55                   	push   %ebp
  803598:	89 e5                	mov    %esp,%ebp
  80359a:	56                   	push   %esi
  80359b:	53                   	push   %ebx
  80359c:	83 ec 1c             	sub    $0x1c,%esp
  80359f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8035a2:	56                   	push   %esi
  8035a3:	e8 b3 ef ff ff       	call   80255b <strlen>
  8035a8:	83 c4 10             	add    $0x10,%esp
  8035ab:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8035b0:	7f 6c                	jg     80361e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8035b2:	83 ec 0c             	sub    $0xc,%esp
  8035b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035b8:	50                   	push   %eax
  8035b9:	e8 79 f8 ff ff       	call   802e37 <fd_alloc>
  8035be:	89 c3                	mov    %eax,%ebx
  8035c0:	83 c4 10             	add    $0x10,%esp
  8035c3:	85 c0                	test   %eax,%eax
  8035c5:	78 3c                	js     803603 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8035c7:	83 ec 08             	sub    $0x8,%esp
  8035ca:	56                   	push   %esi
  8035cb:	68 00 b0 80 00       	push   $0x80b000
  8035d0:	e8 bf ef ff ff       	call   802594 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8035d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d8:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8035dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e5:	e8 b8 fd ff ff       	call   8033a2 <fsipc>
  8035ea:	89 c3                	mov    %eax,%ebx
  8035ec:	83 c4 10             	add    $0x10,%esp
  8035ef:	85 c0                	test   %eax,%eax
  8035f1:	78 19                	js     80360c <open+0x75>
	return fd2num(fd);
  8035f3:	83 ec 0c             	sub    $0xc,%esp
  8035f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8035f9:	e8 12 f8 ff ff       	call   802e10 <fd2num>
  8035fe:	89 c3                	mov    %eax,%ebx
  803600:	83 c4 10             	add    $0x10,%esp
}
  803603:	89 d8                	mov    %ebx,%eax
  803605:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803608:	5b                   	pop    %ebx
  803609:	5e                   	pop    %esi
  80360a:	5d                   	pop    %ebp
  80360b:	c3                   	ret    
		fd_close(fd, 0);
  80360c:	83 ec 08             	sub    $0x8,%esp
  80360f:	6a 00                	push   $0x0
  803611:	ff 75 f4             	pushl  -0xc(%ebp)
  803614:	e8 1b f9 ff ff       	call   802f34 <fd_close>
		return r;
  803619:	83 c4 10             	add    $0x10,%esp
  80361c:	eb e5                	jmp    803603 <open+0x6c>
		return -E_BAD_PATH;
  80361e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  803623:	eb de                	jmp    803603 <open+0x6c>

00803625 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803625:	55                   	push   %ebp
  803626:	89 e5                	mov    %esp,%ebp
  803628:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80362b:	ba 00 00 00 00       	mov    $0x0,%edx
  803630:	b8 08 00 00 00       	mov    $0x8,%eax
  803635:	e8 68 fd ff ff       	call   8033a2 <fsipc>
}
  80363a:	c9                   	leave  
  80363b:	c3                   	ret    

0080363c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80363c:	55                   	push   %ebp
  80363d:	89 e5                	mov    %esp,%ebp
  80363f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803642:	89 d0                	mov    %edx,%eax
  803644:	c1 e8 16             	shr    $0x16,%eax
  803647:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80364e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803653:	f6 c1 01             	test   $0x1,%cl
  803656:	74 1d                	je     803675 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803658:	c1 ea 0c             	shr    $0xc,%edx
  80365b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803662:	f6 c2 01             	test   $0x1,%dl
  803665:	74 0e                	je     803675 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803667:	c1 ea 0c             	shr    $0xc,%edx
  80366a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803671:	ef 
  803672:	0f b7 c0             	movzwl %ax,%eax
}
  803675:	5d                   	pop    %ebp
  803676:	c3                   	ret    

00803677 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803677:	55                   	push   %ebp
  803678:	89 e5                	mov    %esp,%ebp
  80367a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80367d:	68 5e 4d 80 00       	push   $0x804d5e
  803682:	ff 75 0c             	pushl  0xc(%ebp)
  803685:	e8 0a ef ff ff       	call   802594 <strcpy>
	return 0;
}
  80368a:	b8 00 00 00 00       	mov    $0x0,%eax
  80368f:	c9                   	leave  
  803690:	c3                   	ret    

00803691 <devsock_close>:
{
  803691:	55                   	push   %ebp
  803692:	89 e5                	mov    %esp,%ebp
  803694:	53                   	push   %ebx
  803695:	83 ec 10             	sub    $0x10,%esp
  803698:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80369b:	53                   	push   %ebx
  80369c:	e8 9b ff ff ff       	call   80363c <pageref>
  8036a1:	83 c4 10             	add    $0x10,%esp
		return 0;
  8036a4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8036a9:	83 f8 01             	cmp    $0x1,%eax
  8036ac:	74 07                	je     8036b5 <devsock_close+0x24>
}
  8036ae:	89 d0                	mov    %edx,%eax
  8036b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036b3:	c9                   	leave  
  8036b4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8036b5:	83 ec 0c             	sub    $0xc,%esp
  8036b8:	ff 73 0c             	pushl  0xc(%ebx)
  8036bb:	e8 b9 02 00 00       	call   803979 <nsipc_close>
  8036c0:	89 c2                	mov    %eax,%edx
  8036c2:	83 c4 10             	add    $0x10,%esp
  8036c5:	eb e7                	jmp    8036ae <devsock_close+0x1d>

008036c7 <devsock_write>:
{
  8036c7:	55                   	push   %ebp
  8036c8:	89 e5                	mov    %esp,%ebp
  8036ca:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8036cd:	6a 00                	push   $0x0
  8036cf:	ff 75 10             	pushl  0x10(%ebp)
  8036d2:	ff 75 0c             	pushl  0xc(%ebp)
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	ff 70 0c             	pushl  0xc(%eax)
  8036db:	e8 76 03 00 00       	call   803a56 <nsipc_send>
}
  8036e0:	c9                   	leave  
  8036e1:	c3                   	ret    

008036e2 <devsock_read>:
{
  8036e2:	55                   	push   %ebp
  8036e3:	89 e5                	mov    %esp,%ebp
  8036e5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036e8:	6a 00                	push   $0x0
  8036ea:	ff 75 10             	pushl  0x10(%ebp)
  8036ed:	ff 75 0c             	pushl  0xc(%ebp)
  8036f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f3:	ff 70 0c             	pushl  0xc(%eax)
  8036f6:	e8 ef 02 00 00       	call   8039ea <nsipc_recv>
}
  8036fb:	c9                   	leave  
  8036fc:	c3                   	ret    

008036fd <fd2sockid>:
{
  8036fd:	55                   	push   %ebp
  8036fe:	89 e5                	mov    %esp,%ebp
  803700:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  803703:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803706:	52                   	push   %edx
  803707:	50                   	push   %eax
  803708:	e8 7c f7 ff ff       	call   802e89 <fd_lookup>
  80370d:	83 c4 10             	add    $0x10,%esp
  803710:	85 c0                	test   %eax,%eax
  803712:	78 10                	js     803724 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  803714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803717:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  80371d:	39 08                	cmp    %ecx,(%eax)
  80371f:	75 05                	jne    803726 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  803721:	8b 40 0c             	mov    0xc(%eax),%eax
}
  803724:	c9                   	leave  
  803725:	c3                   	ret    
		return -E_NOT_SUPP;
  803726:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80372b:	eb f7                	jmp    803724 <fd2sockid+0x27>

0080372d <alloc_sockfd>:
{
  80372d:	55                   	push   %ebp
  80372e:	89 e5                	mov    %esp,%ebp
  803730:	56                   	push   %esi
  803731:	53                   	push   %ebx
  803732:	83 ec 1c             	sub    $0x1c,%esp
  803735:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  803737:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80373a:	50                   	push   %eax
  80373b:	e8 f7 f6 ff ff       	call   802e37 <fd_alloc>
  803740:	89 c3                	mov    %eax,%ebx
  803742:	83 c4 10             	add    $0x10,%esp
  803745:	85 c0                	test   %eax,%eax
  803747:	78 43                	js     80378c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803749:	83 ec 04             	sub    $0x4,%esp
  80374c:	68 07 04 00 00       	push   $0x407
  803751:	ff 75 f4             	pushl  -0xc(%ebp)
  803754:	6a 00                	push   $0x0
  803756:	e8 2b f2 ff ff       	call   802986 <sys_page_alloc>
  80375b:	89 c3                	mov    %eax,%ebx
  80375d:	83 c4 10             	add    $0x10,%esp
  803760:	85 c0                	test   %eax,%eax
  803762:	78 28                	js     80378c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  803764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803767:	8b 15 80 90 80 00    	mov    0x809080,%edx
  80376d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803779:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80377c:	83 ec 0c             	sub    $0xc,%esp
  80377f:	50                   	push   %eax
  803780:	e8 8b f6 ff ff       	call   802e10 <fd2num>
  803785:	89 c3                	mov    %eax,%ebx
  803787:	83 c4 10             	add    $0x10,%esp
  80378a:	eb 0c                	jmp    803798 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80378c:	83 ec 0c             	sub    $0xc,%esp
  80378f:	56                   	push   %esi
  803790:	e8 e4 01 00 00       	call   803979 <nsipc_close>
		return r;
  803795:	83 c4 10             	add    $0x10,%esp
}
  803798:	89 d8                	mov    %ebx,%eax
  80379a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80379d:	5b                   	pop    %ebx
  80379e:	5e                   	pop    %esi
  80379f:	5d                   	pop    %ebp
  8037a0:	c3                   	ret    

008037a1 <accept>:
{
  8037a1:	55                   	push   %ebp
  8037a2:	89 e5                	mov    %esp,%ebp
  8037a4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	e8 4e ff ff ff       	call   8036fd <fd2sockid>
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	78 1b                	js     8037ce <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	ff 75 10             	pushl  0x10(%ebp)
  8037b9:	ff 75 0c             	pushl  0xc(%ebp)
  8037bc:	50                   	push   %eax
  8037bd:	e8 0e 01 00 00       	call   8038d0 <nsipc_accept>
  8037c2:	83 c4 10             	add    $0x10,%esp
  8037c5:	85 c0                	test   %eax,%eax
  8037c7:	78 05                	js     8037ce <accept+0x2d>
	return alloc_sockfd(r);
  8037c9:	e8 5f ff ff ff       	call   80372d <alloc_sockfd>
}
  8037ce:	c9                   	leave  
  8037cf:	c3                   	ret    

008037d0 <bind>:
{
  8037d0:	55                   	push   %ebp
  8037d1:	89 e5                	mov    %esp,%ebp
  8037d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d9:	e8 1f ff ff ff       	call   8036fd <fd2sockid>
  8037de:	85 c0                	test   %eax,%eax
  8037e0:	78 12                	js     8037f4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8037e2:	83 ec 04             	sub    $0x4,%esp
  8037e5:	ff 75 10             	pushl  0x10(%ebp)
  8037e8:	ff 75 0c             	pushl  0xc(%ebp)
  8037eb:	50                   	push   %eax
  8037ec:	e8 31 01 00 00       	call   803922 <nsipc_bind>
  8037f1:	83 c4 10             	add    $0x10,%esp
}
  8037f4:	c9                   	leave  
  8037f5:	c3                   	ret    

008037f6 <shutdown>:
{
  8037f6:	55                   	push   %ebp
  8037f7:	89 e5                	mov    %esp,%ebp
  8037f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8037fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ff:	e8 f9 fe ff ff       	call   8036fd <fd2sockid>
  803804:	85 c0                	test   %eax,%eax
  803806:	78 0f                	js     803817 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  803808:	83 ec 08             	sub    $0x8,%esp
  80380b:	ff 75 0c             	pushl  0xc(%ebp)
  80380e:	50                   	push   %eax
  80380f:	e8 43 01 00 00       	call   803957 <nsipc_shutdown>
  803814:	83 c4 10             	add    $0x10,%esp
}
  803817:	c9                   	leave  
  803818:	c3                   	ret    

00803819 <connect>:
{
  803819:	55                   	push   %ebp
  80381a:	89 e5                	mov    %esp,%ebp
  80381c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	e8 d6 fe ff ff       	call   8036fd <fd2sockid>
  803827:	85 c0                	test   %eax,%eax
  803829:	78 12                	js     80383d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80382b:	83 ec 04             	sub    $0x4,%esp
  80382e:	ff 75 10             	pushl  0x10(%ebp)
  803831:	ff 75 0c             	pushl  0xc(%ebp)
  803834:	50                   	push   %eax
  803835:	e8 59 01 00 00       	call   803993 <nsipc_connect>
  80383a:	83 c4 10             	add    $0x10,%esp
}
  80383d:	c9                   	leave  
  80383e:	c3                   	ret    

0080383f <listen>:
{
  80383f:	55                   	push   %ebp
  803840:	89 e5                	mov    %esp,%ebp
  803842:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	e8 b0 fe ff ff       	call   8036fd <fd2sockid>
  80384d:	85 c0                	test   %eax,%eax
  80384f:	78 0f                	js     803860 <listen+0x21>
	return nsipc_listen(r, backlog);
  803851:	83 ec 08             	sub    $0x8,%esp
  803854:	ff 75 0c             	pushl  0xc(%ebp)
  803857:	50                   	push   %eax
  803858:	e8 6b 01 00 00       	call   8039c8 <nsipc_listen>
  80385d:	83 c4 10             	add    $0x10,%esp
}
  803860:	c9                   	leave  
  803861:	c3                   	ret    

00803862 <socket>:

int
socket(int domain, int type, int protocol)
{
  803862:	55                   	push   %ebp
  803863:	89 e5                	mov    %esp,%ebp
  803865:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803868:	ff 75 10             	pushl  0x10(%ebp)
  80386b:	ff 75 0c             	pushl  0xc(%ebp)
  80386e:	ff 75 08             	pushl  0x8(%ebp)
  803871:	e8 3e 02 00 00       	call   803ab4 <nsipc_socket>
  803876:	83 c4 10             	add    $0x10,%esp
  803879:	85 c0                	test   %eax,%eax
  80387b:	78 05                	js     803882 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80387d:	e8 ab fe ff ff       	call   80372d <alloc_sockfd>
}
  803882:	c9                   	leave  
  803883:	c3                   	ret    

00803884 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803884:	55                   	push   %ebp
  803885:	89 e5                	mov    %esp,%ebp
  803887:	53                   	push   %ebx
  803888:	83 ec 04             	sub    $0x4,%esp
  80388b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80388d:	83 3d 44 a0 80 00 00 	cmpl   $0x0,0x80a044
  803894:	74 26                	je     8038bc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803896:	6a 07                	push   $0x7
  803898:	68 00 c0 80 00       	push   $0x80c000
  80389d:	53                   	push   %ebx
  80389e:	ff 35 44 a0 80 00    	pushl  0x80a044
  8038a4:	e8 d0 f4 ff ff       	call   802d79 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8038a9:	83 c4 0c             	add    $0xc,%esp
  8038ac:	6a 00                	push   $0x0
  8038ae:	6a 00                	push   $0x0
  8038b0:	6a 00                	push   $0x0
  8038b2:	e8 59 f4 ff ff       	call   802d10 <ipc_recv>
}
  8038b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038ba:	c9                   	leave  
  8038bb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8038bc:	83 ec 0c             	sub    $0xc,%esp
  8038bf:	6a 02                	push   $0x2
  8038c1:	e8 0b f5 ff ff       	call   802dd1 <ipc_find_env>
  8038c6:	a3 44 a0 80 00       	mov    %eax,0x80a044
  8038cb:	83 c4 10             	add    $0x10,%esp
  8038ce:	eb c6                	jmp    803896 <nsipc+0x12>

008038d0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038d0:	55                   	push   %ebp
  8038d1:	89 e5                	mov    %esp,%ebp
  8038d3:	56                   	push   %esi
  8038d4:	53                   	push   %ebx
  8038d5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8038d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038db:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8038e0:	8b 06                	mov    (%esi),%eax
  8038e2:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ec:	e8 93 ff ff ff       	call   803884 <nsipc>
  8038f1:	89 c3                	mov    %eax,%ebx
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	79 09                	jns    803900 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8038f7:	89 d8                	mov    %ebx,%eax
  8038f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8038fc:	5b                   	pop    %ebx
  8038fd:	5e                   	pop    %esi
  8038fe:	5d                   	pop    %ebp
  8038ff:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803900:	83 ec 04             	sub    $0x4,%esp
  803903:	ff 35 10 c0 80 00    	pushl  0x80c010
  803909:	68 00 c0 80 00       	push   $0x80c000
  80390e:	ff 75 0c             	pushl  0xc(%ebp)
  803911:	e8 0c ee ff ff       	call   802722 <memmove>
		*addrlen = ret->ret_addrlen;
  803916:	a1 10 c0 80 00       	mov    0x80c010,%eax
  80391b:	89 06                	mov    %eax,(%esi)
  80391d:	83 c4 10             	add    $0x10,%esp
	return r;
  803920:	eb d5                	jmp    8038f7 <nsipc_accept+0x27>

00803922 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803922:	55                   	push   %ebp
  803923:	89 e5                	mov    %esp,%ebp
  803925:	53                   	push   %ebx
  803926:	83 ec 08             	sub    $0x8,%esp
  803929:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803934:	53                   	push   %ebx
  803935:	ff 75 0c             	pushl  0xc(%ebp)
  803938:	68 04 c0 80 00       	push   $0x80c004
  80393d:	e8 e0 ed ff ff       	call   802722 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803942:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  803948:	b8 02 00 00 00       	mov    $0x2,%eax
  80394d:	e8 32 ff ff ff       	call   803884 <nsipc>
}
  803952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803955:	c9                   	leave  
  803956:	c3                   	ret    

00803957 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803957:	55                   	push   %ebp
  803958:	89 e5                	mov    %esp,%ebp
  80395a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80395d:	8b 45 08             	mov    0x8(%ebp),%eax
  803960:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  803965:	8b 45 0c             	mov    0xc(%ebp),%eax
  803968:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  80396d:	b8 03 00 00 00       	mov    $0x3,%eax
  803972:	e8 0d ff ff ff       	call   803884 <nsipc>
}
  803977:	c9                   	leave  
  803978:	c3                   	ret    

00803979 <nsipc_close>:

int
nsipc_close(int s)
{
  803979:	55                   	push   %ebp
  80397a:	89 e5                	mov    %esp,%ebp
  80397c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80397f:	8b 45 08             	mov    0x8(%ebp),%eax
  803982:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  803987:	b8 04 00 00 00       	mov    $0x4,%eax
  80398c:	e8 f3 fe ff ff       	call   803884 <nsipc>
}
  803991:	c9                   	leave  
  803992:	c3                   	ret    

00803993 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803993:	55                   	push   %ebp
  803994:	89 e5                	mov    %esp,%ebp
  803996:	53                   	push   %ebx
  803997:	83 ec 08             	sub    $0x8,%esp
  80399a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80399d:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a0:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8039a5:	53                   	push   %ebx
  8039a6:	ff 75 0c             	pushl  0xc(%ebp)
  8039a9:	68 04 c0 80 00       	push   $0x80c004
  8039ae:	e8 6f ed ff ff       	call   802722 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8039b3:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  8039b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8039be:	e8 c1 fe ff ff       	call   803884 <nsipc>
}
  8039c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039c6:	c9                   	leave  
  8039c7:	c3                   	ret    

008039c8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8039c8:	55                   	push   %ebp
  8039c9:	89 e5                	mov    %esp,%ebp
  8039cb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  8039d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d9:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  8039de:	b8 06 00 00 00       	mov    $0x6,%eax
  8039e3:	e8 9c fe ff ff       	call   803884 <nsipc>
}
  8039e8:	c9                   	leave  
  8039e9:	c3                   	ret    

008039ea <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8039ea:	55                   	push   %ebp
  8039eb:	89 e5                	mov    %esp,%ebp
  8039ed:	56                   	push   %esi
  8039ee:	53                   	push   %ebx
  8039ef:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  8039fa:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  803a00:	8b 45 14             	mov    0x14(%ebp),%eax
  803a03:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a08:	b8 07 00 00 00       	mov    $0x7,%eax
  803a0d:	e8 72 fe ff ff       	call   803884 <nsipc>
  803a12:	89 c3                	mov    %eax,%ebx
  803a14:	85 c0                	test   %eax,%eax
  803a16:	78 1f                	js     803a37 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  803a18:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803a1d:	7f 21                	jg     803a40 <nsipc_recv+0x56>
  803a1f:	39 c6                	cmp    %eax,%esi
  803a21:	7c 1d                	jl     803a40 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a23:	83 ec 04             	sub    $0x4,%esp
  803a26:	50                   	push   %eax
  803a27:	68 00 c0 80 00       	push   $0x80c000
  803a2c:	ff 75 0c             	pushl  0xc(%ebp)
  803a2f:	e8 ee ec ff ff       	call   802722 <memmove>
  803a34:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803a37:	89 d8                	mov    %ebx,%eax
  803a39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803a3c:	5b                   	pop    %ebx
  803a3d:	5e                   	pop    %esi
  803a3e:	5d                   	pop    %ebp
  803a3f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  803a40:	68 6a 4d 80 00       	push   $0x804d6a
  803a45:	68 3d 42 80 00       	push   $0x80423d
  803a4a:	6a 62                	push   $0x62
  803a4c:	68 7f 4d 80 00       	push   $0x804d7f
  803a51:	e8 e9 e2 ff ff       	call   801d3f <_panic>

00803a56 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a56:	55                   	push   %ebp
  803a57:	89 e5                	mov    %esp,%ebp
  803a59:	53                   	push   %ebx
  803a5a:	83 ec 04             	sub    $0x4,%esp
  803a5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803a60:	8b 45 08             	mov    0x8(%ebp),%eax
  803a63:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  803a68:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803a6e:	7f 2e                	jg     803a9e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a70:	83 ec 04             	sub    $0x4,%esp
  803a73:	53                   	push   %ebx
  803a74:	ff 75 0c             	pushl  0xc(%ebp)
  803a77:	68 0c c0 80 00       	push   $0x80c00c
  803a7c:	e8 a1 ec ff ff       	call   802722 <memmove>
	nsipcbuf.send.req_size = size;
  803a81:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  803a87:	8b 45 14             	mov    0x14(%ebp),%eax
  803a8a:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803a8f:	b8 08 00 00 00       	mov    $0x8,%eax
  803a94:	e8 eb fd ff ff       	call   803884 <nsipc>
}
  803a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a9c:	c9                   	leave  
  803a9d:	c3                   	ret    
	assert(size < 1600);
  803a9e:	68 8b 4d 80 00       	push   $0x804d8b
  803aa3:	68 3d 42 80 00       	push   $0x80423d
  803aa8:	6a 6d                	push   $0x6d
  803aaa:	68 7f 4d 80 00       	push   $0x804d7f
  803aaf:	e8 8b e2 ff ff       	call   801d3f <_panic>

00803ab4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ab4:	55                   	push   %ebp
  803ab5:	89 e5                	mov    %esp,%ebp
  803ab7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803aba:	8b 45 08             	mov    0x8(%ebp),%eax
  803abd:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac5:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803aca:	8b 45 10             	mov    0x10(%ebp),%eax
  803acd:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803ad2:	b8 09 00 00 00       	mov    $0x9,%eax
  803ad7:	e8 a8 fd ff ff       	call   803884 <nsipc>
}
  803adc:	c9                   	leave  
  803add:	c3                   	ret    

00803ade <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ade:	55                   	push   %ebp
  803adf:	89 e5                	mov    %esp,%ebp
  803ae1:	56                   	push   %esi
  803ae2:	53                   	push   %ebx
  803ae3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ae6:	83 ec 0c             	sub    $0xc,%esp
  803ae9:	ff 75 08             	pushl  0x8(%ebp)
  803aec:	e8 2f f3 ff ff       	call   802e20 <fd2data>
  803af1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803af3:	83 c4 08             	add    $0x8,%esp
  803af6:	68 97 4d 80 00       	push   $0x804d97
  803afb:	53                   	push   %ebx
  803afc:	e8 93 ea ff ff       	call   802594 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803b01:	8b 46 04             	mov    0x4(%esi),%eax
  803b04:	2b 06                	sub    (%esi),%eax
  803b06:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803b0c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803b13:	00 00 00 
	stat->st_dev = &devpipe;
  803b16:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  803b1d:	90 80 00 
	return 0;
}
  803b20:	b8 00 00 00 00       	mov    $0x0,%eax
  803b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803b28:	5b                   	pop    %ebx
  803b29:	5e                   	pop    %esi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    

00803b2c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b2c:	55                   	push   %ebp
  803b2d:	89 e5                	mov    %esp,%ebp
  803b2f:	53                   	push   %ebx
  803b30:	83 ec 0c             	sub    $0xc,%esp
  803b33:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803b36:	53                   	push   %ebx
  803b37:	6a 00                	push   $0x0
  803b39:	e8 cd ee ff ff       	call   802a0b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803b3e:	89 1c 24             	mov    %ebx,(%esp)
  803b41:	e8 da f2 ff ff       	call   802e20 <fd2data>
  803b46:	83 c4 08             	add    $0x8,%esp
  803b49:	50                   	push   %eax
  803b4a:	6a 00                	push   $0x0
  803b4c:	e8 ba ee ff ff       	call   802a0b <sys_page_unmap>
}
  803b51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803b54:	c9                   	leave  
  803b55:	c3                   	ret    

00803b56 <_pipeisclosed>:
{
  803b56:	55                   	push   %ebp
  803b57:	89 e5                	mov    %esp,%ebp
  803b59:	57                   	push   %edi
  803b5a:	56                   	push   %esi
  803b5b:	53                   	push   %ebx
  803b5c:	83 ec 1c             	sub    $0x1c,%esp
  803b5f:	89 c7                	mov    %eax,%edi
  803b61:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803b63:	a1 50 a0 80 00       	mov    0x80a050,%eax
  803b68:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803b6b:	83 ec 0c             	sub    $0xc,%esp
  803b6e:	57                   	push   %edi
  803b6f:	e8 c8 fa ff ff       	call   80363c <pageref>
  803b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803b77:	89 34 24             	mov    %esi,(%esp)
  803b7a:	e8 bd fa ff ff       	call   80363c <pageref>
		nn = thisenv->env_runs;
  803b7f:	8b 15 50 a0 80 00    	mov    0x80a050,%edx
  803b85:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803b88:	83 c4 10             	add    $0x10,%esp
  803b8b:	39 cb                	cmp    %ecx,%ebx
  803b8d:	74 1b                	je     803baa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803b8f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803b92:	75 cf                	jne    803b63 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b94:	8b 42 58             	mov    0x58(%edx),%eax
  803b97:	6a 01                	push   $0x1
  803b99:	50                   	push   %eax
  803b9a:	53                   	push   %ebx
  803b9b:	68 9e 4d 80 00       	push   $0x804d9e
  803ba0:	e8 90 e2 ff ff       	call   801e35 <cprintf>
  803ba5:	83 c4 10             	add    $0x10,%esp
  803ba8:	eb b9                	jmp    803b63 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803baa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803bad:	0f 94 c0             	sete   %al
  803bb0:	0f b6 c0             	movzbl %al,%eax
}
  803bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803bb6:	5b                   	pop    %ebx
  803bb7:	5e                   	pop    %esi
  803bb8:	5f                   	pop    %edi
  803bb9:	5d                   	pop    %ebp
  803bba:	c3                   	ret    

00803bbb <devpipe_write>:
{
  803bbb:	55                   	push   %ebp
  803bbc:	89 e5                	mov    %esp,%ebp
  803bbe:	57                   	push   %edi
  803bbf:	56                   	push   %esi
  803bc0:	53                   	push   %ebx
  803bc1:	83 ec 28             	sub    $0x28,%esp
  803bc4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803bc7:	56                   	push   %esi
  803bc8:	e8 53 f2 ff ff       	call   802e20 <fd2data>
  803bcd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803bcf:	83 c4 10             	add    $0x10,%esp
  803bd2:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803bda:	74 4f                	je     803c2b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bdc:	8b 43 04             	mov    0x4(%ebx),%eax
  803bdf:	8b 0b                	mov    (%ebx),%ecx
  803be1:	8d 51 20             	lea    0x20(%ecx),%edx
  803be4:	39 d0                	cmp    %edx,%eax
  803be6:	72 14                	jb     803bfc <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803be8:	89 da                	mov    %ebx,%edx
  803bea:	89 f0                	mov    %esi,%eax
  803bec:	e8 65 ff ff ff       	call   803b56 <_pipeisclosed>
  803bf1:	85 c0                	test   %eax,%eax
  803bf3:	75 3b                	jne    803c30 <devpipe_write+0x75>
			sys_yield();
  803bf5:	e8 6d ed ff ff       	call   802967 <sys_yield>
  803bfa:	eb e0                	jmp    803bdc <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803bff:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803c03:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803c06:	89 c2                	mov    %eax,%edx
  803c08:	c1 fa 1f             	sar    $0x1f,%edx
  803c0b:	89 d1                	mov    %edx,%ecx
  803c0d:	c1 e9 1b             	shr    $0x1b,%ecx
  803c10:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803c13:	83 e2 1f             	and    $0x1f,%edx
  803c16:	29 ca                	sub    %ecx,%edx
  803c18:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803c1c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803c20:	83 c0 01             	add    $0x1,%eax
  803c23:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803c26:	83 c7 01             	add    $0x1,%edi
  803c29:	eb ac                	jmp    803bd7 <devpipe_write+0x1c>
	return i;
  803c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  803c2e:	eb 05                	jmp    803c35 <devpipe_write+0x7a>
				return 0;
  803c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803c38:	5b                   	pop    %ebx
  803c39:	5e                   	pop    %esi
  803c3a:	5f                   	pop    %edi
  803c3b:	5d                   	pop    %ebp
  803c3c:	c3                   	ret    

00803c3d <devpipe_read>:
{
  803c3d:	55                   	push   %ebp
  803c3e:	89 e5                	mov    %esp,%ebp
  803c40:	57                   	push   %edi
  803c41:	56                   	push   %esi
  803c42:	53                   	push   %ebx
  803c43:	83 ec 18             	sub    $0x18,%esp
  803c46:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803c49:	57                   	push   %edi
  803c4a:	e8 d1 f1 ff ff       	call   802e20 <fd2data>
  803c4f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803c51:	83 c4 10             	add    $0x10,%esp
  803c54:	be 00 00 00 00       	mov    $0x0,%esi
  803c59:	3b 75 10             	cmp    0x10(%ebp),%esi
  803c5c:	75 14                	jne    803c72 <devpipe_read+0x35>
	return i;
  803c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  803c61:	eb 02                	jmp    803c65 <devpipe_read+0x28>
				return i;
  803c63:	89 f0                	mov    %esi,%eax
}
  803c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803c68:	5b                   	pop    %ebx
  803c69:	5e                   	pop    %esi
  803c6a:	5f                   	pop    %edi
  803c6b:	5d                   	pop    %ebp
  803c6c:	c3                   	ret    
			sys_yield();
  803c6d:	e8 f5 ec ff ff       	call   802967 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803c72:	8b 03                	mov    (%ebx),%eax
  803c74:	3b 43 04             	cmp    0x4(%ebx),%eax
  803c77:	75 18                	jne    803c91 <devpipe_read+0x54>
			if (i > 0)
  803c79:	85 f6                	test   %esi,%esi
  803c7b:	75 e6                	jne    803c63 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  803c7d:	89 da                	mov    %ebx,%edx
  803c7f:	89 f8                	mov    %edi,%eax
  803c81:	e8 d0 fe ff ff       	call   803b56 <_pipeisclosed>
  803c86:	85 c0                	test   %eax,%eax
  803c88:	74 e3                	je     803c6d <devpipe_read+0x30>
				return 0;
  803c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8f:	eb d4                	jmp    803c65 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c91:	99                   	cltd   
  803c92:	c1 ea 1b             	shr    $0x1b,%edx
  803c95:	01 d0                	add    %edx,%eax
  803c97:	83 e0 1f             	and    $0x1f,%eax
  803c9a:	29 d0                	sub    %edx,%eax
  803c9c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803ca4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803ca7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803caa:	83 c6 01             	add    $0x1,%esi
  803cad:	eb aa                	jmp    803c59 <devpipe_read+0x1c>

00803caf <pipe>:
{
  803caf:	55                   	push   %ebp
  803cb0:	89 e5                	mov    %esp,%ebp
  803cb2:	56                   	push   %esi
  803cb3:	53                   	push   %ebx
  803cb4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803cb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803cba:	50                   	push   %eax
  803cbb:	e8 77 f1 ff ff       	call   802e37 <fd_alloc>
  803cc0:	89 c3                	mov    %eax,%ebx
  803cc2:	83 c4 10             	add    $0x10,%esp
  803cc5:	85 c0                	test   %eax,%eax
  803cc7:	0f 88 23 01 00 00    	js     803df0 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ccd:	83 ec 04             	sub    $0x4,%esp
  803cd0:	68 07 04 00 00       	push   $0x407
  803cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  803cd8:	6a 00                	push   $0x0
  803cda:	e8 a7 ec ff ff       	call   802986 <sys_page_alloc>
  803cdf:	89 c3                	mov    %eax,%ebx
  803ce1:	83 c4 10             	add    $0x10,%esp
  803ce4:	85 c0                	test   %eax,%eax
  803ce6:	0f 88 04 01 00 00    	js     803df0 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  803cec:	83 ec 0c             	sub    $0xc,%esp
  803cef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803cf2:	50                   	push   %eax
  803cf3:	e8 3f f1 ff ff       	call   802e37 <fd_alloc>
  803cf8:	89 c3                	mov    %eax,%ebx
  803cfa:	83 c4 10             	add    $0x10,%esp
  803cfd:	85 c0                	test   %eax,%eax
  803cff:	0f 88 db 00 00 00    	js     803de0 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d05:	83 ec 04             	sub    $0x4,%esp
  803d08:	68 07 04 00 00       	push   $0x407
  803d0d:	ff 75 f0             	pushl  -0x10(%ebp)
  803d10:	6a 00                	push   $0x0
  803d12:	e8 6f ec ff ff       	call   802986 <sys_page_alloc>
  803d17:	89 c3                	mov    %eax,%ebx
  803d19:	83 c4 10             	add    $0x10,%esp
  803d1c:	85 c0                	test   %eax,%eax
  803d1e:	0f 88 bc 00 00 00    	js     803de0 <pipe+0x131>
	va = fd2data(fd0);
  803d24:	83 ec 0c             	sub    $0xc,%esp
  803d27:	ff 75 f4             	pushl  -0xc(%ebp)
  803d2a:	e8 f1 f0 ff ff       	call   802e20 <fd2data>
  803d2f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d31:	83 c4 0c             	add    $0xc,%esp
  803d34:	68 07 04 00 00       	push   $0x407
  803d39:	50                   	push   %eax
  803d3a:	6a 00                	push   $0x0
  803d3c:	e8 45 ec ff ff       	call   802986 <sys_page_alloc>
  803d41:	89 c3                	mov    %eax,%ebx
  803d43:	83 c4 10             	add    $0x10,%esp
  803d46:	85 c0                	test   %eax,%eax
  803d48:	0f 88 82 00 00 00    	js     803dd0 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d4e:	83 ec 0c             	sub    $0xc,%esp
  803d51:	ff 75 f0             	pushl  -0x10(%ebp)
  803d54:	e8 c7 f0 ff ff       	call   802e20 <fd2data>
  803d59:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803d60:	50                   	push   %eax
  803d61:	6a 00                	push   $0x0
  803d63:	56                   	push   %esi
  803d64:	6a 00                	push   $0x0
  803d66:	e8 5e ec ff ff       	call   8029c9 <sys_page_map>
  803d6b:	89 c3                	mov    %eax,%ebx
  803d6d:	83 c4 20             	add    $0x20,%esp
  803d70:	85 c0                	test   %eax,%eax
  803d72:	78 4e                	js     803dc2 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  803d74:	a1 9c 90 80 00       	mov    0x80909c,%eax
  803d79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d7c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803d7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d81:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  803d88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d8b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d90:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803d97:	83 ec 0c             	sub    $0xc,%esp
  803d9a:	ff 75 f4             	pushl  -0xc(%ebp)
  803d9d:	e8 6e f0 ff ff       	call   802e10 <fd2num>
  803da2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803da5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803da7:	83 c4 04             	add    $0x4,%esp
  803daa:	ff 75 f0             	pushl  -0x10(%ebp)
  803dad:	e8 5e f0 ff ff       	call   802e10 <fd2num>
  803db2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803db5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803db8:	83 c4 10             	add    $0x10,%esp
  803dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  803dc0:	eb 2e                	jmp    803df0 <pipe+0x141>
	sys_page_unmap(0, va);
  803dc2:	83 ec 08             	sub    $0x8,%esp
  803dc5:	56                   	push   %esi
  803dc6:	6a 00                	push   $0x0
  803dc8:	e8 3e ec ff ff       	call   802a0b <sys_page_unmap>
  803dcd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803dd0:	83 ec 08             	sub    $0x8,%esp
  803dd3:	ff 75 f0             	pushl  -0x10(%ebp)
  803dd6:	6a 00                	push   $0x0
  803dd8:	e8 2e ec ff ff       	call   802a0b <sys_page_unmap>
  803ddd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803de0:	83 ec 08             	sub    $0x8,%esp
  803de3:	ff 75 f4             	pushl  -0xc(%ebp)
  803de6:	6a 00                	push   $0x0
  803de8:	e8 1e ec ff ff       	call   802a0b <sys_page_unmap>
  803ded:	83 c4 10             	add    $0x10,%esp
}
  803df0:	89 d8                	mov    %ebx,%eax
  803df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803df5:	5b                   	pop    %ebx
  803df6:	5e                   	pop    %esi
  803df7:	5d                   	pop    %ebp
  803df8:	c3                   	ret    

00803df9 <pipeisclosed>:
{
  803df9:	55                   	push   %ebp
  803dfa:	89 e5                	mov    %esp,%ebp
  803dfc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803e02:	50                   	push   %eax
  803e03:	ff 75 08             	pushl  0x8(%ebp)
  803e06:	e8 7e f0 ff ff       	call   802e89 <fd_lookup>
  803e0b:	83 c4 10             	add    $0x10,%esp
  803e0e:	85 c0                	test   %eax,%eax
  803e10:	78 18                	js     803e2a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803e12:	83 ec 0c             	sub    $0xc,%esp
  803e15:	ff 75 f4             	pushl  -0xc(%ebp)
  803e18:	e8 03 f0 ff ff       	call   802e20 <fd2data>
	return _pipeisclosed(fd, p);
  803e1d:	89 c2                	mov    %eax,%edx
  803e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e22:	e8 2f fd ff ff       	call   803b56 <_pipeisclosed>
  803e27:	83 c4 10             	add    $0x10,%esp
}
  803e2a:	c9                   	leave  
  803e2b:	c3                   	ret    

00803e2c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  803e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e31:	c3                   	ret    

00803e32 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e32:	55                   	push   %ebp
  803e33:	89 e5                	mov    %esp,%ebp
  803e35:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803e38:	68 b6 4d 80 00       	push   $0x804db6
  803e3d:	ff 75 0c             	pushl  0xc(%ebp)
  803e40:	e8 4f e7 ff ff       	call   802594 <strcpy>
	return 0;
}
  803e45:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4a:	c9                   	leave  
  803e4b:	c3                   	ret    

00803e4c <devcons_write>:
{
  803e4c:	55                   	push   %ebp
  803e4d:	89 e5                	mov    %esp,%ebp
  803e4f:	57                   	push   %edi
  803e50:	56                   	push   %esi
  803e51:	53                   	push   %ebx
  803e52:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  803e58:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803e5d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803e63:	3b 75 10             	cmp    0x10(%ebp),%esi
  803e66:	73 31                	jae    803e99 <devcons_write+0x4d>
		m = n - tot;
  803e68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803e6b:	29 f3                	sub    %esi,%ebx
  803e6d:	83 fb 7f             	cmp    $0x7f,%ebx
  803e70:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803e75:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803e78:	83 ec 04             	sub    $0x4,%esp
  803e7b:	53                   	push   %ebx
  803e7c:	89 f0                	mov    %esi,%eax
  803e7e:	03 45 0c             	add    0xc(%ebp),%eax
  803e81:	50                   	push   %eax
  803e82:	57                   	push   %edi
  803e83:	e8 9a e8 ff ff       	call   802722 <memmove>
		sys_cputs(buf, m);
  803e88:	83 c4 08             	add    $0x8,%esp
  803e8b:	53                   	push   %ebx
  803e8c:	57                   	push   %edi
  803e8d:	e8 38 ea ff ff       	call   8028ca <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803e92:	01 de                	add    %ebx,%esi
  803e94:	83 c4 10             	add    $0x10,%esp
  803e97:	eb ca                	jmp    803e63 <devcons_write+0x17>
}
  803e99:	89 f0                	mov    %esi,%eax
  803e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803e9e:	5b                   	pop    %ebx
  803e9f:	5e                   	pop    %esi
  803ea0:	5f                   	pop    %edi
  803ea1:	5d                   	pop    %ebp
  803ea2:	c3                   	ret    

00803ea3 <devcons_read>:
{
  803ea3:	55                   	push   %ebp
  803ea4:	89 e5                	mov    %esp,%ebp
  803ea6:	83 ec 08             	sub    $0x8,%esp
  803ea9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803eae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803eb2:	74 21                	je     803ed5 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  803eb4:	e8 2f ea ff ff       	call   8028e8 <sys_cgetc>
  803eb9:	85 c0                	test   %eax,%eax
  803ebb:	75 07                	jne    803ec4 <devcons_read+0x21>
		sys_yield();
  803ebd:	e8 a5 ea ff ff       	call   802967 <sys_yield>
  803ec2:	eb f0                	jmp    803eb4 <devcons_read+0x11>
	if (c < 0)
  803ec4:	78 0f                	js     803ed5 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  803ec6:	83 f8 04             	cmp    $0x4,%eax
  803ec9:	74 0c                	je     803ed7 <devcons_read+0x34>
	*(char*)vbuf = c;
  803ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ece:	88 02                	mov    %al,(%edx)
	return 1;
  803ed0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ed5:	c9                   	leave  
  803ed6:	c3                   	ret    
		return 0;
  803ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  803edc:	eb f7                	jmp    803ed5 <devcons_read+0x32>

00803ede <cputchar>:
{
  803ede:	55                   	push   %ebp
  803edf:	89 e5                	mov    %esp,%ebp
  803ee1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803eea:	6a 01                	push   $0x1
  803eec:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803eef:	50                   	push   %eax
  803ef0:	e8 d5 e9 ff ff       	call   8028ca <sys_cputs>
}
  803ef5:	83 c4 10             	add    $0x10,%esp
  803ef8:	c9                   	leave  
  803ef9:	c3                   	ret    

00803efa <getchar>:
{
  803efa:	55                   	push   %ebp
  803efb:	89 e5                	mov    %esp,%ebp
  803efd:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803f00:	6a 01                	push   $0x1
  803f02:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803f05:	50                   	push   %eax
  803f06:	6a 00                	push   $0x0
  803f08:	e8 ec f1 ff ff       	call   8030f9 <read>
	if (r < 0)
  803f0d:	83 c4 10             	add    $0x10,%esp
  803f10:	85 c0                	test   %eax,%eax
  803f12:	78 06                	js     803f1a <getchar+0x20>
	if (r < 1)
  803f14:	74 06                	je     803f1c <getchar+0x22>
	return c;
  803f16:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803f1a:	c9                   	leave  
  803f1b:	c3                   	ret    
		return -E_EOF;
  803f1c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803f21:	eb f7                	jmp    803f1a <getchar+0x20>

00803f23 <iscons>:
{
  803f23:	55                   	push   %ebp
  803f24:	89 e5                	mov    %esp,%ebp
  803f26:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f2c:	50                   	push   %eax
  803f2d:	ff 75 08             	pushl  0x8(%ebp)
  803f30:	e8 54 ef ff ff       	call   802e89 <fd_lookup>
  803f35:	83 c4 10             	add    $0x10,%esp
  803f38:	85 c0                	test   %eax,%eax
  803f3a:	78 11                	js     803f4d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3f:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803f45:	39 10                	cmp    %edx,(%eax)
  803f47:	0f 94 c0             	sete   %al
  803f4a:	0f b6 c0             	movzbl %al,%eax
}
  803f4d:	c9                   	leave  
  803f4e:	c3                   	ret    

00803f4f <opencons>:
{
  803f4f:	55                   	push   %ebp
  803f50:	89 e5                	mov    %esp,%ebp
  803f52:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f58:	50                   	push   %eax
  803f59:	e8 d9 ee ff ff       	call   802e37 <fd_alloc>
  803f5e:	83 c4 10             	add    $0x10,%esp
  803f61:	85 c0                	test   %eax,%eax
  803f63:	78 3a                	js     803f9f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f65:	83 ec 04             	sub    $0x4,%esp
  803f68:	68 07 04 00 00       	push   $0x407
  803f6d:	ff 75 f4             	pushl  -0xc(%ebp)
  803f70:	6a 00                	push   $0x0
  803f72:	e8 0f ea ff ff       	call   802986 <sys_page_alloc>
  803f77:	83 c4 10             	add    $0x10,%esp
  803f7a:	85 c0                	test   %eax,%eax
  803f7c:	78 21                	js     803f9f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f81:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803f87:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803f93:	83 ec 0c             	sub    $0xc,%esp
  803f96:	50                   	push   %eax
  803f97:	e8 74 ee ff ff       	call   802e10 <fd2num>
  803f9c:	83 c4 10             	add    $0x10,%esp
}
  803f9f:	c9                   	leave  
  803fa0:	c3                   	ret    
  803fa1:	66 90                	xchg   %ax,%ax
  803fa3:	66 90                	xchg   %ax,%ax
  803fa5:	66 90                	xchg   %ax,%ax
  803fa7:	66 90                	xchg   %ax,%ax
  803fa9:	66 90                	xchg   %ax,%ax
  803fab:	66 90                	xchg   %ax,%ax
  803fad:	66 90                	xchg   %ax,%ax
  803faf:	90                   	nop

00803fb0 <__udivdi3>:
  803fb0:	55                   	push   %ebp
  803fb1:	57                   	push   %edi
  803fb2:	56                   	push   %esi
  803fb3:	53                   	push   %ebx
  803fb4:	83 ec 1c             	sub    $0x1c,%esp
  803fb7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803fbb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803fbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fc3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803fc7:	85 d2                	test   %edx,%edx
  803fc9:	75 4d                	jne    804018 <__udivdi3+0x68>
  803fcb:	39 f3                	cmp    %esi,%ebx
  803fcd:	76 19                	jbe    803fe8 <__udivdi3+0x38>
  803fcf:	31 ff                	xor    %edi,%edi
  803fd1:	89 e8                	mov    %ebp,%eax
  803fd3:	89 f2                	mov    %esi,%edx
  803fd5:	f7 f3                	div    %ebx
  803fd7:	89 fa                	mov    %edi,%edx
  803fd9:	83 c4 1c             	add    $0x1c,%esp
  803fdc:	5b                   	pop    %ebx
  803fdd:	5e                   	pop    %esi
  803fde:	5f                   	pop    %edi
  803fdf:	5d                   	pop    %ebp
  803fe0:	c3                   	ret    
  803fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803fe8:	89 d9                	mov    %ebx,%ecx
  803fea:	85 db                	test   %ebx,%ebx
  803fec:	75 0b                	jne    803ff9 <__udivdi3+0x49>
  803fee:	b8 01 00 00 00       	mov    $0x1,%eax
  803ff3:	31 d2                	xor    %edx,%edx
  803ff5:	f7 f3                	div    %ebx
  803ff7:	89 c1                	mov    %eax,%ecx
  803ff9:	31 d2                	xor    %edx,%edx
  803ffb:	89 f0                	mov    %esi,%eax
  803ffd:	f7 f1                	div    %ecx
  803fff:	89 c6                	mov    %eax,%esi
  804001:	89 e8                	mov    %ebp,%eax
  804003:	89 f7                	mov    %esi,%edi
  804005:	f7 f1                	div    %ecx
  804007:	89 fa                	mov    %edi,%edx
  804009:	83 c4 1c             	add    $0x1c,%esp
  80400c:	5b                   	pop    %ebx
  80400d:	5e                   	pop    %esi
  80400e:	5f                   	pop    %edi
  80400f:	5d                   	pop    %ebp
  804010:	c3                   	ret    
  804011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804018:	39 f2                	cmp    %esi,%edx
  80401a:	77 1c                	ja     804038 <__udivdi3+0x88>
  80401c:	0f bd fa             	bsr    %edx,%edi
  80401f:	83 f7 1f             	xor    $0x1f,%edi
  804022:	75 2c                	jne    804050 <__udivdi3+0xa0>
  804024:	39 f2                	cmp    %esi,%edx
  804026:	72 06                	jb     80402e <__udivdi3+0x7e>
  804028:	31 c0                	xor    %eax,%eax
  80402a:	39 eb                	cmp    %ebp,%ebx
  80402c:	77 a9                	ja     803fd7 <__udivdi3+0x27>
  80402e:	b8 01 00 00 00       	mov    $0x1,%eax
  804033:	eb a2                	jmp    803fd7 <__udivdi3+0x27>
  804035:	8d 76 00             	lea    0x0(%esi),%esi
  804038:	31 ff                	xor    %edi,%edi
  80403a:	31 c0                	xor    %eax,%eax
  80403c:	89 fa                	mov    %edi,%edx
  80403e:	83 c4 1c             	add    $0x1c,%esp
  804041:	5b                   	pop    %ebx
  804042:	5e                   	pop    %esi
  804043:	5f                   	pop    %edi
  804044:	5d                   	pop    %ebp
  804045:	c3                   	ret    
  804046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80404d:	8d 76 00             	lea    0x0(%esi),%esi
  804050:	89 f9                	mov    %edi,%ecx
  804052:	b8 20 00 00 00       	mov    $0x20,%eax
  804057:	29 f8                	sub    %edi,%eax
  804059:	d3 e2                	shl    %cl,%edx
  80405b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80405f:	89 c1                	mov    %eax,%ecx
  804061:	89 da                	mov    %ebx,%edx
  804063:	d3 ea                	shr    %cl,%edx
  804065:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  804069:	09 d1                	or     %edx,%ecx
  80406b:	89 f2                	mov    %esi,%edx
  80406d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804071:	89 f9                	mov    %edi,%ecx
  804073:	d3 e3                	shl    %cl,%ebx
  804075:	89 c1                	mov    %eax,%ecx
  804077:	d3 ea                	shr    %cl,%edx
  804079:	89 f9                	mov    %edi,%ecx
  80407b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80407f:	89 eb                	mov    %ebp,%ebx
  804081:	d3 e6                	shl    %cl,%esi
  804083:	89 c1                	mov    %eax,%ecx
  804085:	d3 eb                	shr    %cl,%ebx
  804087:	09 de                	or     %ebx,%esi
  804089:	89 f0                	mov    %esi,%eax
  80408b:	f7 74 24 08          	divl   0x8(%esp)
  80408f:	89 d6                	mov    %edx,%esi
  804091:	89 c3                	mov    %eax,%ebx
  804093:	f7 64 24 0c          	mull   0xc(%esp)
  804097:	39 d6                	cmp    %edx,%esi
  804099:	72 15                	jb     8040b0 <__udivdi3+0x100>
  80409b:	89 f9                	mov    %edi,%ecx
  80409d:	d3 e5                	shl    %cl,%ebp
  80409f:	39 c5                	cmp    %eax,%ebp
  8040a1:	73 04                	jae    8040a7 <__udivdi3+0xf7>
  8040a3:	39 d6                	cmp    %edx,%esi
  8040a5:	74 09                	je     8040b0 <__udivdi3+0x100>
  8040a7:	89 d8                	mov    %ebx,%eax
  8040a9:	31 ff                	xor    %edi,%edi
  8040ab:	e9 27 ff ff ff       	jmp    803fd7 <__udivdi3+0x27>
  8040b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040b3:	31 ff                	xor    %edi,%edi
  8040b5:	e9 1d ff ff ff       	jmp    803fd7 <__udivdi3+0x27>
  8040ba:	66 90                	xchg   %ax,%ax
  8040bc:	66 90                	xchg   %ax,%ax
  8040be:	66 90                	xchg   %ax,%ax

008040c0 <__umoddi3>:
  8040c0:	55                   	push   %ebp
  8040c1:	57                   	push   %edi
  8040c2:	56                   	push   %esi
  8040c3:	53                   	push   %ebx
  8040c4:	83 ec 1c             	sub    $0x1c,%esp
  8040c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8040cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8040d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040d7:	89 da                	mov    %ebx,%edx
  8040d9:	85 c0                	test   %eax,%eax
  8040db:	75 43                	jne    804120 <__umoddi3+0x60>
  8040dd:	39 df                	cmp    %ebx,%edi
  8040df:	76 17                	jbe    8040f8 <__umoddi3+0x38>
  8040e1:	89 f0                	mov    %esi,%eax
  8040e3:	f7 f7                	div    %edi
  8040e5:	89 d0                	mov    %edx,%eax
  8040e7:	31 d2                	xor    %edx,%edx
  8040e9:	83 c4 1c             	add    $0x1c,%esp
  8040ec:	5b                   	pop    %ebx
  8040ed:	5e                   	pop    %esi
  8040ee:	5f                   	pop    %edi
  8040ef:	5d                   	pop    %ebp
  8040f0:	c3                   	ret    
  8040f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8040f8:	89 fd                	mov    %edi,%ebp
  8040fa:	85 ff                	test   %edi,%edi
  8040fc:	75 0b                	jne    804109 <__umoddi3+0x49>
  8040fe:	b8 01 00 00 00       	mov    $0x1,%eax
  804103:	31 d2                	xor    %edx,%edx
  804105:	f7 f7                	div    %edi
  804107:	89 c5                	mov    %eax,%ebp
  804109:	89 d8                	mov    %ebx,%eax
  80410b:	31 d2                	xor    %edx,%edx
  80410d:	f7 f5                	div    %ebp
  80410f:	89 f0                	mov    %esi,%eax
  804111:	f7 f5                	div    %ebp
  804113:	89 d0                	mov    %edx,%eax
  804115:	eb d0                	jmp    8040e7 <__umoddi3+0x27>
  804117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80411e:	66 90                	xchg   %ax,%ax
  804120:	89 f1                	mov    %esi,%ecx
  804122:	39 d8                	cmp    %ebx,%eax
  804124:	76 0a                	jbe    804130 <__umoddi3+0x70>
  804126:	89 f0                	mov    %esi,%eax
  804128:	83 c4 1c             	add    $0x1c,%esp
  80412b:	5b                   	pop    %ebx
  80412c:	5e                   	pop    %esi
  80412d:	5f                   	pop    %edi
  80412e:	5d                   	pop    %ebp
  80412f:	c3                   	ret    
  804130:	0f bd e8             	bsr    %eax,%ebp
  804133:	83 f5 1f             	xor    $0x1f,%ebp
  804136:	75 20                	jne    804158 <__umoddi3+0x98>
  804138:	39 d8                	cmp    %ebx,%eax
  80413a:	0f 82 b0 00 00 00    	jb     8041f0 <__umoddi3+0x130>
  804140:	39 f7                	cmp    %esi,%edi
  804142:	0f 86 a8 00 00 00    	jbe    8041f0 <__umoddi3+0x130>
  804148:	89 c8                	mov    %ecx,%eax
  80414a:	83 c4 1c             	add    $0x1c,%esp
  80414d:	5b                   	pop    %ebx
  80414e:	5e                   	pop    %esi
  80414f:	5f                   	pop    %edi
  804150:	5d                   	pop    %ebp
  804151:	c3                   	ret    
  804152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804158:	89 e9                	mov    %ebp,%ecx
  80415a:	ba 20 00 00 00       	mov    $0x20,%edx
  80415f:	29 ea                	sub    %ebp,%edx
  804161:	d3 e0                	shl    %cl,%eax
  804163:	89 44 24 08          	mov    %eax,0x8(%esp)
  804167:	89 d1                	mov    %edx,%ecx
  804169:	89 f8                	mov    %edi,%eax
  80416b:	d3 e8                	shr    %cl,%eax
  80416d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  804171:	89 54 24 04          	mov    %edx,0x4(%esp)
  804175:	8b 54 24 04          	mov    0x4(%esp),%edx
  804179:	09 c1                	or     %eax,%ecx
  80417b:	89 d8                	mov    %ebx,%eax
  80417d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804181:	89 e9                	mov    %ebp,%ecx
  804183:	d3 e7                	shl    %cl,%edi
  804185:	89 d1                	mov    %edx,%ecx
  804187:	d3 e8                	shr    %cl,%eax
  804189:	89 e9                	mov    %ebp,%ecx
  80418b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80418f:	d3 e3                	shl    %cl,%ebx
  804191:	89 c7                	mov    %eax,%edi
  804193:	89 d1                	mov    %edx,%ecx
  804195:	89 f0                	mov    %esi,%eax
  804197:	d3 e8                	shr    %cl,%eax
  804199:	89 e9                	mov    %ebp,%ecx
  80419b:	89 fa                	mov    %edi,%edx
  80419d:	d3 e6                	shl    %cl,%esi
  80419f:	09 d8                	or     %ebx,%eax
  8041a1:	f7 74 24 08          	divl   0x8(%esp)
  8041a5:	89 d1                	mov    %edx,%ecx
  8041a7:	89 f3                	mov    %esi,%ebx
  8041a9:	f7 64 24 0c          	mull   0xc(%esp)
  8041ad:	89 c6                	mov    %eax,%esi
  8041af:	89 d7                	mov    %edx,%edi
  8041b1:	39 d1                	cmp    %edx,%ecx
  8041b3:	72 06                	jb     8041bb <__umoddi3+0xfb>
  8041b5:	75 10                	jne    8041c7 <__umoddi3+0x107>
  8041b7:	39 c3                	cmp    %eax,%ebx
  8041b9:	73 0c                	jae    8041c7 <__umoddi3+0x107>
  8041bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8041bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8041c3:	89 d7                	mov    %edx,%edi
  8041c5:	89 c6                	mov    %eax,%esi
  8041c7:	89 ca                	mov    %ecx,%edx
  8041c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8041ce:	29 f3                	sub    %esi,%ebx
  8041d0:	19 fa                	sbb    %edi,%edx
  8041d2:	89 d0                	mov    %edx,%eax
  8041d4:	d3 e0                	shl    %cl,%eax
  8041d6:	89 e9                	mov    %ebp,%ecx
  8041d8:	d3 eb                	shr    %cl,%ebx
  8041da:	d3 ea                	shr    %cl,%edx
  8041dc:	09 d8                	or     %ebx,%eax
  8041de:	83 c4 1c             	add    $0x1c,%esp
  8041e1:	5b                   	pop    %ebx
  8041e2:	5e                   	pop    %esi
  8041e3:	5f                   	pop    %edi
  8041e4:	5d                   	pop    %ebp
  8041e5:	c3                   	ret    
  8041e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8041ed:	8d 76 00             	lea    0x0(%esi),%esi
  8041f0:	89 da                	mov    %ebx,%edx
  8041f2:	29 fe                	sub    %edi,%esi
  8041f4:	19 c2                	sbb    %eax,%edx
  8041f6:	89 f1                	mov    %esi,%ecx
  8041f8:	89 c8                	mov    %ecx,%eax
  8041fa:	e9 4b ff ff ff       	jmp    80414a <__umoddi3+0x8a>
