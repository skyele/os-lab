
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
  80002c:	e8 db 1b 00 00       	call   801c0c <libmain>
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
  8000b0:	68 40 41 80 00       	push   $0x804140
  8000b5:	e8 c5 1c 00 00       	call   801d7f <cprintf>
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
  8000d9:	68 57 41 80 00       	push   $0x804157
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 67 41 80 00       	push   $0x804167
  8000e5:	e8 9f 1b 00 00       	call   801c89 <_panic>

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
  80018f:	68 70 41 80 00       	push   $0x804170
  800194:	68 7d 41 80 00       	push   $0x80417d
  800199:	6a 44                	push   $0x44
  80019b:	68 67 41 80 00       	push   $0x804167
  8001a0:	e8 e4 1a 00 00       	call   801c89 <_panic>
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
  800257:	68 70 41 80 00       	push   $0x804170
  80025c:	68 7d 41 80 00       	push   $0x80417d
  800261:	6a 5d                	push   $0x5d
  800263:	68 67 41 80 00       	push   $0x804167
  800268:	e8 1c 1a 00 00       	call   801c89 <_panic>
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
  8002a1:	68 94 41 80 00       	push   $0x804194
  8002a6:	6a 0c                	push   $0xc
  8002a8:	68 70 42 80 00       	push   $0x804270
  8002ad:	e8 d7 19 00 00       	call   801c89 <_panic>

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
  800377:	e8 97 25 00 00       	call   802913 <sys_page_map>
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
  80038c:	68 78 42 80 00       	push   $0x804278
  800391:	6a 5a                	push   $0x5a
  800393:	68 70 42 80 00       	push   $0x804270
  800398:	e8 ec 18 00 00       	call   801c89 <_panic>
		panic("the ide_write panic!\n");
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 93 42 80 00       	push   $0x804293
  8003a5:	6a 64                	push   $0x64
  8003a7:	68 70 42 80 00       	push   $0x804270
  8003ac:	e8 d8 18 00 00       	call   801c89 <_panic>
		panic("the sys_page_map panic!\n");
  8003b1:	83 ec 04             	sub    $0x4,%esp
  8003b4:	68 a9 42 80 00       	push   $0x8042a9
  8003b9:	6a 67                	push   $0x67
  8003bb:	68 70 42 80 00       	push   $0x804270
  8003c0:	e8 c4 18 00 00       	call   801c89 <_panic>

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
  8003d4:	e8 ec 27 00 00       	call   802bc5 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8003d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003e0:	e8 95 fe ff ff       	call   80027a <diskaddr>
  8003e5:	83 c4 0c             	add    $0xc,%esp
  8003e8:	68 08 01 00 00       	push   $0x108
  8003ed:	50                   	push   %eax
  8003ee:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8003f4:	50                   	push   %eax
  8003f5:	e8 72 22 00 00       	call   80266c <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  8003fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800401:	e8 74 fe ff ff       	call   80027a <diskaddr>
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	68 c2 42 80 00       	push   $0x8042c2
  80040e:	50                   	push   %eax
  80040f:	e8 ca 20 00 00       	call   8024de <strcpy>
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
  800474:	e8 dc 24 00 00       	call   802955 <sys_page_unmap>
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
  8004a5:	68 c2 42 80 00       	push   $0x8042c2
  8004aa:	50                   	push   %eax
  8004ab:	e8 d9 20 00 00       	call   802589 <strcmp>
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
  8004d5:	e8 92 21 00 00       	call   80266c <memmove>
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
  800504:	e8 63 21 00 00       	call   80266c <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800509:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800510:	e8 65 fd ff ff       	call   80027a <diskaddr>
  800515:	83 c4 08             	add    $0x8,%esp
  800518:	68 c2 42 80 00       	push   $0x8042c2
  80051d:	50                   	push   %eax
  80051e:	e8 bb 1f 00 00       	call   8024de <strcpy>
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
  800569:	e8 e7 23 00 00       	call   802955 <sys_page_unmap>
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
  80059a:	68 c2 42 80 00       	push   $0x8042c2
  80059f:	50                   	push   %eax
  8005a0:	e8 e4 1f 00 00       	call   802589 <strcmp>
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
  8005ca:	e8 9d 20 00 00       	call   80266c <memmove>
	flush_block(diskaddr(1));
  8005cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d6:	e8 9f fc ff ff       	call   80027a <diskaddr>
  8005db:	89 04 24             	mov    %eax,(%esp)
  8005de:	e8 2d fd ff ff       	call   800310 <flush_block>
	cprintf("block cache is good\n");
  8005e3:	c7 04 24 fe 42 80 00 	movl   $0x8042fe,(%esp)
  8005ea:	e8 90 17 00 00       	call   801d7f <cprintf>
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
  80060b:	e8 5c 20 00 00       	call   80266c <memmove>
}
  800610:	83 c4 10             	add    $0x10,%esp
  800613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800616:	c9                   	leave  
  800617:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800618:	68 e4 42 80 00       	push   $0x8042e4
  80061d:	68 7d 41 80 00       	push   $0x80417d
  800622:	6a 78                	push   $0x78
  800624:	68 70 42 80 00       	push   $0x804270
  800629:	e8 5b 16 00 00       	call   801c89 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80062e:	68 c9 42 80 00       	push   $0x8042c9
  800633:	68 7d 41 80 00       	push   $0x80417d
  800638:	6a 79                	push   $0x79
  80063a:	68 70 42 80 00       	push   $0x804270
  80063f:	e8 45 16 00 00       	call   801c89 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800644:	68 e3 42 80 00       	push   $0x8042e3
  800649:	68 7d 41 80 00       	push   $0x80417d
  80064e:	6a 7d                	push   $0x7d
  800650:	68 70 42 80 00       	push   $0x804270
  800655:	e8 2f 16 00 00       	call   801c89 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80065a:	68 b8 41 80 00       	push   $0x8041b8
  80065f:	68 7d 41 80 00       	push   $0x80417d
  800664:	68 80 00 00 00       	push   $0x80
  800669:	68 70 42 80 00       	push   $0x804270
  80066e:	e8 16 16 00 00       	call   801c89 <_panic>
	assert(va_is_mapped(diskaddr(1)));
  800673:	68 e4 42 80 00       	push   $0x8042e4
  800678:	68 7d 41 80 00       	push   $0x80417d
  80067d:	68 91 00 00 00       	push   $0x91
  800682:	68 70 42 80 00       	push   $0x804270
  800687:	e8 fd 15 00 00       	call   801c89 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  80068c:	68 e3 42 80 00       	push   $0x8042e3
  800691:	68 7d 41 80 00       	push   $0x80417d
  800696:	68 99 00 00 00       	push   $0x99
  80069b:	68 70 42 80 00       	push   $0x804270
  8006a0:	e8 e4 15 00 00       	call   801c89 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006a5:	68 b8 41 80 00       	push   $0x8041b8
  8006aa:	68 7d 41 80 00       	push   $0x80417d
  8006af:	68 9c 00 00 00       	push   $0x9c
  8006b4:	68 70 42 80 00       	push   $0x804270
  8006b9:	e8 cb 15 00 00       	call   801c89 <_panic>

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
  8006f2:	e8 6c 24 00 00       	call   802b63 <sys_clear_access_bit>
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
  800762:	68 dc 41 80 00       	push   $0x8041dc
  800767:	68 c1 00 00 00       	push   $0xc1
  80076c:	68 70 42 80 00       	push   $0x804270
  800771:	e8 13 15 00 00       	call   801c89 <_panic>
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
  80080d:	e8 be 20 00 00       	call   8028d0 <sys_page_alloc>
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
  80084a:	e8 c4 20 00 00       	call   802913 <sys_page_map>
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
  80088c:	68 fc 41 80 00       	push   $0x8041fc
  800891:	6a 31                	push   $0x31
  800893:	68 70 42 80 00       	push   $0x804270
  800898:	e8 ec 13 00 00       	call   801c89 <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80089d:	56                   	push   %esi
  80089e:	68 2c 42 80 00       	push   $0x80422c
  8008a3:	6a 34                	push   $0x34
  8008a5:	68 70 42 80 00       	push   $0x804270
  8008aa:	e8 da 13 00 00       	call   801c89 <_panic>
		panic("the sys_page_alloc panic!\n");
  8008af:	83 ec 04             	sub    $0x4,%esp
  8008b2:	68 13 43 80 00       	push   $0x804313
  8008b7:	6a 3f                	push   $0x3f
  8008b9:	68 70 42 80 00       	push   $0x804270
  8008be:	e8 c6 13 00 00       	call   801c89 <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8008c3:	50                   	push   %eax
  8008c4:	68 50 42 80 00       	push   $0x804250
  8008c9:	6a 44                	push   $0x44
  8008cb:	68 70 42 80 00       	push   $0x804270
  8008d0:	e8 b4 13 00 00       	call   801c89 <_panic>
		panic("reading free block %08x\n", blockno);
  8008d5:	56                   	push   %esi
  8008d6:	68 2e 43 80 00       	push   $0x80432e
  8008db:	6a 49                	push   $0x49
  8008dd:	68 70 42 80 00       	push   $0x804270
  8008e2:	e8 a2 13 00 00       	call   801c89 <_panic>

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
  800906:	68 85 43 80 00       	push   $0x804385
  80090b:	e8 6f 14 00 00       	call   801d7f <cprintf>
}
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	c9                   	leave  
  800914:	c3                   	ret    
		panic("bad file system magic number");
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 47 43 80 00       	push   $0x804347
  80091d:	6a 0f                	push   $0xf
  80091f:	68 64 43 80 00       	push   $0x804364
  800924:	e8 60 13 00 00       	call   801c89 <_panic>
		panic("file system is too large");
  800929:	83 ec 04             	sub    $0x4,%esp
  80092c:	68 6c 43 80 00       	push   $0x80436c
  800931:	6a 12                	push   $0x12
  800933:	68 64 43 80 00       	push   $0x804364
  800938:	e8 4c 13 00 00       	call   801c89 <_panic>

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
  8009a5:	68 99 43 80 00       	push   $0x804399
  8009aa:	6a 2d                	push   $0x2d
  8009ac:	68 64 43 80 00       	push   $0x804364
  8009b1:	e8 d3 12 00 00       	call   801c89 <_panic>

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
  800a8a:	e8 95 1b 00 00       	call   802624 <memset>
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
  800b10:	68 b4 43 80 00       	push   $0x8043b4
  800b15:	68 7d 41 80 00       	push   $0x80417d
  800b1a:	6a 5b                	push   $0x5b
  800b1c:	68 64 43 80 00       	push   $0x804364
  800b21:	e8 63 11 00 00       	call   801c89 <_panic>
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
  800b4b:	68 ec 43 80 00       	push   $0x8043ec
  800b50:	e8 2a 12 00 00       	call   801d7f <cprintf>
}
  800b55:	83 c4 10             	add    $0x10,%esp
  800b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5b:	5b                   	pop    %ebx
  800b5c:	5e                   	pop    %esi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    
	assert(!block_is_free(0));
  800b5f:	68 c8 43 80 00       	push   $0x8043c8
  800b64:	68 7d 41 80 00       	push   $0x80417d
  800b69:	6a 5e                	push   $0x5e
  800b6b:	68 64 43 80 00       	push   $0x804364
  800b70:	e8 14 11 00 00       	call   801c89 <_panic>
	assert(!block_is_free(1));
  800b75:	68 da 43 80 00       	push   $0x8043da
  800b7a:	68 7d 41 80 00       	push   $0x80417d
  800b7f:	6a 5f                	push   $0x5f
  800b81:	68 64 43 80 00       	push   $0x804364
  800b86:	e8 fe 10 00 00       	call   801c89 <_panic>

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
  800cd1:	e8 96 19 00 00       	call   80266c <memmove>
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
  800d83:	e8 01 18 00 00       	call   802589 <strcmp>
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
  800da6:	68 fc 43 80 00       	push   $0x8043fc
  800dab:	68 7d 41 80 00       	push   $0x80417d
  800db0:	68 d9 00 00 00       	push   $0xd9
  800db5:	68 64 43 80 00       	push   $0x804364
  800dba:	e8 ca 0e 00 00       	call   801c89 <_panic>
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
  800df4:	e8 e5 16 00 00       	call   8024de <strcpy>
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
  800e85:	68 19 44 80 00       	push   $0x804419
  800e8a:	e8 f0 0e 00 00       	call   801d7f <cprintf>
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
  800f3b:	e8 2c 17 00 00       	call   80266c <memmove>
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
  800fe4:	68 26 44 80 00       	push   $0x804426
  800fe9:	e8 91 0d 00 00       	call   801d7f <cprintf>
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
  8010ad:	e8 ba 15 00 00       	call   80266c <memmove>
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
  80122a:	68 fc 43 80 00       	push   $0x8043fc
  80122f:	68 7d 41 80 00       	push   $0x80417d
  801234:	68 f2 00 00 00       	push   $0xf2
  801239:	68 64 43 80 00       	push   $0x804364
  80123e:	e8 46 0a 00 00       	call   801c89 <_panic>
				*file = &f[j];
  801243:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801259:	e8 80 12 00 00       	call   8024de <strcpy>
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
  80134b:	e8 36 22 00 00       	call   803586 <pageref>
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
  801380:	e8 4b 15 00 00       	call   8028d0 <sys_page_alloc>
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
  8013b1:	e8 6e 12 00 00       	call   802624 <memset>
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
  8013ea:	e8 97 21 00 00       	call   803586 <pageref>
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
  801526:	e8 b3 0f 00 00       	call   8024de <strcpy>
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
  8015b0:	e8 b7 10 00 00       	call   80266c <memmove>
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
  8016cc:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016cf:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8016d2:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8016d5:	e9 82 00 00 00       	jmp    80175c <serve+0x95>
		if (!(perm & PTE_P)) {
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}
		pg = NULL;
  8016da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8016e1:	83 f8 01             	cmp    $0x1,%eax
  8016e4:	74 23                	je     801709 <serve+0x42>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  8016e6:	83 f8 08             	cmp    $0x8,%eax
  8016e9:	77 36                	ja     801721 <serve+0x5a>
  8016eb:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8016f2:	85 d2                	test   %edx,%edx
  8016f4:	74 2b                	je     801721 <serve+0x5a>
			r = handlers[req](whom, fsreq);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 35 44 50 80 00    	pushl  0x805044
  8016ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801702:	ff d2                	call   *%edx
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	eb 31                	jmp    80173a <serve+0x73>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  801709:	53                   	push   %ebx
  80170a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80170d:	50                   	push   %eax
  80170e:	ff 35 44 50 80 00    	pushl  0x805044
  801714:	ff 75 f4             	pushl  -0xc(%ebp)
  801717:	e8 7a fe ff ff       	call   801596 <serve_open>
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	eb 19                	jmp    80173a <serve+0x73>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	ff 75 f4             	pushl  -0xc(%ebp)
  801727:	50                   	push   %eax
  801728:	68 74 44 80 00       	push   $0x804474
  80172d:	e8 4d 06 00 00       	call   801d7f <cprintf>
  801732:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801735:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80173a:	ff 75 f0             	pushl  -0x10(%ebp)
  80173d:	ff 75 ec             	pushl  -0x14(%ebp)
  801740:	50                   	push   %eax
  801741:	ff 75 f4             	pushl  -0xc(%ebp)
  801744:	e8 7a 15 00 00       	call   802cc3 <ipc_send>
		sys_page_unmap(0, fsreq);
  801749:	83 c4 08             	add    $0x8,%esp
  80174c:	ff 35 44 50 80 00    	pushl  0x805044
  801752:	6a 00                	push   $0x0
  801754:	e8 fc 11 00 00       	call   802955 <sys_page_unmap>
  801759:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  80175c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	53                   	push   %ebx
  801767:	ff 35 44 50 80 00    	pushl  0x805044
  80176d:	56                   	push   %esi
  80176e:	e8 e7 14 00 00       	call   802c5a <ipc_recv>
		if (!(perm & PTE_P)) {
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  80177a:	0f 85 5a ff ff ff    	jne    8016da <serve+0x13>
			cprintf("Invalid request from %08x: no argument page\n",
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	ff 75 f4             	pushl  -0xc(%ebp)
  801786:	68 44 44 80 00       	push   $0x804444
  80178b:	e8 ef 05 00 00       	call   801d7f <cprintf>
			continue; // just leave it hanging...
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	eb c7                	jmp    80175c <serve+0x95>

00801795 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in serv.c %s\n", thisenv->env_id, __FUNCTION__);
  80179b:	a1 50 a0 80 00       	mov    0x80a050,%eax
  8017a0:	8b 40 48             	mov    0x48(%eax),%eax
  8017a3:	68 cc 44 80 00       	push   $0x8044cc
  8017a8:	50                   	push   %eax
  8017a9:	68 97 44 80 00       	push   $0x804497
  8017ae:	e8 cc 05 00 00       	call   801d7f <cprintf>
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8017b3:	c7 05 60 90 80 00 a9 	movl   $0x8044a9,0x809060
  8017ba:	44 80 00 
	cprintf("FS is running\n");
  8017bd:	c7 04 24 ac 44 80 00 	movl   $0x8044ac,(%esp)
  8017c4:	e8 b6 05 00 00       	call   801d7f <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8017c9:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8017ce:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8017d3:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8017d5:	c7 04 24 bb 44 80 00 	movl   $0x8044bb,(%esp)
  8017dc:	e8 9e 05 00 00       	call   801d7f <cprintf>

	serve_init();
  8017e1:	e8 1e fb ff ff       	call   801304 <serve_init>
	fs_init();
  8017e6:	e8 a0 f3 ff ff       	call   800b8b <fs_init>
	serve();
  8017eb:	e8 d7 fe ff ff       	call   8016c7 <serve>

008017f0 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8017f7:	6a 07                	push   $0x7
  8017f9:	68 00 10 00 00       	push   $0x1000
  8017fe:	6a 00                	push   $0x0
  801800:	e8 cb 10 00 00       	call   8028d0 <sys_page_alloc>
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	85 c0                	test   %eax,%eax
  80180a:	0f 88 68 02 00 00    	js     801a78 <fs_test+0x288>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	68 00 10 00 00       	push   $0x1000
  801818:	ff 35 48 a0 80 00    	pushl  0x80a048
  80181e:	68 00 10 00 00       	push   $0x1000
  801823:	e8 44 0e 00 00       	call   80266c <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801828:	e8 89 f1 ff ff       	call   8009b6 <alloc_block>
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	85 c0                	test   %eax,%eax
  801832:	0f 88 52 02 00 00    	js     801a8a <fs_test+0x29a>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801838:	8d 50 1f             	lea    0x1f(%eax),%edx
  80183b:	0f 49 d0             	cmovns %eax,%edx
  80183e:	c1 fa 05             	sar    $0x5,%edx
  801841:	89 c3                	mov    %eax,%ebx
  801843:	c1 fb 1f             	sar    $0x1f,%ebx
  801846:	c1 eb 1b             	shr    $0x1b,%ebx
  801849:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  80184c:	83 e1 1f             	and    $0x1f,%ecx
  80184f:	29 d9                	sub    %ebx,%ecx
  801851:	b8 01 00 00 00       	mov    $0x1,%eax
  801856:	d3 e0                	shl    %cl,%eax
  801858:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  80185f:	0f 84 37 02 00 00    	je     801a9c <fs_test+0x2ac>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801865:	8b 0d 48 a0 80 00    	mov    0x80a048,%ecx
  80186b:	85 04 91             	test   %eax,(%ecx,%edx,4)
  80186e:	0f 85 3e 02 00 00    	jne    801ab2 <fs_test+0x2c2>
	cprintf("alloc_block is good\n");
  801874:	83 ec 0c             	sub    $0xc,%esp
  801877:	68 1a 45 80 00       	push   $0x80451a
  80187c:	e8 fe 04 00 00       	call   801d7f <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801881:	83 c4 08             	add    $0x8,%esp
  801884:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801887:	50                   	push   %eax
  801888:	68 2f 45 80 00       	push   $0x80452f
  80188d:	e8 e8 f5 ff ff       	call   800e7a <file_open>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801898:	74 08                	je     8018a2 <fs_test+0xb2>
  80189a:	85 c0                	test   %eax,%eax
  80189c:	0f 88 26 02 00 00    	js     801ac8 <fs_test+0x2d8>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	0f 84 30 02 00 00    	je     801ada <fs_test+0x2ea>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  8018aa:	83 ec 08             	sub    $0x8,%esp
  8018ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b0:	50                   	push   %eax
  8018b1:	68 53 45 80 00       	push   $0x804553
  8018b6:	e8 bf f5 ff ff       	call   800e7a <file_open>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	0f 88 28 02 00 00    	js     801aee <fs_test+0x2fe>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  8018c6:	83 ec 0c             	sub    $0xc,%esp
  8018c9:	68 73 45 80 00       	push   $0x804573
  8018ce:	e8 ac 04 00 00       	call   801d7f <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018d3:	83 c4 0c             	add    $0xc,%esp
  8018d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d9:	50                   	push   %eax
  8018da:	6a 00                	push   $0x0
  8018dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018df:	e8 06 f3 ff ff       	call   800bea <file_get_block>
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	0f 88 11 02 00 00    	js     801b00 <fs_test+0x310>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  8018ef:	83 ec 08             	sub    $0x8,%esp
  8018f2:	68 b8 46 80 00       	push   $0x8046b8
  8018f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8018fa:	e8 8a 0c 00 00       	call   802589 <strcmp>
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	85 c0                	test   %eax,%eax
  801904:	0f 85 08 02 00 00    	jne    801b12 <fs_test+0x322>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  80190a:	83 ec 0c             	sub    $0xc,%esp
  80190d:	68 99 45 80 00       	push   $0x804599
  801912:	e8 68 04 00 00       	call   801d7f <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191a:	0f b6 10             	movzbl (%eax),%edx
  80191d:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80191f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801922:	c1 e8 0c             	shr    $0xc,%eax
  801925:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	a8 40                	test   $0x40,%al
  801931:	0f 84 ef 01 00 00    	je     801b26 <fs_test+0x336>
	file_flush(f);
  801937:	83 ec 0c             	sub    $0xc,%esp
  80193a:	ff 75 f4             	pushl  -0xc(%ebp)
  80193d:	e8 97 f7 ff ff       	call   8010d9 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801945:	c1 e8 0c             	shr    $0xc,%eax
  801948:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	a8 40                	test   $0x40,%al
  801954:	0f 85 e2 01 00 00    	jne    801b3c <fs_test+0x34c>
	cprintf("file_flush is good\n");
  80195a:	83 ec 0c             	sub    $0xc,%esp
  80195d:	68 cd 45 80 00       	push   $0x8045cd
  801962:	e8 18 04 00 00       	call   801d7f <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801967:	83 c4 08             	add    $0x8,%esp
  80196a:	6a 00                	push   $0x0
  80196c:	ff 75 f4             	pushl  -0xc(%ebp)
  80196f:	e8 e0 f5 ff ff       	call   800f54 <file_set_size>
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	85 c0                	test   %eax,%eax
  801979:	0f 88 d3 01 00 00    	js     801b52 <fs_test+0x362>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  80197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801982:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801989:	0f 85 d5 01 00 00    	jne    801b64 <fs_test+0x374>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80198f:	c1 e8 0c             	shr    $0xc,%eax
  801992:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801999:	a8 40                	test   $0x40,%al
  80199b:	0f 85 d9 01 00 00    	jne    801b7a <fs_test+0x38a>
	cprintf("file_truncate is good\n");
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	68 21 46 80 00       	push   $0x804621
  8019a9:	e8 d1 03 00 00       	call   801d7f <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8019ae:	c7 04 24 b8 46 80 00 	movl   $0x8046b8,(%esp)
  8019b5:	e8 eb 0a 00 00       	call   8024a5 <strlen>
  8019ba:	83 c4 08             	add    $0x8,%esp
  8019bd:	50                   	push   %eax
  8019be:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c1:	e8 8e f5 ff ff       	call   800f54 <file_set_size>
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	0f 88 bf 01 00 00    	js     801b90 <fs_test+0x3a0>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	89 c2                	mov    %eax,%edx
  8019d6:	c1 ea 0c             	shr    $0xc,%edx
  8019d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019e0:	f6 c2 40             	test   $0x40,%dl
  8019e3:	0f 85 b9 01 00 00    	jne    801ba2 <fs_test+0x3b2>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8019ef:	52                   	push   %edx
  8019f0:	6a 00                	push   $0x0
  8019f2:	50                   	push   %eax
  8019f3:	e8 f2 f1 ff ff       	call   800bea <file_get_block>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	0f 88 b5 01 00 00    	js     801bb8 <fs_test+0x3c8>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	68 b8 46 80 00       	push   $0x8046b8
  801a0b:	ff 75 f0             	pushl  -0x10(%ebp)
  801a0e:	e8 cb 0a 00 00       	call   8024de <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a16:	c1 e8 0c             	shr    $0xc,%eax
  801a19:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	a8 40                	test   $0x40,%al
  801a25:	0f 84 9f 01 00 00    	je     801bca <fs_test+0x3da>
	file_flush(f);
  801a2b:	83 ec 0c             	sub    $0xc,%esp
  801a2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a31:	e8 a3 f6 ff ff       	call   8010d9 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a39:	c1 e8 0c             	shr    $0xc,%eax
  801a3c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	a8 40                	test   $0x40,%al
  801a48:	0f 85 92 01 00 00    	jne    801be0 <fs_test+0x3f0>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	c1 e8 0c             	shr    $0xc,%eax
  801a54:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a5b:	a8 40                	test   $0x40,%al
  801a5d:	0f 85 93 01 00 00    	jne    801bf6 <fs_test+0x406>
	cprintf("file rewrite is good\n");
  801a63:	83 ec 0c             	sub    $0xc,%esp
  801a66:	68 61 46 80 00       	push   $0x804661
  801a6b:	e8 0f 03 00 00       	call   801d7f <cprintf>
}
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801a78:	50                   	push   %eax
  801a79:	68 d2 44 80 00       	push   $0x8044d2
  801a7e:	6a 12                	push   $0x12
  801a80:	68 e5 44 80 00       	push   $0x8044e5
  801a85:	e8 ff 01 00 00       	call   801c89 <_panic>
		panic("alloc_block: %e", r);
  801a8a:	50                   	push   %eax
  801a8b:	68 ef 44 80 00       	push   $0x8044ef
  801a90:	6a 17                	push   $0x17
  801a92:	68 e5 44 80 00       	push   $0x8044e5
  801a97:	e8 ed 01 00 00       	call   801c89 <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801a9c:	68 ff 44 80 00       	push   $0x8044ff
  801aa1:	68 7d 41 80 00       	push   $0x80417d
  801aa6:	6a 19                	push   $0x19
  801aa8:	68 e5 44 80 00       	push   $0x8044e5
  801aad:	e8 d7 01 00 00       	call   801c89 <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801ab2:	68 78 46 80 00       	push   $0x804678
  801ab7:	68 7d 41 80 00       	push   $0x80417d
  801abc:	6a 1b                	push   $0x1b
  801abe:	68 e5 44 80 00       	push   $0x8044e5
  801ac3:	e8 c1 01 00 00       	call   801c89 <_panic>
		panic("file_open /not-found: %e", r);
  801ac8:	50                   	push   %eax
  801ac9:	68 3a 45 80 00       	push   $0x80453a
  801ace:	6a 1f                	push   $0x1f
  801ad0:	68 e5 44 80 00       	push   $0x8044e5
  801ad5:	e8 af 01 00 00       	call   801c89 <_panic>
		panic("file_open /not-found succeeded!");
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	68 98 46 80 00       	push   $0x804698
  801ae2:	6a 21                	push   $0x21
  801ae4:	68 e5 44 80 00       	push   $0x8044e5
  801ae9:	e8 9b 01 00 00       	call   801c89 <_panic>
		panic("file_open /newmotd: %e", r);
  801aee:	50                   	push   %eax
  801aef:	68 5c 45 80 00       	push   $0x80455c
  801af4:	6a 23                	push   $0x23
  801af6:	68 e5 44 80 00       	push   $0x8044e5
  801afb:	e8 89 01 00 00       	call   801c89 <_panic>
		panic("file_get_block: %e", r);
  801b00:	50                   	push   %eax
  801b01:	68 86 45 80 00       	push   $0x804586
  801b06:	6a 27                	push   $0x27
  801b08:	68 e5 44 80 00       	push   $0x8044e5
  801b0d:	e8 77 01 00 00       	call   801c89 <_panic>
		panic("file_get_block returned wrong data");
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	68 e0 46 80 00       	push   $0x8046e0
  801b1a:	6a 29                	push   $0x29
  801b1c:	68 e5 44 80 00       	push   $0x8044e5
  801b21:	e8 63 01 00 00       	call   801c89 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b26:	68 b2 45 80 00       	push   $0x8045b2
  801b2b:	68 7d 41 80 00       	push   $0x80417d
  801b30:	6a 2d                	push   $0x2d
  801b32:	68 e5 44 80 00       	push   $0x8044e5
  801b37:	e8 4d 01 00 00       	call   801c89 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b3c:	68 b1 45 80 00       	push   $0x8045b1
  801b41:	68 7d 41 80 00       	push   $0x80417d
  801b46:	6a 2f                	push   $0x2f
  801b48:	68 e5 44 80 00       	push   $0x8044e5
  801b4d:	e8 37 01 00 00       	call   801c89 <_panic>
		panic("file_set_size: %e", r);
  801b52:	50                   	push   %eax
  801b53:	68 e1 45 80 00       	push   $0x8045e1
  801b58:	6a 33                	push   $0x33
  801b5a:	68 e5 44 80 00       	push   $0x8044e5
  801b5f:	e8 25 01 00 00       	call   801c89 <_panic>
	assert(f->f_direct[0] == 0);
  801b64:	68 f3 45 80 00       	push   $0x8045f3
  801b69:	68 7d 41 80 00       	push   $0x80417d
  801b6e:	6a 34                	push   $0x34
  801b70:	68 e5 44 80 00       	push   $0x8044e5
  801b75:	e8 0f 01 00 00       	call   801c89 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b7a:	68 07 46 80 00       	push   $0x804607
  801b7f:	68 7d 41 80 00       	push   $0x80417d
  801b84:	6a 35                	push   $0x35
  801b86:	68 e5 44 80 00       	push   $0x8044e5
  801b8b:	e8 f9 00 00 00       	call   801c89 <_panic>
		panic("file_set_size 2: %e", r);
  801b90:	50                   	push   %eax
  801b91:	68 38 46 80 00       	push   $0x804638
  801b96:	6a 39                	push   $0x39
  801b98:	68 e5 44 80 00       	push   $0x8044e5
  801b9d:	e8 e7 00 00 00       	call   801c89 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801ba2:	68 07 46 80 00       	push   $0x804607
  801ba7:	68 7d 41 80 00       	push   $0x80417d
  801bac:	6a 3a                	push   $0x3a
  801bae:	68 e5 44 80 00       	push   $0x8044e5
  801bb3:	e8 d1 00 00 00       	call   801c89 <_panic>
		panic("file_get_block 2: %e", r);
  801bb8:	50                   	push   %eax
  801bb9:	68 4c 46 80 00       	push   $0x80464c
  801bbe:	6a 3c                	push   $0x3c
  801bc0:	68 e5 44 80 00       	push   $0x8044e5
  801bc5:	e8 bf 00 00 00       	call   801c89 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801bca:	68 b2 45 80 00       	push   $0x8045b2
  801bcf:	68 7d 41 80 00       	push   $0x80417d
  801bd4:	6a 3e                	push   $0x3e
  801bd6:	68 e5 44 80 00       	push   $0x8044e5
  801bdb:	e8 a9 00 00 00       	call   801c89 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801be0:	68 b1 45 80 00       	push   $0x8045b1
  801be5:	68 7d 41 80 00       	push   $0x80417d
  801bea:	6a 40                	push   $0x40
  801bec:	68 e5 44 80 00       	push   $0x8044e5
  801bf1:	e8 93 00 00 00       	call   801c89 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801bf6:	68 07 46 80 00       	push   $0x804607
  801bfb:	68 7d 41 80 00       	push   $0x80417d
  801c00:	6a 41                	push   $0x41
  801c02:	68 e5 44 80 00       	push   $0x8044e5
  801c07:	e8 7d 00 00 00       	call   801c89 <_panic>

00801c0c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	56                   	push   %esi
  801c10:	53                   	push   %ebx
  801c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c14:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  801c17:	e8 76 0c 00 00       	call   802892 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  801c1c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c21:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801c27:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c2c:	a3 50 a0 80 00       	mov    %eax,0x80a050

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801c31:	85 db                	test   %ebx,%ebx
  801c33:	7e 07                	jle    801c3c <libmain+0x30>
		binaryname = argv[0];
  801c35:	8b 06                	mov    (%esi),%eax
  801c37:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801c3c:	83 ec 08             	sub    $0x8,%esp
  801c3f:	56                   	push   %esi
  801c40:	53                   	push   %ebx
  801c41:	e8 4f fb ff ff       	call   801795 <umain>

	// exit gracefully
	exit();
  801c46:	e8 0a 00 00 00       	call   801c55 <exit>
}
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5e                   	pop    %esi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    

00801c55 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801c5b:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801c60:	8b 40 48             	mov    0x48(%eax),%eax
  801c63:	68 18 47 80 00       	push   $0x804718
  801c68:	50                   	push   %eax
  801c69:	68 0d 47 80 00       	push   $0x80470d
  801c6e:	e8 0c 01 00 00       	call   801d7f <cprintf>
	close_all();
  801c73:	e8 ba 12 00 00       	call   802f32 <close_all>
	sys_env_destroy(0);
  801c78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c7f:	e8 cd 0b 00 00       	call   802851 <sys_env_destroy>
}
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	56                   	push   %esi
  801c8d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801c8e:	a1 50 a0 80 00       	mov    0x80a050,%eax
  801c93:	8b 40 48             	mov    0x48(%eax),%eax
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	68 44 47 80 00       	push   $0x804744
  801c9e:	50                   	push   %eax
  801c9f:	68 0d 47 80 00       	push   $0x80470d
  801ca4:	e8 d6 00 00 00       	call   801d7f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  801ca9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801cac:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801cb2:	e8 db 0b 00 00       	call   802892 <sys_getenvid>
  801cb7:	83 c4 04             	add    $0x4,%esp
  801cba:	ff 75 0c             	pushl  0xc(%ebp)
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	56                   	push   %esi
  801cc1:	50                   	push   %eax
  801cc2:	68 20 47 80 00       	push   $0x804720
  801cc7:	e8 b3 00 00 00       	call   801d7f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ccc:	83 c4 18             	add    $0x18,%esp
  801ccf:	53                   	push   %ebx
  801cd0:	ff 75 10             	pushl  0x10(%ebp)
  801cd3:	e8 56 00 00 00       	call   801d2e <vcprintf>
	cprintf("\n");
  801cd8:	c7 04 24 c7 42 80 00 	movl   $0x8042c7,(%esp)
  801cdf:	e8 9b 00 00 00       	call   801d7f <cprintf>
  801ce4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ce7:	cc                   	int3   
  801ce8:	eb fd                	jmp    801ce7 <_panic+0x5e>

00801cea <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801cf4:	8b 13                	mov    (%ebx),%edx
  801cf6:	8d 42 01             	lea    0x1(%edx),%eax
  801cf9:	89 03                	mov    %eax,(%ebx)
  801cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cfe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801d02:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d07:	74 09                	je     801d12 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801d09:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801d0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801d12:	83 ec 08             	sub    $0x8,%esp
  801d15:	68 ff 00 00 00       	push   $0xff
  801d1a:	8d 43 08             	lea    0x8(%ebx),%eax
  801d1d:	50                   	push   %eax
  801d1e:	e8 f1 0a 00 00       	call   802814 <sys_cputs>
		b->idx = 0;
  801d23:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d29:	83 c4 10             	add    $0x10,%esp
  801d2c:	eb db                	jmp    801d09 <putch+0x1f>

00801d2e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801d37:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d3e:	00 00 00 
	b.cnt = 0;
  801d41:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d48:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d4b:	ff 75 0c             	pushl  0xc(%ebp)
  801d4e:	ff 75 08             	pushl  0x8(%ebp)
  801d51:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d57:	50                   	push   %eax
  801d58:	68 ea 1c 80 00       	push   $0x801cea
  801d5d:	e8 4a 01 00 00       	call   801eac <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801d62:	83 c4 08             	add    $0x8,%esp
  801d65:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801d6b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801d71:	50                   	push   %eax
  801d72:	e8 9d 0a 00 00       	call   802814 <sys_cputs>

	return b.cnt;
}
  801d77:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d85:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801d88:	50                   	push   %eax
  801d89:	ff 75 08             	pushl  0x8(%ebp)
  801d8c:	e8 9d ff ff ff       	call   801d2e <vcprintf>
	va_end(ap);

	return cnt;
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	57                   	push   %edi
  801d97:	56                   	push   %esi
  801d98:	53                   	push   %ebx
  801d99:	83 ec 1c             	sub    $0x1c,%esp
  801d9c:	89 c6                	mov    %eax,%esi
  801d9e:	89 d7                	mov    %edx,%edi
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801da9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801dac:	8b 45 10             	mov    0x10(%ebp),%eax
  801daf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  801db2:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  801db6:	74 2c                	je     801de4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  801db8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801dbb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801dc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801dc8:	39 c2                	cmp    %eax,%edx
  801dca:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  801dcd:	73 43                	jae    801e12 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  801dcf:	83 eb 01             	sub    $0x1,%ebx
  801dd2:	85 db                	test   %ebx,%ebx
  801dd4:	7e 6c                	jle    801e42 <printnum+0xaf>
				putch(padc, putdat);
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	57                   	push   %edi
  801dda:	ff 75 18             	pushl  0x18(%ebp)
  801ddd:	ff d6                	call   *%esi
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	eb eb                	jmp    801dcf <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  801de4:	83 ec 0c             	sub    $0xc,%esp
  801de7:	6a 20                	push   $0x20
  801de9:	6a 00                	push   $0x0
  801deb:	50                   	push   %eax
  801dec:	ff 75 e4             	pushl  -0x1c(%ebp)
  801def:	ff 75 e0             	pushl  -0x20(%ebp)
  801df2:	89 fa                	mov    %edi,%edx
  801df4:	89 f0                	mov    %esi,%eax
  801df6:	e8 98 ff ff ff       	call   801d93 <printnum>
		while (--width > 0)
  801dfb:	83 c4 20             	add    $0x20,%esp
  801dfe:	83 eb 01             	sub    $0x1,%ebx
  801e01:	85 db                	test   %ebx,%ebx
  801e03:	7e 65                	jle    801e6a <printnum+0xd7>
			putch(padc, putdat);
  801e05:	83 ec 08             	sub    $0x8,%esp
  801e08:	57                   	push   %edi
  801e09:	6a 20                	push   $0x20
  801e0b:	ff d6                	call   *%esi
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	eb ec                	jmp    801dfe <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	ff 75 18             	pushl  0x18(%ebp)
  801e18:	83 eb 01             	sub    $0x1,%ebx
  801e1b:	53                   	push   %ebx
  801e1c:	50                   	push   %eax
  801e1d:	83 ec 08             	sub    $0x8,%esp
  801e20:	ff 75 dc             	pushl  -0x24(%ebp)
  801e23:	ff 75 d8             	pushl  -0x28(%ebp)
  801e26:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e29:	ff 75 e0             	pushl  -0x20(%ebp)
  801e2c:	e8 bf 20 00 00       	call   803ef0 <__udivdi3>
  801e31:	83 c4 18             	add    $0x18,%esp
  801e34:	52                   	push   %edx
  801e35:	50                   	push   %eax
  801e36:	89 fa                	mov    %edi,%edx
  801e38:	89 f0                	mov    %esi,%eax
  801e3a:	e8 54 ff ff ff       	call   801d93 <printnum>
  801e3f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  801e42:	83 ec 08             	sub    $0x8,%esp
  801e45:	57                   	push   %edi
  801e46:	83 ec 04             	sub    $0x4,%esp
  801e49:	ff 75 dc             	pushl  -0x24(%ebp)
  801e4c:	ff 75 d8             	pushl  -0x28(%ebp)
  801e4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e52:	ff 75 e0             	pushl  -0x20(%ebp)
  801e55:	e8 a6 21 00 00       	call   804000 <__umoddi3>
  801e5a:	83 c4 14             	add    $0x14,%esp
  801e5d:	0f be 80 4b 47 80 00 	movsbl 0x80474b(%eax),%eax
  801e64:	50                   	push   %eax
  801e65:	ff d6                	call   *%esi
  801e67:	83 c4 10             	add    $0x10,%esp
	}
}
  801e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e6d:	5b                   	pop    %ebx
  801e6e:	5e                   	pop    %esi
  801e6f:	5f                   	pop    %edi
  801e70:	5d                   	pop    %ebp
  801e71:	c3                   	ret    

00801e72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801e78:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801e7c:	8b 10                	mov    (%eax),%edx
  801e7e:	3b 50 04             	cmp    0x4(%eax),%edx
  801e81:	73 0a                	jae    801e8d <sprintputch+0x1b>
		*b->buf++ = ch;
  801e83:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e86:	89 08                	mov    %ecx,(%eax)
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	88 02                	mov    %al,(%edx)
}
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    

00801e8f <printfmt>:
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801e95:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801e98:	50                   	push   %eax
  801e99:	ff 75 10             	pushl  0x10(%ebp)
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	e8 05 00 00 00       	call   801eac <vprintfmt>
}
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <vprintfmt>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	57                   	push   %edi
  801eb0:	56                   	push   %esi
  801eb1:	53                   	push   %ebx
  801eb2:	83 ec 3c             	sub    $0x3c,%esp
  801eb5:	8b 75 08             	mov    0x8(%ebp),%esi
  801eb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ebb:	8b 7d 10             	mov    0x10(%ebp),%edi
  801ebe:	e9 32 04 00 00       	jmp    8022f5 <vprintfmt+0x449>
		padc = ' ';
  801ec3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  801ec7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  801ece:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  801ed5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801edc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801ee3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  801eea:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801eef:	8d 47 01             	lea    0x1(%edi),%eax
  801ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ef5:	0f b6 17             	movzbl (%edi),%edx
  801ef8:	8d 42 dd             	lea    -0x23(%edx),%eax
  801efb:	3c 55                	cmp    $0x55,%al
  801efd:	0f 87 12 05 00 00    	ja     802415 <vprintfmt+0x569>
  801f03:	0f b6 c0             	movzbl %al,%eax
  801f06:	ff 24 85 20 49 80 00 	jmp    *0x804920(,%eax,4)
  801f0d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801f10:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  801f14:	eb d9                	jmp    801eef <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801f16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801f19:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  801f1d:	eb d0                	jmp    801eef <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801f1f:	0f b6 d2             	movzbl %dl,%edx
  801f22:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2a:	89 75 08             	mov    %esi,0x8(%ebp)
  801f2d:	eb 03                	jmp    801f32 <vprintfmt+0x86>
  801f2f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801f32:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801f35:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801f39:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801f3c:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f3f:	83 fe 09             	cmp    $0x9,%esi
  801f42:	76 eb                	jbe    801f2f <vprintfmt+0x83>
  801f44:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f47:	8b 75 08             	mov    0x8(%ebp),%esi
  801f4a:	eb 14                	jmp    801f60 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  801f4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f54:	8b 45 14             	mov    0x14(%ebp),%eax
  801f57:	8d 40 04             	lea    0x4(%eax),%eax
  801f5a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801f5d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801f60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f64:	79 89                	jns    801eef <vprintfmt+0x43>
				width = precision, precision = -1;
  801f66:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f69:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f6c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801f73:	e9 77 ff ff ff       	jmp    801eef <vprintfmt+0x43>
  801f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	0f 48 c1             	cmovs  %ecx,%eax
  801f80:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801f83:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801f86:	e9 64 ff ff ff       	jmp    801eef <vprintfmt+0x43>
  801f8b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801f8e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  801f95:	e9 55 ff ff ff       	jmp    801eef <vprintfmt+0x43>
			lflag++;
  801f9a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801f9e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801fa1:	e9 49 ff ff ff       	jmp    801eef <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  801fa6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa9:	8d 78 04             	lea    0x4(%eax),%edi
  801fac:	83 ec 08             	sub    $0x8,%esp
  801faf:	53                   	push   %ebx
  801fb0:	ff 30                	pushl  (%eax)
  801fb2:	ff d6                	call   *%esi
			break;
  801fb4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801fb7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801fba:	e9 33 03 00 00       	jmp    8022f2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  801fbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc2:	8d 78 04             	lea    0x4(%eax),%edi
  801fc5:	8b 00                	mov    (%eax),%eax
  801fc7:	99                   	cltd   
  801fc8:	31 d0                	xor    %edx,%eax
  801fca:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801fcc:	83 f8 11             	cmp    $0x11,%eax
  801fcf:	7f 23                	jg     801ff4 <vprintfmt+0x148>
  801fd1:	8b 14 85 80 4a 80 00 	mov    0x804a80(,%eax,4),%edx
  801fd8:	85 d2                	test   %edx,%edx
  801fda:	74 18                	je     801ff4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  801fdc:	52                   	push   %edx
  801fdd:	68 8f 41 80 00       	push   $0x80418f
  801fe2:	53                   	push   %ebx
  801fe3:	56                   	push   %esi
  801fe4:	e8 a6 fe ff ff       	call   801e8f <printfmt>
  801fe9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801fec:	89 7d 14             	mov    %edi,0x14(%ebp)
  801fef:	e9 fe 02 00 00       	jmp    8022f2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  801ff4:	50                   	push   %eax
  801ff5:	68 63 47 80 00       	push   $0x804763
  801ffa:	53                   	push   %ebx
  801ffb:	56                   	push   %esi
  801ffc:	e8 8e fe ff ff       	call   801e8f <printfmt>
  802001:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  802004:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  802007:	e9 e6 02 00 00       	jmp    8022f2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80200c:	8b 45 14             	mov    0x14(%ebp),%eax
  80200f:	83 c0 04             	add    $0x4,%eax
  802012:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802015:	8b 45 14             	mov    0x14(%ebp),%eax
  802018:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80201a:	85 c9                	test   %ecx,%ecx
  80201c:	b8 5c 47 80 00       	mov    $0x80475c,%eax
  802021:	0f 45 c1             	cmovne %ecx,%eax
  802024:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  802027:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80202b:	7e 06                	jle    802033 <vprintfmt+0x187>
  80202d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  802031:	75 0d                	jne    802040 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  802033:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802036:	89 c7                	mov    %eax,%edi
  802038:	03 45 e0             	add    -0x20(%ebp),%eax
  80203b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80203e:	eb 53                	jmp    802093 <vprintfmt+0x1e7>
  802040:	83 ec 08             	sub    $0x8,%esp
  802043:	ff 75 d8             	pushl  -0x28(%ebp)
  802046:	50                   	push   %eax
  802047:	e8 71 04 00 00       	call   8024bd <strnlen>
  80204c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80204f:	29 c1                	sub    %eax,%ecx
  802051:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  802054:	83 c4 10             	add    $0x10,%esp
  802057:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  802059:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80205d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  802060:	eb 0f                	jmp    802071 <vprintfmt+0x1c5>
					putch(padc, putdat);
  802062:	83 ec 08             	sub    $0x8,%esp
  802065:	53                   	push   %ebx
  802066:	ff 75 e0             	pushl  -0x20(%ebp)
  802069:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80206b:	83 ef 01             	sub    $0x1,%edi
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	85 ff                	test   %edi,%edi
  802073:	7f ed                	jg     802062 <vprintfmt+0x1b6>
  802075:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  802078:	85 c9                	test   %ecx,%ecx
  80207a:	b8 00 00 00 00       	mov    $0x0,%eax
  80207f:	0f 49 c1             	cmovns %ecx,%eax
  802082:	29 c1                	sub    %eax,%ecx
  802084:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  802087:	eb aa                	jmp    802033 <vprintfmt+0x187>
					putch(ch, putdat);
  802089:	83 ec 08             	sub    $0x8,%esp
  80208c:	53                   	push   %ebx
  80208d:	52                   	push   %edx
  80208e:	ff d6                	call   *%esi
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802096:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802098:	83 c7 01             	add    $0x1,%edi
  80209b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80209f:	0f be d0             	movsbl %al,%edx
  8020a2:	85 d2                	test   %edx,%edx
  8020a4:	74 4b                	je     8020f1 <vprintfmt+0x245>
  8020a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8020aa:	78 06                	js     8020b2 <vprintfmt+0x206>
  8020ac:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8020b0:	78 1e                	js     8020d0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8020b2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8020b6:	74 d1                	je     802089 <vprintfmt+0x1dd>
  8020b8:	0f be c0             	movsbl %al,%eax
  8020bb:	83 e8 20             	sub    $0x20,%eax
  8020be:	83 f8 5e             	cmp    $0x5e,%eax
  8020c1:	76 c6                	jbe    802089 <vprintfmt+0x1dd>
					putch('?', putdat);
  8020c3:	83 ec 08             	sub    $0x8,%esp
  8020c6:	53                   	push   %ebx
  8020c7:	6a 3f                	push   $0x3f
  8020c9:	ff d6                	call   *%esi
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	eb c3                	jmp    802093 <vprintfmt+0x1e7>
  8020d0:	89 cf                	mov    %ecx,%edi
  8020d2:	eb 0e                	jmp    8020e2 <vprintfmt+0x236>
				putch(' ', putdat);
  8020d4:	83 ec 08             	sub    $0x8,%esp
  8020d7:	53                   	push   %ebx
  8020d8:	6a 20                	push   $0x20
  8020da:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8020dc:	83 ef 01             	sub    $0x1,%edi
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	85 ff                	test   %edi,%edi
  8020e4:	7f ee                	jg     8020d4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8020e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8020ec:	e9 01 02 00 00       	jmp    8022f2 <vprintfmt+0x446>
  8020f1:	89 cf                	mov    %ecx,%edi
  8020f3:	eb ed                	jmp    8020e2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8020f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8020f8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8020ff:	e9 eb fd ff ff       	jmp    801eef <vprintfmt+0x43>
	if (lflag >= 2)
  802104:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  802108:	7f 21                	jg     80212b <vprintfmt+0x27f>
	else if (lflag)
  80210a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80210e:	74 68                	je     802178 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  802110:	8b 45 14             	mov    0x14(%ebp),%eax
  802113:	8b 00                	mov    (%eax),%eax
  802115:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802118:	89 c1                	mov    %eax,%ecx
  80211a:	c1 f9 1f             	sar    $0x1f,%ecx
  80211d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802120:	8b 45 14             	mov    0x14(%ebp),%eax
  802123:	8d 40 04             	lea    0x4(%eax),%eax
  802126:	89 45 14             	mov    %eax,0x14(%ebp)
  802129:	eb 17                	jmp    802142 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80212b:	8b 45 14             	mov    0x14(%ebp),%eax
  80212e:	8b 50 04             	mov    0x4(%eax),%edx
  802131:	8b 00                	mov    (%eax),%eax
  802133:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802136:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  802139:	8b 45 14             	mov    0x14(%ebp),%eax
  80213c:	8d 40 08             	lea    0x8(%eax),%eax
  80213f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  802142:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802145:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802148:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80214b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80214e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802152:	78 3f                	js     802193 <vprintfmt+0x2e7>
			base = 10;
  802154:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  802159:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80215d:	0f 84 71 01 00 00    	je     8022d4 <vprintfmt+0x428>
				putch('+', putdat);
  802163:	83 ec 08             	sub    $0x8,%esp
  802166:	53                   	push   %ebx
  802167:	6a 2b                	push   $0x2b
  802169:	ff d6                	call   *%esi
  80216b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80216e:	b8 0a 00 00 00       	mov    $0xa,%eax
  802173:	e9 5c 01 00 00       	jmp    8022d4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  802178:	8b 45 14             	mov    0x14(%ebp),%eax
  80217b:	8b 00                	mov    (%eax),%eax
  80217d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802180:	89 c1                	mov    %eax,%ecx
  802182:	c1 f9 1f             	sar    $0x1f,%ecx
  802185:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802188:	8b 45 14             	mov    0x14(%ebp),%eax
  80218b:	8d 40 04             	lea    0x4(%eax),%eax
  80218e:	89 45 14             	mov    %eax,0x14(%ebp)
  802191:	eb af                	jmp    802142 <vprintfmt+0x296>
				putch('-', putdat);
  802193:	83 ec 08             	sub    $0x8,%esp
  802196:	53                   	push   %ebx
  802197:	6a 2d                	push   $0x2d
  802199:	ff d6                	call   *%esi
				num = -(long long) num;
  80219b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80219e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021a1:	f7 d8                	neg    %eax
  8021a3:	83 d2 00             	adc    $0x0,%edx
  8021a6:	f7 da                	neg    %edx
  8021a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8021ae:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8021b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8021b6:	e9 19 01 00 00       	jmp    8022d4 <vprintfmt+0x428>
	if (lflag >= 2)
  8021bb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8021bf:	7f 29                	jg     8021ea <vprintfmt+0x33e>
	else if (lflag)
  8021c1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8021c5:	74 44                	je     80220b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8021c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ca:	8b 00                	mov    (%eax),%eax
  8021cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8021d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021da:	8d 40 04             	lea    0x4(%eax),%eax
  8021dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8021e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8021e5:	e9 ea 00 00 00       	jmp    8022d4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8021ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ed:	8b 50 04             	mov    0x4(%eax),%edx
  8021f0:	8b 00                	mov    (%eax),%eax
  8021f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8021f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8021f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fb:	8d 40 08             	lea    0x8(%eax),%eax
  8021fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802201:	b8 0a 00 00 00       	mov    $0xa,%eax
  802206:	e9 c9 00 00 00       	jmp    8022d4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80220b:	8b 45 14             	mov    0x14(%ebp),%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	ba 00 00 00 00       	mov    $0x0,%edx
  802215:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802218:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80221b:	8b 45 14             	mov    0x14(%ebp),%eax
  80221e:	8d 40 04             	lea    0x4(%eax),%eax
  802221:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802224:	b8 0a 00 00 00       	mov    $0xa,%eax
  802229:	e9 a6 00 00 00       	jmp    8022d4 <vprintfmt+0x428>
			putch('0', putdat);
  80222e:	83 ec 08             	sub    $0x8,%esp
  802231:	53                   	push   %ebx
  802232:	6a 30                	push   $0x30
  802234:	ff d6                	call   *%esi
	if (lflag >= 2)
  802236:	83 c4 10             	add    $0x10,%esp
  802239:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80223d:	7f 26                	jg     802265 <vprintfmt+0x3b9>
	else if (lflag)
  80223f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802243:	74 3e                	je     802283 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  802245:	8b 45 14             	mov    0x14(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	ba 00 00 00 00       	mov    $0x0,%edx
  80224f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802252:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802255:	8b 45 14             	mov    0x14(%ebp),%eax
  802258:	8d 40 04             	lea    0x4(%eax),%eax
  80225b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80225e:	b8 08 00 00 00       	mov    $0x8,%eax
  802263:	eb 6f                	jmp    8022d4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  802265:	8b 45 14             	mov    0x14(%ebp),%eax
  802268:	8b 50 04             	mov    0x4(%eax),%edx
  80226b:	8b 00                	mov    (%eax),%eax
  80226d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802270:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802273:	8b 45 14             	mov    0x14(%ebp),%eax
  802276:	8d 40 08             	lea    0x8(%eax),%eax
  802279:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80227c:	b8 08 00 00 00       	mov    $0x8,%eax
  802281:	eb 51                	jmp    8022d4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  802283:	8b 45 14             	mov    0x14(%ebp),%eax
  802286:	8b 00                	mov    (%eax),%eax
  802288:	ba 00 00 00 00       	mov    $0x0,%edx
  80228d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802290:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802293:	8b 45 14             	mov    0x14(%ebp),%eax
  802296:	8d 40 04             	lea    0x4(%eax),%eax
  802299:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80229c:	b8 08 00 00 00       	mov    $0x8,%eax
  8022a1:	eb 31                	jmp    8022d4 <vprintfmt+0x428>
			putch('0', putdat);
  8022a3:	83 ec 08             	sub    $0x8,%esp
  8022a6:	53                   	push   %ebx
  8022a7:	6a 30                	push   $0x30
  8022a9:	ff d6                	call   *%esi
			putch('x', putdat);
  8022ab:	83 c4 08             	add    $0x8,%esp
  8022ae:	53                   	push   %ebx
  8022af:	6a 78                	push   $0x78
  8022b1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8022b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8022c3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8022c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c9:	8d 40 04             	lea    0x4(%eax),%eax
  8022cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8022cf:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8022d4:	83 ec 0c             	sub    $0xc,%esp
  8022d7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8022db:	52                   	push   %edx
  8022dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8022df:	50                   	push   %eax
  8022e0:	ff 75 dc             	pushl  -0x24(%ebp)
  8022e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8022e6:	89 da                	mov    %ebx,%edx
  8022e8:	89 f0                	mov    %esi,%eax
  8022ea:	e8 a4 fa ff ff       	call   801d93 <printnum>
			break;
  8022ef:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8022f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8022f5:	83 c7 01             	add    $0x1,%edi
  8022f8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8022fc:	83 f8 25             	cmp    $0x25,%eax
  8022ff:	0f 84 be fb ff ff    	je     801ec3 <vprintfmt+0x17>
			if (ch == '\0')
  802305:	85 c0                	test   %eax,%eax
  802307:	0f 84 28 01 00 00    	je     802435 <vprintfmt+0x589>
			putch(ch, putdat);
  80230d:	83 ec 08             	sub    $0x8,%esp
  802310:	53                   	push   %ebx
  802311:	50                   	push   %eax
  802312:	ff d6                	call   *%esi
  802314:	83 c4 10             	add    $0x10,%esp
  802317:	eb dc                	jmp    8022f5 <vprintfmt+0x449>
	if (lflag >= 2)
  802319:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80231d:	7f 26                	jg     802345 <vprintfmt+0x499>
	else if (lflag)
  80231f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802323:	74 41                	je     802366 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  802325:	8b 45 14             	mov    0x14(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	ba 00 00 00 00       	mov    $0x0,%edx
  80232f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802332:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802335:	8b 45 14             	mov    0x14(%ebp),%eax
  802338:	8d 40 04             	lea    0x4(%eax),%eax
  80233b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80233e:	b8 10 00 00 00       	mov    $0x10,%eax
  802343:	eb 8f                	jmp    8022d4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  802345:	8b 45 14             	mov    0x14(%ebp),%eax
  802348:	8b 50 04             	mov    0x4(%eax),%edx
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802350:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802353:	8b 45 14             	mov    0x14(%ebp),%eax
  802356:	8d 40 08             	lea    0x8(%eax),%eax
  802359:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80235c:	b8 10 00 00 00       	mov    $0x10,%eax
  802361:	e9 6e ff ff ff       	jmp    8022d4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  802366:	8b 45 14             	mov    0x14(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	ba 00 00 00 00       	mov    $0x0,%edx
  802370:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802373:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802376:	8b 45 14             	mov    0x14(%ebp),%eax
  802379:	8d 40 04             	lea    0x4(%eax),%eax
  80237c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80237f:	b8 10 00 00 00       	mov    $0x10,%eax
  802384:	e9 4b ff ff ff       	jmp    8022d4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  802389:	8b 45 14             	mov    0x14(%ebp),%eax
  80238c:	83 c0 04             	add    $0x4,%eax
  80238f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802392:	8b 45 14             	mov    0x14(%ebp),%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	74 14                	je     8023af <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80239b:	8b 13                	mov    (%ebx),%edx
  80239d:	83 fa 7f             	cmp    $0x7f,%edx
  8023a0:	7f 37                	jg     8023d9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8023a2:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8023a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8023aa:	e9 43 ff ff ff       	jmp    8022f2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8023af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8023b4:	bf 81 48 80 00       	mov    $0x804881,%edi
							putch(ch, putdat);
  8023b9:	83 ec 08             	sub    $0x8,%esp
  8023bc:	53                   	push   %ebx
  8023bd:	50                   	push   %eax
  8023be:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8023c0:	83 c7 01             	add    $0x1,%edi
  8023c3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8023c7:	83 c4 10             	add    $0x10,%esp
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	75 eb                	jne    8023b9 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8023ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8023d4:	e9 19 ff ff ff       	jmp    8022f2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8023d9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8023db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8023e0:	bf b9 48 80 00       	mov    $0x8048b9,%edi
							putch(ch, putdat);
  8023e5:	83 ec 08             	sub    $0x8,%esp
  8023e8:	53                   	push   %ebx
  8023e9:	50                   	push   %eax
  8023ea:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8023ec:	83 c7 01             	add    $0x1,%edi
  8023ef:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	75 eb                	jne    8023e5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8023fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023fd:	89 45 14             	mov    %eax,0x14(%ebp)
  802400:	e9 ed fe ff ff       	jmp    8022f2 <vprintfmt+0x446>
			putch(ch, putdat);
  802405:	83 ec 08             	sub    $0x8,%esp
  802408:	53                   	push   %ebx
  802409:	6a 25                	push   $0x25
  80240b:	ff d6                	call   *%esi
			break;
  80240d:	83 c4 10             	add    $0x10,%esp
  802410:	e9 dd fe ff ff       	jmp    8022f2 <vprintfmt+0x446>
			putch('%', putdat);
  802415:	83 ec 08             	sub    $0x8,%esp
  802418:	53                   	push   %ebx
  802419:	6a 25                	push   $0x25
  80241b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80241d:	83 c4 10             	add    $0x10,%esp
  802420:	89 f8                	mov    %edi,%eax
  802422:	eb 03                	jmp    802427 <vprintfmt+0x57b>
  802424:	83 e8 01             	sub    $0x1,%eax
  802427:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80242b:	75 f7                	jne    802424 <vprintfmt+0x578>
  80242d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802430:	e9 bd fe ff ff       	jmp    8022f2 <vprintfmt+0x446>
}
  802435:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802438:	5b                   	pop    %ebx
  802439:	5e                   	pop    %esi
  80243a:	5f                   	pop    %edi
  80243b:	5d                   	pop    %ebp
  80243c:	c3                   	ret    

0080243d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
  802440:	83 ec 18             	sub    $0x18,%esp
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802449:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80244c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802450:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 26                	je     802484 <vsnprintf+0x47>
  80245e:	85 d2                	test   %edx,%edx
  802460:	7e 22                	jle    802484 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802462:	ff 75 14             	pushl  0x14(%ebp)
  802465:	ff 75 10             	pushl  0x10(%ebp)
  802468:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80246b:	50                   	push   %eax
  80246c:	68 72 1e 80 00       	push   $0x801e72
  802471:	e8 36 fa ff ff       	call   801eac <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802479:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	83 c4 10             	add    $0x10,%esp
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    
		return -E_INVAL;
  802484:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802489:	eb f7                	jmp    802482 <vsnprintf+0x45>

0080248b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802491:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802494:	50                   	push   %eax
  802495:	ff 75 10             	pushl  0x10(%ebp)
  802498:	ff 75 0c             	pushl  0xc(%ebp)
  80249b:	ff 75 08             	pushl  0x8(%ebp)
  80249e:	e8 9a ff ff ff       	call   80243d <vsnprintf>
	va_end(ap);

	return rc;
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8024b4:	74 05                	je     8024bb <strlen+0x16>
		n++;
  8024b6:	83 c0 01             	add    $0x1,%eax
  8024b9:	eb f5                	jmp    8024b0 <strlen+0xb>
	return n;
}
  8024bb:	5d                   	pop    %ebp
  8024bc:	c3                   	ret    

008024bd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
  8024c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8024c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8024cb:	39 c2                	cmp    %eax,%edx
  8024cd:	74 0d                	je     8024dc <strnlen+0x1f>
  8024cf:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8024d3:	74 05                	je     8024da <strnlen+0x1d>
		n++;
  8024d5:	83 c2 01             	add    $0x1,%edx
  8024d8:	eb f1                	jmp    8024cb <strnlen+0xe>
  8024da:	89 d0                	mov    %edx,%eax
	return n;
}
  8024dc:	5d                   	pop    %ebp
  8024dd:	c3                   	ret    

008024de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	53                   	push   %ebx
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8024e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ed:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8024f1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8024f4:	83 c2 01             	add    $0x1,%edx
  8024f7:	84 c9                	test   %cl,%cl
  8024f9:	75 f2                	jne    8024ed <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8024fb:	5b                   	pop    %ebx
  8024fc:	5d                   	pop    %ebp
  8024fd:	c3                   	ret    

008024fe <strcat>:

char *
strcat(char *dst, const char *src)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	53                   	push   %ebx
  802502:	83 ec 10             	sub    $0x10,%esp
  802505:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802508:	53                   	push   %ebx
  802509:	e8 97 ff ff ff       	call   8024a5 <strlen>
  80250e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  802511:	ff 75 0c             	pushl  0xc(%ebp)
  802514:	01 d8                	add    %ebx,%eax
  802516:	50                   	push   %eax
  802517:	e8 c2 ff ff ff       	call   8024de <strcpy>
	return dst;
}
  80251c:	89 d8                	mov    %ebx,%eax
  80251e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80252e:	89 c6                	mov    %eax,%esi
  802530:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802533:	89 c2                	mov    %eax,%edx
  802535:	39 f2                	cmp    %esi,%edx
  802537:	74 11                	je     80254a <strncpy+0x27>
		*dst++ = *src;
  802539:	83 c2 01             	add    $0x1,%edx
  80253c:	0f b6 19             	movzbl (%ecx),%ebx
  80253f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802542:	80 fb 01             	cmp    $0x1,%bl
  802545:	83 d9 ff             	sbb    $0xffffffff,%ecx
  802548:	eb eb                	jmp    802535 <strncpy+0x12>
	}
	return ret;
}
  80254a:	5b                   	pop    %ebx
  80254b:	5e                   	pop    %esi
  80254c:	5d                   	pop    %ebp
  80254d:	c3                   	ret    

0080254e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	56                   	push   %esi
  802552:	53                   	push   %ebx
  802553:	8b 75 08             	mov    0x8(%ebp),%esi
  802556:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802559:	8b 55 10             	mov    0x10(%ebp),%edx
  80255c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80255e:	85 d2                	test   %edx,%edx
  802560:	74 21                	je     802583 <strlcpy+0x35>
  802562:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  802566:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  802568:	39 c2                	cmp    %eax,%edx
  80256a:	74 14                	je     802580 <strlcpy+0x32>
  80256c:	0f b6 19             	movzbl (%ecx),%ebx
  80256f:	84 db                	test   %bl,%bl
  802571:	74 0b                	je     80257e <strlcpy+0x30>
			*dst++ = *src++;
  802573:	83 c1 01             	add    $0x1,%ecx
  802576:	83 c2 01             	add    $0x1,%edx
  802579:	88 5a ff             	mov    %bl,-0x1(%edx)
  80257c:	eb ea                	jmp    802568 <strlcpy+0x1a>
  80257e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  802580:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802583:	29 f0                	sub    %esi,%eax
}
  802585:	5b                   	pop    %ebx
  802586:	5e                   	pop    %esi
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    

00802589 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80258f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802592:	0f b6 01             	movzbl (%ecx),%eax
  802595:	84 c0                	test   %al,%al
  802597:	74 0c                	je     8025a5 <strcmp+0x1c>
  802599:	3a 02                	cmp    (%edx),%al
  80259b:	75 08                	jne    8025a5 <strcmp+0x1c>
		p++, q++;
  80259d:	83 c1 01             	add    $0x1,%ecx
  8025a0:	83 c2 01             	add    $0x1,%edx
  8025a3:	eb ed                	jmp    802592 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8025a5:	0f b6 c0             	movzbl %al,%eax
  8025a8:	0f b6 12             	movzbl (%edx),%edx
  8025ab:	29 d0                	sub    %edx,%eax
}
  8025ad:	5d                   	pop    %ebp
  8025ae:	c3                   	ret    

008025af <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	53                   	push   %ebx
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b9:	89 c3                	mov    %eax,%ebx
  8025bb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8025be:	eb 06                	jmp    8025c6 <strncmp+0x17>
		n--, p++, q++;
  8025c0:	83 c0 01             	add    $0x1,%eax
  8025c3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8025c6:	39 d8                	cmp    %ebx,%eax
  8025c8:	74 16                	je     8025e0 <strncmp+0x31>
  8025ca:	0f b6 08             	movzbl (%eax),%ecx
  8025cd:	84 c9                	test   %cl,%cl
  8025cf:	74 04                	je     8025d5 <strncmp+0x26>
  8025d1:	3a 0a                	cmp    (%edx),%cl
  8025d3:	74 eb                	je     8025c0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8025d5:	0f b6 00             	movzbl (%eax),%eax
  8025d8:	0f b6 12             	movzbl (%edx),%edx
  8025db:	29 d0                	sub    %edx,%eax
}
  8025dd:	5b                   	pop    %ebx
  8025de:	5d                   	pop    %ebp
  8025df:	c3                   	ret    
		return 0;
  8025e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e5:	eb f6                	jmp    8025dd <strncmp+0x2e>

008025e7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8025f1:	0f b6 10             	movzbl (%eax),%edx
  8025f4:	84 d2                	test   %dl,%dl
  8025f6:	74 09                	je     802601 <strchr+0x1a>
		if (*s == c)
  8025f8:	38 ca                	cmp    %cl,%dl
  8025fa:	74 0a                	je     802606 <strchr+0x1f>
	for (; *s; s++)
  8025fc:	83 c0 01             	add    $0x1,%eax
  8025ff:	eb f0                	jmp    8025f1 <strchr+0xa>
			return (char *) s;
	return 0;
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802606:	5d                   	pop    %ebp
  802607:	c3                   	ret    

00802608 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802612:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  802615:	38 ca                	cmp    %cl,%dl
  802617:	74 09                	je     802622 <strfind+0x1a>
  802619:	84 d2                	test   %dl,%dl
  80261b:	74 05                	je     802622 <strfind+0x1a>
	for (; *s; s++)
  80261d:	83 c0 01             	add    $0x1,%eax
  802620:	eb f0                	jmp    802612 <strfind+0xa>
			break;
	return (char *) s;
}
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    

00802624 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	57                   	push   %edi
  802628:	56                   	push   %esi
  802629:	53                   	push   %ebx
  80262a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80262d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802630:	85 c9                	test   %ecx,%ecx
  802632:	74 31                	je     802665 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802634:	89 f8                	mov    %edi,%eax
  802636:	09 c8                	or     %ecx,%eax
  802638:	a8 03                	test   $0x3,%al
  80263a:	75 23                	jne    80265f <memset+0x3b>
		c &= 0xFF;
  80263c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802640:	89 d3                	mov    %edx,%ebx
  802642:	c1 e3 08             	shl    $0x8,%ebx
  802645:	89 d0                	mov    %edx,%eax
  802647:	c1 e0 18             	shl    $0x18,%eax
  80264a:	89 d6                	mov    %edx,%esi
  80264c:	c1 e6 10             	shl    $0x10,%esi
  80264f:	09 f0                	or     %esi,%eax
  802651:	09 c2                	or     %eax,%edx
  802653:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802655:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  802658:	89 d0                	mov    %edx,%eax
  80265a:	fc                   	cld    
  80265b:	f3 ab                	rep stos %eax,%es:(%edi)
  80265d:	eb 06                	jmp    802665 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80265f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802662:	fc                   	cld    
  802663:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802665:	89 f8                	mov    %edi,%eax
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    

0080266c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	57                   	push   %edi
  802670:	56                   	push   %esi
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	8b 75 0c             	mov    0xc(%ebp),%esi
  802677:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80267a:	39 c6                	cmp    %eax,%esi
  80267c:	73 32                	jae    8026b0 <memmove+0x44>
  80267e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802681:	39 c2                	cmp    %eax,%edx
  802683:	76 2b                	jbe    8026b0 <memmove+0x44>
		s += n;
		d += n;
  802685:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802688:	89 fe                	mov    %edi,%esi
  80268a:	09 ce                	or     %ecx,%esi
  80268c:	09 d6                	or     %edx,%esi
  80268e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  802694:	75 0e                	jne    8026a4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802696:	83 ef 04             	sub    $0x4,%edi
  802699:	8d 72 fc             	lea    -0x4(%edx),%esi
  80269c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80269f:	fd                   	std    
  8026a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8026a2:	eb 09                	jmp    8026ad <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8026a4:	83 ef 01             	sub    $0x1,%edi
  8026a7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8026aa:	fd                   	std    
  8026ab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8026ad:	fc                   	cld    
  8026ae:	eb 1a                	jmp    8026ca <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8026b0:	89 c2                	mov    %eax,%edx
  8026b2:	09 ca                	or     %ecx,%edx
  8026b4:	09 f2                	or     %esi,%edx
  8026b6:	f6 c2 03             	test   $0x3,%dl
  8026b9:	75 0a                	jne    8026c5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8026bb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8026be:	89 c7                	mov    %eax,%edi
  8026c0:	fc                   	cld    
  8026c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8026c3:	eb 05                	jmp    8026ca <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  8026c5:	89 c7                	mov    %eax,%edi
  8026c7:	fc                   	cld    
  8026c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8026ca:	5e                   	pop    %esi
  8026cb:	5f                   	pop    %edi
  8026cc:	5d                   	pop    %ebp
  8026cd:	c3                   	ret    

008026ce <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
  8026d1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8026d4:	ff 75 10             	pushl  0x10(%ebp)
  8026d7:	ff 75 0c             	pushl  0xc(%ebp)
  8026da:	ff 75 08             	pushl  0x8(%ebp)
  8026dd:	e8 8a ff ff ff       	call   80266c <memmove>
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	56                   	push   %esi
  8026e8:	53                   	push   %ebx
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ef:	89 c6                	mov    %eax,%esi
  8026f1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8026f4:	39 f0                	cmp    %esi,%eax
  8026f6:	74 1c                	je     802714 <memcmp+0x30>
		if (*s1 != *s2)
  8026f8:	0f b6 08             	movzbl (%eax),%ecx
  8026fb:	0f b6 1a             	movzbl (%edx),%ebx
  8026fe:	38 d9                	cmp    %bl,%cl
  802700:	75 08                	jne    80270a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  802702:	83 c0 01             	add    $0x1,%eax
  802705:	83 c2 01             	add    $0x1,%edx
  802708:	eb ea                	jmp    8026f4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80270a:	0f b6 c1             	movzbl %cl,%eax
  80270d:	0f b6 db             	movzbl %bl,%ebx
  802710:	29 d8                	sub    %ebx,%eax
  802712:	eb 05                	jmp    802719 <memcmp+0x35>
	}

	return 0;
  802714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802719:	5b                   	pop    %ebx
  80271a:	5e                   	pop    %esi
  80271b:	5d                   	pop    %ebp
  80271c:	c3                   	ret    

0080271d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	8b 45 08             	mov    0x8(%ebp),%eax
  802723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  802726:	89 c2                	mov    %eax,%edx
  802728:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80272b:	39 d0                	cmp    %edx,%eax
  80272d:	73 09                	jae    802738 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80272f:	38 08                	cmp    %cl,(%eax)
  802731:	74 05                	je     802738 <memfind+0x1b>
	for (; s < ends; s++)
  802733:	83 c0 01             	add    $0x1,%eax
  802736:	eb f3                	jmp    80272b <memfind+0xe>
			break;
	return (void *) s;
}
  802738:	5d                   	pop    %ebp
  802739:	c3                   	ret    

0080273a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	57                   	push   %edi
  80273e:	56                   	push   %esi
  80273f:	53                   	push   %ebx
  802740:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802743:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802746:	eb 03                	jmp    80274b <strtol+0x11>
		s++;
  802748:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80274b:	0f b6 01             	movzbl (%ecx),%eax
  80274e:	3c 20                	cmp    $0x20,%al
  802750:	74 f6                	je     802748 <strtol+0xe>
  802752:	3c 09                	cmp    $0x9,%al
  802754:	74 f2                	je     802748 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  802756:	3c 2b                	cmp    $0x2b,%al
  802758:	74 2a                	je     802784 <strtol+0x4a>
	int neg = 0;
  80275a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80275f:	3c 2d                	cmp    $0x2d,%al
  802761:	74 2b                	je     80278e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802763:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  802769:	75 0f                	jne    80277a <strtol+0x40>
  80276b:	80 39 30             	cmpb   $0x30,(%ecx)
  80276e:	74 28                	je     802798 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802770:	85 db                	test   %ebx,%ebx
  802772:	b8 0a 00 00 00       	mov    $0xa,%eax
  802777:	0f 44 d8             	cmove  %eax,%ebx
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax
  80277f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802782:	eb 50                	jmp    8027d4 <strtol+0x9a>
		s++;
  802784:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  802787:	bf 00 00 00 00       	mov    $0x0,%edi
  80278c:	eb d5                	jmp    802763 <strtol+0x29>
		s++, neg = 1;
  80278e:	83 c1 01             	add    $0x1,%ecx
  802791:	bf 01 00 00 00       	mov    $0x1,%edi
  802796:	eb cb                	jmp    802763 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802798:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80279c:	74 0e                	je     8027ac <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80279e:	85 db                	test   %ebx,%ebx
  8027a0:	75 d8                	jne    80277a <strtol+0x40>
		s++, base = 8;
  8027a2:	83 c1 01             	add    $0x1,%ecx
  8027a5:	bb 08 00 00 00       	mov    $0x8,%ebx
  8027aa:	eb ce                	jmp    80277a <strtol+0x40>
		s += 2, base = 16;
  8027ac:	83 c1 02             	add    $0x2,%ecx
  8027af:	bb 10 00 00 00       	mov    $0x10,%ebx
  8027b4:	eb c4                	jmp    80277a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8027b6:	8d 72 9f             	lea    -0x61(%edx),%esi
  8027b9:	89 f3                	mov    %esi,%ebx
  8027bb:	80 fb 19             	cmp    $0x19,%bl
  8027be:	77 29                	ja     8027e9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  8027c0:	0f be d2             	movsbl %dl,%edx
  8027c3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8027c6:	3b 55 10             	cmp    0x10(%ebp),%edx
  8027c9:	7d 30                	jge    8027fb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  8027cb:	83 c1 01             	add    $0x1,%ecx
  8027ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8027d2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8027d4:	0f b6 11             	movzbl (%ecx),%edx
  8027d7:	8d 72 d0             	lea    -0x30(%edx),%esi
  8027da:	89 f3                	mov    %esi,%ebx
  8027dc:	80 fb 09             	cmp    $0x9,%bl
  8027df:	77 d5                	ja     8027b6 <strtol+0x7c>
			dig = *s - '0';
  8027e1:	0f be d2             	movsbl %dl,%edx
  8027e4:	83 ea 30             	sub    $0x30,%edx
  8027e7:	eb dd                	jmp    8027c6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  8027e9:	8d 72 bf             	lea    -0x41(%edx),%esi
  8027ec:	89 f3                	mov    %esi,%ebx
  8027ee:	80 fb 19             	cmp    $0x19,%bl
  8027f1:	77 08                	ja     8027fb <strtol+0xc1>
			dig = *s - 'A' + 10;
  8027f3:	0f be d2             	movsbl %dl,%edx
  8027f6:	83 ea 37             	sub    $0x37,%edx
  8027f9:	eb cb                	jmp    8027c6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  8027fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027ff:	74 05                	je     802806 <strtol+0xcc>
		*endptr = (char *) s;
  802801:	8b 75 0c             	mov    0xc(%ebp),%esi
  802804:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802806:	89 c2                	mov    %eax,%edx
  802808:	f7 da                	neg    %edx
  80280a:	85 ff                	test   %edi,%edi
  80280c:	0f 45 c2             	cmovne %edx,%eax
}
  80280f:	5b                   	pop    %ebx
  802810:	5e                   	pop    %esi
  802811:	5f                   	pop    %edi
  802812:	5d                   	pop    %ebp
  802813:	c3                   	ret    

00802814 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	57                   	push   %edi
  802818:	56                   	push   %esi
  802819:	53                   	push   %ebx
	asm volatile("int %1\n"
  80281a:	b8 00 00 00 00       	mov    $0x0,%eax
  80281f:	8b 55 08             	mov    0x8(%ebp),%edx
  802822:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802825:	89 c3                	mov    %eax,%ebx
  802827:	89 c7                	mov    %eax,%edi
  802829:	89 c6                	mov    %eax,%esi
  80282b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80282d:	5b                   	pop    %ebx
  80282e:	5e                   	pop    %esi
  80282f:	5f                   	pop    %edi
  802830:	5d                   	pop    %ebp
  802831:	c3                   	ret    

00802832 <sys_cgetc>:

int
sys_cgetc(void)
{
  802832:	55                   	push   %ebp
  802833:	89 e5                	mov    %esp,%ebp
  802835:	57                   	push   %edi
  802836:	56                   	push   %esi
  802837:	53                   	push   %ebx
	asm volatile("int %1\n"
  802838:	ba 00 00 00 00       	mov    $0x0,%edx
  80283d:	b8 01 00 00 00       	mov    $0x1,%eax
  802842:	89 d1                	mov    %edx,%ecx
  802844:	89 d3                	mov    %edx,%ebx
  802846:	89 d7                	mov    %edx,%edi
  802848:	89 d6                	mov    %edx,%esi
  80284a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80284c:	5b                   	pop    %ebx
  80284d:	5e                   	pop    %esi
  80284e:	5f                   	pop    %edi
  80284f:	5d                   	pop    %ebp
  802850:	c3                   	ret    

00802851 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	57                   	push   %edi
  802855:	56                   	push   %esi
  802856:	53                   	push   %ebx
  802857:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80285a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80285f:	8b 55 08             	mov    0x8(%ebp),%edx
  802862:	b8 03 00 00 00       	mov    $0x3,%eax
  802867:	89 cb                	mov    %ecx,%ebx
  802869:	89 cf                	mov    %ecx,%edi
  80286b:	89 ce                	mov    %ecx,%esi
  80286d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80286f:	85 c0                	test   %eax,%eax
  802871:	7f 08                	jg     80287b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  802873:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802876:	5b                   	pop    %ebx
  802877:	5e                   	pop    %esi
  802878:	5f                   	pop    %edi
  802879:	5d                   	pop    %ebp
  80287a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80287b:	83 ec 0c             	sub    $0xc,%esp
  80287e:	50                   	push   %eax
  80287f:	6a 03                	push   $0x3
  802881:	68 c8 4a 80 00       	push   $0x804ac8
  802886:	6a 43                	push   $0x43
  802888:	68 e5 4a 80 00       	push   $0x804ae5
  80288d:	e8 f7 f3 ff ff       	call   801c89 <_panic>

00802892 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	57                   	push   %edi
  802896:	56                   	push   %esi
  802897:	53                   	push   %ebx
	asm volatile("int %1\n"
  802898:	ba 00 00 00 00       	mov    $0x0,%edx
  80289d:	b8 02 00 00 00       	mov    $0x2,%eax
  8028a2:	89 d1                	mov    %edx,%ecx
  8028a4:	89 d3                	mov    %edx,%ebx
  8028a6:	89 d7                	mov    %edx,%edi
  8028a8:	89 d6                	mov    %edx,%esi
  8028aa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8028ac:	5b                   	pop    %ebx
  8028ad:	5e                   	pop    %esi
  8028ae:	5f                   	pop    %edi
  8028af:	5d                   	pop    %ebp
  8028b0:	c3                   	ret    

008028b1 <sys_yield>:

void
sys_yield(void)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	57                   	push   %edi
  8028b5:	56                   	push   %esi
  8028b6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028bc:	b8 0b 00 00 00       	mov    $0xb,%eax
  8028c1:	89 d1                	mov    %edx,%ecx
  8028c3:	89 d3                	mov    %edx,%ebx
  8028c5:	89 d7                	mov    %edx,%edi
  8028c7:	89 d6                	mov    %edx,%esi
  8028c9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8028cb:	5b                   	pop    %ebx
  8028cc:	5e                   	pop    %esi
  8028cd:	5f                   	pop    %edi
  8028ce:	5d                   	pop    %ebp
  8028cf:	c3                   	ret    

008028d0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
  8028d3:	57                   	push   %edi
  8028d4:	56                   	push   %esi
  8028d5:	53                   	push   %ebx
  8028d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8028d9:	be 00 00 00 00       	mov    $0x0,%esi
  8028de:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028e4:	b8 04 00 00 00       	mov    $0x4,%eax
  8028e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028ec:	89 f7                	mov    %esi,%edi
  8028ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	7f 08                	jg     8028fc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8028f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028f7:	5b                   	pop    %ebx
  8028f8:	5e                   	pop    %esi
  8028f9:	5f                   	pop    %edi
  8028fa:	5d                   	pop    %ebp
  8028fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8028fc:	83 ec 0c             	sub    $0xc,%esp
  8028ff:	50                   	push   %eax
  802900:	6a 04                	push   $0x4
  802902:	68 c8 4a 80 00       	push   $0x804ac8
  802907:	6a 43                	push   $0x43
  802909:	68 e5 4a 80 00       	push   $0x804ae5
  80290e:	e8 76 f3 ff ff       	call   801c89 <_panic>

00802913 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
  802916:	57                   	push   %edi
  802917:	56                   	push   %esi
  802918:	53                   	push   %ebx
  802919:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80291c:	8b 55 08             	mov    0x8(%ebp),%edx
  80291f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802922:	b8 05 00 00 00       	mov    $0x5,%eax
  802927:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80292a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80292d:	8b 75 18             	mov    0x18(%ebp),%esi
  802930:	cd 30                	int    $0x30
	if(check && ret > 0)
  802932:	85 c0                	test   %eax,%eax
  802934:	7f 08                	jg     80293e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802936:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802939:	5b                   	pop    %ebx
  80293a:	5e                   	pop    %esi
  80293b:	5f                   	pop    %edi
  80293c:	5d                   	pop    %ebp
  80293d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80293e:	83 ec 0c             	sub    $0xc,%esp
  802941:	50                   	push   %eax
  802942:	6a 05                	push   $0x5
  802944:	68 c8 4a 80 00       	push   $0x804ac8
  802949:	6a 43                	push   $0x43
  80294b:	68 e5 4a 80 00       	push   $0x804ae5
  802950:	e8 34 f3 ff ff       	call   801c89 <_panic>

00802955 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	57                   	push   %edi
  802959:	56                   	push   %esi
  80295a:	53                   	push   %ebx
  80295b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80295e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802963:	8b 55 08             	mov    0x8(%ebp),%edx
  802966:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802969:	b8 06 00 00 00       	mov    $0x6,%eax
  80296e:	89 df                	mov    %ebx,%edi
  802970:	89 de                	mov    %ebx,%esi
  802972:	cd 30                	int    $0x30
	if(check && ret > 0)
  802974:	85 c0                	test   %eax,%eax
  802976:	7f 08                	jg     802980 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802978:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80297b:	5b                   	pop    %ebx
  80297c:	5e                   	pop    %esi
  80297d:	5f                   	pop    %edi
  80297e:	5d                   	pop    %ebp
  80297f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802980:	83 ec 0c             	sub    $0xc,%esp
  802983:	50                   	push   %eax
  802984:	6a 06                	push   $0x6
  802986:	68 c8 4a 80 00       	push   $0x804ac8
  80298b:	6a 43                	push   $0x43
  80298d:	68 e5 4a 80 00       	push   $0x804ae5
  802992:	e8 f2 f2 ff ff       	call   801c89 <_panic>

00802997 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	57                   	push   %edi
  80299b:	56                   	push   %esi
  80299c:	53                   	push   %ebx
  80299d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8029a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8029b0:	89 df                	mov    %ebx,%edi
  8029b2:	89 de                	mov    %ebx,%esi
  8029b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	7f 08                	jg     8029c2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8029ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029bd:	5b                   	pop    %ebx
  8029be:	5e                   	pop    %esi
  8029bf:	5f                   	pop    %edi
  8029c0:	5d                   	pop    %ebp
  8029c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8029c2:	83 ec 0c             	sub    $0xc,%esp
  8029c5:	50                   	push   %eax
  8029c6:	6a 08                	push   $0x8
  8029c8:	68 c8 4a 80 00       	push   $0x804ac8
  8029cd:	6a 43                	push   $0x43
  8029cf:	68 e5 4a 80 00       	push   $0x804ae5
  8029d4:	e8 b0 f2 ff ff       	call   801c89 <_panic>

008029d9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8029d9:	55                   	push   %ebp
  8029da:	89 e5                	mov    %esp,%ebp
  8029dc:	57                   	push   %edi
  8029dd:	56                   	push   %esi
  8029de:	53                   	push   %ebx
  8029df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8029e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029ed:	b8 09 00 00 00       	mov    $0x9,%eax
  8029f2:	89 df                	mov    %ebx,%edi
  8029f4:	89 de                	mov    %ebx,%esi
  8029f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	7f 08                	jg     802a04 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8029fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ff:	5b                   	pop    %ebx
  802a00:	5e                   	pop    %esi
  802a01:	5f                   	pop    %edi
  802a02:	5d                   	pop    %ebp
  802a03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802a04:	83 ec 0c             	sub    $0xc,%esp
  802a07:	50                   	push   %eax
  802a08:	6a 09                	push   $0x9
  802a0a:	68 c8 4a 80 00       	push   $0x804ac8
  802a0f:	6a 43                	push   $0x43
  802a11:	68 e5 4a 80 00       	push   $0x804ae5
  802a16:	e8 6e f2 ff ff       	call   801c89 <_panic>

00802a1b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
  802a1e:	57                   	push   %edi
  802a1f:	56                   	push   %esi
  802a20:	53                   	push   %ebx
  802a21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a24:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a29:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a2f:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a34:	89 df                	mov    %ebx,%edi
  802a36:	89 de                	mov    %ebx,%esi
  802a38:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	7f 08                	jg     802a46 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a41:	5b                   	pop    %ebx
  802a42:	5e                   	pop    %esi
  802a43:	5f                   	pop    %edi
  802a44:	5d                   	pop    %ebp
  802a45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802a46:	83 ec 0c             	sub    $0xc,%esp
  802a49:	50                   	push   %eax
  802a4a:	6a 0a                	push   $0xa
  802a4c:	68 c8 4a 80 00       	push   $0x804ac8
  802a51:	6a 43                	push   $0x43
  802a53:	68 e5 4a 80 00       	push   $0x804ae5
  802a58:	e8 2c f2 ff ff       	call   801c89 <_panic>

00802a5d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
  802a60:	57                   	push   %edi
  802a61:	56                   	push   %esi
  802a62:	53                   	push   %ebx
	asm volatile("int %1\n"
  802a63:	8b 55 08             	mov    0x8(%ebp),%edx
  802a66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a69:	b8 0c 00 00 00       	mov    $0xc,%eax
  802a6e:	be 00 00 00 00       	mov    $0x0,%esi
  802a73:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a76:	8b 7d 14             	mov    0x14(%ebp),%edi
  802a79:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802a7b:	5b                   	pop    %ebx
  802a7c:	5e                   	pop    %esi
  802a7d:	5f                   	pop    %edi
  802a7e:	5d                   	pop    %ebp
  802a7f:	c3                   	ret    

00802a80 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
  802a83:	57                   	push   %edi
  802a84:	56                   	push   %esi
  802a85:	53                   	push   %ebx
  802a86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802a89:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a91:	b8 0d 00 00 00       	mov    $0xd,%eax
  802a96:	89 cb                	mov    %ecx,%ebx
  802a98:	89 cf                	mov    %ecx,%edi
  802a9a:	89 ce                	mov    %ecx,%esi
  802a9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	7f 08                	jg     802aaa <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802aa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802aa5:	5b                   	pop    %ebx
  802aa6:	5e                   	pop    %esi
  802aa7:	5f                   	pop    %edi
  802aa8:	5d                   	pop    %ebp
  802aa9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802aaa:	83 ec 0c             	sub    $0xc,%esp
  802aad:	50                   	push   %eax
  802aae:	6a 0d                	push   $0xd
  802ab0:	68 c8 4a 80 00       	push   $0x804ac8
  802ab5:	6a 43                	push   $0x43
  802ab7:	68 e5 4a 80 00       	push   $0x804ae5
  802abc:	e8 c8 f1 ff ff       	call   801c89 <_panic>

00802ac1 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
  802ac4:	57                   	push   %edi
  802ac5:	56                   	push   %esi
  802ac6:	53                   	push   %ebx
	asm volatile("int %1\n"
  802ac7:	bb 00 00 00 00       	mov    $0x0,%ebx
  802acc:	8b 55 08             	mov    0x8(%ebp),%edx
  802acf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ad2:	b8 0e 00 00 00       	mov    $0xe,%eax
  802ad7:	89 df                	mov    %ebx,%edi
  802ad9:	89 de                	mov    %ebx,%esi
  802adb:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  802add:	5b                   	pop    %ebx
  802ade:	5e                   	pop    %esi
  802adf:	5f                   	pop    %edi
  802ae0:	5d                   	pop    %ebp
  802ae1:	c3                   	ret    

00802ae2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
  802ae5:	57                   	push   %edi
  802ae6:	56                   	push   %esi
  802ae7:	53                   	push   %ebx
	asm volatile("int %1\n"
  802ae8:	b9 00 00 00 00       	mov    $0x0,%ecx
  802aed:	8b 55 08             	mov    0x8(%ebp),%edx
  802af0:	b8 0f 00 00 00       	mov    $0xf,%eax
  802af5:	89 cb                	mov    %ecx,%ebx
  802af7:	89 cf                	mov    %ecx,%edi
  802af9:	89 ce                	mov    %ecx,%esi
  802afb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  802afd:	5b                   	pop    %ebx
  802afe:	5e                   	pop    %esi
  802aff:	5f                   	pop    %edi
  802b00:	5d                   	pop    %ebp
  802b01:	c3                   	ret    

00802b02 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802b02:	55                   	push   %ebp
  802b03:	89 e5                	mov    %esp,%ebp
  802b05:	57                   	push   %edi
  802b06:	56                   	push   %esi
  802b07:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b08:	ba 00 00 00 00       	mov    $0x0,%edx
  802b0d:	b8 10 00 00 00       	mov    $0x10,%eax
  802b12:	89 d1                	mov    %edx,%ecx
  802b14:	89 d3                	mov    %edx,%ebx
  802b16:	89 d7                	mov    %edx,%edi
  802b18:	89 d6                	mov    %edx,%esi
  802b1a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802b1c:	5b                   	pop    %ebx
  802b1d:	5e                   	pop    %esi
  802b1e:	5f                   	pop    %edi
  802b1f:	5d                   	pop    %ebp
  802b20:	c3                   	ret    

00802b21 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  802b21:	55                   	push   %ebp
  802b22:	89 e5                	mov    %esp,%ebp
  802b24:	57                   	push   %edi
  802b25:	56                   	push   %esi
  802b26:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b27:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b32:	b8 11 00 00 00       	mov    $0x11,%eax
  802b37:	89 df                	mov    %ebx,%edi
  802b39:	89 de                	mov    %ebx,%esi
  802b3b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  802b3d:	5b                   	pop    %ebx
  802b3e:	5e                   	pop    %esi
  802b3f:	5f                   	pop    %edi
  802b40:	5d                   	pop    %ebp
  802b41:	c3                   	ret    

00802b42 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  802b42:	55                   	push   %ebp
  802b43:	89 e5                	mov    %esp,%ebp
  802b45:	57                   	push   %edi
  802b46:	56                   	push   %esi
  802b47:	53                   	push   %ebx
	asm volatile("int %1\n"
  802b48:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b53:	b8 12 00 00 00       	mov    $0x12,%eax
  802b58:	89 df                	mov    %ebx,%edi
  802b5a:	89 de                	mov    %ebx,%esi
  802b5c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  802b5e:	5b                   	pop    %ebx
  802b5f:	5e                   	pop    %esi
  802b60:	5f                   	pop    %edi
  802b61:	5d                   	pop    %ebp
  802b62:	c3                   	ret    

00802b63 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  802b63:	55                   	push   %ebp
  802b64:	89 e5                	mov    %esp,%ebp
  802b66:	57                   	push   %edi
  802b67:	56                   	push   %esi
  802b68:	53                   	push   %ebx
  802b69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802b6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b71:	8b 55 08             	mov    0x8(%ebp),%edx
  802b74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b77:	b8 13 00 00 00       	mov    $0x13,%eax
  802b7c:	89 df                	mov    %ebx,%edi
  802b7e:	89 de                	mov    %ebx,%esi
  802b80:	cd 30                	int    $0x30
	if(check && ret > 0)
  802b82:	85 c0                	test   %eax,%eax
  802b84:	7f 08                	jg     802b8e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802b86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b89:	5b                   	pop    %ebx
  802b8a:	5e                   	pop    %esi
  802b8b:	5f                   	pop    %edi
  802b8c:	5d                   	pop    %ebp
  802b8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802b8e:	83 ec 0c             	sub    $0xc,%esp
  802b91:	50                   	push   %eax
  802b92:	6a 13                	push   $0x13
  802b94:	68 c8 4a 80 00       	push   $0x804ac8
  802b99:	6a 43                	push   $0x43
  802b9b:	68 e5 4a 80 00       	push   $0x804ae5
  802ba0:	e8 e4 f0 ff ff       	call   801c89 <_panic>

00802ba5 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  802ba5:	55                   	push   %ebp
  802ba6:	89 e5                	mov    %esp,%ebp
  802ba8:	57                   	push   %edi
  802ba9:	56                   	push   %esi
  802baa:	53                   	push   %ebx
	asm volatile("int %1\n"
  802bab:	b9 00 00 00 00       	mov    $0x0,%ecx
  802bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb3:	b8 14 00 00 00       	mov    $0x14,%eax
  802bb8:	89 cb                	mov    %ecx,%ebx
  802bba:	89 cf                	mov    %ecx,%edi
  802bbc:	89 ce                	mov    %ecx,%esi
  802bbe:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  802bc0:	5b                   	pop    %ebx
  802bc1:	5e                   	pop    %esi
  802bc2:	5f                   	pop    %edi
  802bc3:	5d                   	pop    %ebp
  802bc4:	c3                   	ret    

00802bc5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802bc5:	55                   	push   %ebp
  802bc6:	89 e5                	mov    %esp,%ebp
  802bc8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802bcb:	83 3d 54 a0 80 00 00 	cmpl   $0x0,0x80a054
  802bd2:	74 0a                	je     802bde <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	a3 54 a0 80 00       	mov    %eax,0x80a054
}
  802bdc:	c9                   	leave  
  802bdd:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	6a 07                	push   $0x7
  802be3:	68 00 f0 bf ee       	push   $0xeebff000
  802be8:	6a 00                	push   $0x0
  802bea:	e8 e1 fc ff ff       	call   8028d0 <sys_page_alloc>
		if(r < 0)
  802bef:	83 c4 10             	add    $0x10,%esp
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	78 2a                	js     802c20 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802bf6:	83 ec 08             	sub    $0x8,%esp
  802bf9:	68 34 2c 80 00       	push   $0x802c34
  802bfe:	6a 00                	push   $0x0
  802c00:	e8 16 fe ff ff       	call   802a1b <sys_env_set_pgfault_upcall>
		if(r < 0)
  802c05:	83 c4 10             	add    $0x10,%esp
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	79 c8                	jns    802bd4 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802c0c:	83 ec 04             	sub    $0x4,%esp
  802c0f:	68 24 4b 80 00       	push   $0x804b24
  802c14:	6a 25                	push   $0x25
  802c16:	68 5d 4b 80 00       	push   $0x804b5d
  802c1b:	e8 69 f0 ff ff       	call   801c89 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802c20:	83 ec 04             	sub    $0x4,%esp
  802c23:	68 f4 4a 80 00       	push   $0x804af4
  802c28:	6a 22                	push   $0x22
  802c2a:	68 5d 4b 80 00       	push   $0x804b5d
  802c2f:	e8 55 f0 ff ff       	call   801c89 <_panic>

00802c34 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c34:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c35:	a1 54 a0 80 00       	mov    0x80a054,%eax
	call *%eax
  802c3a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c3c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802c3f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802c43:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802c47:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802c4a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802c4c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802c50:	83 c4 08             	add    $0x8,%esp
	popal
  802c53:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802c54:	83 c4 04             	add    $0x4,%esp
	popfl
  802c57:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802c58:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802c59:	c3                   	ret    

00802c5a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c5a:	55                   	push   %ebp
  802c5b:	89 e5                	mov    %esp,%ebp
  802c5d:	56                   	push   %esi
  802c5e:	53                   	push   %ebx
  802c5f:	8b 75 08             	mov    0x8(%ebp),%esi
  802c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802c68:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802c6a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802c6f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802c72:	83 ec 0c             	sub    $0xc,%esp
  802c75:	50                   	push   %eax
  802c76:	e8 05 fe ff ff       	call   802a80 <sys_ipc_recv>
	if(ret < 0){
  802c7b:	83 c4 10             	add    $0x10,%esp
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	78 2b                	js     802cad <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802c82:	85 f6                	test   %esi,%esi
  802c84:	74 0a                	je     802c90 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802c86:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802c8b:	8b 40 78             	mov    0x78(%eax),%eax
  802c8e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802c90:	85 db                	test   %ebx,%ebx
  802c92:	74 0a                	je     802c9e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802c94:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802c99:	8b 40 7c             	mov    0x7c(%eax),%eax
  802c9c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802c9e:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802ca3:	8b 40 74             	mov    0x74(%eax),%eax
}
  802ca6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ca9:	5b                   	pop    %ebx
  802caa:	5e                   	pop    %esi
  802cab:	5d                   	pop    %ebp
  802cac:	c3                   	ret    
		if(from_env_store)
  802cad:	85 f6                	test   %esi,%esi
  802caf:	74 06                	je     802cb7 <ipc_recv+0x5d>
			*from_env_store = 0;
  802cb1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802cb7:	85 db                	test   %ebx,%ebx
  802cb9:	74 eb                	je     802ca6 <ipc_recv+0x4c>
			*perm_store = 0;
  802cbb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802cc1:	eb e3                	jmp    802ca6 <ipc_recv+0x4c>

00802cc3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802cc3:	55                   	push   %ebp
  802cc4:	89 e5                	mov    %esp,%ebp
  802cc6:	57                   	push   %edi
  802cc7:	56                   	push   %esi
  802cc8:	53                   	push   %ebx
  802cc9:	83 ec 0c             	sub    $0xc,%esp
  802ccc:	8b 7d 08             	mov    0x8(%ebp),%edi
  802ccf:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802cd5:	85 db                	test   %ebx,%ebx
  802cd7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802cdc:	0f 44 d8             	cmove  %eax,%ebx
  802cdf:	eb 05                	jmp    802ce6 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802ce1:	e8 cb fb ff ff       	call   8028b1 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802ce6:	ff 75 14             	pushl  0x14(%ebp)
  802ce9:	53                   	push   %ebx
  802cea:	56                   	push   %esi
  802ceb:	57                   	push   %edi
  802cec:	e8 6c fd ff ff       	call   802a5d <sys_ipc_try_send>
  802cf1:	83 c4 10             	add    $0x10,%esp
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	74 1b                	je     802d13 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802cf8:	79 e7                	jns    802ce1 <ipc_send+0x1e>
  802cfa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802cfd:	74 e2                	je     802ce1 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802cff:	83 ec 04             	sub    $0x4,%esp
  802d02:	68 6b 4b 80 00       	push   $0x804b6b
  802d07:	6a 46                	push   $0x46
  802d09:	68 80 4b 80 00       	push   $0x804b80
  802d0e:	e8 76 ef ff ff       	call   801c89 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d16:	5b                   	pop    %ebx
  802d17:	5e                   	pop    %esi
  802d18:	5f                   	pop    %edi
  802d19:	5d                   	pop    %ebp
  802d1a:	c3                   	ret    

00802d1b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d1b:	55                   	push   %ebp
  802d1c:	89 e5                	mov    %esp,%ebp
  802d1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d21:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d26:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802d2c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d32:	8b 52 50             	mov    0x50(%edx),%edx
  802d35:	39 ca                	cmp    %ecx,%edx
  802d37:	74 11                	je     802d4a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802d39:	83 c0 01             	add    $0x1,%eax
  802d3c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d41:	75 e3                	jne    802d26 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
  802d48:	eb 0e                	jmp    802d58 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802d4a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802d50:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802d55:	8b 40 48             	mov    0x48(%eax),%eax
}
  802d58:	5d                   	pop    %ebp
  802d59:	c3                   	ret    

00802d5a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802d5a:	55                   	push   %ebp
  802d5b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	05 00 00 00 30       	add    $0x30000000,%eax
  802d65:	c1 e8 0c             	shr    $0xc,%eax
}
  802d68:	5d                   	pop    %ebp
  802d69:	c3                   	ret    

00802d6a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802d6a:	55                   	push   %ebp
  802d6b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802d75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802d7a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802d7f:	5d                   	pop    %ebp
  802d80:	c3                   	ret    

00802d81 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802d81:	55                   	push   %ebp
  802d82:	89 e5                	mov    %esp,%ebp
  802d84:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802d89:	89 c2                	mov    %eax,%edx
  802d8b:	c1 ea 16             	shr    $0x16,%edx
  802d8e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802d95:	f6 c2 01             	test   $0x1,%dl
  802d98:	74 2d                	je     802dc7 <fd_alloc+0x46>
  802d9a:	89 c2                	mov    %eax,%edx
  802d9c:	c1 ea 0c             	shr    $0xc,%edx
  802d9f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802da6:	f6 c2 01             	test   $0x1,%dl
  802da9:	74 1c                	je     802dc7 <fd_alloc+0x46>
  802dab:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802db0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802db5:	75 d2                	jne    802d89 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802dc0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802dc5:	eb 0a                	jmp    802dd1 <fd_alloc+0x50>
			*fd_store = fd;
  802dc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dca:	89 01                	mov    %eax,(%ecx)
			return 0;
  802dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dd1:	5d                   	pop    %ebp
  802dd2:	c3                   	ret    

00802dd3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802dd3:	55                   	push   %ebp
  802dd4:	89 e5                	mov    %esp,%ebp
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802dd9:	83 f8 1f             	cmp    $0x1f,%eax
  802ddc:	77 30                	ja     802e0e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802dde:	c1 e0 0c             	shl    $0xc,%eax
  802de1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802de6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802dec:	f6 c2 01             	test   $0x1,%dl
  802def:	74 24                	je     802e15 <fd_lookup+0x42>
  802df1:	89 c2                	mov    %eax,%edx
  802df3:	c1 ea 0c             	shr    $0xc,%edx
  802df6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802dfd:	f6 c2 01             	test   $0x1,%dl
  802e00:	74 1a                	je     802e1c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e05:	89 02                	mov    %eax,(%edx)
	return 0;
  802e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0c:	5d                   	pop    %ebp
  802e0d:	c3                   	ret    
		return -E_INVAL;
  802e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e13:	eb f7                	jmp    802e0c <fd_lookup+0x39>
		return -E_INVAL;
  802e15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e1a:	eb f0                	jmp    802e0c <fd_lookup+0x39>
  802e1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e21:	eb e9                	jmp    802e0c <fd_lookup+0x39>

00802e23 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802e23:	55                   	push   %ebp
  802e24:	89 e5                	mov    %esp,%ebp
  802e26:	83 ec 08             	sub    $0x8,%esp
  802e29:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802e2c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e31:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802e36:	39 08                	cmp    %ecx,(%eax)
  802e38:	74 38                	je     802e72 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  802e3a:	83 c2 01             	add    $0x1,%edx
  802e3d:	8b 04 95 0c 4c 80 00 	mov    0x804c0c(,%edx,4),%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	75 ee                	jne    802e36 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802e48:	a1 50 a0 80 00       	mov    0x80a050,%eax
  802e4d:	8b 40 48             	mov    0x48(%eax),%eax
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	51                   	push   %ecx
  802e54:	50                   	push   %eax
  802e55:	68 8c 4b 80 00       	push   $0x804b8c
  802e5a:	e8 20 ef ff ff       	call   801d7f <cprintf>
	*dev = 0;
  802e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802e68:	83 c4 10             	add    $0x10,%esp
  802e6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802e70:	c9                   	leave  
  802e71:	c3                   	ret    
			*dev = devtab[i];
  802e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e75:	89 01                	mov    %eax,(%ecx)
			return 0;
  802e77:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7c:	eb f2                	jmp    802e70 <dev_lookup+0x4d>

00802e7e <fd_close>:
{
  802e7e:	55                   	push   %ebp
  802e7f:	89 e5                	mov    %esp,%ebp
  802e81:	57                   	push   %edi
  802e82:	56                   	push   %esi
  802e83:	53                   	push   %ebx
  802e84:	83 ec 24             	sub    $0x24,%esp
  802e87:	8b 75 08             	mov    0x8(%ebp),%esi
  802e8a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802e8d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802e90:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e91:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802e97:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802e9a:	50                   	push   %eax
  802e9b:	e8 33 ff ff ff       	call   802dd3 <fd_lookup>
  802ea0:	89 c3                	mov    %eax,%ebx
  802ea2:	83 c4 10             	add    $0x10,%esp
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	78 05                	js     802eae <fd_close+0x30>
	    || fd != fd2)
  802ea9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802eac:	74 16                	je     802ec4 <fd_close+0x46>
		return (must_exist ? r : 0);
  802eae:	89 f8                	mov    %edi,%eax
  802eb0:	84 c0                	test   %al,%al
  802eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb7:	0f 44 d8             	cmove  %eax,%ebx
}
  802eba:	89 d8                	mov    %ebx,%eax
  802ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ebf:	5b                   	pop    %ebx
  802ec0:	5e                   	pop    %esi
  802ec1:	5f                   	pop    %edi
  802ec2:	5d                   	pop    %ebp
  802ec3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802ec4:	83 ec 08             	sub    $0x8,%esp
  802ec7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802eca:	50                   	push   %eax
  802ecb:	ff 36                	pushl  (%esi)
  802ecd:	e8 51 ff ff ff       	call   802e23 <dev_lookup>
  802ed2:	89 c3                	mov    %eax,%ebx
  802ed4:	83 c4 10             	add    $0x10,%esp
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	78 1a                	js     802ef5 <fd_close+0x77>
		if (dev->dev_close)
  802edb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ede:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 0b                	je     802ef5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  802eea:	83 ec 0c             	sub    $0xc,%esp
  802eed:	56                   	push   %esi
  802eee:	ff d0                	call   *%eax
  802ef0:	89 c3                	mov    %eax,%ebx
  802ef2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802ef5:	83 ec 08             	sub    $0x8,%esp
  802ef8:	56                   	push   %esi
  802ef9:	6a 00                	push   $0x0
  802efb:	e8 55 fa ff ff       	call   802955 <sys_page_unmap>
	return r;
  802f00:	83 c4 10             	add    $0x10,%esp
  802f03:	eb b5                	jmp    802eba <fd_close+0x3c>

00802f05 <close>:

int
close(int fdnum)
{
  802f05:	55                   	push   %ebp
  802f06:	89 e5                	mov    %esp,%ebp
  802f08:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f0e:	50                   	push   %eax
  802f0f:	ff 75 08             	pushl  0x8(%ebp)
  802f12:	e8 bc fe ff ff       	call   802dd3 <fd_lookup>
  802f17:	83 c4 10             	add    $0x10,%esp
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	79 02                	jns    802f20 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  802f1e:	c9                   	leave  
  802f1f:	c3                   	ret    
		return fd_close(fd, 1);
  802f20:	83 ec 08             	sub    $0x8,%esp
  802f23:	6a 01                	push   $0x1
  802f25:	ff 75 f4             	pushl  -0xc(%ebp)
  802f28:	e8 51 ff ff ff       	call   802e7e <fd_close>
  802f2d:	83 c4 10             	add    $0x10,%esp
  802f30:	eb ec                	jmp    802f1e <close+0x19>

00802f32 <close_all>:

void
close_all(void)
{
  802f32:	55                   	push   %ebp
  802f33:	89 e5                	mov    %esp,%ebp
  802f35:	53                   	push   %ebx
  802f36:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802f39:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802f3e:	83 ec 0c             	sub    $0xc,%esp
  802f41:	53                   	push   %ebx
  802f42:	e8 be ff ff ff       	call   802f05 <close>
	for (i = 0; i < MAXFD; i++)
  802f47:	83 c3 01             	add    $0x1,%ebx
  802f4a:	83 c4 10             	add    $0x10,%esp
  802f4d:	83 fb 20             	cmp    $0x20,%ebx
  802f50:	75 ec                	jne    802f3e <close_all+0xc>
}
  802f52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f55:	c9                   	leave  
  802f56:	c3                   	ret    

00802f57 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802f57:	55                   	push   %ebp
  802f58:	89 e5                	mov    %esp,%ebp
  802f5a:	57                   	push   %edi
  802f5b:	56                   	push   %esi
  802f5c:	53                   	push   %ebx
  802f5d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802f60:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802f63:	50                   	push   %eax
  802f64:	ff 75 08             	pushl  0x8(%ebp)
  802f67:	e8 67 fe ff ff       	call   802dd3 <fd_lookup>
  802f6c:	89 c3                	mov    %eax,%ebx
  802f6e:	83 c4 10             	add    $0x10,%esp
  802f71:	85 c0                	test   %eax,%eax
  802f73:	0f 88 81 00 00 00    	js     802ffa <dup+0xa3>
		return r;
	close(newfdnum);
  802f79:	83 ec 0c             	sub    $0xc,%esp
  802f7c:	ff 75 0c             	pushl  0xc(%ebp)
  802f7f:	e8 81 ff ff ff       	call   802f05 <close>

	newfd = INDEX2FD(newfdnum);
  802f84:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f87:	c1 e6 0c             	shl    $0xc,%esi
  802f8a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802f90:	83 c4 04             	add    $0x4,%esp
  802f93:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f96:	e8 cf fd ff ff       	call   802d6a <fd2data>
  802f9b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802f9d:	89 34 24             	mov    %esi,(%esp)
  802fa0:	e8 c5 fd ff ff       	call   802d6a <fd2data>
  802fa5:	83 c4 10             	add    $0x10,%esp
  802fa8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802faa:	89 d8                	mov    %ebx,%eax
  802fac:	c1 e8 16             	shr    $0x16,%eax
  802faf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802fb6:	a8 01                	test   $0x1,%al
  802fb8:	74 11                	je     802fcb <dup+0x74>
  802fba:	89 d8                	mov    %ebx,%eax
  802fbc:	c1 e8 0c             	shr    $0xc,%eax
  802fbf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802fc6:	f6 c2 01             	test   $0x1,%dl
  802fc9:	75 39                	jne    803004 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802fcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fce:	89 d0                	mov    %edx,%eax
  802fd0:	c1 e8 0c             	shr    $0xc,%eax
  802fd3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802fda:	83 ec 0c             	sub    $0xc,%esp
  802fdd:	25 07 0e 00 00       	and    $0xe07,%eax
  802fe2:	50                   	push   %eax
  802fe3:	56                   	push   %esi
  802fe4:	6a 00                	push   $0x0
  802fe6:	52                   	push   %edx
  802fe7:	6a 00                	push   $0x0
  802fe9:	e8 25 f9 ff ff       	call   802913 <sys_page_map>
  802fee:	89 c3                	mov    %eax,%ebx
  802ff0:	83 c4 20             	add    $0x20,%esp
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	78 31                	js     803028 <dup+0xd1>
		goto err;

	return newfdnum;
  802ff7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802ffa:	89 d8                	mov    %ebx,%eax
  802ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802fff:	5b                   	pop    %ebx
  803000:	5e                   	pop    %esi
  803001:	5f                   	pop    %edi
  803002:	5d                   	pop    %ebp
  803003:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803004:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80300b:	83 ec 0c             	sub    $0xc,%esp
  80300e:	25 07 0e 00 00       	and    $0xe07,%eax
  803013:	50                   	push   %eax
  803014:	57                   	push   %edi
  803015:	6a 00                	push   $0x0
  803017:	53                   	push   %ebx
  803018:	6a 00                	push   $0x0
  80301a:	e8 f4 f8 ff ff       	call   802913 <sys_page_map>
  80301f:	89 c3                	mov    %eax,%ebx
  803021:	83 c4 20             	add    $0x20,%esp
  803024:	85 c0                	test   %eax,%eax
  803026:	79 a3                	jns    802fcb <dup+0x74>
	sys_page_unmap(0, newfd);
  803028:	83 ec 08             	sub    $0x8,%esp
  80302b:	56                   	push   %esi
  80302c:	6a 00                	push   $0x0
  80302e:	e8 22 f9 ff ff       	call   802955 <sys_page_unmap>
	sys_page_unmap(0, nva);
  803033:	83 c4 08             	add    $0x8,%esp
  803036:	57                   	push   %edi
  803037:	6a 00                	push   $0x0
  803039:	e8 17 f9 ff ff       	call   802955 <sys_page_unmap>
	return r;
  80303e:	83 c4 10             	add    $0x10,%esp
  803041:	eb b7                	jmp    802ffa <dup+0xa3>

00803043 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803043:	55                   	push   %ebp
  803044:	89 e5                	mov    %esp,%ebp
  803046:	53                   	push   %ebx
  803047:	83 ec 1c             	sub    $0x1c,%esp
  80304a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80304d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803050:	50                   	push   %eax
  803051:	53                   	push   %ebx
  803052:	e8 7c fd ff ff       	call   802dd3 <fd_lookup>
  803057:	83 c4 10             	add    $0x10,%esp
  80305a:	85 c0                	test   %eax,%eax
  80305c:	78 3f                	js     80309d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80305e:	83 ec 08             	sub    $0x8,%esp
  803061:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803064:	50                   	push   %eax
  803065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803068:	ff 30                	pushl  (%eax)
  80306a:	e8 b4 fd ff ff       	call   802e23 <dev_lookup>
  80306f:	83 c4 10             	add    $0x10,%esp
  803072:	85 c0                	test   %eax,%eax
  803074:	78 27                	js     80309d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803079:	8b 42 08             	mov    0x8(%edx),%eax
  80307c:	83 e0 03             	and    $0x3,%eax
  80307f:	83 f8 01             	cmp    $0x1,%eax
  803082:	74 1e                	je     8030a2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 40 08             	mov    0x8(%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 35                	je     8030c3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80308e:	83 ec 04             	sub    $0x4,%esp
  803091:	ff 75 10             	pushl  0x10(%ebp)
  803094:	ff 75 0c             	pushl  0xc(%ebp)
  803097:	52                   	push   %edx
  803098:	ff d0                	call   *%eax
  80309a:	83 c4 10             	add    $0x10,%esp
}
  80309d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030a0:	c9                   	leave  
  8030a1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8030a2:	a1 50 a0 80 00       	mov    0x80a050,%eax
  8030a7:	8b 40 48             	mov    0x48(%eax),%eax
  8030aa:	83 ec 04             	sub    $0x4,%esp
  8030ad:	53                   	push   %ebx
  8030ae:	50                   	push   %eax
  8030af:	68 d0 4b 80 00       	push   $0x804bd0
  8030b4:	e8 c6 ec ff ff       	call   801d7f <cprintf>
		return -E_INVAL;
  8030b9:	83 c4 10             	add    $0x10,%esp
  8030bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030c1:	eb da                	jmp    80309d <read+0x5a>
		return -E_NOT_SUPP;
  8030c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8030c8:	eb d3                	jmp    80309d <read+0x5a>

008030ca <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8030ca:	55                   	push   %ebp
  8030cb:	89 e5                	mov    %esp,%ebp
  8030cd:	57                   	push   %edi
  8030ce:	56                   	push   %esi
  8030cf:	53                   	push   %ebx
  8030d0:	83 ec 0c             	sub    $0xc,%esp
  8030d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8030d6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8030de:	39 f3                	cmp    %esi,%ebx
  8030e0:	73 23                	jae    803105 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8030e2:	83 ec 04             	sub    $0x4,%esp
  8030e5:	89 f0                	mov    %esi,%eax
  8030e7:	29 d8                	sub    %ebx,%eax
  8030e9:	50                   	push   %eax
  8030ea:	89 d8                	mov    %ebx,%eax
  8030ec:	03 45 0c             	add    0xc(%ebp),%eax
  8030ef:	50                   	push   %eax
  8030f0:	57                   	push   %edi
  8030f1:	e8 4d ff ff ff       	call   803043 <read>
		if (m < 0)
  8030f6:	83 c4 10             	add    $0x10,%esp
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	78 06                	js     803103 <readn+0x39>
			return m;
		if (m == 0)
  8030fd:	74 06                	je     803105 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8030ff:	01 c3                	add    %eax,%ebx
  803101:	eb db                	jmp    8030de <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803103:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  803105:	89 d8                	mov    %ebx,%eax
  803107:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80310a:	5b                   	pop    %ebx
  80310b:	5e                   	pop    %esi
  80310c:	5f                   	pop    %edi
  80310d:	5d                   	pop    %ebp
  80310e:	c3                   	ret    

0080310f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80310f:	55                   	push   %ebp
  803110:	89 e5                	mov    %esp,%ebp
  803112:	53                   	push   %ebx
  803113:	83 ec 1c             	sub    $0x1c,%esp
  803116:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803119:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80311c:	50                   	push   %eax
  80311d:	53                   	push   %ebx
  80311e:	e8 b0 fc ff ff       	call   802dd3 <fd_lookup>
  803123:	83 c4 10             	add    $0x10,%esp
  803126:	85 c0                	test   %eax,%eax
  803128:	78 3a                	js     803164 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80312a:	83 ec 08             	sub    $0x8,%esp
  80312d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803130:	50                   	push   %eax
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	ff 30                	pushl  (%eax)
  803136:	e8 e8 fc ff ff       	call   802e23 <dev_lookup>
  80313b:	83 c4 10             	add    $0x10,%esp
  80313e:	85 c0                	test   %eax,%eax
  803140:	78 22                	js     803164 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803145:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  803149:	74 1e                	je     803169 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80314b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314e:	8b 52 0c             	mov    0xc(%edx),%edx
  803151:	85 d2                	test   %edx,%edx
  803153:	74 35                	je     80318a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	ff 75 10             	pushl  0x10(%ebp)
  80315b:	ff 75 0c             	pushl  0xc(%ebp)
  80315e:	50                   	push   %eax
  80315f:	ff d2                	call   *%edx
  803161:	83 c4 10             	add    $0x10,%esp
}
  803164:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803167:	c9                   	leave  
  803168:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803169:	a1 50 a0 80 00       	mov    0x80a050,%eax
  80316e:	8b 40 48             	mov    0x48(%eax),%eax
  803171:	83 ec 04             	sub    $0x4,%esp
  803174:	53                   	push   %ebx
  803175:	50                   	push   %eax
  803176:	68 ec 4b 80 00       	push   $0x804bec
  80317b:	e8 ff eb ff ff       	call   801d7f <cprintf>
		return -E_INVAL;
  803180:	83 c4 10             	add    $0x10,%esp
  803183:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803188:	eb da                	jmp    803164 <write+0x55>
		return -E_NOT_SUPP;
  80318a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80318f:	eb d3                	jmp    803164 <write+0x55>

00803191 <seek>:

int
seek(int fdnum, off_t offset)
{
  803191:	55                   	push   %ebp
  803192:	89 e5                	mov    %esp,%ebp
  803194:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803197:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80319a:	50                   	push   %eax
  80319b:	ff 75 08             	pushl  0x8(%ebp)
  80319e:	e8 30 fc ff ff       	call   802dd3 <fd_lookup>
  8031a3:	83 c4 10             	add    $0x10,%esp
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	78 0e                	js     8031b8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8031aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8031b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b8:	c9                   	leave  
  8031b9:	c3                   	ret    

008031ba <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8031ba:	55                   	push   %ebp
  8031bb:	89 e5                	mov    %esp,%ebp
  8031bd:	53                   	push   %ebx
  8031be:	83 ec 1c             	sub    $0x1c,%esp
  8031c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031c7:	50                   	push   %eax
  8031c8:	53                   	push   %ebx
  8031c9:	e8 05 fc ff ff       	call   802dd3 <fd_lookup>
  8031ce:	83 c4 10             	add    $0x10,%esp
  8031d1:	85 c0                	test   %eax,%eax
  8031d3:	78 37                	js     80320c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031d5:	83 ec 08             	sub    $0x8,%esp
  8031d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031db:	50                   	push   %eax
  8031dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031df:	ff 30                	pushl  (%eax)
  8031e1:	e8 3d fc ff ff       	call   802e23 <dev_lookup>
  8031e6:	83 c4 10             	add    $0x10,%esp
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	78 1f                	js     80320c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8031f4:	74 1b                	je     803211 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8031f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f9:	8b 52 18             	mov    0x18(%edx),%edx
  8031fc:	85 d2                	test   %edx,%edx
  8031fe:	74 32                	je     803232 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  803200:	83 ec 08             	sub    $0x8,%esp
  803203:	ff 75 0c             	pushl  0xc(%ebp)
  803206:	50                   	push   %eax
  803207:	ff d2                	call   *%edx
  803209:	83 c4 10             	add    $0x10,%esp
}
  80320c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80320f:	c9                   	leave  
  803210:	c3                   	ret    
			thisenv->env_id, fdnum);
  803211:	a1 50 a0 80 00       	mov    0x80a050,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803216:	8b 40 48             	mov    0x48(%eax),%eax
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	53                   	push   %ebx
  80321d:	50                   	push   %eax
  80321e:	68 ac 4b 80 00       	push   $0x804bac
  803223:	e8 57 eb ff ff       	call   801d7f <cprintf>
		return -E_INVAL;
  803228:	83 c4 10             	add    $0x10,%esp
  80322b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803230:	eb da                	jmp    80320c <ftruncate+0x52>
		return -E_NOT_SUPP;
  803232:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803237:	eb d3                	jmp    80320c <ftruncate+0x52>

00803239 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	53                   	push   %ebx
  80323d:	83 ec 1c             	sub    $0x1c,%esp
  803240:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803243:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803246:	50                   	push   %eax
  803247:	ff 75 08             	pushl  0x8(%ebp)
  80324a:	e8 84 fb ff ff       	call   802dd3 <fd_lookup>
  80324f:	83 c4 10             	add    $0x10,%esp
  803252:	85 c0                	test   %eax,%eax
  803254:	78 4b                	js     8032a1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803256:	83 ec 08             	sub    $0x8,%esp
  803259:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80325c:	50                   	push   %eax
  80325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803260:	ff 30                	pushl  (%eax)
  803262:	e8 bc fb ff ff       	call   802e23 <dev_lookup>
  803267:	83 c4 10             	add    $0x10,%esp
  80326a:	85 c0                	test   %eax,%eax
  80326c:	78 33                	js     8032a1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  803275:	74 2f                	je     8032a6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  803277:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80327a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  803281:	00 00 00 
	stat->st_isdir = 0;
  803284:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80328b:	00 00 00 
	stat->st_dev = dev;
  80328e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  803294:	83 ec 08             	sub    $0x8,%esp
  803297:	53                   	push   %ebx
  803298:	ff 75 f0             	pushl  -0x10(%ebp)
  80329b:	ff 50 14             	call   *0x14(%eax)
  80329e:	83 c4 10             	add    $0x10,%esp
}
  8032a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032a4:	c9                   	leave  
  8032a5:	c3                   	ret    
		return -E_NOT_SUPP;
  8032a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8032ab:	eb f4                	jmp    8032a1 <fstat+0x68>

008032ad <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8032ad:	55                   	push   %ebp
  8032ae:	89 e5                	mov    %esp,%ebp
  8032b0:	56                   	push   %esi
  8032b1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8032b2:	83 ec 08             	sub    $0x8,%esp
  8032b5:	6a 00                	push   $0x0
  8032b7:	ff 75 08             	pushl  0x8(%ebp)
  8032ba:	e8 22 02 00 00       	call   8034e1 <open>
  8032bf:	89 c3                	mov    %eax,%ebx
  8032c1:	83 c4 10             	add    $0x10,%esp
  8032c4:	85 c0                	test   %eax,%eax
  8032c6:	78 1b                	js     8032e3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8032c8:	83 ec 08             	sub    $0x8,%esp
  8032cb:	ff 75 0c             	pushl  0xc(%ebp)
  8032ce:	50                   	push   %eax
  8032cf:	e8 65 ff ff ff       	call   803239 <fstat>
  8032d4:	89 c6                	mov    %eax,%esi
	close(fd);
  8032d6:	89 1c 24             	mov    %ebx,(%esp)
  8032d9:	e8 27 fc ff ff       	call   802f05 <close>
	return r;
  8032de:	83 c4 10             	add    $0x10,%esp
  8032e1:	89 f3                	mov    %esi,%ebx
}
  8032e3:	89 d8                	mov    %ebx,%eax
  8032e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032e8:	5b                   	pop    %ebx
  8032e9:	5e                   	pop    %esi
  8032ea:	5d                   	pop    %ebp
  8032eb:	c3                   	ret    

008032ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
  8032ef:	56                   	push   %esi
  8032f0:	53                   	push   %ebx
  8032f1:	89 c6                	mov    %eax,%esi
  8032f3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8032f5:	83 3d 40 a0 80 00 00 	cmpl   $0x0,0x80a040
  8032fc:	74 27                	je     803325 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8032fe:	6a 07                	push   $0x7
  803300:	68 00 b0 80 00       	push   $0x80b000
  803305:	56                   	push   %esi
  803306:	ff 35 40 a0 80 00    	pushl  0x80a040
  80330c:	e8 b2 f9 ff ff       	call   802cc3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  803311:	83 c4 0c             	add    $0xc,%esp
  803314:	6a 00                	push   $0x0
  803316:	53                   	push   %ebx
  803317:	6a 00                	push   $0x0
  803319:	e8 3c f9 ff ff       	call   802c5a <ipc_recv>
}
  80331e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803321:	5b                   	pop    %ebx
  803322:	5e                   	pop    %esi
  803323:	5d                   	pop    %ebp
  803324:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803325:	83 ec 0c             	sub    $0xc,%esp
  803328:	6a 01                	push   $0x1
  80332a:	e8 ec f9 ff ff       	call   802d1b <ipc_find_env>
  80332f:	a3 40 a0 80 00       	mov    %eax,0x80a040
  803334:	83 c4 10             	add    $0x10,%esp
  803337:	eb c5                	jmp    8032fe <fsipc+0x12>

00803339 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803339:	55                   	push   %ebp
  80333a:	89 e5                	mov    %esp,%ebp
  80333c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	8b 40 0c             	mov    0xc(%eax),%eax
  803345:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  80334a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334d:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803352:	ba 00 00 00 00       	mov    $0x0,%edx
  803357:	b8 02 00 00 00       	mov    $0x2,%eax
  80335c:	e8 8b ff ff ff       	call   8032ec <fsipc>
}
  803361:	c9                   	leave  
  803362:	c3                   	ret    

00803363 <devfile_flush>:
{
  803363:	55                   	push   %ebp
  803364:	89 e5                	mov    %esp,%ebp
  803366:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	8b 40 0c             	mov    0xc(%eax),%eax
  80336f:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803374:	ba 00 00 00 00       	mov    $0x0,%edx
  803379:	b8 06 00 00 00       	mov    $0x6,%eax
  80337e:	e8 69 ff ff ff       	call   8032ec <fsipc>
}
  803383:	c9                   	leave  
  803384:	c3                   	ret    

00803385 <devfile_stat>:
{
  803385:	55                   	push   %ebp
  803386:	89 e5                	mov    %esp,%ebp
  803388:	53                   	push   %ebx
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	8b 40 0c             	mov    0xc(%eax),%eax
  803395:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80339a:	ba 00 00 00 00       	mov    $0x0,%edx
  80339f:	b8 05 00 00 00       	mov    $0x5,%eax
  8033a4:	e8 43 ff ff ff       	call   8032ec <fsipc>
  8033a9:	85 c0                	test   %eax,%eax
  8033ab:	78 2c                	js     8033d9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033ad:	83 ec 08             	sub    $0x8,%esp
  8033b0:	68 00 b0 80 00       	push   $0x80b000
  8033b5:	53                   	push   %ebx
  8033b6:	e8 23 f1 ff ff       	call   8024de <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8033bb:	a1 80 b0 80 00       	mov    0x80b080,%eax
  8033c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033c6:	a1 84 b0 80 00       	mov    0x80b084,%eax
  8033cb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8033d1:	83 c4 10             	add    $0x10,%esp
  8033d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033dc:	c9                   	leave  
  8033dd:	c3                   	ret    

008033de <devfile_write>:
{
  8033de:	55                   	push   %ebp
  8033df:	89 e5                	mov    %esp,%ebp
  8033e1:	53                   	push   %ebx
  8033e2:	83 ec 08             	sub    $0x8,%esp
  8033e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ee:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  8033f3:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8033f9:	53                   	push   %ebx
  8033fa:	ff 75 0c             	pushl  0xc(%ebp)
  8033fd:	68 08 b0 80 00       	push   $0x80b008
  803402:	e8 c7 f2 ff ff       	call   8026ce <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803407:	ba 00 00 00 00       	mov    $0x0,%edx
  80340c:	b8 04 00 00 00       	mov    $0x4,%eax
  803411:	e8 d6 fe ff ff       	call   8032ec <fsipc>
  803416:	83 c4 10             	add    $0x10,%esp
  803419:	85 c0                	test   %eax,%eax
  80341b:	78 0b                	js     803428 <devfile_write+0x4a>
	assert(r <= n);
  80341d:	39 d8                	cmp    %ebx,%eax
  80341f:	77 0c                	ja     80342d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  803421:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803426:	7f 1e                	jg     803446 <devfile_write+0x68>
}
  803428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80342b:	c9                   	leave  
  80342c:	c3                   	ret    
	assert(r <= n);
  80342d:	68 20 4c 80 00       	push   $0x804c20
  803432:	68 7d 41 80 00       	push   $0x80417d
  803437:	68 98 00 00 00       	push   $0x98
  80343c:	68 27 4c 80 00       	push   $0x804c27
  803441:	e8 43 e8 ff ff       	call   801c89 <_panic>
	assert(r <= PGSIZE);
  803446:	68 32 4c 80 00       	push   $0x804c32
  80344b:	68 7d 41 80 00       	push   $0x80417d
  803450:	68 99 00 00 00       	push   $0x99
  803455:	68 27 4c 80 00       	push   $0x804c27
  80345a:	e8 2a e8 ff ff       	call   801c89 <_panic>

0080345f <devfile_read>:
{
  80345f:	55                   	push   %ebp
  803460:	89 e5                	mov    %esp,%ebp
  803462:	56                   	push   %esi
  803463:	53                   	push   %ebx
  803464:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	8b 40 0c             	mov    0xc(%eax),%eax
  80346d:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803472:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803478:	ba 00 00 00 00       	mov    $0x0,%edx
  80347d:	b8 03 00 00 00       	mov    $0x3,%eax
  803482:	e8 65 fe ff ff       	call   8032ec <fsipc>
  803487:	89 c3                	mov    %eax,%ebx
  803489:	85 c0                	test   %eax,%eax
  80348b:	78 1f                	js     8034ac <devfile_read+0x4d>
	assert(r <= n);
  80348d:	39 f0                	cmp    %esi,%eax
  80348f:	77 24                	ja     8034b5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  803491:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803496:	7f 33                	jg     8034cb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	50                   	push   %eax
  80349c:	68 00 b0 80 00       	push   $0x80b000
  8034a1:	ff 75 0c             	pushl  0xc(%ebp)
  8034a4:	e8 c3 f1 ff ff       	call   80266c <memmove>
	return r;
  8034a9:	83 c4 10             	add    $0x10,%esp
}
  8034ac:	89 d8                	mov    %ebx,%eax
  8034ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034b1:	5b                   	pop    %ebx
  8034b2:	5e                   	pop    %esi
  8034b3:	5d                   	pop    %ebp
  8034b4:	c3                   	ret    
	assert(r <= n);
  8034b5:	68 20 4c 80 00       	push   $0x804c20
  8034ba:	68 7d 41 80 00       	push   $0x80417d
  8034bf:	6a 7c                	push   $0x7c
  8034c1:	68 27 4c 80 00       	push   $0x804c27
  8034c6:	e8 be e7 ff ff       	call   801c89 <_panic>
	assert(r <= PGSIZE);
  8034cb:	68 32 4c 80 00       	push   $0x804c32
  8034d0:	68 7d 41 80 00       	push   $0x80417d
  8034d5:	6a 7d                	push   $0x7d
  8034d7:	68 27 4c 80 00       	push   $0x804c27
  8034dc:	e8 a8 e7 ff ff       	call   801c89 <_panic>

008034e1 <open>:
{
  8034e1:	55                   	push   %ebp
  8034e2:	89 e5                	mov    %esp,%ebp
  8034e4:	56                   	push   %esi
  8034e5:	53                   	push   %ebx
  8034e6:	83 ec 1c             	sub    $0x1c,%esp
  8034e9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8034ec:	56                   	push   %esi
  8034ed:	e8 b3 ef ff ff       	call   8024a5 <strlen>
  8034f2:	83 c4 10             	add    $0x10,%esp
  8034f5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034fa:	7f 6c                	jg     803568 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8034fc:	83 ec 0c             	sub    $0xc,%esp
  8034ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803502:	50                   	push   %eax
  803503:	e8 79 f8 ff ff       	call   802d81 <fd_alloc>
  803508:	89 c3                	mov    %eax,%ebx
  80350a:	83 c4 10             	add    $0x10,%esp
  80350d:	85 c0                	test   %eax,%eax
  80350f:	78 3c                	js     80354d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  803511:	83 ec 08             	sub    $0x8,%esp
  803514:	56                   	push   %esi
  803515:	68 00 b0 80 00       	push   $0x80b000
  80351a:	e8 bf ef ff ff       	call   8024de <strcpy>
	fsipcbuf.open.req_omode = mode;
  80351f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803522:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803527:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352a:	b8 01 00 00 00       	mov    $0x1,%eax
  80352f:	e8 b8 fd ff ff       	call   8032ec <fsipc>
  803534:	89 c3                	mov    %eax,%ebx
  803536:	83 c4 10             	add    $0x10,%esp
  803539:	85 c0                	test   %eax,%eax
  80353b:	78 19                	js     803556 <open+0x75>
	return fd2num(fd);
  80353d:	83 ec 0c             	sub    $0xc,%esp
  803540:	ff 75 f4             	pushl  -0xc(%ebp)
  803543:	e8 12 f8 ff ff       	call   802d5a <fd2num>
  803548:	89 c3                	mov    %eax,%ebx
  80354a:	83 c4 10             	add    $0x10,%esp
}
  80354d:	89 d8                	mov    %ebx,%eax
  80354f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803552:	5b                   	pop    %ebx
  803553:	5e                   	pop    %esi
  803554:	5d                   	pop    %ebp
  803555:	c3                   	ret    
		fd_close(fd, 0);
  803556:	83 ec 08             	sub    $0x8,%esp
  803559:	6a 00                	push   $0x0
  80355b:	ff 75 f4             	pushl  -0xc(%ebp)
  80355e:	e8 1b f9 ff ff       	call   802e7e <fd_close>
		return r;
  803563:	83 c4 10             	add    $0x10,%esp
  803566:	eb e5                	jmp    80354d <open+0x6c>
		return -E_BAD_PATH;
  803568:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80356d:	eb de                	jmp    80354d <open+0x6c>

0080356f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80356f:	55                   	push   %ebp
  803570:	89 e5                	mov    %esp,%ebp
  803572:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803575:	ba 00 00 00 00       	mov    $0x0,%edx
  80357a:	b8 08 00 00 00       	mov    $0x8,%eax
  80357f:	e8 68 fd ff ff       	call   8032ec <fsipc>
}
  803584:	c9                   	leave  
  803585:	c3                   	ret    

00803586 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803586:	55                   	push   %ebp
  803587:	89 e5                	mov    %esp,%ebp
  803589:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80358c:	89 d0                	mov    %edx,%eax
  80358e:	c1 e8 16             	shr    $0x16,%eax
  803591:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803598:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80359d:	f6 c1 01             	test   $0x1,%cl
  8035a0:	74 1d                	je     8035bf <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8035a2:	c1 ea 0c             	shr    $0xc,%edx
  8035a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8035ac:	f6 c2 01             	test   $0x1,%dl
  8035af:	74 0e                	je     8035bf <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8035b1:	c1 ea 0c             	shr    $0xc,%edx
  8035b4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8035bb:	ef 
  8035bc:	0f b7 c0             	movzwl %ax,%eax
}
  8035bf:	5d                   	pop    %ebp
  8035c0:	c3                   	ret    

008035c1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035c1:	55                   	push   %ebp
  8035c2:	89 e5                	mov    %esp,%ebp
  8035c4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8035c7:	68 3e 4c 80 00       	push   $0x804c3e
  8035cc:	ff 75 0c             	pushl  0xc(%ebp)
  8035cf:	e8 0a ef ff ff       	call   8024de <strcpy>
	return 0;
}
  8035d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d9:	c9                   	leave  
  8035da:	c3                   	ret    

008035db <devsock_close>:
{
  8035db:	55                   	push   %ebp
  8035dc:	89 e5                	mov    %esp,%ebp
  8035de:	53                   	push   %ebx
  8035df:	83 ec 10             	sub    $0x10,%esp
  8035e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8035e5:	53                   	push   %ebx
  8035e6:	e8 9b ff ff ff       	call   803586 <pageref>
  8035eb:	83 c4 10             	add    $0x10,%esp
		return 0;
  8035ee:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8035f3:	83 f8 01             	cmp    $0x1,%eax
  8035f6:	74 07                	je     8035ff <devsock_close+0x24>
}
  8035f8:	89 d0                	mov    %edx,%eax
  8035fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035fd:	c9                   	leave  
  8035fe:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8035ff:	83 ec 0c             	sub    $0xc,%esp
  803602:	ff 73 0c             	pushl  0xc(%ebx)
  803605:	e8 b9 02 00 00       	call   8038c3 <nsipc_close>
  80360a:	89 c2                	mov    %eax,%edx
  80360c:	83 c4 10             	add    $0x10,%esp
  80360f:	eb e7                	jmp    8035f8 <devsock_close+0x1d>

00803611 <devsock_write>:
{
  803611:	55                   	push   %ebp
  803612:	89 e5                	mov    %esp,%ebp
  803614:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803617:	6a 00                	push   $0x0
  803619:	ff 75 10             	pushl  0x10(%ebp)
  80361c:	ff 75 0c             	pushl  0xc(%ebp)
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	ff 70 0c             	pushl  0xc(%eax)
  803625:	e8 76 03 00 00       	call   8039a0 <nsipc_send>
}
  80362a:	c9                   	leave  
  80362b:	c3                   	ret    

0080362c <devsock_read>:
{
  80362c:	55                   	push   %ebp
  80362d:	89 e5                	mov    %esp,%ebp
  80362f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803632:	6a 00                	push   $0x0
  803634:	ff 75 10             	pushl  0x10(%ebp)
  803637:	ff 75 0c             	pushl  0xc(%ebp)
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	ff 70 0c             	pushl  0xc(%eax)
  803640:	e8 ef 02 00 00       	call   803934 <nsipc_recv>
}
  803645:	c9                   	leave  
  803646:	c3                   	ret    

00803647 <fd2sockid>:
{
  803647:	55                   	push   %ebp
  803648:	89 e5                	mov    %esp,%ebp
  80364a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80364d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803650:	52                   	push   %edx
  803651:	50                   	push   %eax
  803652:	e8 7c f7 ff ff       	call   802dd3 <fd_lookup>
  803657:	83 c4 10             	add    $0x10,%esp
  80365a:	85 c0                	test   %eax,%eax
  80365c:	78 10                	js     80366e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80365e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803661:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  803667:	39 08                	cmp    %ecx,(%eax)
  803669:	75 05                	jne    803670 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80366b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80366e:	c9                   	leave  
  80366f:	c3                   	ret    
		return -E_NOT_SUPP;
  803670:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803675:	eb f7                	jmp    80366e <fd2sockid+0x27>

00803677 <alloc_sockfd>:
{
  803677:	55                   	push   %ebp
  803678:	89 e5                	mov    %esp,%ebp
  80367a:	56                   	push   %esi
  80367b:	53                   	push   %ebx
  80367c:	83 ec 1c             	sub    $0x1c,%esp
  80367f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  803681:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803684:	50                   	push   %eax
  803685:	e8 f7 f6 ff ff       	call   802d81 <fd_alloc>
  80368a:	89 c3                	mov    %eax,%ebx
  80368c:	83 c4 10             	add    $0x10,%esp
  80368f:	85 c0                	test   %eax,%eax
  803691:	78 43                	js     8036d6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803693:	83 ec 04             	sub    $0x4,%esp
  803696:	68 07 04 00 00       	push   $0x407
  80369b:	ff 75 f4             	pushl  -0xc(%ebp)
  80369e:	6a 00                	push   $0x0
  8036a0:	e8 2b f2 ff ff       	call   8028d0 <sys_page_alloc>
  8036a5:	89 c3                	mov    %eax,%ebx
  8036a7:	83 c4 10             	add    $0x10,%esp
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	78 28                	js     8036d6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8036b7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8036b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8036c3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8036c6:	83 ec 0c             	sub    $0xc,%esp
  8036c9:	50                   	push   %eax
  8036ca:	e8 8b f6 ff ff       	call   802d5a <fd2num>
  8036cf:	89 c3                	mov    %eax,%ebx
  8036d1:	83 c4 10             	add    $0x10,%esp
  8036d4:	eb 0c                	jmp    8036e2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8036d6:	83 ec 0c             	sub    $0xc,%esp
  8036d9:	56                   	push   %esi
  8036da:	e8 e4 01 00 00       	call   8038c3 <nsipc_close>
		return r;
  8036df:	83 c4 10             	add    $0x10,%esp
}
  8036e2:	89 d8                	mov    %ebx,%eax
  8036e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8036e7:	5b                   	pop    %ebx
  8036e8:	5e                   	pop    %esi
  8036e9:	5d                   	pop    %ebp
  8036ea:	c3                   	ret    

008036eb <accept>:
{
  8036eb:	55                   	push   %ebp
  8036ec:	89 e5                	mov    %esp,%ebp
  8036ee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f4:	e8 4e ff ff ff       	call   803647 <fd2sockid>
  8036f9:	85 c0                	test   %eax,%eax
  8036fb:	78 1b                	js     803718 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8036fd:	83 ec 04             	sub    $0x4,%esp
  803700:	ff 75 10             	pushl  0x10(%ebp)
  803703:	ff 75 0c             	pushl  0xc(%ebp)
  803706:	50                   	push   %eax
  803707:	e8 0e 01 00 00       	call   80381a <nsipc_accept>
  80370c:	83 c4 10             	add    $0x10,%esp
  80370f:	85 c0                	test   %eax,%eax
  803711:	78 05                	js     803718 <accept+0x2d>
	return alloc_sockfd(r);
  803713:	e8 5f ff ff ff       	call   803677 <alloc_sockfd>
}
  803718:	c9                   	leave  
  803719:	c3                   	ret    

0080371a <bind>:
{
  80371a:	55                   	push   %ebp
  80371b:	89 e5                	mov    %esp,%ebp
  80371d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	e8 1f ff ff ff       	call   803647 <fd2sockid>
  803728:	85 c0                	test   %eax,%eax
  80372a:	78 12                	js     80373e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80372c:	83 ec 04             	sub    $0x4,%esp
  80372f:	ff 75 10             	pushl  0x10(%ebp)
  803732:	ff 75 0c             	pushl  0xc(%ebp)
  803735:	50                   	push   %eax
  803736:	e8 31 01 00 00       	call   80386c <nsipc_bind>
  80373b:	83 c4 10             	add    $0x10,%esp
}
  80373e:	c9                   	leave  
  80373f:	c3                   	ret    

00803740 <shutdown>:
{
  803740:	55                   	push   %ebp
  803741:	89 e5                	mov    %esp,%ebp
  803743:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	e8 f9 fe ff ff       	call   803647 <fd2sockid>
  80374e:	85 c0                	test   %eax,%eax
  803750:	78 0f                	js     803761 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  803752:	83 ec 08             	sub    $0x8,%esp
  803755:	ff 75 0c             	pushl  0xc(%ebp)
  803758:	50                   	push   %eax
  803759:	e8 43 01 00 00       	call   8038a1 <nsipc_shutdown>
  80375e:	83 c4 10             	add    $0x10,%esp
}
  803761:	c9                   	leave  
  803762:	c3                   	ret    

00803763 <connect>:
{
  803763:	55                   	push   %ebp
  803764:	89 e5                	mov    %esp,%ebp
  803766:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	e8 d6 fe ff ff       	call   803647 <fd2sockid>
  803771:	85 c0                	test   %eax,%eax
  803773:	78 12                	js     803787 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  803775:	83 ec 04             	sub    $0x4,%esp
  803778:	ff 75 10             	pushl  0x10(%ebp)
  80377b:	ff 75 0c             	pushl  0xc(%ebp)
  80377e:	50                   	push   %eax
  80377f:	e8 59 01 00 00       	call   8038dd <nsipc_connect>
  803784:	83 c4 10             	add    $0x10,%esp
}
  803787:	c9                   	leave  
  803788:	c3                   	ret    

00803789 <listen>:
{
  803789:	55                   	push   %ebp
  80378a:	89 e5                	mov    %esp,%ebp
  80378c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	e8 b0 fe ff ff       	call   803647 <fd2sockid>
  803797:	85 c0                	test   %eax,%eax
  803799:	78 0f                	js     8037aa <listen+0x21>
	return nsipc_listen(r, backlog);
  80379b:	83 ec 08             	sub    $0x8,%esp
  80379e:	ff 75 0c             	pushl  0xc(%ebp)
  8037a1:	50                   	push   %eax
  8037a2:	e8 6b 01 00 00       	call   803912 <nsipc_listen>
  8037a7:	83 c4 10             	add    $0x10,%esp
}
  8037aa:	c9                   	leave  
  8037ab:	c3                   	ret    

008037ac <socket>:

int
socket(int domain, int type, int protocol)
{
  8037ac:	55                   	push   %ebp
  8037ad:	89 e5                	mov    %esp,%ebp
  8037af:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037b2:	ff 75 10             	pushl  0x10(%ebp)
  8037b5:	ff 75 0c             	pushl  0xc(%ebp)
  8037b8:	ff 75 08             	pushl  0x8(%ebp)
  8037bb:	e8 3e 02 00 00       	call   8039fe <nsipc_socket>
  8037c0:	83 c4 10             	add    $0x10,%esp
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	78 05                	js     8037cc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8037c7:	e8 ab fe ff ff       	call   803677 <alloc_sockfd>
}
  8037cc:	c9                   	leave  
  8037cd:	c3                   	ret    

008037ce <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8037ce:	55                   	push   %ebp
  8037cf:	89 e5                	mov    %esp,%ebp
  8037d1:	53                   	push   %ebx
  8037d2:	83 ec 04             	sub    $0x4,%esp
  8037d5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8037d7:	83 3d 44 a0 80 00 00 	cmpl   $0x0,0x80a044
  8037de:	74 26                	je     803806 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8037e0:	6a 07                	push   $0x7
  8037e2:	68 00 c0 80 00       	push   $0x80c000
  8037e7:	53                   	push   %ebx
  8037e8:	ff 35 44 a0 80 00    	pushl  0x80a044
  8037ee:	e8 d0 f4 ff ff       	call   802cc3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8037f3:	83 c4 0c             	add    $0xc,%esp
  8037f6:	6a 00                	push   $0x0
  8037f8:	6a 00                	push   $0x0
  8037fa:	6a 00                	push   $0x0
  8037fc:	e8 59 f4 ff ff       	call   802c5a <ipc_recv>
}
  803801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803804:	c9                   	leave  
  803805:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803806:	83 ec 0c             	sub    $0xc,%esp
  803809:	6a 02                	push   $0x2
  80380b:	e8 0b f5 ff ff       	call   802d1b <ipc_find_env>
  803810:	a3 44 a0 80 00       	mov    %eax,0x80a044
  803815:	83 c4 10             	add    $0x10,%esp
  803818:	eb c6                	jmp    8037e0 <nsipc+0x12>

0080381a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80381a:	55                   	push   %ebp
  80381b:	89 e5                	mov    %esp,%ebp
  80381d:	56                   	push   %esi
  80381e:	53                   	push   %ebx
  80381f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803822:	8b 45 08             	mov    0x8(%ebp),%eax
  803825:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80382a:	8b 06                	mov    (%esi),%eax
  80382c:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803831:	b8 01 00 00 00       	mov    $0x1,%eax
  803836:	e8 93 ff ff ff       	call   8037ce <nsipc>
  80383b:	89 c3                	mov    %eax,%ebx
  80383d:	85 c0                	test   %eax,%eax
  80383f:	79 09                	jns    80384a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  803841:	89 d8                	mov    %ebx,%eax
  803843:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803846:	5b                   	pop    %ebx
  803847:	5e                   	pop    %esi
  803848:	5d                   	pop    %ebp
  803849:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80384a:	83 ec 04             	sub    $0x4,%esp
  80384d:	ff 35 10 c0 80 00    	pushl  0x80c010
  803853:	68 00 c0 80 00       	push   $0x80c000
  803858:	ff 75 0c             	pushl  0xc(%ebp)
  80385b:	e8 0c ee ff ff       	call   80266c <memmove>
		*addrlen = ret->ret_addrlen;
  803860:	a1 10 c0 80 00       	mov    0x80c010,%eax
  803865:	89 06                	mov    %eax,(%esi)
  803867:	83 c4 10             	add    $0x10,%esp
	return r;
  80386a:	eb d5                	jmp    803841 <nsipc_accept+0x27>

0080386c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80386c:	55                   	push   %ebp
  80386d:	89 e5                	mov    %esp,%ebp
  80386f:	53                   	push   %ebx
  803870:	83 ec 08             	sub    $0x8,%esp
  803873:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803876:	8b 45 08             	mov    0x8(%ebp),%eax
  803879:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80387e:	53                   	push   %ebx
  80387f:	ff 75 0c             	pushl  0xc(%ebp)
  803882:	68 04 c0 80 00       	push   $0x80c004
  803887:	e8 e0 ed ff ff       	call   80266c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80388c:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  803892:	b8 02 00 00 00       	mov    $0x2,%eax
  803897:	e8 32 ff ff ff       	call   8037ce <nsipc>
}
  80389c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80389f:	c9                   	leave  
  8038a0:	c3                   	ret    

008038a1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8038a1:	55                   	push   %ebp
  8038a2:	89 e5                	mov    %esp,%ebp
  8038a4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8038a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038aa:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  8038af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b2:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  8038b7:	b8 03 00 00 00       	mov    $0x3,%eax
  8038bc:	e8 0d ff ff ff       	call   8037ce <nsipc>
}
  8038c1:	c9                   	leave  
  8038c2:	c3                   	ret    

008038c3 <nsipc_close>:

int
nsipc_close(int s)
{
  8038c3:	55                   	push   %ebp
  8038c4:	89 e5                	mov    %esp,%ebp
  8038c6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  8038d1:	b8 04 00 00 00       	mov    $0x4,%eax
  8038d6:	e8 f3 fe ff ff       	call   8037ce <nsipc>
}
  8038db:	c9                   	leave  
  8038dc:	c3                   	ret    

008038dd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038dd:	55                   	push   %ebp
  8038de:	89 e5                	mov    %esp,%ebp
  8038e0:	53                   	push   %ebx
  8038e1:	83 ec 08             	sub    $0x8,%esp
  8038e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8038ef:	53                   	push   %ebx
  8038f0:	ff 75 0c             	pushl  0xc(%ebp)
  8038f3:	68 04 c0 80 00       	push   $0x80c004
  8038f8:	e8 6f ed ff ff       	call   80266c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8038fd:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803903:	b8 05 00 00 00       	mov    $0x5,%eax
  803908:	e8 c1 fe ff ff       	call   8037ce <nsipc>
}
  80390d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803910:	c9                   	leave  
  803911:	c3                   	ret    

00803912 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803912:	55                   	push   %ebp
  803913:	89 e5                	mov    %esp,%ebp
  803915:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803918:	8b 45 08             	mov    0x8(%ebp),%eax
  80391b:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  803920:	8b 45 0c             	mov    0xc(%ebp),%eax
  803923:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  803928:	b8 06 00 00 00       	mov    $0x6,%eax
  80392d:	e8 9c fe ff ff       	call   8037ce <nsipc>
}
  803932:	c9                   	leave  
  803933:	c3                   	ret    

00803934 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803934:	55                   	push   %ebp
  803935:	89 e5                	mov    %esp,%ebp
  803937:	56                   	push   %esi
  803938:	53                   	push   %ebx
  803939:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80393c:	8b 45 08             	mov    0x8(%ebp),%eax
  80393f:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  803944:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  80394a:	8b 45 14             	mov    0x14(%ebp),%eax
  80394d:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803952:	b8 07 00 00 00       	mov    $0x7,%eax
  803957:	e8 72 fe ff ff       	call   8037ce <nsipc>
  80395c:	89 c3                	mov    %eax,%ebx
  80395e:	85 c0                	test   %eax,%eax
  803960:	78 1f                	js     803981 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  803962:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803967:	7f 21                	jg     80398a <nsipc_recv+0x56>
  803969:	39 c6                	cmp    %eax,%esi
  80396b:	7c 1d                	jl     80398a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80396d:	83 ec 04             	sub    $0x4,%esp
  803970:	50                   	push   %eax
  803971:	68 00 c0 80 00       	push   $0x80c000
  803976:	ff 75 0c             	pushl  0xc(%ebp)
  803979:	e8 ee ec ff ff       	call   80266c <memmove>
  80397e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803981:	89 d8                	mov    %ebx,%eax
  803983:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803986:	5b                   	pop    %ebx
  803987:	5e                   	pop    %esi
  803988:	5d                   	pop    %ebp
  803989:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80398a:	68 4a 4c 80 00       	push   $0x804c4a
  80398f:	68 7d 41 80 00       	push   $0x80417d
  803994:	6a 62                	push   $0x62
  803996:	68 5f 4c 80 00       	push   $0x804c5f
  80399b:	e8 e9 e2 ff ff       	call   801c89 <_panic>

008039a0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8039a0:	55                   	push   %ebp
  8039a1:	89 e5                	mov    %esp,%ebp
  8039a3:	53                   	push   %ebx
  8039a4:	83 ec 04             	sub    $0x4,%esp
  8039a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8039aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ad:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  8039b2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8039b8:	7f 2e                	jg     8039e8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8039ba:	83 ec 04             	sub    $0x4,%esp
  8039bd:	53                   	push   %ebx
  8039be:	ff 75 0c             	pushl  0xc(%ebp)
  8039c1:	68 0c c0 80 00       	push   $0x80c00c
  8039c6:	e8 a1 ec ff ff       	call   80266c <memmove>
	nsipcbuf.send.req_size = size;
  8039cb:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  8039d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8039d4:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  8039d9:	b8 08 00 00 00       	mov    $0x8,%eax
  8039de:	e8 eb fd ff ff       	call   8037ce <nsipc>
}
  8039e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039e6:	c9                   	leave  
  8039e7:	c3                   	ret    
	assert(size < 1600);
  8039e8:	68 6b 4c 80 00       	push   $0x804c6b
  8039ed:	68 7d 41 80 00       	push   $0x80417d
  8039f2:	6a 6d                	push   $0x6d
  8039f4:	68 5f 4c 80 00       	push   $0x804c5f
  8039f9:	e8 8b e2 ff ff       	call   801c89 <_panic>

008039fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039fe:	55                   	push   %ebp
  8039ff:	89 e5                	mov    %esp,%ebp
  803a01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803a04:	8b 45 08             	mov    0x8(%ebp),%eax
  803a07:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a0f:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803a14:	8b 45 10             	mov    0x10(%ebp),%eax
  803a17:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803a1c:	b8 09 00 00 00       	mov    $0x9,%eax
  803a21:	e8 a8 fd ff ff       	call   8037ce <nsipc>
}
  803a26:	c9                   	leave  
  803a27:	c3                   	ret    

00803a28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a28:	55                   	push   %ebp
  803a29:	89 e5                	mov    %esp,%ebp
  803a2b:	56                   	push   %esi
  803a2c:	53                   	push   %ebx
  803a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a30:	83 ec 0c             	sub    $0xc,%esp
  803a33:	ff 75 08             	pushl  0x8(%ebp)
  803a36:	e8 2f f3 ff ff       	call   802d6a <fd2data>
  803a3b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803a3d:	83 c4 08             	add    $0x8,%esp
  803a40:	68 77 4c 80 00       	push   $0x804c77
  803a45:	53                   	push   %ebx
  803a46:	e8 93 ea ff ff       	call   8024de <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803a4b:	8b 46 04             	mov    0x4(%esi),%eax
  803a4e:	2b 06                	sub    (%esi),%eax
  803a50:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803a56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803a5d:	00 00 00 
	stat->st_dev = &devpipe;
  803a60:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  803a67:	90 80 00 
	return 0;
}
  803a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803a72:	5b                   	pop    %ebx
  803a73:	5e                   	pop    %esi
  803a74:	5d                   	pop    %ebp
  803a75:	c3                   	ret    

00803a76 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a76:	55                   	push   %ebp
  803a77:	89 e5                	mov    %esp,%ebp
  803a79:	53                   	push   %ebx
  803a7a:	83 ec 0c             	sub    $0xc,%esp
  803a7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803a80:	53                   	push   %ebx
  803a81:	6a 00                	push   $0x0
  803a83:	e8 cd ee ff ff       	call   802955 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803a88:	89 1c 24             	mov    %ebx,(%esp)
  803a8b:	e8 da f2 ff ff       	call   802d6a <fd2data>
  803a90:	83 c4 08             	add    $0x8,%esp
  803a93:	50                   	push   %eax
  803a94:	6a 00                	push   $0x0
  803a96:	e8 ba ee ff ff       	call   802955 <sys_page_unmap>
}
  803a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a9e:	c9                   	leave  
  803a9f:	c3                   	ret    

00803aa0 <_pipeisclosed>:
{
  803aa0:	55                   	push   %ebp
  803aa1:	89 e5                	mov    %esp,%ebp
  803aa3:	57                   	push   %edi
  803aa4:	56                   	push   %esi
  803aa5:	53                   	push   %ebx
  803aa6:	83 ec 1c             	sub    $0x1c,%esp
  803aa9:	89 c7                	mov    %eax,%edi
  803aab:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803aad:	a1 50 a0 80 00       	mov    0x80a050,%eax
  803ab2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803ab5:	83 ec 0c             	sub    $0xc,%esp
  803ab8:	57                   	push   %edi
  803ab9:	e8 c8 fa ff ff       	call   803586 <pageref>
  803abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803ac1:	89 34 24             	mov    %esi,(%esp)
  803ac4:	e8 bd fa ff ff       	call   803586 <pageref>
		nn = thisenv->env_runs;
  803ac9:	8b 15 50 a0 80 00    	mov    0x80a050,%edx
  803acf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803ad2:	83 c4 10             	add    $0x10,%esp
  803ad5:	39 cb                	cmp    %ecx,%ebx
  803ad7:	74 1b                	je     803af4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803ad9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803adc:	75 cf                	jne    803aad <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ade:	8b 42 58             	mov    0x58(%edx),%eax
  803ae1:	6a 01                	push   $0x1
  803ae3:	50                   	push   %eax
  803ae4:	53                   	push   %ebx
  803ae5:	68 7e 4c 80 00       	push   $0x804c7e
  803aea:	e8 90 e2 ff ff       	call   801d7f <cprintf>
  803aef:	83 c4 10             	add    $0x10,%esp
  803af2:	eb b9                	jmp    803aad <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803af4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803af7:	0f 94 c0             	sete   %al
  803afa:	0f b6 c0             	movzbl %al,%eax
}
  803afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803b00:	5b                   	pop    %ebx
  803b01:	5e                   	pop    %esi
  803b02:	5f                   	pop    %edi
  803b03:	5d                   	pop    %ebp
  803b04:	c3                   	ret    

00803b05 <devpipe_write>:
{
  803b05:	55                   	push   %ebp
  803b06:	89 e5                	mov    %esp,%ebp
  803b08:	57                   	push   %edi
  803b09:	56                   	push   %esi
  803b0a:	53                   	push   %ebx
  803b0b:	83 ec 28             	sub    $0x28,%esp
  803b0e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803b11:	56                   	push   %esi
  803b12:	e8 53 f2 ff ff       	call   802d6a <fd2data>
  803b17:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803b19:	83 c4 10             	add    $0x10,%esp
  803b1c:	bf 00 00 00 00       	mov    $0x0,%edi
  803b21:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803b24:	74 4f                	je     803b75 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b26:	8b 43 04             	mov    0x4(%ebx),%eax
  803b29:	8b 0b                	mov    (%ebx),%ecx
  803b2b:	8d 51 20             	lea    0x20(%ecx),%edx
  803b2e:	39 d0                	cmp    %edx,%eax
  803b30:	72 14                	jb     803b46 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803b32:	89 da                	mov    %ebx,%edx
  803b34:	89 f0                	mov    %esi,%eax
  803b36:	e8 65 ff ff ff       	call   803aa0 <_pipeisclosed>
  803b3b:	85 c0                	test   %eax,%eax
  803b3d:	75 3b                	jne    803b7a <devpipe_write+0x75>
			sys_yield();
  803b3f:	e8 6d ed ff ff       	call   8028b1 <sys_yield>
  803b44:	eb e0                	jmp    803b26 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803b49:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803b4d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803b50:	89 c2                	mov    %eax,%edx
  803b52:	c1 fa 1f             	sar    $0x1f,%edx
  803b55:	89 d1                	mov    %edx,%ecx
  803b57:	c1 e9 1b             	shr    $0x1b,%ecx
  803b5a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803b5d:	83 e2 1f             	and    $0x1f,%edx
  803b60:	29 ca                	sub    %ecx,%edx
  803b62:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803b66:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803b6a:	83 c0 01             	add    $0x1,%eax
  803b6d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803b70:	83 c7 01             	add    $0x1,%edi
  803b73:	eb ac                	jmp    803b21 <devpipe_write+0x1c>
	return i;
  803b75:	8b 45 10             	mov    0x10(%ebp),%eax
  803b78:	eb 05                	jmp    803b7f <devpipe_write+0x7a>
				return 0;
  803b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803b82:	5b                   	pop    %ebx
  803b83:	5e                   	pop    %esi
  803b84:	5f                   	pop    %edi
  803b85:	5d                   	pop    %ebp
  803b86:	c3                   	ret    

00803b87 <devpipe_read>:
{
  803b87:	55                   	push   %ebp
  803b88:	89 e5                	mov    %esp,%ebp
  803b8a:	57                   	push   %edi
  803b8b:	56                   	push   %esi
  803b8c:	53                   	push   %ebx
  803b8d:	83 ec 18             	sub    $0x18,%esp
  803b90:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803b93:	57                   	push   %edi
  803b94:	e8 d1 f1 ff ff       	call   802d6a <fd2data>
  803b99:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803b9b:	83 c4 10             	add    $0x10,%esp
  803b9e:	be 00 00 00 00       	mov    $0x0,%esi
  803ba3:	3b 75 10             	cmp    0x10(%ebp),%esi
  803ba6:	75 14                	jne    803bbc <devpipe_read+0x35>
	return i;
  803ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  803bab:	eb 02                	jmp    803baf <devpipe_read+0x28>
				return i;
  803bad:	89 f0                	mov    %esi,%eax
}
  803baf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803bb2:	5b                   	pop    %ebx
  803bb3:	5e                   	pop    %esi
  803bb4:	5f                   	pop    %edi
  803bb5:	5d                   	pop    %ebp
  803bb6:	c3                   	ret    
			sys_yield();
  803bb7:	e8 f5 ec ff ff       	call   8028b1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  803bbc:	8b 03                	mov    (%ebx),%eax
  803bbe:	3b 43 04             	cmp    0x4(%ebx),%eax
  803bc1:	75 18                	jne    803bdb <devpipe_read+0x54>
			if (i > 0)
  803bc3:	85 f6                	test   %esi,%esi
  803bc5:	75 e6                	jne    803bad <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  803bc7:	89 da                	mov    %ebx,%edx
  803bc9:	89 f8                	mov    %edi,%eax
  803bcb:	e8 d0 fe ff ff       	call   803aa0 <_pipeisclosed>
  803bd0:	85 c0                	test   %eax,%eax
  803bd2:	74 e3                	je     803bb7 <devpipe_read+0x30>
				return 0;
  803bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd9:	eb d4                	jmp    803baf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803bdb:	99                   	cltd   
  803bdc:	c1 ea 1b             	shr    $0x1b,%edx
  803bdf:	01 d0                	add    %edx,%eax
  803be1:	83 e0 1f             	and    $0x1f,%eax
  803be4:	29 d0                	sub    %edx,%eax
  803be6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803beb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803bee:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803bf1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803bf4:	83 c6 01             	add    $0x1,%esi
  803bf7:	eb aa                	jmp    803ba3 <devpipe_read+0x1c>

00803bf9 <pipe>:
{
  803bf9:	55                   	push   %ebp
  803bfa:	89 e5                	mov    %esp,%ebp
  803bfc:	56                   	push   %esi
  803bfd:	53                   	push   %ebx
  803bfe:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803c04:	50                   	push   %eax
  803c05:	e8 77 f1 ff ff       	call   802d81 <fd_alloc>
  803c0a:	89 c3                	mov    %eax,%ebx
  803c0c:	83 c4 10             	add    $0x10,%esp
  803c0f:	85 c0                	test   %eax,%eax
  803c11:	0f 88 23 01 00 00    	js     803d3a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c17:	83 ec 04             	sub    $0x4,%esp
  803c1a:	68 07 04 00 00       	push   $0x407
  803c1f:	ff 75 f4             	pushl  -0xc(%ebp)
  803c22:	6a 00                	push   $0x0
  803c24:	e8 a7 ec ff ff       	call   8028d0 <sys_page_alloc>
  803c29:	89 c3                	mov    %eax,%ebx
  803c2b:	83 c4 10             	add    $0x10,%esp
  803c2e:	85 c0                	test   %eax,%eax
  803c30:	0f 88 04 01 00 00    	js     803d3a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  803c36:	83 ec 0c             	sub    $0xc,%esp
  803c39:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803c3c:	50                   	push   %eax
  803c3d:	e8 3f f1 ff ff       	call   802d81 <fd_alloc>
  803c42:	89 c3                	mov    %eax,%ebx
  803c44:	83 c4 10             	add    $0x10,%esp
  803c47:	85 c0                	test   %eax,%eax
  803c49:	0f 88 db 00 00 00    	js     803d2a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c4f:	83 ec 04             	sub    $0x4,%esp
  803c52:	68 07 04 00 00       	push   $0x407
  803c57:	ff 75 f0             	pushl  -0x10(%ebp)
  803c5a:	6a 00                	push   $0x0
  803c5c:	e8 6f ec ff ff       	call   8028d0 <sys_page_alloc>
  803c61:	89 c3                	mov    %eax,%ebx
  803c63:	83 c4 10             	add    $0x10,%esp
  803c66:	85 c0                	test   %eax,%eax
  803c68:	0f 88 bc 00 00 00    	js     803d2a <pipe+0x131>
	va = fd2data(fd0);
  803c6e:	83 ec 0c             	sub    $0xc,%esp
  803c71:	ff 75 f4             	pushl  -0xc(%ebp)
  803c74:	e8 f1 f0 ff ff       	call   802d6a <fd2data>
  803c79:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c7b:	83 c4 0c             	add    $0xc,%esp
  803c7e:	68 07 04 00 00       	push   $0x407
  803c83:	50                   	push   %eax
  803c84:	6a 00                	push   $0x0
  803c86:	e8 45 ec ff ff       	call   8028d0 <sys_page_alloc>
  803c8b:	89 c3                	mov    %eax,%ebx
  803c8d:	83 c4 10             	add    $0x10,%esp
  803c90:	85 c0                	test   %eax,%eax
  803c92:	0f 88 82 00 00 00    	js     803d1a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c98:	83 ec 0c             	sub    $0xc,%esp
  803c9b:	ff 75 f0             	pushl  -0x10(%ebp)
  803c9e:	e8 c7 f0 ff ff       	call   802d6a <fd2data>
  803ca3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803caa:	50                   	push   %eax
  803cab:	6a 00                	push   $0x0
  803cad:	56                   	push   %esi
  803cae:	6a 00                	push   $0x0
  803cb0:	e8 5e ec ff ff       	call   802913 <sys_page_map>
  803cb5:	89 c3                	mov    %eax,%ebx
  803cb7:	83 c4 20             	add    $0x20,%esp
  803cba:	85 c0                	test   %eax,%eax
  803cbc:	78 4e                	js     803d0c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  803cbe:	a1 9c 90 80 00       	mov    0x80909c,%eax
  803cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cc6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ccb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  803cd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cd5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cda:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803ce1:	83 ec 0c             	sub    $0xc,%esp
  803ce4:	ff 75 f4             	pushl  -0xc(%ebp)
  803ce7:	e8 6e f0 ff ff       	call   802d5a <fd2num>
  803cec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803cef:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803cf1:	83 c4 04             	add    $0x4,%esp
  803cf4:	ff 75 f0             	pushl  -0x10(%ebp)
  803cf7:	e8 5e f0 ff ff       	call   802d5a <fd2num>
  803cfc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803cff:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803d02:	83 c4 10             	add    $0x10,%esp
  803d05:	bb 00 00 00 00       	mov    $0x0,%ebx
  803d0a:	eb 2e                	jmp    803d3a <pipe+0x141>
	sys_page_unmap(0, va);
  803d0c:	83 ec 08             	sub    $0x8,%esp
  803d0f:	56                   	push   %esi
  803d10:	6a 00                	push   $0x0
  803d12:	e8 3e ec ff ff       	call   802955 <sys_page_unmap>
  803d17:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803d1a:	83 ec 08             	sub    $0x8,%esp
  803d1d:	ff 75 f0             	pushl  -0x10(%ebp)
  803d20:	6a 00                	push   $0x0
  803d22:	e8 2e ec ff ff       	call   802955 <sys_page_unmap>
  803d27:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803d2a:	83 ec 08             	sub    $0x8,%esp
  803d2d:	ff 75 f4             	pushl  -0xc(%ebp)
  803d30:	6a 00                	push   $0x0
  803d32:	e8 1e ec ff ff       	call   802955 <sys_page_unmap>
  803d37:	83 c4 10             	add    $0x10,%esp
}
  803d3a:	89 d8                	mov    %ebx,%eax
  803d3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803d3f:	5b                   	pop    %ebx
  803d40:	5e                   	pop    %esi
  803d41:	5d                   	pop    %ebp
  803d42:	c3                   	ret    

00803d43 <pipeisclosed>:
{
  803d43:	55                   	push   %ebp
  803d44:	89 e5                	mov    %esp,%ebp
  803d46:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d4c:	50                   	push   %eax
  803d4d:	ff 75 08             	pushl  0x8(%ebp)
  803d50:	e8 7e f0 ff ff       	call   802dd3 <fd_lookup>
  803d55:	83 c4 10             	add    $0x10,%esp
  803d58:	85 c0                	test   %eax,%eax
  803d5a:	78 18                	js     803d74 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  803d5c:	83 ec 0c             	sub    $0xc,%esp
  803d5f:	ff 75 f4             	pushl  -0xc(%ebp)
  803d62:	e8 03 f0 ff ff       	call   802d6a <fd2data>
	return _pipeisclosed(fd, p);
  803d67:	89 c2                	mov    %eax,%edx
  803d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6c:	e8 2f fd ff ff       	call   803aa0 <_pipeisclosed>
  803d71:	83 c4 10             	add    $0x10,%esp
}
  803d74:	c9                   	leave  
  803d75:	c3                   	ret    

00803d76 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  803d76:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7b:	c3                   	ret    

00803d7c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d7c:	55                   	push   %ebp
  803d7d:	89 e5                	mov    %esp,%ebp
  803d7f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803d82:	68 96 4c 80 00       	push   $0x804c96
  803d87:	ff 75 0c             	pushl  0xc(%ebp)
  803d8a:	e8 4f e7 ff ff       	call   8024de <strcpy>
	return 0;
}
  803d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d94:	c9                   	leave  
  803d95:	c3                   	ret    

00803d96 <devcons_write>:
{
  803d96:	55                   	push   %ebp
  803d97:	89 e5                	mov    %esp,%ebp
  803d99:	57                   	push   %edi
  803d9a:	56                   	push   %esi
  803d9b:	53                   	push   %ebx
  803d9c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  803da2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803da7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803dad:	3b 75 10             	cmp    0x10(%ebp),%esi
  803db0:	73 31                	jae    803de3 <devcons_write+0x4d>
		m = n - tot;
  803db2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803db5:	29 f3                	sub    %esi,%ebx
  803db7:	83 fb 7f             	cmp    $0x7f,%ebx
  803dba:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803dbf:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803dc2:	83 ec 04             	sub    $0x4,%esp
  803dc5:	53                   	push   %ebx
  803dc6:	89 f0                	mov    %esi,%eax
  803dc8:	03 45 0c             	add    0xc(%ebp),%eax
  803dcb:	50                   	push   %eax
  803dcc:	57                   	push   %edi
  803dcd:	e8 9a e8 ff ff       	call   80266c <memmove>
		sys_cputs(buf, m);
  803dd2:	83 c4 08             	add    $0x8,%esp
  803dd5:	53                   	push   %ebx
  803dd6:	57                   	push   %edi
  803dd7:	e8 38 ea ff ff       	call   802814 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803ddc:	01 de                	add    %ebx,%esi
  803dde:	83 c4 10             	add    $0x10,%esp
  803de1:	eb ca                	jmp    803dad <devcons_write+0x17>
}
  803de3:	89 f0                	mov    %esi,%eax
  803de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803de8:	5b                   	pop    %ebx
  803de9:	5e                   	pop    %esi
  803dea:	5f                   	pop    %edi
  803deb:	5d                   	pop    %ebp
  803dec:	c3                   	ret    

00803ded <devcons_read>:
{
  803ded:	55                   	push   %ebp
  803dee:	89 e5                	mov    %esp,%ebp
  803df0:	83 ec 08             	sub    $0x8,%esp
  803df3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803df8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803dfc:	74 21                	je     803e1f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  803dfe:	e8 2f ea ff ff       	call   802832 <sys_cgetc>
  803e03:	85 c0                	test   %eax,%eax
  803e05:	75 07                	jne    803e0e <devcons_read+0x21>
		sys_yield();
  803e07:	e8 a5 ea ff ff       	call   8028b1 <sys_yield>
  803e0c:	eb f0                	jmp    803dfe <devcons_read+0x11>
	if (c < 0)
  803e0e:	78 0f                	js     803e1f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  803e10:	83 f8 04             	cmp    $0x4,%eax
  803e13:	74 0c                	je     803e21 <devcons_read+0x34>
	*(char*)vbuf = c;
  803e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e18:	88 02                	mov    %al,(%edx)
	return 1;
  803e1a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e1f:	c9                   	leave  
  803e20:	c3                   	ret    
		return 0;
  803e21:	b8 00 00 00 00       	mov    $0x0,%eax
  803e26:	eb f7                	jmp    803e1f <devcons_read+0x32>

00803e28 <cputchar>:
{
  803e28:	55                   	push   %ebp
  803e29:	89 e5                	mov    %esp,%ebp
  803e2b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e31:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803e34:	6a 01                	push   $0x1
  803e36:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e39:	50                   	push   %eax
  803e3a:	e8 d5 e9 ff ff       	call   802814 <sys_cputs>
}
  803e3f:	83 c4 10             	add    $0x10,%esp
  803e42:	c9                   	leave  
  803e43:	c3                   	ret    

00803e44 <getchar>:
{
  803e44:	55                   	push   %ebp
  803e45:	89 e5                	mov    %esp,%ebp
  803e47:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803e4a:	6a 01                	push   $0x1
  803e4c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e4f:	50                   	push   %eax
  803e50:	6a 00                	push   $0x0
  803e52:	e8 ec f1 ff ff       	call   803043 <read>
	if (r < 0)
  803e57:	83 c4 10             	add    $0x10,%esp
  803e5a:	85 c0                	test   %eax,%eax
  803e5c:	78 06                	js     803e64 <getchar+0x20>
	if (r < 1)
  803e5e:	74 06                	je     803e66 <getchar+0x22>
	return c;
  803e60:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803e64:	c9                   	leave  
  803e65:	c3                   	ret    
		return -E_EOF;
  803e66:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803e6b:	eb f7                	jmp    803e64 <getchar+0x20>

00803e6d <iscons>:
{
  803e6d:	55                   	push   %ebp
  803e6e:	89 e5                	mov    %esp,%ebp
  803e70:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803e76:	50                   	push   %eax
  803e77:	ff 75 08             	pushl  0x8(%ebp)
  803e7a:	e8 54 ef ff ff       	call   802dd3 <fd_lookup>
  803e7f:	83 c4 10             	add    $0x10,%esp
  803e82:	85 c0                	test   %eax,%eax
  803e84:	78 11                	js     803e97 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e89:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803e8f:	39 10                	cmp    %edx,(%eax)
  803e91:	0f 94 c0             	sete   %al
  803e94:	0f b6 c0             	movzbl %al,%eax
}
  803e97:	c9                   	leave  
  803e98:	c3                   	ret    

00803e99 <opencons>:
{
  803e99:	55                   	push   %ebp
  803e9a:	89 e5                	mov    %esp,%ebp
  803e9c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803e9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ea2:	50                   	push   %eax
  803ea3:	e8 d9 ee ff ff       	call   802d81 <fd_alloc>
  803ea8:	83 c4 10             	add    $0x10,%esp
  803eab:	85 c0                	test   %eax,%eax
  803ead:	78 3a                	js     803ee9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803eaf:	83 ec 04             	sub    $0x4,%esp
  803eb2:	68 07 04 00 00       	push   $0x407
  803eb7:	ff 75 f4             	pushl  -0xc(%ebp)
  803eba:	6a 00                	push   $0x0
  803ebc:	e8 0f ea ff ff       	call   8028d0 <sys_page_alloc>
  803ec1:	83 c4 10             	add    $0x10,%esp
  803ec4:	85 c0                	test   %eax,%eax
  803ec6:	78 21                	js     803ee9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ecb:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803ed1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803edd:	83 ec 0c             	sub    $0xc,%esp
  803ee0:	50                   	push   %eax
  803ee1:	e8 74 ee ff ff       	call   802d5a <fd2num>
  803ee6:	83 c4 10             	add    $0x10,%esp
}
  803ee9:	c9                   	leave  
  803eea:	c3                   	ret    
  803eeb:	66 90                	xchg   %ax,%ax
  803eed:	66 90                	xchg   %ax,%ax
  803eef:	90                   	nop

00803ef0 <__udivdi3>:
  803ef0:	55                   	push   %ebp
  803ef1:	57                   	push   %edi
  803ef2:	56                   	push   %esi
  803ef3:	53                   	push   %ebx
  803ef4:	83 ec 1c             	sub    $0x1c,%esp
  803ef7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803efb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803eff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803f07:	85 d2                	test   %edx,%edx
  803f09:	75 4d                	jne    803f58 <__udivdi3+0x68>
  803f0b:	39 f3                	cmp    %esi,%ebx
  803f0d:	76 19                	jbe    803f28 <__udivdi3+0x38>
  803f0f:	31 ff                	xor    %edi,%edi
  803f11:	89 e8                	mov    %ebp,%eax
  803f13:	89 f2                	mov    %esi,%edx
  803f15:	f7 f3                	div    %ebx
  803f17:	89 fa                	mov    %edi,%edx
  803f19:	83 c4 1c             	add    $0x1c,%esp
  803f1c:	5b                   	pop    %ebx
  803f1d:	5e                   	pop    %esi
  803f1e:	5f                   	pop    %edi
  803f1f:	5d                   	pop    %ebp
  803f20:	c3                   	ret    
  803f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f28:	89 d9                	mov    %ebx,%ecx
  803f2a:	85 db                	test   %ebx,%ebx
  803f2c:	75 0b                	jne    803f39 <__udivdi3+0x49>
  803f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f33:	31 d2                	xor    %edx,%edx
  803f35:	f7 f3                	div    %ebx
  803f37:	89 c1                	mov    %eax,%ecx
  803f39:	31 d2                	xor    %edx,%edx
  803f3b:	89 f0                	mov    %esi,%eax
  803f3d:	f7 f1                	div    %ecx
  803f3f:	89 c6                	mov    %eax,%esi
  803f41:	89 e8                	mov    %ebp,%eax
  803f43:	89 f7                	mov    %esi,%edi
  803f45:	f7 f1                	div    %ecx
  803f47:	89 fa                	mov    %edi,%edx
  803f49:	83 c4 1c             	add    $0x1c,%esp
  803f4c:	5b                   	pop    %ebx
  803f4d:	5e                   	pop    %esi
  803f4e:	5f                   	pop    %edi
  803f4f:	5d                   	pop    %ebp
  803f50:	c3                   	ret    
  803f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f58:	39 f2                	cmp    %esi,%edx
  803f5a:	77 1c                	ja     803f78 <__udivdi3+0x88>
  803f5c:	0f bd fa             	bsr    %edx,%edi
  803f5f:	83 f7 1f             	xor    $0x1f,%edi
  803f62:	75 2c                	jne    803f90 <__udivdi3+0xa0>
  803f64:	39 f2                	cmp    %esi,%edx
  803f66:	72 06                	jb     803f6e <__udivdi3+0x7e>
  803f68:	31 c0                	xor    %eax,%eax
  803f6a:	39 eb                	cmp    %ebp,%ebx
  803f6c:	77 a9                	ja     803f17 <__udivdi3+0x27>
  803f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f73:	eb a2                	jmp    803f17 <__udivdi3+0x27>
  803f75:	8d 76 00             	lea    0x0(%esi),%esi
  803f78:	31 ff                	xor    %edi,%edi
  803f7a:	31 c0                	xor    %eax,%eax
  803f7c:	89 fa                	mov    %edi,%edx
  803f7e:	83 c4 1c             	add    $0x1c,%esp
  803f81:	5b                   	pop    %ebx
  803f82:	5e                   	pop    %esi
  803f83:	5f                   	pop    %edi
  803f84:	5d                   	pop    %ebp
  803f85:	c3                   	ret    
  803f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f8d:	8d 76 00             	lea    0x0(%esi),%esi
  803f90:	89 f9                	mov    %edi,%ecx
  803f92:	b8 20 00 00 00       	mov    $0x20,%eax
  803f97:	29 f8                	sub    %edi,%eax
  803f99:	d3 e2                	shl    %cl,%edx
  803f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  803f9f:	89 c1                	mov    %eax,%ecx
  803fa1:	89 da                	mov    %ebx,%edx
  803fa3:	d3 ea                	shr    %cl,%edx
  803fa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803fa9:	09 d1                	or     %edx,%ecx
  803fab:	89 f2                	mov    %esi,%edx
  803fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fb1:	89 f9                	mov    %edi,%ecx
  803fb3:	d3 e3                	shl    %cl,%ebx
  803fb5:	89 c1                	mov    %eax,%ecx
  803fb7:	d3 ea                	shr    %cl,%edx
  803fb9:	89 f9                	mov    %edi,%ecx
  803fbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803fbf:	89 eb                	mov    %ebp,%ebx
  803fc1:	d3 e6                	shl    %cl,%esi
  803fc3:	89 c1                	mov    %eax,%ecx
  803fc5:	d3 eb                	shr    %cl,%ebx
  803fc7:	09 de                	or     %ebx,%esi
  803fc9:	89 f0                	mov    %esi,%eax
  803fcb:	f7 74 24 08          	divl   0x8(%esp)
  803fcf:	89 d6                	mov    %edx,%esi
  803fd1:	89 c3                	mov    %eax,%ebx
  803fd3:	f7 64 24 0c          	mull   0xc(%esp)
  803fd7:	39 d6                	cmp    %edx,%esi
  803fd9:	72 15                	jb     803ff0 <__udivdi3+0x100>
  803fdb:	89 f9                	mov    %edi,%ecx
  803fdd:	d3 e5                	shl    %cl,%ebp
  803fdf:	39 c5                	cmp    %eax,%ebp
  803fe1:	73 04                	jae    803fe7 <__udivdi3+0xf7>
  803fe3:	39 d6                	cmp    %edx,%esi
  803fe5:	74 09                	je     803ff0 <__udivdi3+0x100>
  803fe7:	89 d8                	mov    %ebx,%eax
  803fe9:	31 ff                	xor    %edi,%edi
  803feb:	e9 27 ff ff ff       	jmp    803f17 <__udivdi3+0x27>
  803ff0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ff3:	31 ff                	xor    %edi,%edi
  803ff5:	e9 1d ff ff ff       	jmp    803f17 <__udivdi3+0x27>
  803ffa:	66 90                	xchg   %ax,%ax
  803ffc:	66 90                	xchg   %ax,%ax
  803ffe:	66 90                	xchg   %ax,%ax

00804000 <__umoddi3>:
  804000:	55                   	push   %ebp
  804001:	57                   	push   %edi
  804002:	56                   	push   %esi
  804003:	53                   	push   %ebx
  804004:	83 ec 1c             	sub    $0x1c,%esp
  804007:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80400b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80400f:	8b 74 24 30          	mov    0x30(%esp),%esi
  804013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804017:	89 da                	mov    %ebx,%edx
  804019:	85 c0                	test   %eax,%eax
  80401b:	75 43                	jne    804060 <__umoddi3+0x60>
  80401d:	39 df                	cmp    %ebx,%edi
  80401f:	76 17                	jbe    804038 <__umoddi3+0x38>
  804021:	89 f0                	mov    %esi,%eax
  804023:	f7 f7                	div    %edi
  804025:	89 d0                	mov    %edx,%eax
  804027:	31 d2                	xor    %edx,%edx
  804029:	83 c4 1c             	add    $0x1c,%esp
  80402c:	5b                   	pop    %ebx
  80402d:	5e                   	pop    %esi
  80402e:	5f                   	pop    %edi
  80402f:	5d                   	pop    %ebp
  804030:	c3                   	ret    
  804031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804038:	89 fd                	mov    %edi,%ebp
  80403a:	85 ff                	test   %edi,%edi
  80403c:	75 0b                	jne    804049 <__umoddi3+0x49>
  80403e:	b8 01 00 00 00       	mov    $0x1,%eax
  804043:	31 d2                	xor    %edx,%edx
  804045:	f7 f7                	div    %edi
  804047:	89 c5                	mov    %eax,%ebp
  804049:	89 d8                	mov    %ebx,%eax
  80404b:	31 d2                	xor    %edx,%edx
  80404d:	f7 f5                	div    %ebp
  80404f:	89 f0                	mov    %esi,%eax
  804051:	f7 f5                	div    %ebp
  804053:	89 d0                	mov    %edx,%eax
  804055:	eb d0                	jmp    804027 <__umoddi3+0x27>
  804057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80405e:	66 90                	xchg   %ax,%ax
  804060:	89 f1                	mov    %esi,%ecx
  804062:	39 d8                	cmp    %ebx,%eax
  804064:	76 0a                	jbe    804070 <__umoddi3+0x70>
  804066:	89 f0                	mov    %esi,%eax
  804068:	83 c4 1c             	add    $0x1c,%esp
  80406b:	5b                   	pop    %ebx
  80406c:	5e                   	pop    %esi
  80406d:	5f                   	pop    %edi
  80406e:	5d                   	pop    %ebp
  80406f:	c3                   	ret    
  804070:	0f bd e8             	bsr    %eax,%ebp
  804073:	83 f5 1f             	xor    $0x1f,%ebp
  804076:	75 20                	jne    804098 <__umoddi3+0x98>
  804078:	39 d8                	cmp    %ebx,%eax
  80407a:	0f 82 b0 00 00 00    	jb     804130 <__umoddi3+0x130>
  804080:	39 f7                	cmp    %esi,%edi
  804082:	0f 86 a8 00 00 00    	jbe    804130 <__umoddi3+0x130>
  804088:	89 c8                	mov    %ecx,%eax
  80408a:	83 c4 1c             	add    $0x1c,%esp
  80408d:	5b                   	pop    %ebx
  80408e:	5e                   	pop    %esi
  80408f:	5f                   	pop    %edi
  804090:	5d                   	pop    %ebp
  804091:	c3                   	ret    
  804092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804098:	89 e9                	mov    %ebp,%ecx
  80409a:	ba 20 00 00 00       	mov    $0x20,%edx
  80409f:	29 ea                	sub    %ebp,%edx
  8040a1:	d3 e0                	shl    %cl,%eax
  8040a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8040a7:	89 d1                	mov    %edx,%ecx
  8040a9:	89 f8                	mov    %edi,%eax
  8040ab:	d3 e8                	shr    %cl,%eax
  8040ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8040b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8040b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040b9:	09 c1                	or     %eax,%ecx
  8040bb:	89 d8                	mov    %ebx,%eax
  8040bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040c1:	89 e9                	mov    %ebp,%ecx
  8040c3:	d3 e7                	shl    %cl,%edi
  8040c5:	89 d1                	mov    %edx,%ecx
  8040c7:	d3 e8                	shr    %cl,%eax
  8040c9:	89 e9                	mov    %ebp,%ecx
  8040cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040cf:	d3 e3                	shl    %cl,%ebx
  8040d1:	89 c7                	mov    %eax,%edi
  8040d3:	89 d1                	mov    %edx,%ecx
  8040d5:	89 f0                	mov    %esi,%eax
  8040d7:	d3 e8                	shr    %cl,%eax
  8040d9:	89 e9                	mov    %ebp,%ecx
  8040db:	89 fa                	mov    %edi,%edx
  8040dd:	d3 e6                	shl    %cl,%esi
  8040df:	09 d8                	or     %ebx,%eax
  8040e1:	f7 74 24 08          	divl   0x8(%esp)
  8040e5:	89 d1                	mov    %edx,%ecx
  8040e7:	89 f3                	mov    %esi,%ebx
  8040e9:	f7 64 24 0c          	mull   0xc(%esp)
  8040ed:	89 c6                	mov    %eax,%esi
  8040ef:	89 d7                	mov    %edx,%edi
  8040f1:	39 d1                	cmp    %edx,%ecx
  8040f3:	72 06                	jb     8040fb <__umoddi3+0xfb>
  8040f5:	75 10                	jne    804107 <__umoddi3+0x107>
  8040f7:	39 c3                	cmp    %eax,%ebx
  8040f9:	73 0c                	jae    804107 <__umoddi3+0x107>
  8040fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8040ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  804103:	89 d7                	mov    %edx,%edi
  804105:	89 c6                	mov    %eax,%esi
  804107:	89 ca                	mov    %ecx,%edx
  804109:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80410e:	29 f3                	sub    %esi,%ebx
  804110:	19 fa                	sbb    %edi,%edx
  804112:	89 d0                	mov    %edx,%eax
  804114:	d3 e0                	shl    %cl,%eax
  804116:	89 e9                	mov    %ebp,%ecx
  804118:	d3 eb                	shr    %cl,%ebx
  80411a:	d3 ea                	shr    %cl,%edx
  80411c:	09 d8                	or     %ebx,%eax
  80411e:	83 c4 1c             	add    $0x1c,%esp
  804121:	5b                   	pop    %ebx
  804122:	5e                   	pop    %esi
  804123:	5f                   	pop    %edi
  804124:	5d                   	pop    %ebp
  804125:	c3                   	ret    
  804126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80412d:	8d 76 00             	lea    0x0(%esi),%esi
  804130:	89 da                	mov    %ebx,%edx
  804132:	29 fe                	sub    %edi,%esi
  804134:	19 c2                	sbb    %eax,%edx
  804136:	89 f1                	mov    %esi,%ecx
  804138:	89 c8                	mov    %ecx,%eax
  80413a:	e9 4b ff ff ff       	jmp    80408a <__umoddi3+0x8a>
