
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
  80002c:	e8 e5 12 00 00       	call   801316 <libmain>
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
  8000b0:	68 e0 32 80 00       	push   $0x8032e0
  8000b5:	e8 f9 13 00 00       	call   8014b3 <cprintf>
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
  8000cf:	a3 00 40 80 00       	mov    %eax,0x804000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 f7 32 80 00       	push   $0x8032f7
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 07 33 80 00       	push   $0x803307
  8000e5:	e8 d3 12 00 00       	call   8013bd <_panic>

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
  800138:	0f b6 05 00 40 80 00 	movzbl 0x804000,%eax
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
  80018f:	68 10 33 80 00       	push   $0x803310
  800194:	68 1d 33 80 00       	push   $0x80331d
  800199:	6a 44                	push   $0x44
  80019b:	68 07 33 80 00       	push   $0x803307
  8001a0:	e8 18 12 00 00       	call   8013bd <_panic>
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
  800200:	0f b6 05 00 40 80 00 	movzbl 0x804000,%eax
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
  800257:	68 10 33 80 00       	push   $0x803310
  80025c:	68 1d 33 80 00       	push   $0x80331d
  800261:	6a 5d                	push   $0x5d
  800263:	68 07 33 80 00       	push   $0x803307
  800268:	e8 50 11 00 00       	call   8013bd <_panic>
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

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	53                   	push   %ebx
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	8b 4d 08             	mov    0x8(%ebp),%ecx
	void *addr = (void *) utf->utf_fault_va;
  800284:	8b 01                	mov    (%ecx),%eax
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800286:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
  80028c:	89 d3                	mov    %edx,%ebx
  80028e:	c1 eb 0c             	shr    $0xc,%ebx
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800291:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
  800297:	77 55                	ja     8002ee <bc_pgfault+0x74>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  800299:	8b 15 08 90 80 00    	mov    0x809008,%edx
  80029f:	85 d2                	test   %edx,%edx
  8002a1:	74 05                	je     8002a8 <bc_pgfault+0x2e>
  8002a3:	39 5a 04             	cmp    %ebx,0x4(%edx)
  8002a6:	76 61                	jbe    800309 <bc_pgfault+0x8f>
	//
	// LAB 5: you code here:

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	c1 ea 0c             	shr    $0xc,%edx
  8002ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8002bd:	52                   	push   %edx
  8002be:	50                   	push   %eax
  8002bf:	6a 00                	push   $0x0
  8002c1:	50                   	push   %eax
  8002c2:	6a 00                	push   $0x0
  8002c4:	e8 7e 1d 00 00       	call   802047 <sys_page_map>
  8002c9:	83 c4 20             	add    $0x20,%esp
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	78 4b                	js     80031b <bc_pgfault+0xa1>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8002d0:	83 3d 04 90 80 00 00 	cmpl   $0x0,0x809004
  8002d7:	74 10                	je     8002e9 <bc_pgfault+0x6f>
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	53                   	push   %ebx
  8002dd:	e8 6f 03 00 00       	call   800651 <block_is_free>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	84 c0                	test   %al,%al
  8002e7:	75 44                	jne    80032d <bc_pgfault+0xb3>
		panic("reading free block %08x\n", blockno);
}
  8002e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	ff 71 04             	pushl  0x4(%ecx)
  8002f4:	50                   	push   %eax
  8002f5:	ff 71 28             	pushl  0x28(%ecx)
  8002f8:	68 34 33 80 00       	push   $0x803334
  8002fd:	6a 27                	push   $0x27
  8002ff:	68 ca 33 80 00       	push   $0x8033ca
  800304:	e8 b4 10 00 00       	call   8013bd <_panic>
		panic("reading non-existent block %08x\n", blockno);
  800309:	53                   	push   %ebx
  80030a:	68 64 33 80 00       	push   $0x803364
  80030f:	6a 2b                	push   $0x2b
  800311:	68 ca 33 80 00       	push   $0x8033ca
  800316:	e8 a2 10 00 00       	call   8013bd <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  80031b:	50                   	push   %eax
  80031c:	68 88 33 80 00       	push   $0x803388
  800321:	6a 37                	push   $0x37
  800323:	68 ca 33 80 00       	push   $0x8033ca
  800328:	e8 90 10 00 00       	call   8013bd <_panic>
		panic("reading free block %08x\n", blockno);
  80032d:	53                   	push   %ebx
  80032e:	68 d2 33 80 00       	push   $0x8033d2
  800333:	6a 3d                	push   $0x3d
  800335:	68 ca 33 80 00       	push   $0x8033ca
  80033a:	e8 7e 10 00 00       	call   8013bd <_panic>

0080033f <diskaddr>:
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800348:	85 c0                	test   %eax,%eax
  80034a:	74 19                	je     800365 <diskaddr+0x26>
  80034c:	8b 15 08 90 80 00    	mov    0x809008,%edx
  800352:	85 d2                	test   %edx,%edx
  800354:	74 05                	je     80035b <diskaddr+0x1c>
  800356:	39 42 04             	cmp    %eax,0x4(%edx)
  800359:	76 0a                	jbe    800365 <diskaddr+0x26>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  80035b:	05 00 00 01 00       	add    $0x10000,%eax
  800360:	c1 e0 0c             	shl    $0xc,%eax
}
  800363:	c9                   	leave  
  800364:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  800365:	50                   	push   %eax
  800366:	68 a8 33 80 00       	push   $0x8033a8
  80036b:	6a 09                	push   $0x9
  80036d:	68 ca 33 80 00       	push   $0x8033ca
  800372:	e8 46 10 00 00       	call   8013bd <_panic>

00800377 <va_is_mapped>:
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80037d:	89 d0                	mov    %edx,%eax
  80037f:	c1 e8 16             	shr    $0x16,%eax
  800382:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  800389:	b8 00 00 00 00       	mov    $0x0,%eax
  80038e:	f6 c1 01             	test   $0x1,%cl
  800391:	74 0d                	je     8003a0 <va_is_mapped+0x29>
  800393:	c1 ea 0c             	shr    $0xc,%edx
  800396:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80039d:	83 e0 01             	and    $0x1,%eax
  8003a0:	83 e0 01             	and    $0x1,%eax
}
  8003a3:	5d                   	pop    %ebp
  8003a4:	c3                   	ret    

008003a5 <va_is_dirty>:
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	c1 e8 0c             	shr    $0xc,%eax
  8003ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8003b5:	c1 e8 06             	shr    $0x6,%eax
  8003b8:	83 e0 01             	and    $0x1,%eax
}
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	8b 45 08             	mov    0x8(%ebp),%eax
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8003c6:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8003cc:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
  8003d2:	76 12                	jbe    8003e6 <flush_block+0x29>
		panic("flush_block of bad va %08x", addr);
  8003d4:	50                   	push   %eax
  8003d5:	68 eb 33 80 00       	push   $0x8033eb
  8003da:	6a 4d                	push   $0x4d
  8003dc:	68 ca 33 80 00       	push   $0x8033ca
  8003e1:	e8 d7 0f 00 00       	call   8013bd <_panic>

	// LAB 5: Your code here.
	panic("flush_block not implemented");
  8003e6:	83 ec 04             	sub    $0x4,%esp
  8003e9:	68 06 34 80 00       	push   $0x803406
  8003ee:	6a 50                	push   $0x50
  8003f0:	68 ca 33 80 00       	push   $0x8033ca
  8003f5:	e8 c3 0f 00 00       	call   8013bd <_panic>

008003fa <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	81 ec 24 01 00 00    	sub    $0x124,%esp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800403:	6a 01                	push   $0x1
  800405:	e8 35 ff ff ff       	call   80033f <diskaddr>
  80040a:	83 c4 0c             	add    $0xc,%esp
  80040d:	68 08 01 00 00       	push   $0x108
  800412:	50                   	push   %eax
  800413:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800419:	50                   	push   %eax
  80041a:	e8 81 19 00 00       	call   801da0 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  80041f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800426:	e8 14 ff ff ff       	call   80033f <diskaddr>
  80042b:	83 c4 08             	add    $0x8,%esp
  80042e:	68 22 34 80 00       	push   $0x803422
  800433:	50                   	push   %eax
  800434:	e8 d9 17 00 00       	call   801c12 <strcpy>
	flush_block(diskaddr(1));
  800439:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800440:	e8 fa fe ff ff       	call   80033f <diskaddr>
  800445:	89 04 24             	mov    %eax,(%esp)
  800448:	e8 70 ff ff ff       	call   8003bd <flush_block>

0080044d <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 14             	sub    $0x14,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800453:	68 7a 02 80 00       	push   $0x80027a
  800458:	e8 d9 1d 00 00       	call   802236 <set_pgfault_handler>
	check_bc();
  80045d:	e8 98 ff ff ff       	call   8003fa <check_bc>

00800462 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	57                   	push   %edi
  800466:	56                   	push   %esi
  800467:	53                   	push   %ebx
  800468:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  80046e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  800474:	89 8d 64 ff ff ff    	mov    %ecx,-0x9c(%ebp)
	while (*p == '/')
  80047a:	80 38 2f             	cmpb   $0x2f,(%eax)
  80047d:	75 05                	jne    800484 <walk_path+0x22>
		p++;
  80047f:	83 c0 01             	add    $0x1,%eax
  800482:	eb f6                	jmp    80047a <walk_path+0x18>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800484:	8b 3d 08 90 80 00    	mov    0x809008,%edi
  80048a:	8d 4f 08             	lea    0x8(%edi),%ecx
  80048d:	89 8d 5c ff ff ff    	mov    %ecx,-0xa4(%ebp)
	dir = 0;
	name[0] = 0;
  800493:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  80049a:	8b 8d 60 ff ff ff    	mov    -0xa0(%ebp),%ecx
  8004a0:	85 c9                	test   %ecx,%ecx
  8004a2:	0f 84 3c 01 00 00    	je     8005e4 <walk_path+0x182>
		*pdir = 0;
  8004a8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  8004ae:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8004b4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	while (*path != '\0') {
  8004ba:	80 38 00             	cmpb   $0x0,(%eax)
  8004bd:	0f 84 ec 00 00 00    	je     8005af <walk_path+0x14d>
{
  8004c3:	89 c3                	mov    %eax,%ebx
  8004c5:	eb 03                	jmp    8004ca <walk_path+0x68>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  8004c7:	83 c3 01             	add    $0x1,%ebx
		while (*path != '/' && *path != '\0')
  8004ca:	0f b6 13             	movzbl (%ebx),%edx
  8004cd:	80 fa 2f             	cmp    $0x2f,%dl
  8004d0:	74 04                	je     8004d6 <walk_path+0x74>
  8004d2:	84 d2                	test   %dl,%dl
  8004d4:	75 f1                	jne    8004c7 <walk_path+0x65>
		if (path - p >= MAXNAMELEN)
  8004d6:	89 de                	mov    %ebx,%esi
  8004d8:	29 c6                	sub    %eax,%esi
  8004da:	83 fe 7f             	cmp    $0x7f,%esi
  8004dd:	0f 8f f3 00 00 00    	jg     8005d6 <walk_path+0x174>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  8004e3:	83 ec 04             	sub    $0x4,%esp
  8004e6:	56                   	push   %esi
  8004e7:	50                   	push   %eax
  8004e8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8004ee:	50                   	push   %eax
  8004ef:	e8 ac 18 00 00       	call   801da0 <memmove>
		name[path - p] = '\0';
  8004f4:	c6 84 35 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%esi,1)
  8004fb:	00 
  8004fc:	83 c4 10             	add    $0x10,%esp
	while (*p == '/')
  8004ff:	0f b6 13             	movzbl (%ebx),%edx
  800502:	80 fa 2f             	cmp    $0x2f,%dl
  800505:	75 05                	jne    80050c <walk_path+0xaa>
		p++;
  800507:	83 c3 01             	add    $0x1,%ebx
  80050a:	eb f3                	jmp    8004ff <walk_path+0x9d>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  80050c:	83 bf 8c 00 00 00 01 	cmpl   $0x1,0x8c(%edi)
  800513:	0f 85 c4 00 00 00    	jne    8005dd <walk_path+0x17b>
	assert((dir->f_size % BLKSIZE) == 0);
  800519:	8b 87 88 00 00 00    	mov    0x88(%edi),%eax
  80051f:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800524:	75 59                	jne    80057f <walk_path+0x11d>
	for (i = 0; i < nblock; i++) {
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	3d fe 1f 00 00       	cmp    $0x1ffe,%eax
  800530:	77 66                	ja     800598 <walk_path+0x136>
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800532:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800537:	84 d2                	test   %dl,%dl
  800539:	0f 85 8f 00 00 00    	jne    8005ce <walk_path+0x16c>
				if (pdir)
  80053f:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800545:	85 c0                	test   %eax,%eax
  800547:	74 08                	je     800551 <walk_path+0xef>
					*pdir = dir;
  800549:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80054f:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800551:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800555:	74 15                	je     80056c <walk_path+0x10a>
					strcpy(lastelem, name);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800560:	50                   	push   %eax
  800561:	ff 75 08             	pushl  0x8(%ebp)
  800564:	e8 a9 16 00 00       	call   801c12 <strcpy>
  800569:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  80056c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800572:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800578:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  80057d:	eb 4f                	jmp    8005ce <walk_path+0x16c>
	assert((dir->f_size % BLKSIZE) == 0);
  80057f:	68 29 34 80 00       	push   $0x803429
  800584:	68 1d 33 80 00       	push   $0x80331d
  800589:	68 ab 00 00 00       	push   $0xab
  80058e:	68 46 34 80 00       	push   $0x803446
  800593:	e8 25 0e 00 00       	call   8013bd <_panic>
       panic("file_get_block not implemented");
  800598:	83 ec 04             	sub    $0x4,%esp
  80059b:	68 18 35 80 00       	push   $0x803518
  8005a0:	68 99 00 00 00       	push   $0x99
  8005a5:	68 46 34 80 00       	push   $0x803446
  8005aa:	e8 0e 0e 00 00       	call   8013bd <_panic>
		}
	}

	if (pdir)
		*pdir = dir;
  8005af:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8005b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pf = f;
  8005bb:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8005c1:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8005c7:	89 08                	mov    %ecx,(%eax)
	return 0;
  8005c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d1:	5b                   	pop    %ebx
  8005d2:	5e                   	pop    %esi
  8005d3:	5f                   	pop    %edi
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    
			return -E_BAD_PATH;
  8005d6:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8005db:	eb f1                	jmp    8005ce <walk_path+0x16c>
			return -E_NOT_FOUND;
  8005dd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8005e2:	eb ea                	jmp    8005ce <walk_path+0x16c>
	*pf = 0;
  8005e4:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8005ea:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	while (*path != '\0') {
  8005f0:	80 38 00             	cmpb   $0x0,(%eax)
  8005f3:	0f 85 ca fe ff ff    	jne    8004c3 <walk_path+0x61>
  8005f9:	eb c0                	jmp    8005bb <walk_path+0x159>

008005fb <check_super>:
{
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  800601:	a1 08 90 80 00       	mov    0x809008,%eax
  800606:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  80060c:	75 1b                	jne    800629 <check_super+0x2e>
	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  80060e:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800615:	77 26                	ja     80063d <check_super+0x42>
	cprintf("superblock is good\n");
  800617:	83 ec 0c             	sub    $0xc,%esp
  80061a:	68 84 34 80 00       	push   $0x803484
  80061f:	e8 8f 0e 00 00       	call   8014b3 <cprintf>
}
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	c9                   	leave  
  800628:	c3                   	ret    
		panic("bad file system magic number");
  800629:	83 ec 04             	sub    $0x4,%esp
  80062c:	68 4e 34 80 00       	push   $0x80344e
  800631:	6a 0f                	push   $0xf
  800633:	68 46 34 80 00       	push   $0x803446
  800638:	e8 80 0d 00 00       	call   8013bd <_panic>
		panic("file system is too large");
  80063d:	83 ec 04             	sub    $0x4,%esp
  800640:	68 6b 34 80 00       	push   $0x80346b
  800645:	6a 12                	push   $0x12
  800647:	68 46 34 80 00       	push   $0x803446
  80064c:	e8 6c 0d 00 00       	call   8013bd <_panic>

00800651 <block_is_free>:
{
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	53                   	push   %ebx
  800655:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800658:	8b 15 08 90 80 00    	mov    0x809008,%edx
  80065e:	85 d2                	test   %edx,%edx
  800660:	74 25                	je     800687 <block_is_free+0x36>
		return 0;
  800662:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  800667:	39 4a 04             	cmp    %ecx,0x4(%edx)
  80066a:	76 18                	jbe    800684 <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80066c:	89 cb                	mov    %ecx,%ebx
  80066e:	c1 eb 05             	shr    $0x5,%ebx
  800671:	b8 01 00 00 00       	mov    $0x1,%eax
  800676:	d3 e0                	shl    %cl,%eax
  800678:	8b 15 04 90 80 00    	mov    0x809004,%edx
  80067e:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  800681:	0f 95 c0             	setne  %al
}
  800684:	5b                   	pop    %ebx
  800685:	5d                   	pop    %ebp
  800686:	c3                   	ret    
		return 0;
  800687:	b8 00 00 00 00       	mov    $0x0,%eax
  80068c:	eb f6                	jmp    800684 <block_is_free+0x33>

0080068e <free_block>:
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	53                   	push   %ebx
  800692:	83 ec 04             	sub    $0x4,%esp
  800695:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (blockno == 0)
  800698:	85 c9                	test   %ecx,%ecx
  80069a:	74 1a                	je     8006b6 <free_block+0x28>
	bitmap[blockno/32] |= 1<<(blockno%32);
  80069c:	89 cb                	mov    %ecx,%ebx
  80069e:	c1 eb 05             	shr    $0x5,%ebx
  8006a1:	8b 15 04 90 80 00    	mov    0x809004,%edx
  8006a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8006ac:	d3 e0                	shl    %cl,%eax
  8006ae:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  8006b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    
		panic("attempt to free zero block");
  8006b6:	83 ec 04             	sub    $0x4,%esp
  8006b9:	68 98 34 80 00       	push   $0x803498
  8006be:	6a 2d                	push   $0x2d
  8006c0:	68 46 34 80 00       	push   $0x803446
  8006c5:	e8 f3 0c 00 00       	call   8013bd <_panic>

008006ca <alloc_block>:
{
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	83 ec 0c             	sub    $0xc,%esp
	panic("alloc_block not implemented");
  8006d0:	68 b3 34 80 00       	push   $0x8034b3
  8006d5:	6a 41                	push   $0x41
  8006d7:	68 46 34 80 00       	push   $0x803446
  8006dc:	e8 dc 0c 00 00       	call   8013bd <_panic>

008006e1 <check_bitmap>:
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	56                   	push   %esi
  8006e5:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8006e6:	a1 08 90 80 00       	mov    0x809008,%eax
  8006eb:	8b 70 04             	mov    0x4(%eax),%esi
  8006ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f3:	89 d8                	mov    %ebx,%eax
  8006f5:	c1 e0 0f             	shl    $0xf,%eax
  8006f8:	39 c6                	cmp    %eax,%esi
  8006fa:	76 2e                	jbe    80072a <check_bitmap+0x49>
		assert(!block_is_free(2+i));
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	8d 43 02             	lea    0x2(%ebx),%eax
  800702:	50                   	push   %eax
  800703:	e8 49 ff ff ff       	call   800651 <block_is_free>
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	84 c0                	test   %al,%al
  80070d:	75 05                	jne    800714 <check_bitmap+0x33>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  80070f:	83 c3 01             	add    $0x1,%ebx
  800712:	eb df                	jmp    8006f3 <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  800714:	68 cf 34 80 00       	push   $0x8034cf
  800719:	68 1d 33 80 00       	push   $0x80331d
  80071e:	6a 50                	push   $0x50
  800720:	68 46 34 80 00       	push   $0x803446
  800725:	e8 93 0c 00 00       	call   8013bd <_panic>
	assert(!block_is_free(0));
  80072a:	83 ec 0c             	sub    $0xc,%esp
  80072d:	6a 00                	push   $0x0
  80072f:	e8 1d ff ff ff       	call   800651 <block_is_free>
  800734:	83 c4 10             	add    $0x10,%esp
  800737:	84 c0                	test   %al,%al
  800739:	75 28                	jne    800763 <check_bitmap+0x82>
	assert(!block_is_free(1));
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 01                	push   $0x1
  800740:	e8 0c ff ff ff       	call   800651 <block_is_free>
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	84 c0                	test   %al,%al
  80074a:	75 2d                	jne    800779 <check_bitmap+0x98>
	cprintf("bitmap is good\n");
  80074c:	83 ec 0c             	sub    $0xc,%esp
  80074f:	68 07 35 80 00       	push   $0x803507
  800754:	e8 5a 0d 00 00       	call   8014b3 <cprintf>
}
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80075f:	5b                   	pop    %ebx
  800760:	5e                   	pop    %esi
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    
	assert(!block_is_free(0));
  800763:	68 e3 34 80 00       	push   $0x8034e3
  800768:	68 1d 33 80 00       	push   $0x80331d
  80076d:	6a 53                	push   $0x53
  80076f:	68 46 34 80 00       	push   $0x803446
  800774:	e8 44 0c 00 00       	call   8013bd <_panic>
	assert(!block_is_free(1));
  800779:	68 f5 34 80 00       	push   $0x8034f5
  80077e:	68 1d 33 80 00       	push   $0x80331d
  800783:	6a 54                	push   $0x54
  800785:	68 46 34 80 00       	push   $0x803446
  80078a:	e8 2e 0c 00 00       	call   8013bd <_panic>

0080078f <fs_init>:
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800795:	e8 c5 f8 ff ff       	call   80005f <ide_probe_disk1>
  80079a:	84 c0                	test   %al,%al
  80079c:	74 41                	je     8007df <fs_init+0x50>
		ide_set_disk(1);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 01                	push   $0x1
  8007a3:	e8 19 f9 ff ff       	call   8000c1 <ide_set_disk>
  8007a8:	83 c4 10             	add    $0x10,%esp
	bc_init();
  8007ab:	e8 9d fc ff ff       	call   80044d <bc_init>
	super = diskaddr(1);
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	6a 01                	push   $0x1
  8007b5:	e8 85 fb ff ff       	call   80033f <diskaddr>
  8007ba:	a3 08 90 80 00       	mov    %eax,0x809008
	check_super();
  8007bf:	e8 37 fe ff ff       	call   8005fb <check_super>
	bitmap = diskaddr(2);
  8007c4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8007cb:	e8 6f fb ff ff       	call   80033f <diskaddr>
  8007d0:	a3 04 90 80 00       	mov    %eax,0x809004
	check_bitmap();
  8007d5:	e8 07 ff ff ff       	call   8006e1 <check_bitmap>
}
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	c9                   	leave  
  8007de:	c3                   	ret    
		ide_set_disk(0);
  8007df:	83 ec 0c             	sub    $0xc,%esp
  8007e2:	6a 00                	push   $0x0
  8007e4:	e8 d8 f8 ff ff       	call   8000c1 <ide_set_disk>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	eb bd                	jmp    8007ab <fs_init+0x1c>

008007ee <file_get_block>:
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	83 ec 0c             	sub    $0xc,%esp
       panic("file_get_block not implemented");
  8007f4:	68 18 35 80 00       	push   $0x803518
  8007f9:	68 99 00 00 00       	push   $0x99
  8007fe:	68 46 34 80 00       	push   $0x803446
  800803:	e8 b5 0b 00 00       	call   8013bd <_panic>

00800808 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  800811:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800817:	50                   	push   %eax
  800818:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80081e:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	e8 36 fc ff ff       	call   800462 <walk_path>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 7e                	je     8008b1 <file_create+0xa9>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  800833:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800836:	75 0a                	jne    800842 <file_create+0x3a>
  800838:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  80083e:	85 d2                	test   %edx,%edx
  800840:	75 02                	jne    800844 <file_create+0x3c>

	strcpy(f->f_name, name);
	*pf = f;
	file_flush(dir);
	return 0;
}
  800842:	c9                   	leave  
  800843:	c3                   	ret    
	assert((dir->f_size % BLKSIZE) == 0);
  800844:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
  80084a:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80084f:	75 25                	jne    800876 <file_create+0x6e>
	for (i = 0; i < nblock; i++) {
  800851:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  800857:	81 f9 fe 1f 00 00    	cmp    $0x1ffe,%ecx
  80085d:	76 30                	jbe    80088f <file_create+0x87>
       panic("file_get_block not implemented");
  80085f:	83 ec 04             	sub    $0x4,%esp
  800862:	68 18 35 80 00       	push   $0x803518
  800867:	68 99 00 00 00       	push   $0x99
  80086c:	68 46 34 80 00       	push   $0x803446
  800871:	e8 47 0b 00 00       	call   8013bd <_panic>
	assert((dir->f_size % BLKSIZE) == 0);
  800876:	68 29 34 80 00       	push   $0x803429
  80087b:	68 1d 33 80 00       	push   $0x80331d
  800880:	68 c4 00 00 00       	push   $0xc4
  800885:	68 46 34 80 00       	push   $0x803446
  80088a:	e8 2e 0b 00 00       	call   8013bd <_panic>
	dir->f_size += BLKSIZE;
  80088f:	05 00 10 00 00       	add    $0x1000,%eax
  800894:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
       panic("file_get_block not implemented");
  80089a:	83 ec 04             	sub    $0x4,%esp
  80089d:	68 18 35 80 00       	push   $0x803518
  8008a2:	68 99 00 00 00       	push   $0x99
  8008a7:	68 46 34 80 00       	push   $0x803446
  8008ac:	e8 0c 0b 00 00       	call   8013bd <_panic>
		return -E_FILE_EXISTS;
  8008b1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8008b6:	eb 8a                	jmp    800842 <file_create+0x3a>

008008b8 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  8008be:	6a 00                	push   $0x0
  8008c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	e8 92 fb ff ff       	call   800462 <walk_path>
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008db:	8b 55 14             	mov    0x14(%ebp),%edx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  8008e7:	39 d0                	cmp    %edx,%eax
  8008e9:	7e 27                	jle    800912 <file_read+0x40>
		return 0;

	count = MIN(count, f->f_size - offset);
  8008eb:	29 d0                	sub    %edx,%eax
  8008ed:	39 c8                	cmp    %ecx,%eax
  8008ef:	0f 47 c1             	cmova  %ecx,%eax

	for (pos = offset; pos < offset + count; ) {
  8008f2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8008f5:	39 ca                	cmp    %ecx,%edx
  8008f7:	72 02                	jb     8008fb <file_read+0x29>
		pos += bn;
		buf += bn;
	}

	return count;
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    
       panic("file_get_block not implemented");
  8008fb:	83 ec 04             	sub    $0x4,%esp
  8008fe:	68 18 35 80 00       	push   $0x803518
  800903:	68 99 00 00 00       	push   $0x99
  800908:	68 46 34 80 00       	push   $0x803446
  80090d:	e8 ab 0a 00 00       	call   8013bd <_panic>
		return 0;
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
  800917:	eb e0                	jmp    8008f9 <file_read+0x27>

00800919 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	56                   	push   %esi
  80091d:	53                   	push   %ebx
  80091e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800921:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (f->f_size > newsize)
  800924:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  80092a:	39 f0                	cmp    %esi,%eax
  80092c:	7f 1b                	jg     800949 <file_set_size+0x30>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  80092e:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
	flush_block(f);
  800934:	83 ec 0c             	sub    $0xc,%esp
  800937:	53                   	push   %ebx
  800938:	e8 80 fa ff ff       	call   8003bd <flush_block>
	return 0;
}
  80093d:	b8 00 00 00 00       	mov    $0x0,%eax
  800942:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800945:	5b                   	pop    %ebx
  800946:	5e                   	pop    %esi
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800949:	8d 96 fe 1f 00 00    	lea    0x1ffe(%esi),%edx
  80094f:	89 f1                	mov    %esi,%ecx
  800951:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  800957:	0f 49 d1             	cmovns %ecx,%edx
  80095a:	c1 fa 0c             	sar    $0xc,%edx
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  80095d:	8d 88 fe 1f 00 00    	lea    0x1ffe(%eax),%ecx
  800963:	05 ff 0f 00 00       	add    $0xfff,%eax
  800968:	0f 48 c1             	cmovs  %ecx,%eax
  80096b:	c1 f8 0c             	sar    $0xc,%eax
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  80096e:	39 d0                	cmp    %edx,%eax
  800970:	77 27                	ja     800999 <file_set_size+0x80>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800972:	83 fa 0a             	cmp    $0xa,%edx
  800975:	77 b7                	ja     80092e <file_set_size+0x15>
  800977:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  80097d:	85 c0                	test   %eax,%eax
  80097f:	74 ad                	je     80092e <file_set_size+0x15>
		free_block(f->f_indirect);
  800981:	83 ec 0c             	sub    $0xc,%esp
  800984:	50                   	push   %eax
  800985:	e8 04 fd ff ff       	call   80068e <free_block>
		f->f_indirect = 0;
  80098a:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
  800991:	00 00 00 
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	eb 95                	jmp    80092e <file_set_size+0x15>
       panic("file_block_walk not implemented");
  800999:	83 ec 04             	sub    $0x4,%esp
  80099c:	68 38 35 80 00       	push   $0x803538
  8009a1:	68 8a 00 00 00       	push   $0x8a
  8009a6:	68 46 34 80 00       	push   $0x803446
  8009ab:	e8 0d 0a 00 00       	call   8013bd <_panic>

008009b0 <file_write>:
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	57                   	push   %edi
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	83 ec 0c             	sub    $0xc,%esp
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8009bf:	8b 75 14             	mov    0x14(%ebp),%esi
	if (offset + count > f->f_size)
  8009c2:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
  8009c5:	3b 98 80 00 00 00    	cmp    0x80(%eax),%ebx
  8009cb:	77 0e                	ja     8009db <file_write+0x2b>
	for (pos = offset; pos < offset + count; ) {
  8009cd:	39 de                	cmp    %ebx,%esi
  8009cf:	72 1d                	jb     8009ee <file_write+0x3e>
	return count;
  8009d1:	89 f8                	mov    %edi,%eax
}
  8009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009d6:	5b                   	pop    %ebx
  8009d7:	5e                   	pop    %esi
  8009d8:	5f                   	pop    %edi
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    
		if ((r = file_set_size(f, offset + count)) < 0)
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	53                   	push   %ebx
  8009df:	50                   	push   %eax
  8009e0:	e8 34 ff ff ff       	call   800919 <file_set_size>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	85 c0                	test   %eax,%eax
  8009ea:	79 e1                	jns    8009cd <file_write+0x1d>
  8009ec:	eb e5                	jmp    8009d3 <file_write+0x23>
       panic("file_get_block not implemented");
  8009ee:	83 ec 04             	sub    $0x4,%esp
  8009f1:	68 18 35 80 00       	push   $0x803518
  8009f6:	68 99 00 00 00       	push   $0x99
  8009fb:	68 46 34 80 00       	push   $0x803446
  800a00:	e8 b8 09 00 00       	call   8013bd <_panic>

00800a05 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	53                   	push   %ebx
  800a09:	83 ec 04             	sub    $0x4,%esp
  800a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800a0f:	83 bb 80 00 00 00 00 	cmpl   $0x0,0x80(%ebx)
  800a16:	7f 1b                	jg     800a33 <file_flush+0x2e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  800a18:	83 ec 0c             	sub    $0xc,%esp
  800a1b:	53                   	push   %ebx
  800a1c:	e8 9c f9 ff ff       	call   8003bd <flush_block>
	if (f->f_indirect)
  800a21:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	85 c0                	test   %eax,%eax
  800a2c:	75 1c                	jne    800a4a <file_flush+0x45>
		flush_block(diskaddr(f->f_indirect));
}
  800a2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    
       panic("file_block_walk not implemented");
  800a33:	83 ec 04             	sub    $0x4,%esp
  800a36:	68 38 35 80 00       	push   $0x803538
  800a3b:	68 8a 00 00 00       	push   $0x8a
  800a40:	68 46 34 80 00       	push   $0x803446
  800a45:	e8 73 09 00 00       	call   8013bd <_panic>
		flush_block(diskaddr(f->f_indirect));
  800a4a:	83 ec 0c             	sub    $0xc,%esp
  800a4d:	50                   	push   %eax
  800a4e:	e8 ec f8 ff ff       	call   80033f <diskaddr>
  800a53:	89 04 24             	mov    %eax,(%esp)
  800a56:	e8 62 f9 ff ff       	call   8003bd <flush_block>
  800a5b:	83 c4 10             	add    $0x10,%esp
}
  800a5e:	eb ce                	jmp    800a2e <file_flush+0x29>

00800a60 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	53                   	push   %ebx
  800a64:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  800a67:	bb 01 00 00 00       	mov    $0x1,%ebx
  800a6c:	a1 08 90 80 00       	mov    0x809008,%eax
  800a71:	39 58 04             	cmp    %ebx,0x4(%eax)
  800a74:	76 19                	jbe    800a8f <fs_sync+0x2f>
		flush_block(diskaddr(i));
  800a76:	83 ec 0c             	sub    $0xc,%esp
  800a79:	53                   	push   %ebx
  800a7a:	e8 c0 f8 ff ff       	call   80033f <diskaddr>
  800a7f:	89 04 24             	mov    %eax,(%esp)
  800a82:	e8 36 f9 ff ff       	call   8003bd <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  800a87:	83 c3 01             	add    $0x1,%ebx
  800a8a:	83 c4 10             	add    $0x10,%esp
  800a8d:	eb dd                	jmp    800a6c <fs_sync+0xc>
}
  800a8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a92:	c9                   	leave  
  800a93:	c3                   	ret    

00800a94 <serve_read>:
	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:
	return 0;
}
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
  800a99:	c3                   	ret    

00800a9a <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 0c             	sub    $0xc,%esp
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	panic("serve_write not implemented");
  800aa0:	68 58 35 80 00       	push   $0x803558
  800aa5:	68 e8 00 00 00       	push   $0xe8
  800aaa:	68 74 35 80 00       	push   $0x803574
  800aaf:	e8 09 09 00 00       	call   8013bd <_panic>

00800ab4 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  800aba:	e8 a1 ff ff ff       	call   800a60 <fs_sync>
	return 0;
}
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    

00800ac6 <serve_init>:
{
  800ac6:	ba 60 40 80 00       	mov    $0x804060,%edx
	uintptr_t va = FILEVA;
  800acb:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  800ad0:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  800ad5:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  800ad7:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  800ada:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  800ae0:	83 c0 01             	add    $0x1,%eax
  800ae3:	83 c2 10             	add    $0x10,%edx
  800ae6:	3d 00 04 00 00       	cmp    $0x400,%eax
  800aeb:	75 e8                	jne    800ad5 <serve_init+0xf>
}
  800aed:	c3                   	ret    

00800aee <openfile_alloc>:
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	83 ec 0c             	sub    $0xc,%esp
  800af7:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  800afa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aff:	89 de                	mov    %ebx,%esi
  800b01:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  800b04:	83 ec 0c             	sub    $0xc,%esp
  800b07:	ff b6 6c 40 80 00    	pushl  0x80406c(%esi)
  800b0d:	e8 e8 1a 00 00       	call   8025fa <pageref>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	85 c0                	test   %eax,%eax
  800b17:	74 17                	je     800b30 <openfile_alloc+0x42>
  800b19:	83 f8 01             	cmp    $0x1,%eax
  800b1c:	74 30                	je     800b4e <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  800b1e:	83 c3 01             	add    $0x1,%ebx
  800b21:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  800b27:	75 d6                	jne    800aff <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  800b29:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800b2e:	eb 4f                	jmp    800b7f <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  800b30:	83 ec 04             	sub    $0x4,%esp
  800b33:	6a 07                	push   $0x7
  800b35:	89 d8                	mov    %ebx,%eax
  800b37:	c1 e0 04             	shl    $0x4,%eax
  800b3a:	ff b0 6c 40 80 00    	pushl  0x80406c(%eax)
  800b40:	6a 00                	push   $0x0
  800b42:	e8 bd 14 00 00       	call   802004 <sys_page_alloc>
  800b47:	83 c4 10             	add    $0x10,%esp
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	78 31                	js     800b7f <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  800b4e:	c1 e3 04             	shl    $0x4,%ebx
  800b51:	81 83 60 40 80 00 00 	addl   $0x400,0x804060(%ebx)
  800b58:	04 00 00 
			*o = &opentab[i];
  800b5b:	81 c6 60 40 80 00    	add    $0x804060,%esi
  800b61:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 00 10 00 00       	push   $0x1000
  800b6b:	6a 00                	push   $0x0
  800b6d:	ff b3 6c 40 80 00    	pushl  0x80406c(%ebx)
  800b73:	e8 e0 11 00 00       	call   801d58 <memset>
			return (*o)->o_fileid;
  800b78:	8b 07                	mov    (%edi),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 c4 10             	add    $0x10,%esp
}
  800b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <openfile_lookup>:
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	83 ec 18             	sub    $0x18,%esp
  800b90:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  800b93:	89 fb                	mov    %edi,%ebx
  800b95:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800b9b:	89 de                	mov    %ebx,%esi
  800b9d:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  800ba0:	ff b6 6c 40 80 00    	pushl  0x80406c(%esi)
	o = &opentab[fileid % MAXOPEN];
  800ba6:	81 c6 60 40 80 00    	add    $0x804060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  800bac:	e8 49 1a 00 00       	call   8025fa <pageref>
  800bb1:	83 c4 10             	add    $0x10,%esp
  800bb4:	83 f8 01             	cmp    $0x1,%eax
  800bb7:	7e 1d                	jle    800bd6 <openfile_lookup+0x4f>
  800bb9:	c1 e3 04             	shl    $0x4,%ebx
  800bbc:	39 bb 60 40 80 00    	cmp    %edi,0x804060(%ebx)
  800bc2:	75 19                	jne    800bdd <openfile_lookup+0x56>
	*po = o;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 30                	mov    %esi,(%eax)
	return 0;
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    
		return -E_INVAL;
  800bd6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bdb:	eb f1                	jmp    800bce <openfile_lookup+0x47>
  800bdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800be2:	eb ea                	jmp    800bce <openfile_lookup+0x47>

00800be4 <serve_set_size>:
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	53                   	push   %ebx
  800be8:	83 ec 18             	sub    $0x18,%esp
  800beb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800bee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bf1:	50                   	push   %eax
  800bf2:	ff 33                	pushl  (%ebx)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 8b ff ff ff       	call   800b87 <openfile_lookup>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	85 c0                	test   %eax,%eax
  800c01:	78 14                	js     800c17 <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 73 04             	pushl  0x4(%ebx)
  800c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c0c:	ff 70 04             	pushl  0x4(%eax)
  800c0f:	e8 05 fd ff ff       	call   800919 <file_set_size>
  800c14:	83 c4 10             	add    $0x10,%esp
}
  800c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <serve_stat>:
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	53                   	push   %ebx
  800c20:	83 ec 18             	sub    $0x18,%esp
  800c23:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c29:	50                   	push   %eax
  800c2a:	ff 33                	pushl  (%ebx)
  800c2c:	ff 75 08             	pushl  0x8(%ebp)
  800c2f:	e8 53 ff ff ff       	call   800b87 <openfile_lookup>
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	85 c0                	test   %eax,%eax
  800c39:	78 3f                	js     800c7a <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c41:	ff 70 04             	pushl  0x4(%eax)
  800c44:	53                   	push   %ebx
  800c45:	e8 c8 0f 00 00       	call   801c12 <strcpy>
	ret->ret_size = o->o_file->f_size;
  800c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c4d:	8b 50 04             	mov    0x4(%eax),%edx
  800c50:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  800c56:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  800c5c:	8b 40 04             	mov    0x4(%eax),%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c69:	0f 94 c0             	sete   %al
  800c6c:	0f b6 c0             	movzbl %al,%eax
  800c6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <serve_flush>:
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800c85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	ff 30                	pushl  (%eax)
  800c8e:	ff 75 08             	pushl  0x8(%ebp)
  800c91:	e8 f1 fe ff ff       	call   800b87 <openfile_lookup>
  800c96:	83 c4 10             	add    $0x10,%esp
  800c99:	85 c0                	test   %eax,%eax
  800c9b:	78 16                	js     800cb3 <serve_flush+0x34>
	file_flush(o->o_file);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca3:	ff 70 04             	pushl  0x4(%eax)
  800ca6:	e8 5a fd ff ff       	call   800a05 <file_flush>
	return 0;
  800cab:	83 c4 10             	add    $0x10,%esp
  800cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <serve_open>:
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	53                   	push   %ebx
  800cb9:	81 ec 18 04 00 00    	sub    $0x418,%esp
  800cbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  800cc2:	68 00 04 00 00       	push   $0x400
  800cc7:	53                   	push   %ebx
  800cc8:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800cce:	50                   	push   %eax
  800ccf:	e8 cc 10 00 00       	call   801da0 <memmove>
	path[MAXPATHLEN-1] = 0;
  800cd4:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  800cd8:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800cde:	89 04 24             	mov    %eax,(%esp)
  800ce1:	e8 08 fe ff ff       	call   800aee <openfile_alloc>
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	0f 88 f0 00 00 00    	js     800de1 <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  800cf1:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  800cf8:	74 33                	je     800d2d <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  800d03:	50                   	push   %eax
  800d04:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800d0a:	50                   	push   %eax
  800d0b:	e8 f8 fa ff ff       	call   800808 <file_create>
  800d10:	83 c4 10             	add    $0x10,%esp
  800d13:	85 c0                	test   %eax,%eax
  800d15:	79 37                	jns    800d4e <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  800d17:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  800d1e:	0f 85 bd 00 00 00    	jne    800de1 <serve_open+0x12c>
  800d24:	83 f8 f3             	cmp    $0xfffffff3,%eax
  800d27:	0f 85 b4 00 00 00    	jne    800de1 <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  800d36:	50                   	push   %eax
  800d37:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800d3d:	50                   	push   %eax
  800d3e:	e8 75 fb ff ff       	call   8008b8 <file_open>
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	85 c0                	test   %eax,%eax
  800d48:	0f 88 93 00 00 00    	js     800de1 <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  800d4e:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  800d55:	74 17                	je     800d6e <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	6a 00                	push   $0x0
  800d5c:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  800d62:	e8 b2 fb ff ff       	call   800919 <file_set_size>
  800d67:	83 c4 10             	add    $0x10,%esp
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	78 73                	js     800de1 <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  800d6e:	83 ec 08             	sub    $0x8,%esp
  800d71:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  800d77:	50                   	push   %eax
  800d78:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800d7e:	50                   	push   %eax
  800d7f:	e8 34 fb ff ff       	call   8008b8 <file_open>
  800d84:	83 c4 10             	add    $0x10,%esp
  800d87:	85 c0                	test   %eax,%eax
  800d89:	78 56                	js     800de1 <serve_open+0x12c>
	o->o_file = f;
  800d8b:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  800d91:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  800d97:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  800d9a:	8b 50 0c             	mov    0xc(%eax),%edx
  800d9d:	8b 08                	mov    (%eax),%ecx
  800d9f:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  800da2:	8b 48 0c             	mov    0xc(%eax),%ecx
  800da5:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  800dab:	83 e2 03             	and    $0x3,%edx
  800dae:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  800db1:	8b 40 0c             	mov    0xc(%eax),%eax
  800db4:	8b 15 64 80 80 00    	mov    0x808064,%edx
  800dba:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  800dbc:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  800dc2:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  800dc8:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  800dcb:	8b 50 0c             	mov    0xc(%eax),%edx
  800dce:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd1:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  800ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800de4:	c9                   	leave  
  800de5:	c3                   	ret    

00800de6 <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800dee:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800df1:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800df4:	e9 82 00 00 00       	jmp    800e7b <serve+0x95>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  800df9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  800e00:	83 f8 01             	cmp    $0x1,%eax
  800e03:	74 23                	je     800e28 <serve+0x42>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  800e05:	83 f8 08             	cmp    $0x8,%eax
  800e08:	77 36                	ja     800e40 <serve+0x5a>
  800e0a:	8b 14 85 20 40 80 00 	mov    0x804020(,%eax,4),%edx
  800e11:	85 d2                	test   %edx,%edx
  800e13:	74 2b                	je     800e40 <serve+0x5a>
			r = handlers[req](whom, fsreq);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 35 44 40 80 00    	pushl  0x804044
  800e1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e21:	ff d2                	call   *%edx
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	eb 31                	jmp    800e59 <serve+0x73>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  800e28:	53                   	push   %ebx
  800e29:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e2c:	50                   	push   %eax
  800e2d:	ff 35 44 40 80 00    	pushl  0x804044
  800e33:	ff 75 f4             	pushl  -0xc(%ebp)
  800e36:	e8 7a fe ff ff       	call   800cb5 <serve_open>
  800e3b:	83 c4 10             	add    $0x10,%esp
  800e3e:	eb 19                	jmp    800e59 <serve+0x73>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  800e40:	83 ec 04             	sub    $0x4,%esp
  800e43:	ff 75 f4             	pushl  -0xc(%ebp)
  800e46:	50                   	push   %eax
  800e47:	68 d0 35 80 00       	push   $0x8035d0
  800e4c:	e8 62 06 00 00       	call   8014b3 <cprintf>
  800e51:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  800e54:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  800e59:	ff 75 f0             	pushl  -0x10(%ebp)
  800e5c:	ff 75 ec             	pushl  -0x14(%ebp)
  800e5f:	50                   	push   %eax
  800e60:	ff 75 f4             	pushl  -0xc(%ebp)
  800e63:	e8 cc 14 00 00       	call   802334 <ipc_send>
		sys_page_unmap(0, fsreq);
  800e68:	83 c4 08             	add    $0x8,%esp
  800e6b:	ff 35 44 40 80 00    	pushl  0x804044
  800e71:	6a 00                	push   $0x0
  800e73:	e8 11 12 00 00       	call   802089 <sys_page_unmap>
  800e78:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  800e7b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	53                   	push   %ebx
  800e86:	ff 35 44 40 80 00    	pushl  0x804044
  800e8c:	56                   	push   %esi
  800e8d:	e8 39 14 00 00       	call   8022cb <ipc_recv>
		if (!(perm & PTE_P)) {
  800e92:	83 c4 10             	add    $0x10,%esp
  800e95:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  800e99:	0f 85 5a ff ff ff    	jne    800df9 <serve+0x13>
			cprintf("Invalid request from %08x: no argument page\n",
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea5:	68 a0 35 80 00       	push   $0x8035a0
  800eaa:	e8 04 06 00 00       	call   8014b3 <cprintf>
			continue; // just leave it hanging...
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	eb c7                	jmp    800e7b <serve+0x95>

00800eb4 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  800eba:	c7 05 60 80 80 00 7e 	movl   $0x80357e,0x808060
  800ec1:	35 80 00 
	cprintf("FS is running\n");
  800ec4:	68 81 35 80 00       	push   $0x803581
  800ec9:	e8 e5 05 00 00       	call   8014b3 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  800ece:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  800ed3:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  800ed8:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  800eda:	c7 04 24 90 35 80 00 	movl   $0x803590,(%esp)
  800ee1:	e8 cd 05 00 00       	call   8014b3 <cprintf>

	serve_init();
  800ee6:	e8 db fb ff ff       	call   800ac6 <serve_init>
	fs_init();
  800eeb:	e8 9f f8 ff ff       	call   80078f <fs_init>
        fs_test();
  800ef0:	e8 05 00 00 00       	call   800efa <fs_test>
	serve();
  800ef5:	e8 ec fe ff ff       	call   800de6 <serve>

00800efa <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	53                   	push   %ebx
  800efe:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  800f01:	6a 07                	push   $0x7
  800f03:	68 00 10 00 00       	push   $0x1000
  800f08:	6a 00                	push   $0x0
  800f0a:	e8 f5 10 00 00       	call   802004 <sys_page_alloc>
  800f0f:	83 c4 10             	add    $0x10,%esp
  800f12:	85 c0                	test   %eax,%eax
  800f14:	0f 88 68 02 00 00    	js     801182 <fs_test+0x288>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  800f1a:	83 ec 04             	sub    $0x4,%esp
  800f1d:	68 00 10 00 00       	push   $0x1000
  800f22:	ff 35 04 90 80 00    	pushl  0x809004
  800f28:	68 00 10 00 00       	push   $0x1000
  800f2d:	e8 6e 0e 00 00       	call   801da0 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  800f32:	e8 93 f7 ff ff       	call   8006ca <alloc_block>
  800f37:	83 c4 10             	add    $0x10,%esp
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	0f 88 52 02 00 00    	js     801194 <fs_test+0x29a>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  800f42:	8d 50 1f             	lea    0x1f(%eax),%edx
  800f45:	0f 49 d0             	cmovns %eax,%edx
  800f48:	c1 fa 05             	sar    $0x5,%edx
  800f4b:	89 c3                	mov    %eax,%ebx
  800f4d:	c1 fb 1f             	sar    $0x1f,%ebx
  800f50:	c1 eb 1b             	shr    $0x1b,%ebx
  800f53:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  800f56:	83 e1 1f             	and    $0x1f,%ecx
  800f59:	29 d9                	sub    %ebx,%ecx
  800f5b:	b8 01 00 00 00       	mov    $0x1,%eax
  800f60:	d3 e0                	shl    %cl,%eax
  800f62:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  800f69:	0f 84 37 02 00 00    	je     8011a6 <fs_test+0x2ac>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  800f6f:	8b 0d 04 90 80 00    	mov    0x809004,%ecx
  800f75:	85 04 91             	test   %eax,(%ecx,%edx,4)
  800f78:	0f 85 3e 02 00 00    	jne    8011bc <fs_test+0x2c2>
	cprintf("alloc_block is good\n");
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	68 3b 36 80 00       	push   $0x80363b
  800f86:	e8 28 05 00 00       	call   8014b3 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  800f8b:	83 c4 08             	add    $0x8,%esp
  800f8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f91:	50                   	push   %eax
  800f92:	68 50 36 80 00       	push   $0x803650
  800f97:	e8 1c f9 ff ff       	call   8008b8 <file_open>
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800fa2:	74 08                	je     800fac <fs_test+0xb2>
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	0f 88 26 02 00 00    	js     8011d2 <fs_test+0x2d8>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	0f 84 30 02 00 00    	je     8011e4 <fs_test+0x2ea>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fba:	50                   	push   %eax
  800fbb:	68 74 36 80 00       	push   $0x803674
  800fc0:	e8 f3 f8 ff ff       	call   8008b8 <file_open>
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	0f 88 28 02 00 00    	js     8011f8 <fs_test+0x2fe>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  800fd0:	83 ec 0c             	sub    $0xc,%esp
  800fd3:	68 94 36 80 00       	push   $0x803694
  800fd8:	e8 d6 04 00 00       	call   8014b3 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  800fdd:	83 c4 0c             	add    $0xc,%esp
  800fe0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800fe3:	50                   	push   %eax
  800fe4:	6a 00                	push   $0x0
  800fe6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe9:	e8 00 f8 ff ff       	call   8007ee <file_get_block>
  800fee:	83 c4 10             	add    $0x10,%esp
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	0f 88 11 02 00 00    	js     80120a <fs_test+0x310>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	68 d8 37 80 00       	push   $0x8037d8
  801001:	ff 75 f0             	pushl  -0x10(%ebp)
  801004:	e8 b4 0c 00 00       	call   801cbd <strcmp>
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	0f 85 08 02 00 00    	jne    80121c <fs_test+0x322>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	68 ba 36 80 00       	push   $0x8036ba
  80101c:	e8 92 04 00 00       	call   8014b3 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801024:	0f b6 10             	movzbl (%eax),%edx
  801027:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102c:	c1 e8 0c             	shr    $0xc,%eax
  80102f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	a8 40                	test   $0x40,%al
  80103b:	0f 84 ef 01 00 00    	je     801230 <fs_test+0x336>
	file_flush(f);
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	ff 75 f4             	pushl  -0xc(%ebp)
  801047:	e8 b9 f9 ff ff       	call   800a05 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80104c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104f:	c1 e8 0c             	shr    $0xc,%eax
  801052:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	a8 40                	test   $0x40,%al
  80105e:	0f 85 e2 01 00 00    	jne    801246 <fs_test+0x34c>
	cprintf("file_flush is good\n");
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	68 ee 36 80 00       	push   $0x8036ee
  80106c:	e8 42 04 00 00       	call   8014b3 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801071:	83 c4 08             	add    $0x8,%esp
  801074:	6a 00                	push   $0x0
  801076:	ff 75 f4             	pushl  -0xc(%ebp)
  801079:	e8 9b f8 ff ff       	call   800919 <file_set_size>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	85 c0                	test   %eax,%eax
  801083:	0f 88 d3 01 00 00    	js     80125c <fs_test+0x362>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  801089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108c:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801093:	0f 85 d5 01 00 00    	jne    80126e <fs_test+0x374>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801099:	c1 e8 0c             	shr    $0xc,%eax
  80109c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a3:	a8 40                	test   $0x40,%al
  8010a5:	0f 85 d9 01 00 00    	jne    801284 <fs_test+0x38a>
	cprintf("file_truncate is good\n");
  8010ab:	83 ec 0c             	sub    $0xc,%esp
  8010ae:	68 42 37 80 00       	push   $0x803742
  8010b3:	e8 fb 03 00 00       	call   8014b3 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8010b8:	c7 04 24 d8 37 80 00 	movl   $0x8037d8,(%esp)
  8010bf:	e8 15 0b 00 00       	call   801bd9 <strlen>
  8010c4:	83 c4 08             	add    $0x8,%esp
  8010c7:	50                   	push   %eax
  8010c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010cb:	e8 49 f8 ff ff       	call   800919 <file_set_size>
  8010d0:	83 c4 10             	add    $0x10,%esp
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	0f 88 bf 01 00 00    	js     80129a <fs_test+0x3a0>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8010db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010de:	89 c2                	mov    %eax,%edx
  8010e0:	c1 ea 0c             	shr    $0xc,%edx
  8010e3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ea:	f6 c2 40             	test   $0x40,%dl
  8010ed:	0f 85 b9 01 00 00    	jne    8012ac <fs_test+0x3b2>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8010f3:	83 ec 04             	sub    $0x4,%esp
  8010f6:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8010f9:	52                   	push   %edx
  8010fa:	6a 00                	push   $0x0
  8010fc:	50                   	push   %eax
  8010fd:	e8 ec f6 ff ff       	call   8007ee <file_get_block>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	85 c0                	test   %eax,%eax
  801107:	0f 88 b5 01 00 00    	js     8012c2 <fs_test+0x3c8>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	68 d8 37 80 00       	push   $0x8037d8
  801115:	ff 75 f0             	pushl  -0x10(%ebp)
  801118:	e8 f5 0a 00 00       	call   801c12 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80111d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801120:	c1 e8 0c             	shr    $0xc,%eax
  801123:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80112a:	83 c4 10             	add    $0x10,%esp
  80112d:	a8 40                	test   $0x40,%al
  80112f:	0f 84 9f 01 00 00    	je     8012d4 <fs_test+0x3da>
	file_flush(f);
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	ff 75 f4             	pushl  -0xc(%ebp)
  80113b:	e8 c5 f8 ff ff       	call   800a05 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801143:	c1 e8 0c             	shr    $0xc,%eax
  801146:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80114d:	83 c4 10             	add    $0x10,%esp
  801150:	a8 40                	test   $0x40,%al
  801152:	0f 85 92 01 00 00    	jne    8012ea <fs_test+0x3f0>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115b:	c1 e8 0c             	shr    $0xc,%eax
  80115e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801165:	a8 40                	test   $0x40,%al
  801167:	0f 85 93 01 00 00    	jne    801300 <fs_test+0x406>
	cprintf("file rewrite is good\n");
  80116d:	83 ec 0c             	sub    $0xc,%esp
  801170:	68 82 37 80 00       	push   $0x803782
  801175:	e8 39 03 00 00       	call   8014b3 <cprintf>
}
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801180:	c9                   	leave  
  801181:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801182:	50                   	push   %eax
  801183:	68 f3 35 80 00       	push   $0x8035f3
  801188:	6a 12                	push   $0x12
  80118a:	68 06 36 80 00       	push   $0x803606
  80118f:	e8 29 02 00 00       	call   8013bd <_panic>
		panic("alloc_block: %e", r);
  801194:	50                   	push   %eax
  801195:	68 10 36 80 00       	push   $0x803610
  80119a:	6a 17                	push   $0x17
  80119c:	68 06 36 80 00       	push   $0x803606
  8011a1:	e8 17 02 00 00       	call   8013bd <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  8011a6:	68 20 36 80 00       	push   $0x803620
  8011ab:	68 1d 33 80 00       	push   $0x80331d
  8011b0:	6a 19                	push   $0x19
  8011b2:	68 06 36 80 00       	push   $0x803606
  8011b7:	e8 01 02 00 00       	call   8013bd <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8011bc:	68 98 37 80 00       	push   $0x803798
  8011c1:	68 1d 33 80 00       	push   $0x80331d
  8011c6:	6a 1b                	push   $0x1b
  8011c8:	68 06 36 80 00       	push   $0x803606
  8011cd:	e8 eb 01 00 00       	call   8013bd <_panic>
		panic("file_open /not-found: %e", r);
  8011d2:	50                   	push   %eax
  8011d3:	68 5b 36 80 00       	push   $0x80365b
  8011d8:	6a 1f                	push   $0x1f
  8011da:	68 06 36 80 00       	push   $0x803606
  8011df:	e8 d9 01 00 00       	call   8013bd <_panic>
		panic("file_open /not-found succeeded!");
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	68 b8 37 80 00       	push   $0x8037b8
  8011ec:	6a 21                	push   $0x21
  8011ee:	68 06 36 80 00       	push   $0x803606
  8011f3:	e8 c5 01 00 00       	call   8013bd <_panic>
		panic("file_open /newmotd: %e", r);
  8011f8:	50                   	push   %eax
  8011f9:	68 7d 36 80 00       	push   $0x80367d
  8011fe:	6a 23                	push   $0x23
  801200:	68 06 36 80 00       	push   $0x803606
  801205:	e8 b3 01 00 00       	call   8013bd <_panic>
		panic("file_get_block: %e", r);
  80120a:	50                   	push   %eax
  80120b:	68 a7 36 80 00       	push   $0x8036a7
  801210:	6a 27                	push   $0x27
  801212:	68 06 36 80 00       	push   $0x803606
  801217:	e8 a1 01 00 00       	call   8013bd <_panic>
		panic("file_get_block returned wrong data");
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	68 00 38 80 00       	push   $0x803800
  801224:	6a 29                	push   $0x29
  801226:	68 06 36 80 00       	push   $0x803606
  80122b:	e8 8d 01 00 00       	call   8013bd <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801230:	68 d3 36 80 00       	push   $0x8036d3
  801235:	68 1d 33 80 00       	push   $0x80331d
  80123a:	6a 2d                	push   $0x2d
  80123c:	68 06 36 80 00       	push   $0x803606
  801241:	e8 77 01 00 00       	call   8013bd <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801246:	68 d2 36 80 00       	push   $0x8036d2
  80124b:	68 1d 33 80 00       	push   $0x80331d
  801250:	6a 2f                	push   $0x2f
  801252:	68 06 36 80 00       	push   $0x803606
  801257:	e8 61 01 00 00       	call   8013bd <_panic>
		panic("file_set_size: %e", r);
  80125c:	50                   	push   %eax
  80125d:	68 02 37 80 00       	push   $0x803702
  801262:	6a 33                	push   $0x33
  801264:	68 06 36 80 00       	push   $0x803606
  801269:	e8 4f 01 00 00       	call   8013bd <_panic>
	assert(f->f_direct[0] == 0);
  80126e:	68 14 37 80 00       	push   $0x803714
  801273:	68 1d 33 80 00       	push   $0x80331d
  801278:	6a 34                	push   $0x34
  80127a:	68 06 36 80 00       	push   $0x803606
  80127f:	e8 39 01 00 00       	call   8013bd <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801284:	68 28 37 80 00       	push   $0x803728
  801289:	68 1d 33 80 00       	push   $0x80331d
  80128e:	6a 35                	push   $0x35
  801290:	68 06 36 80 00       	push   $0x803606
  801295:	e8 23 01 00 00       	call   8013bd <_panic>
		panic("file_set_size 2: %e", r);
  80129a:	50                   	push   %eax
  80129b:	68 59 37 80 00       	push   $0x803759
  8012a0:	6a 39                	push   $0x39
  8012a2:	68 06 36 80 00       	push   $0x803606
  8012a7:	e8 11 01 00 00       	call   8013bd <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8012ac:	68 28 37 80 00       	push   $0x803728
  8012b1:	68 1d 33 80 00       	push   $0x80331d
  8012b6:	6a 3a                	push   $0x3a
  8012b8:	68 06 36 80 00       	push   $0x803606
  8012bd:	e8 fb 00 00 00       	call   8013bd <_panic>
		panic("file_get_block 2: %e", r);
  8012c2:	50                   	push   %eax
  8012c3:	68 6d 37 80 00       	push   $0x80376d
  8012c8:	6a 3c                	push   $0x3c
  8012ca:	68 06 36 80 00       	push   $0x803606
  8012cf:	e8 e9 00 00 00       	call   8013bd <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8012d4:	68 d3 36 80 00       	push   $0x8036d3
  8012d9:	68 1d 33 80 00       	push   $0x80331d
  8012de:	6a 3e                	push   $0x3e
  8012e0:	68 06 36 80 00       	push   $0x803606
  8012e5:	e8 d3 00 00 00       	call   8013bd <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8012ea:	68 d2 36 80 00       	push   $0x8036d2
  8012ef:	68 1d 33 80 00       	push   $0x80331d
  8012f4:	6a 40                	push   $0x40
  8012f6:	68 06 36 80 00       	push   $0x803606
  8012fb:	e8 bd 00 00 00       	call   8013bd <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801300:	68 28 37 80 00       	push   $0x803728
  801305:	68 1d 33 80 00       	push   $0x80331d
  80130a:	6a 41                	push   $0x41
  80130c:	68 06 36 80 00       	push   $0x803606
  801311:	e8 a7 00 00 00       	call   8013bd <_panic>

00801316 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80131f:	c7 05 0c 90 80 00 00 	movl   $0x0,0x80900c
  801326:	00 00 00 
	envid_t find = sys_getenvid();
  801329:	e8 98 0c 00 00       	call   801fc6 <sys_getenvid>
  80132e:	8b 1d 0c 90 80 00    	mov    0x80900c,%ebx
  801334:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  801339:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80133e:	bf 01 00 00 00       	mov    $0x1,%edi
  801343:	eb 0b                	jmp    801350 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  801345:	83 c2 01             	add    $0x1,%edx
  801348:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80134e:	74 21                	je     801371 <libmain+0x5b>
		if(envs[i].env_id == find)
  801350:	89 d1                	mov    %edx,%ecx
  801352:	c1 e1 07             	shl    $0x7,%ecx
  801355:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80135b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80135e:	39 c1                	cmp    %eax,%ecx
  801360:	75 e3                	jne    801345 <libmain+0x2f>
  801362:	89 d3                	mov    %edx,%ebx
  801364:	c1 e3 07             	shl    $0x7,%ebx
  801367:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80136d:	89 fe                	mov    %edi,%esi
  80136f:	eb d4                	jmp    801345 <libmain+0x2f>
  801371:	89 f0                	mov    %esi,%eax
  801373:	84 c0                	test   %al,%al
  801375:	74 06                	je     80137d <libmain+0x67>
  801377:	89 1d 0c 90 80 00    	mov    %ebx,0x80900c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80137d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801381:	7e 0a                	jle    80138d <libmain+0x77>
		binaryname = argv[0];
  801383:	8b 45 0c             	mov    0xc(%ebp),%eax
  801386:	8b 00                	mov    (%eax),%eax
  801388:	a3 60 80 80 00       	mov    %eax,0x808060

	// call user main routine
	umain(argc, argv);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	ff 75 08             	pushl  0x8(%ebp)
  801396:	e8 19 fb ff ff       	call   800eb4 <umain>

	// exit gracefully
	exit();
  80139b:	e8 0b 00 00 00       	call   8013ab <exit>
}
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a6:	5b                   	pop    %ebx
  8013a7:	5e                   	pop    %esi
  8013a8:	5f                   	pop    %edi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	e8 cd 0b 00 00       	call   801f85 <sys_env_destroy>
}
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	56                   	push   %esi
  8013c1:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8013c2:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8013c7:	8b 40 48             	mov    0x48(%eax),%eax
  8013ca:	83 ec 04             	sub    $0x4,%esp
  8013cd:	68 5c 38 80 00       	push   $0x80385c
  8013d2:	50                   	push   %eax
  8013d3:	68 2d 38 80 00       	push   $0x80382d
  8013d8:	e8 d6 00 00 00       	call   8014b3 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8013dd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8013e0:	8b 35 60 80 80 00    	mov    0x808060,%esi
  8013e6:	e8 db 0b 00 00       	call   801fc6 <sys_getenvid>
  8013eb:	83 c4 04             	add    $0x4,%esp
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	ff 75 08             	pushl  0x8(%ebp)
  8013f4:	56                   	push   %esi
  8013f5:	50                   	push   %eax
  8013f6:	68 38 38 80 00       	push   $0x803838
  8013fb:	e8 b3 00 00 00       	call   8014b3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801400:	83 c4 18             	add    $0x18,%esp
  801403:	53                   	push   %ebx
  801404:	ff 75 10             	pushl  0x10(%ebp)
  801407:	e8 56 00 00 00       	call   801462 <vcprintf>
	cprintf("\n");
  80140c:	c7 04 24 27 34 80 00 	movl   $0x803427,(%esp)
  801413:	e8 9b 00 00 00       	call   8014b3 <cprintf>
  801418:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80141b:	cc                   	int3   
  80141c:	eb fd                	jmp    80141b <_panic+0x5e>

0080141e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	53                   	push   %ebx
  801422:	83 ec 04             	sub    $0x4,%esp
  801425:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801428:	8b 13                	mov    (%ebx),%edx
  80142a:	8d 42 01             	lea    0x1(%edx),%eax
  80142d:	89 03                	mov    %eax,(%ebx)
  80142f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801432:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801436:	3d ff 00 00 00       	cmp    $0xff,%eax
  80143b:	74 09                	je     801446 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80143d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801444:	c9                   	leave  
  801445:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	68 ff 00 00 00       	push   $0xff
  80144e:	8d 43 08             	lea    0x8(%ebx),%eax
  801451:	50                   	push   %eax
  801452:	e8 f1 0a 00 00       	call   801f48 <sys_cputs>
		b->idx = 0;
  801457:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	eb db                	jmp    80143d <putch+0x1f>

00801462 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80146b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801472:	00 00 00 
	b.cnt = 0;
  801475:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80147c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80147f:	ff 75 0c             	pushl  0xc(%ebp)
  801482:	ff 75 08             	pushl  0x8(%ebp)
  801485:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	68 1e 14 80 00       	push   $0x80141e
  801491:	e8 4a 01 00 00       	call   8015e0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801496:	83 c4 08             	add    $0x8,%esp
  801499:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80149f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8014a5:	50                   	push   %eax
  8014a6:	e8 9d 0a 00 00       	call   801f48 <sys_cputs>

	return b.cnt;
}
  8014ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8014b9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8014bc:	50                   	push   %eax
  8014bd:	ff 75 08             	pushl  0x8(%ebp)
  8014c0:	e8 9d ff ff ff       	call   801462 <vcprintf>
	va_end(ap);

	return cnt;
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	57                   	push   %edi
  8014cb:	56                   	push   %esi
  8014cc:	53                   	push   %ebx
  8014cd:	83 ec 1c             	sub    $0x1c,%esp
  8014d0:	89 c6                	mov    %eax,%esi
  8014d2:	89 d7                	mov    %edx,%edi
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8014e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8014e6:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8014ea:	74 2c                	je     801518 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8014ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8014f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014f9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8014fc:	39 c2                	cmp    %eax,%edx
  8014fe:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  801501:	73 43                	jae    801546 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  801503:	83 eb 01             	sub    $0x1,%ebx
  801506:	85 db                	test   %ebx,%ebx
  801508:	7e 6c                	jle    801576 <printnum+0xaf>
				putch(padc, putdat);
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	57                   	push   %edi
  80150e:	ff 75 18             	pushl  0x18(%ebp)
  801511:	ff d6                	call   *%esi
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	eb eb                	jmp    801503 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  801518:	83 ec 0c             	sub    $0xc,%esp
  80151b:	6a 20                	push   $0x20
  80151d:	6a 00                	push   $0x0
  80151f:	50                   	push   %eax
  801520:	ff 75 e4             	pushl  -0x1c(%ebp)
  801523:	ff 75 e0             	pushl  -0x20(%ebp)
  801526:	89 fa                	mov    %edi,%edx
  801528:	89 f0                	mov    %esi,%eax
  80152a:	e8 98 ff ff ff       	call   8014c7 <printnum>
		while (--width > 0)
  80152f:	83 c4 20             	add    $0x20,%esp
  801532:	83 eb 01             	sub    $0x1,%ebx
  801535:	85 db                	test   %ebx,%ebx
  801537:	7e 65                	jle    80159e <printnum+0xd7>
			putch(padc, putdat);
  801539:	83 ec 08             	sub    $0x8,%esp
  80153c:	57                   	push   %edi
  80153d:	6a 20                	push   $0x20
  80153f:	ff d6                	call   *%esi
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	eb ec                	jmp    801532 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	ff 75 18             	pushl  0x18(%ebp)
  80154c:	83 eb 01             	sub    $0x1,%ebx
  80154f:	53                   	push   %ebx
  801550:	50                   	push   %eax
  801551:	83 ec 08             	sub    $0x8,%esp
  801554:	ff 75 dc             	pushl  -0x24(%ebp)
  801557:	ff 75 d8             	pushl  -0x28(%ebp)
  80155a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80155d:	ff 75 e0             	pushl  -0x20(%ebp)
  801560:	e8 2b 1b 00 00       	call   803090 <__udivdi3>
  801565:	83 c4 18             	add    $0x18,%esp
  801568:	52                   	push   %edx
  801569:	50                   	push   %eax
  80156a:	89 fa                	mov    %edi,%edx
  80156c:	89 f0                	mov    %esi,%eax
  80156e:	e8 54 ff ff ff       	call   8014c7 <printnum>
  801573:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	57                   	push   %edi
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	ff 75 dc             	pushl  -0x24(%ebp)
  801580:	ff 75 d8             	pushl  -0x28(%ebp)
  801583:	ff 75 e4             	pushl  -0x1c(%ebp)
  801586:	ff 75 e0             	pushl  -0x20(%ebp)
  801589:	e8 12 1c 00 00       	call   8031a0 <__umoddi3>
  80158e:	83 c4 14             	add    $0x14,%esp
  801591:	0f be 80 63 38 80 00 	movsbl 0x803863(%eax),%eax
  801598:	50                   	push   %eax
  801599:	ff d6                	call   *%esi
  80159b:	83 c4 10             	add    $0x10,%esp
	}
}
  80159e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5f                   	pop    %edi
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    

008015a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8015ac:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8015b0:	8b 10                	mov    (%eax),%edx
  8015b2:	3b 50 04             	cmp    0x4(%eax),%edx
  8015b5:	73 0a                	jae    8015c1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8015b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ba:	89 08                	mov    %ecx,(%eax)
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	88 02                	mov    %al,(%edx)
}
  8015c1:	5d                   	pop    %ebp
  8015c2:	c3                   	ret    

008015c3 <printfmt>:
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8015c9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8015cc:	50                   	push   %eax
  8015cd:	ff 75 10             	pushl  0x10(%ebp)
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	ff 75 08             	pushl  0x8(%ebp)
  8015d6:	e8 05 00 00 00       	call   8015e0 <vprintfmt>
}
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <vprintfmt>:
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	57                   	push   %edi
  8015e4:	56                   	push   %esi
  8015e5:	53                   	push   %ebx
  8015e6:	83 ec 3c             	sub    $0x3c,%esp
  8015e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8015ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  8015f2:	e9 32 04 00 00       	jmp    801a29 <vprintfmt+0x449>
		padc = ' ';
  8015f7:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8015fb:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  801602:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  801609:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801610:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801617:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80161e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801623:	8d 47 01             	lea    0x1(%edi),%eax
  801626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801629:	0f b6 17             	movzbl (%edi),%edx
  80162c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80162f:	3c 55                	cmp    $0x55,%al
  801631:	0f 87 12 05 00 00    	ja     801b49 <vprintfmt+0x569>
  801637:	0f b6 c0             	movzbl %al,%eax
  80163a:	ff 24 85 40 3a 80 00 	jmp    *0x803a40(,%eax,4)
  801641:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801644:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  801648:	eb d9                	jmp    801623 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80164a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80164d:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  801651:	eb d0                	jmp    801623 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  801653:	0f b6 d2             	movzbl %dl,%edx
  801656:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801659:	b8 00 00 00 00       	mov    $0x0,%eax
  80165e:	89 75 08             	mov    %esi,0x8(%ebp)
  801661:	eb 03                	jmp    801666 <vprintfmt+0x86>
  801663:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801666:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801669:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80166d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801670:	8d 72 d0             	lea    -0x30(%edx),%esi
  801673:	83 fe 09             	cmp    $0x9,%esi
  801676:	76 eb                	jbe    801663 <vprintfmt+0x83>
  801678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80167b:	8b 75 08             	mov    0x8(%ebp),%esi
  80167e:	eb 14                	jmp    801694 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  801680:	8b 45 14             	mov    0x14(%ebp),%eax
  801683:	8b 00                	mov    (%eax),%eax
  801685:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801688:	8b 45 14             	mov    0x14(%ebp),%eax
  80168b:	8d 40 04             	lea    0x4(%eax),%eax
  80168e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801691:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801694:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801698:	79 89                	jns    801623 <vprintfmt+0x43>
				width = precision, precision = -1;
  80169a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80169d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016a0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8016a7:	e9 77 ff ff ff       	jmp    801623 <vprintfmt+0x43>
  8016ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	0f 48 c1             	cmovs  %ecx,%eax
  8016b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016ba:	e9 64 ff ff ff       	jmp    801623 <vprintfmt+0x43>
  8016bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8016c2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8016c9:	e9 55 ff ff ff       	jmp    801623 <vprintfmt+0x43>
			lflag++;
  8016ce:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8016d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8016d5:	e9 49 ff ff ff       	jmp    801623 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8016da:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dd:	8d 78 04             	lea    0x4(%eax),%edi
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	53                   	push   %ebx
  8016e4:	ff 30                	pushl  (%eax)
  8016e6:	ff d6                	call   *%esi
			break;
  8016e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8016eb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8016ee:	e9 33 03 00 00       	jmp    801a26 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8016f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f6:	8d 78 04             	lea    0x4(%eax),%edi
  8016f9:	8b 00                	mov    (%eax),%eax
  8016fb:	99                   	cltd   
  8016fc:	31 d0                	xor    %edx,%eax
  8016fe:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801700:	83 f8 0f             	cmp    $0xf,%eax
  801703:	7f 23                	jg     801728 <vprintfmt+0x148>
  801705:	8b 14 85 a0 3b 80 00 	mov    0x803ba0(,%eax,4),%edx
  80170c:	85 d2                	test   %edx,%edx
  80170e:	74 18                	je     801728 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  801710:	52                   	push   %edx
  801711:	68 2f 33 80 00       	push   $0x80332f
  801716:	53                   	push   %ebx
  801717:	56                   	push   %esi
  801718:	e8 a6 fe ff ff       	call   8015c3 <printfmt>
  80171d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801720:	89 7d 14             	mov    %edi,0x14(%ebp)
  801723:	e9 fe 02 00 00       	jmp    801a26 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  801728:	50                   	push   %eax
  801729:	68 7b 38 80 00       	push   $0x80387b
  80172e:	53                   	push   %ebx
  80172f:	56                   	push   %esi
  801730:	e8 8e fe ff ff       	call   8015c3 <printfmt>
  801735:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801738:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80173b:	e9 e6 02 00 00       	jmp    801a26 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  801740:	8b 45 14             	mov    0x14(%ebp),%eax
  801743:	83 c0 04             	add    $0x4,%eax
  801746:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  801749:	8b 45 14             	mov    0x14(%ebp),%eax
  80174c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80174e:	85 c9                	test   %ecx,%ecx
  801750:	b8 74 38 80 00       	mov    $0x803874,%eax
  801755:	0f 45 c1             	cmovne %ecx,%eax
  801758:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80175b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80175f:	7e 06                	jle    801767 <vprintfmt+0x187>
  801761:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  801765:	75 0d                	jne    801774 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  801767:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80176a:	89 c7                	mov    %eax,%edi
  80176c:	03 45 e0             	add    -0x20(%ebp),%eax
  80176f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801772:	eb 53                	jmp    8017c7 <vprintfmt+0x1e7>
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	ff 75 d8             	pushl  -0x28(%ebp)
  80177a:	50                   	push   %eax
  80177b:	e8 71 04 00 00       	call   801bf1 <strnlen>
  801780:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801783:	29 c1                	sub    %eax,%ecx
  801785:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80178d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  801791:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801794:	eb 0f                	jmp    8017a5 <vprintfmt+0x1c5>
					putch(padc, putdat);
  801796:	83 ec 08             	sub    $0x8,%esp
  801799:	53                   	push   %ebx
  80179a:	ff 75 e0             	pushl  -0x20(%ebp)
  80179d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80179f:	83 ef 01             	sub    $0x1,%edi
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 ff                	test   %edi,%edi
  8017a7:	7f ed                	jg     801796 <vprintfmt+0x1b6>
  8017a9:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8017ac:	85 c9                	test   %ecx,%ecx
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b3:	0f 49 c1             	cmovns %ecx,%eax
  8017b6:	29 c1                	sub    %eax,%ecx
  8017b8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8017bb:	eb aa                	jmp    801767 <vprintfmt+0x187>
					putch(ch, putdat);
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	53                   	push   %ebx
  8017c1:	52                   	push   %edx
  8017c2:	ff d6                	call   *%esi
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8017ca:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017cc:	83 c7 01             	add    $0x1,%edi
  8017cf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8017d3:	0f be d0             	movsbl %al,%edx
  8017d6:	85 d2                	test   %edx,%edx
  8017d8:	74 4b                	je     801825 <vprintfmt+0x245>
  8017da:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8017de:	78 06                	js     8017e6 <vprintfmt+0x206>
  8017e0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8017e4:	78 1e                	js     801804 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8017e6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8017ea:	74 d1                	je     8017bd <vprintfmt+0x1dd>
  8017ec:	0f be c0             	movsbl %al,%eax
  8017ef:	83 e8 20             	sub    $0x20,%eax
  8017f2:	83 f8 5e             	cmp    $0x5e,%eax
  8017f5:	76 c6                	jbe    8017bd <vprintfmt+0x1dd>
					putch('?', putdat);
  8017f7:	83 ec 08             	sub    $0x8,%esp
  8017fa:	53                   	push   %ebx
  8017fb:	6a 3f                	push   $0x3f
  8017fd:	ff d6                	call   *%esi
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	eb c3                	jmp    8017c7 <vprintfmt+0x1e7>
  801804:	89 cf                	mov    %ecx,%edi
  801806:	eb 0e                	jmp    801816 <vprintfmt+0x236>
				putch(' ', putdat);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	53                   	push   %ebx
  80180c:	6a 20                	push   $0x20
  80180e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801810:	83 ef 01             	sub    $0x1,%edi
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	85 ff                	test   %edi,%edi
  801818:	7f ee                	jg     801808 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80181a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80181d:	89 45 14             	mov    %eax,0x14(%ebp)
  801820:	e9 01 02 00 00       	jmp    801a26 <vprintfmt+0x446>
  801825:	89 cf                	mov    %ecx,%edi
  801827:	eb ed                	jmp    801816 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  801829:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80182c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  801833:	e9 eb fd ff ff       	jmp    801623 <vprintfmt+0x43>
	if (lflag >= 2)
  801838:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80183c:	7f 21                	jg     80185f <vprintfmt+0x27f>
	else if (lflag)
  80183e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801842:	74 68                	je     8018ac <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  801844:	8b 45 14             	mov    0x14(%ebp),%eax
  801847:	8b 00                	mov    (%eax),%eax
  801849:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80184c:	89 c1                	mov    %eax,%ecx
  80184e:	c1 f9 1f             	sar    $0x1f,%ecx
  801851:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801854:	8b 45 14             	mov    0x14(%ebp),%eax
  801857:	8d 40 04             	lea    0x4(%eax),%eax
  80185a:	89 45 14             	mov    %eax,0x14(%ebp)
  80185d:	eb 17                	jmp    801876 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80185f:	8b 45 14             	mov    0x14(%ebp),%eax
  801862:	8b 50 04             	mov    0x4(%eax),%edx
  801865:	8b 00                	mov    (%eax),%eax
  801867:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80186a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80186d:	8b 45 14             	mov    0x14(%ebp),%eax
  801870:	8d 40 08             	lea    0x8(%eax),%eax
  801873:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  801876:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801879:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80187c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80187f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  801882:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801886:	78 3f                	js     8018c7 <vprintfmt+0x2e7>
			base = 10;
  801888:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80188d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801891:	0f 84 71 01 00 00    	je     801a08 <vprintfmt+0x428>
				putch('+', putdat);
  801897:	83 ec 08             	sub    $0x8,%esp
  80189a:	53                   	push   %ebx
  80189b:	6a 2b                	push   $0x2b
  80189d:	ff d6                	call   *%esi
  80189f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8018a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8018a7:	e9 5c 01 00 00       	jmp    801a08 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8018ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8018af:	8b 00                	mov    (%eax),%eax
  8018b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8018b4:	89 c1                	mov    %eax,%ecx
  8018b6:	c1 f9 1f             	sar    $0x1f,%ecx
  8018b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8018bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bf:	8d 40 04             	lea    0x4(%eax),%eax
  8018c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8018c5:	eb af                	jmp    801876 <vprintfmt+0x296>
				putch('-', putdat);
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	53                   	push   %ebx
  8018cb:	6a 2d                	push   $0x2d
  8018cd:	ff d6                	call   *%esi
				num = -(long long) num;
  8018cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8018d5:	f7 d8                	neg    %eax
  8018d7:	83 d2 00             	adc    $0x0,%edx
  8018da:	f7 da                	neg    %edx
  8018dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8018e2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8018e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8018ea:	e9 19 01 00 00       	jmp    801a08 <vprintfmt+0x428>
	if (lflag >= 2)
  8018ef:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8018f3:	7f 29                	jg     80191e <vprintfmt+0x33e>
	else if (lflag)
  8018f5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8018f9:	74 44                	je     80193f <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8018fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fe:	8b 00                	mov    (%eax),%eax
  801900:	ba 00 00 00 00       	mov    $0x0,%edx
  801905:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801908:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80190b:	8b 45 14             	mov    0x14(%ebp),%eax
  80190e:	8d 40 04             	lea    0x4(%eax),%eax
  801911:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801914:	b8 0a 00 00 00       	mov    $0xa,%eax
  801919:	e9 ea 00 00 00       	jmp    801a08 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80191e:	8b 45 14             	mov    0x14(%ebp),%eax
  801921:	8b 50 04             	mov    0x4(%eax),%edx
  801924:	8b 00                	mov    (%eax),%eax
  801926:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801929:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8d 40 08             	lea    0x8(%eax),%eax
  801932:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801935:	b8 0a 00 00 00       	mov    $0xa,%eax
  80193a:	e9 c9 00 00 00       	jmp    801a08 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80193f:	8b 45 14             	mov    0x14(%ebp),%eax
  801942:	8b 00                	mov    (%eax),%eax
  801944:	ba 00 00 00 00       	mov    $0x0,%edx
  801949:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80194c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80194f:	8b 45 14             	mov    0x14(%ebp),%eax
  801952:	8d 40 04             	lea    0x4(%eax),%eax
  801955:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801958:	b8 0a 00 00 00       	mov    $0xa,%eax
  80195d:	e9 a6 00 00 00       	jmp    801a08 <vprintfmt+0x428>
			putch('0', putdat);
  801962:	83 ec 08             	sub    $0x8,%esp
  801965:	53                   	push   %ebx
  801966:	6a 30                	push   $0x30
  801968:	ff d6                	call   *%esi
	if (lflag >= 2)
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801971:	7f 26                	jg     801999 <vprintfmt+0x3b9>
	else if (lflag)
  801973:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801977:	74 3e                	je     8019b7 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  801979:	8b 45 14             	mov    0x14(%ebp),%eax
  80197c:	8b 00                	mov    (%eax),%eax
  80197e:	ba 00 00 00 00       	mov    $0x0,%edx
  801983:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801986:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801989:	8b 45 14             	mov    0x14(%ebp),%eax
  80198c:	8d 40 04             	lea    0x4(%eax),%eax
  80198f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801992:	b8 08 00 00 00       	mov    $0x8,%eax
  801997:	eb 6f                	jmp    801a08 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801999:	8b 45 14             	mov    0x14(%ebp),%eax
  80199c:	8b 50 04             	mov    0x4(%eax),%edx
  80199f:	8b 00                	mov    (%eax),%eax
  8019a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019aa:	8d 40 08             	lea    0x8(%eax),%eax
  8019ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8019b5:	eb 51                	jmp    801a08 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ca:	8d 40 04             	lea    0x4(%eax),%eax
  8019cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019d0:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d5:	eb 31                	jmp    801a08 <vprintfmt+0x428>
			putch('0', putdat);
  8019d7:	83 ec 08             	sub    $0x8,%esp
  8019da:	53                   	push   %ebx
  8019db:	6a 30                	push   $0x30
  8019dd:	ff d6                	call   *%esi
			putch('x', putdat);
  8019df:	83 c4 08             	add    $0x8,%esp
  8019e2:	53                   	push   %ebx
  8019e3:	6a 78                	push   $0x78
  8019e5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8019e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ea:	8b 00                	mov    (%eax),%eax
  8019ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8019f7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8019fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8019fd:	8d 40 04             	lea    0x4(%eax),%eax
  801a00:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a03:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a08:	83 ec 0c             	sub    $0xc,%esp
  801a0b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  801a0f:	52                   	push   %edx
  801a10:	ff 75 e0             	pushl  -0x20(%ebp)
  801a13:	50                   	push   %eax
  801a14:	ff 75 dc             	pushl  -0x24(%ebp)
  801a17:	ff 75 d8             	pushl  -0x28(%ebp)
  801a1a:	89 da                	mov    %ebx,%edx
  801a1c:	89 f0                	mov    %esi,%eax
  801a1e:	e8 a4 fa ff ff       	call   8014c7 <printnum>
			break;
  801a23:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a29:	83 c7 01             	add    $0x1,%edi
  801a2c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801a30:	83 f8 25             	cmp    $0x25,%eax
  801a33:	0f 84 be fb ff ff    	je     8015f7 <vprintfmt+0x17>
			if (ch == '\0')
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	0f 84 28 01 00 00    	je     801b69 <vprintfmt+0x589>
			putch(ch, putdat);
  801a41:	83 ec 08             	sub    $0x8,%esp
  801a44:	53                   	push   %ebx
  801a45:	50                   	push   %eax
  801a46:	ff d6                	call   *%esi
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	eb dc                	jmp    801a29 <vprintfmt+0x449>
	if (lflag >= 2)
  801a4d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  801a51:	7f 26                	jg     801a79 <vprintfmt+0x499>
	else if (lflag)
  801a53:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  801a57:	74 41                	je     801a9a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  801a59:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5c:	8b 00                	mov    (%eax),%eax
  801a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a63:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a66:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a69:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6c:	8d 40 04             	lea    0x4(%eax),%eax
  801a6f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a72:	b8 10 00 00 00       	mov    $0x10,%eax
  801a77:	eb 8f                	jmp    801a08 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 50 04             	mov    0x4(%eax),%edx
  801a7f:	8b 00                	mov    (%eax),%eax
  801a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a84:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a87:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8a:	8d 40 08             	lea    0x8(%eax),%eax
  801a8d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a90:	b8 10 00 00 00       	mov    $0x10,%eax
  801a95:	e9 6e ff ff ff       	jmp    801a08 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  801a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9d:	8b 00                	mov    (%eax),%eax
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801aa7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  801aad:	8d 40 04             	lea    0x4(%eax),%eax
  801ab0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ab3:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab8:	e9 4b ff ff ff       	jmp    801a08 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  801abd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac0:	83 c0 04             	add    $0x4,%eax
  801ac3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac9:	8b 00                	mov    (%eax),%eax
  801acb:	85 c0                	test   %eax,%eax
  801acd:	74 14                	je     801ae3 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  801acf:	8b 13                	mov    (%ebx),%edx
  801ad1:	83 fa 7f             	cmp    $0x7f,%edx
  801ad4:	7f 37                	jg     801b0d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  801ad6:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  801ad8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801adb:	89 45 14             	mov    %eax,0x14(%ebp)
  801ade:	e9 43 ff ff ff       	jmp    801a26 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  801ae3:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ae8:	bf 99 39 80 00       	mov    $0x803999,%edi
							putch(ch, putdat);
  801aed:	83 ec 08             	sub    $0x8,%esp
  801af0:	53                   	push   %ebx
  801af1:	50                   	push   %eax
  801af2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801af4:	83 c7 01             	add    $0x1,%edi
  801af7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801afb:	83 c4 10             	add    $0x10,%esp
  801afe:	85 c0                	test   %eax,%eax
  801b00:	75 eb                	jne    801aed <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  801b02:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b05:	89 45 14             	mov    %eax,0x14(%ebp)
  801b08:	e9 19 ff ff ff       	jmp    801a26 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  801b0d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  801b0f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801b14:	bf d1 39 80 00       	mov    $0x8039d1,%edi
							putch(ch, putdat);
  801b19:	83 ec 08             	sub    $0x8,%esp
  801b1c:	53                   	push   %ebx
  801b1d:	50                   	push   %eax
  801b1e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  801b20:	83 c7 01             	add    $0x1,%edi
  801b23:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	75 eb                	jne    801b19 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  801b2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b31:	89 45 14             	mov    %eax,0x14(%ebp)
  801b34:	e9 ed fe ff ff       	jmp    801a26 <vprintfmt+0x446>
			putch(ch, putdat);
  801b39:	83 ec 08             	sub    $0x8,%esp
  801b3c:	53                   	push   %ebx
  801b3d:	6a 25                	push   $0x25
  801b3f:	ff d6                	call   *%esi
			break;
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	e9 dd fe ff ff       	jmp    801a26 <vprintfmt+0x446>
			putch('%', putdat);
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	53                   	push   %ebx
  801b4d:	6a 25                	push   $0x25
  801b4f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	89 f8                	mov    %edi,%eax
  801b56:	eb 03                	jmp    801b5b <vprintfmt+0x57b>
  801b58:	83 e8 01             	sub    $0x1,%eax
  801b5b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801b5f:	75 f7                	jne    801b58 <vprintfmt+0x578>
  801b61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b64:	e9 bd fe ff ff       	jmp    801a26 <vprintfmt+0x446>
}
  801b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b6c:	5b                   	pop    %ebx
  801b6d:	5e                   	pop    %esi
  801b6e:	5f                   	pop    %edi
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 18             	sub    $0x18,%esp
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b80:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801b84:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	74 26                	je     801bb8 <vsnprintf+0x47>
  801b92:	85 d2                	test   %edx,%edx
  801b94:	7e 22                	jle    801bb8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b96:	ff 75 14             	pushl  0x14(%ebp)
  801b99:	ff 75 10             	pushl  0x10(%ebp)
  801b9c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9f:	50                   	push   %eax
  801ba0:	68 a6 15 80 00       	push   $0x8015a6
  801ba5:	e8 36 fa ff ff       	call   8015e0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb3:	83 c4 10             	add    $0x10,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    
		return -E_INVAL;
  801bb8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bbd:	eb f7                	jmp    801bb6 <vsnprintf+0x45>

00801bbf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bc5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801bc8:	50                   	push   %eax
  801bc9:	ff 75 10             	pushl  0x10(%ebp)
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	e8 9a ff ff ff       	call   801b71 <vsnprintf>
	va_end(ap);

	return rc;
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801be4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801be8:	74 05                	je     801bef <strlen+0x16>
		n++;
  801bea:	83 c0 01             	add    $0x1,%eax
  801bed:	eb f5                	jmp    801be4 <strlen+0xb>
	return n;
}
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    

00801bf1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	39 c2                	cmp    %eax,%edx
  801c01:	74 0d                	je     801c10 <strnlen+0x1f>
  801c03:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801c07:	74 05                	je     801c0e <strnlen+0x1d>
		n++;
  801c09:	83 c2 01             	add    $0x1,%edx
  801c0c:	eb f1                	jmp    801bff <strnlen+0xe>
  801c0e:	89 d0                	mov    %edx,%eax
	return n;
}
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    

00801c12 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	53                   	push   %ebx
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c21:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801c25:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801c28:	83 c2 01             	add    $0x1,%edx
  801c2b:	84 c9                	test   %cl,%cl
  801c2d:	75 f2                	jne    801c21 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801c2f:	5b                   	pop    %ebx
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    

00801c32 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	53                   	push   %ebx
  801c36:	83 ec 10             	sub    $0x10,%esp
  801c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801c3c:	53                   	push   %ebx
  801c3d:	e8 97 ff ff ff       	call   801bd9 <strlen>
  801c42:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	01 d8                	add    %ebx,%eax
  801c4a:	50                   	push   %eax
  801c4b:	e8 c2 ff ff ff       	call   801c12 <strcpy>
	return dst;
}
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	56                   	push   %esi
  801c5b:	53                   	push   %ebx
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c62:	89 c6                	mov    %eax,%esi
  801c64:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c67:	89 c2                	mov    %eax,%edx
  801c69:	39 f2                	cmp    %esi,%edx
  801c6b:	74 11                	je     801c7e <strncpy+0x27>
		*dst++ = *src;
  801c6d:	83 c2 01             	add    $0x1,%edx
  801c70:	0f b6 19             	movzbl (%ecx),%ebx
  801c73:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801c76:	80 fb 01             	cmp    $0x1,%bl
  801c79:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801c7c:	eb eb                	jmp    801c69 <strncpy+0x12>
	}
	return ret;
}
  801c7e:	5b                   	pop    %ebx
  801c7f:	5e                   	pop    %esi
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    

00801c82 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	56                   	push   %esi
  801c86:	53                   	push   %ebx
  801c87:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8d:	8b 55 10             	mov    0x10(%ebp),%edx
  801c90:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c92:	85 d2                	test   %edx,%edx
  801c94:	74 21                	je     801cb7 <strlcpy+0x35>
  801c96:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c9a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c9c:	39 c2                	cmp    %eax,%edx
  801c9e:	74 14                	je     801cb4 <strlcpy+0x32>
  801ca0:	0f b6 19             	movzbl (%ecx),%ebx
  801ca3:	84 db                	test   %bl,%bl
  801ca5:	74 0b                	je     801cb2 <strlcpy+0x30>
			*dst++ = *src++;
  801ca7:	83 c1 01             	add    $0x1,%ecx
  801caa:	83 c2 01             	add    $0x1,%edx
  801cad:	88 5a ff             	mov    %bl,-0x1(%edx)
  801cb0:	eb ea                	jmp    801c9c <strlcpy+0x1a>
  801cb2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801cb4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801cb7:	29 f0                	sub    %esi,%eax
}
  801cb9:	5b                   	pop    %ebx
  801cba:	5e                   	pop    %esi
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    

00801cbd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801cc6:	0f b6 01             	movzbl (%ecx),%eax
  801cc9:	84 c0                	test   %al,%al
  801ccb:	74 0c                	je     801cd9 <strcmp+0x1c>
  801ccd:	3a 02                	cmp    (%edx),%al
  801ccf:	75 08                	jne    801cd9 <strcmp+0x1c>
		p++, q++;
  801cd1:	83 c1 01             	add    $0x1,%ecx
  801cd4:	83 c2 01             	add    $0x1,%edx
  801cd7:	eb ed                	jmp    801cc6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cd9:	0f b6 c0             	movzbl %al,%eax
  801cdc:	0f b6 12             	movzbl (%edx),%edx
  801cdf:	29 d0                	sub    %edx,%eax
}
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	53                   	push   %ebx
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	89 c3                	mov    %eax,%ebx
  801cef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801cf2:	eb 06                	jmp    801cfa <strncmp+0x17>
		n--, p++, q++;
  801cf4:	83 c0 01             	add    $0x1,%eax
  801cf7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801cfa:	39 d8                	cmp    %ebx,%eax
  801cfc:	74 16                	je     801d14 <strncmp+0x31>
  801cfe:	0f b6 08             	movzbl (%eax),%ecx
  801d01:	84 c9                	test   %cl,%cl
  801d03:	74 04                	je     801d09 <strncmp+0x26>
  801d05:	3a 0a                	cmp    (%edx),%cl
  801d07:	74 eb                	je     801cf4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d09:	0f b6 00             	movzbl (%eax),%eax
  801d0c:	0f b6 12             	movzbl (%edx),%edx
  801d0f:	29 d0                	sub    %edx,%eax
}
  801d11:	5b                   	pop    %ebx
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    
		return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
  801d19:	eb f6                	jmp    801d11 <strncmp+0x2e>

00801d1b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d25:	0f b6 10             	movzbl (%eax),%edx
  801d28:	84 d2                	test   %dl,%dl
  801d2a:	74 09                	je     801d35 <strchr+0x1a>
		if (*s == c)
  801d2c:	38 ca                	cmp    %cl,%dl
  801d2e:	74 0a                	je     801d3a <strchr+0x1f>
	for (; *s; s++)
  801d30:	83 c0 01             	add    $0x1,%eax
  801d33:	eb f0                	jmp    801d25 <strchr+0xa>
			return (char *) s;
	return 0;
  801d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    

00801d3c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801d46:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801d49:	38 ca                	cmp    %cl,%dl
  801d4b:	74 09                	je     801d56 <strfind+0x1a>
  801d4d:	84 d2                	test   %dl,%dl
  801d4f:	74 05                	je     801d56 <strfind+0x1a>
	for (; *s; s++)
  801d51:	83 c0 01             	add    $0x1,%eax
  801d54:	eb f0                	jmp    801d46 <strfind+0xa>
			break;
	return (char *) s;
}
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    

00801d58 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	57                   	push   %edi
  801d5c:	56                   	push   %esi
  801d5d:	53                   	push   %ebx
  801d5e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d61:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801d64:	85 c9                	test   %ecx,%ecx
  801d66:	74 31                	je     801d99 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801d68:	89 f8                	mov    %edi,%eax
  801d6a:	09 c8                	or     %ecx,%eax
  801d6c:	a8 03                	test   $0x3,%al
  801d6e:	75 23                	jne    801d93 <memset+0x3b>
		c &= 0xFF;
  801d70:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801d74:	89 d3                	mov    %edx,%ebx
  801d76:	c1 e3 08             	shl    $0x8,%ebx
  801d79:	89 d0                	mov    %edx,%eax
  801d7b:	c1 e0 18             	shl    $0x18,%eax
  801d7e:	89 d6                	mov    %edx,%esi
  801d80:	c1 e6 10             	shl    $0x10,%esi
  801d83:	09 f0                	or     %esi,%eax
  801d85:	09 c2                	or     %eax,%edx
  801d87:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801d89:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d8c:	89 d0                	mov    %edx,%eax
  801d8e:	fc                   	cld    
  801d8f:	f3 ab                	rep stos %eax,%es:(%edi)
  801d91:	eb 06                	jmp    801d99 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d96:	fc                   	cld    
  801d97:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d99:	89 f8                	mov    %edi,%eax
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    

00801da0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	57                   	push   %edi
  801da4:	56                   	push   %esi
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801dae:	39 c6                	cmp    %eax,%esi
  801db0:	73 32                	jae    801de4 <memmove+0x44>
  801db2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801db5:	39 c2                	cmp    %eax,%edx
  801db7:	76 2b                	jbe    801de4 <memmove+0x44>
		s += n;
		d += n;
  801db9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801dbc:	89 fe                	mov    %edi,%esi
  801dbe:	09 ce                	or     %ecx,%esi
  801dc0:	09 d6                	or     %edx,%esi
  801dc2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801dc8:	75 0e                	jne    801dd8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801dca:	83 ef 04             	sub    $0x4,%edi
  801dcd:	8d 72 fc             	lea    -0x4(%edx),%esi
  801dd0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801dd3:	fd                   	std    
  801dd4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801dd6:	eb 09                	jmp    801de1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801dd8:	83 ef 01             	sub    $0x1,%edi
  801ddb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801dde:	fd                   	std    
  801ddf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801de1:	fc                   	cld    
  801de2:	eb 1a                	jmp    801dfe <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801de4:	89 c2                	mov    %eax,%edx
  801de6:	09 ca                	or     %ecx,%edx
  801de8:	09 f2                	or     %esi,%edx
  801dea:	f6 c2 03             	test   $0x3,%dl
  801ded:	75 0a                	jne    801df9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801def:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801df2:	89 c7                	mov    %eax,%edi
  801df4:	fc                   	cld    
  801df5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801df7:	eb 05                	jmp    801dfe <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801df9:	89 c7                	mov    %eax,%edi
  801dfb:	fc                   	cld    
  801dfc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801dfe:	5e                   	pop    %esi
  801dff:	5f                   	pop    %edi
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801e08:	ff 75 10             	pushl  0x10(%ebp)
  801e0b:	ff 75 0c             	pushl  0xc(%ebp)
  801e0e:	ff 75 08             	pushl  0x8(%ebp)
  801e11:	e8 8a ff ff ff       	call   801da0 <memmove>
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	56                   	push   %esi
  801e1c:	53                   	push   %ebx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e23:	89 c6                	mov    %eax,%esi
  801e25:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e28:	39 f0                	cmp    %esi,%eax
  801e2a:	74 1c                	je     801e48 <memcmp+0x30>
		if (*s1 != *s2)
  801e2c:	0f b6 08             	movzbl (%eax),%ecx
  801e2f:	0f b6 1a             	movzbl (%edx),%ebx
  801e32:	38 d9                	cmp    %bl,%cl
  801e34:	75 08                	jne    801e3e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801e36:	83 c0 01             	add    $0x1,%eax
  801e39:	83 c2 01             	add    $0x1,%edx
  801e3c:	eb ea                	jmp    801e28 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801e3e:	0f b6 c1             	movzbl %cl,%eax
  801e41:	0f b6 db             	movzbl %bl,%ebx
  801e44:	29 d8                	sub    %ebx,%eax
  801e46:	eb 05                	jmp    801e4d <memcmp+0x35>
	}

	return 0;
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4d:	5b                   	pop    %ebx
  801e4e:	5e                   	pop    %esi
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    

00801e51 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801e5a:	89 c2                	mov    %eax,%edx
  801e5c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801e5f:	39 d0                	cmp    %edx,%eax
  801e61:	73 09                	jae    801e6c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e63:	38 08                	cmp    %cl,(%eax)
  801e65:	74 05                	je     801e6c <memfind+0x1b>
	for (; s < ends; s++)
  801e67:	83 c0 01             	add    $0x1,%eax
  801e6a:	eb f3                	jmp    801e5f <memfind+0xe>
			break;
	return (void *) s;
}
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    

00801e6e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	57                   	push   %edi
  801e72:	56                   	push   %esi
  801e73:	53                   	push   %ebx
  801e74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e7a:	eb 03                	jmp    801e7f <strtol+0x11>
		s++;
  801e7c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801e7f:	0f b6 01             	movzbl (%ecx),%eax
  801e82:	3c 20                	cmp    $0x20,%al
  801e84:	74 f6                	je     801e7c <strtol+0xe>
  801e86:	3c 09                	cmp    $0x9,%al
  801e88:	74 f2                	je     801e7c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e8a:	3c 2b                	cmp    $0x2b,%al
  801e8c:	74 2a                	je     801eb8 <strtol+0x4a>
	int neg = 0;
  801e8e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e93:	3c 2d                	cmp    $0x2d,%al
  801e95:	74 2b                	je     801ec2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e97:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e9d:	75 0f                	jne    801eae <strtol+0x40>
  801e9f:	80 39 30             	cmpb   $0x30,(%ecx)
  801ea2:	74 28                	je     801ecc <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ea4:	85 db                	test   %ebx,%ebx
  801ea6:	b8 0a 00 00 00       	mov    $0xa,%eax
  801eab:	0f 44 d8             	cmove  %eax,%ebx
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801eb6:	eb 50                	jmp    801f08 <strtol+0x9a>
		s++;
  801eb8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801ebb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec0:	eb d5                	jmp    801e97 <strtol+0x29>
		s++, neg = 1;
  801ec2:	83 c1 01             	add    $0x1,%ecx
  801ec5:	bf 01 00 00 00       	mov    $0x1,%edi
  801eca:	eb cb                	jmp    801e97 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ecc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ed0:	74 0e                	je     801ee0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801ed2:	85 db                	test   %ebx,%ebx
  801ed4:	75 d8                	jne    801eae <strtol+0x40>
		s++, base = 8;
  801ed6:	83 c1 01             	add    $0x1,%ecx
  801ed9:	bb 08 00 00 00       	mov    $0x8,%ebx
  801ede:	eb ce                	jmp    801eae <strtol+0x40>
		s += 2, base = 16;
  801ee0:	83 c1 02             	add    $0x2,%ecx
  801ee3:	bb 10 00 00 00       	mov    $0x10,%ebx
  801ee8:	eb c4                	jmp    801eae <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801eea:	8d 72 9f             	lea    -0x61(%edx),%esi
  801eed:	89 f3                	mov    %esi,%ebx
  801eef:	80 fb 19             	cmp    $0x19,%bl
  801ef2:	77 29                	ja     801f1d <strtol+0xaf>
			dig = *s - 'a' + 10;
  801ef4:	0f be d2             	movsbl %dl,%edx
  801ef7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801efa:	3b 55 10             	cmp    0x10(%ebp),%edx
  801efd:	7d 30                	jge    801f2f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801eff:	83 c1 01             	add    $0x1,%ecx
  801f02:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f06:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801f08:	0f b6 11             	movzbl (%ecx),%edx
  801f0b:	8d 72 d0             	lea    -0x30(%edx),%esi
  801f0e:	89 f3                	mov    %esi,%ebx
  801f10:	80 fb 09             	cmp    $0x9,%bl
  801f13:	77 d5                	ja     801eea <strtol+0x7c>
			dig = *s - '0';
  801f15:	0f be d2             	movsbl %dl,%edx
  801f18:	83 ea 30             	sub    $0x30,%edx
  801f1b:	eb dd                	jmp    801efa <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801f1d:	8d 72 bf             	lea    -0x41(%edx),%esi
  801f20:	89 f3                	mov    %esi,%ebx
  801f22:	80 fb 19             	cmp    $0x19,%bl
  801f25:	77 08                	ja     801f2f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801f27:	0f be d2             	movsbl %dl,%edx
  801f2a:	83 ea 37             	sub    $0x37,%edx
  801f2d:	eb cb                	jmp    801efa <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801f2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f33:	74 05                	je     801f3a <strtol+0xcc>
		*endptr = (char *) s;
  801f35:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f38:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801f3a:	89 c2                	mov    %eax,%edx
  801f3c:	f7 da                	neg    %edx
  801f3e:	85 ff                	test   %edi,%edi
  801f40:	0f 45 c2             	cmovne %edx,%eax
}
  801f43:	5b                   	pop    %ebx
  801f44:	5e                   	pop    %esi
  801f45:	5f                   	pop    %edi
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    

00801f48 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	57                   	push   %edi
  801f4c:	56                   	push   %esi
  801f4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f53:	8b 55 08             	mov    0x8(%ebp),%edx
  801f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f59:	89 c3                	mov    %eax,%ebx
  801f5b:	89 c7                	mov    %eax,%edi
  801f5d:	89 c6                	mov    %eax,%esi
  801f5f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5f                   	pop    %edi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	57                   	push   %edi
  801f6a:	56                   	push   %esi
  801f6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  801f6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f71:	b8 01 00 00 00       	mov    $0x1,%eax
  801f76:	89 d1                	mov    %edx,%ecx
  801f78:	89 d3                	mov    %edx,%ebx
  801f7a:	89 d7                	mov    %edx,%edi
  801f7c:	89 d6                	mov    %edx,%esi
  801f7e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    

00801f85 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	57                   	push   %edi
  801f89:	56                   	push   %esi
  801f8a:	53                   	push   %ebx
  801f8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801f8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f93:	8b 55 08             	mov    0x8(%ebp),%edx
  801f96:	b8 03 00 00 00       	mov    $0x3,%eax
  801f9b:	89 cb                	mov    %ecx,%ebx
  801f9d:	89 cf                	mov    %ecx,%edi
  801f9f:	89 ce                	mov    %ecx,%esi
  801fa1:	cd 30                	int    $0x30
	if(check && ret > 0)
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	7f 08                	jg     801faf <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801faa:	5b                   	pop    %ebx
  801fab:	5e                   	pop    %esi
  801fac:	5f                   	pop    %edi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	50                   	push   %eax
  801fb3:	6a 03                	push   $0x3
  801fb5:	68 e0 3b 80 00       	push   $0x803be0
  801fba:	6a 43                	push   $0x43
  801fbc:	68 fd 3b 80 00       	push   $0x803bfd
  801fc1:	e8 f7 f3 ff ff       	call   8013bd <_panic>

00801fc6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	57                   	push   %edi
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  801fcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd1:	b8 02 00 00 00       	mov    $0x2,%eax
  801fd6:	89 d1                	mov    %edx,%ecx
  801fd8:	89 d3                	mov    %edx,%ebx
  801fda:	89 d7                	mov    %edx,%edi
  801fdc:	89 d6                	mov    %edx,%esi
  801fde:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801fe0:	5b                   	pop    %ebx
  801fe1:	5e                   	pop    %esi
  801fe2:	5f                   	pop    %edi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <sys_yield>:

void
sys_yield(void)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	57                   	push   %edi
  801fe9:	56                   	push   %esi
  801fea:	53                   	push   %ebx
	asm volatile("int %1\n"
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	b8 0b 00 00 00       	mov    $0xb,%eax
  801ff5:	89 d1                	mov    %edx,%ecx
  801ff7:	89 d3                	mov    %edx,%ebx
  801ff9:	89 d7                	mov    %edx,%edi
  801ffb:	89 d6                	mov    %edx,%esi
  801ffd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801fff:	5b                   	pop    %ebx
  802000:	5e                   	pop    %esi
  802001:	5f                   	pop    %edi
  802002:	5d                   	pop    %ebp
  802003:	c3                   	ret    

00802004 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	57                   	push   %edi
  802008:	56                   	push   %esi
  802009:	53                   	push   %ebx
  80200a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80200d:	be 00 00 00 00       	mov    $0x0,%esi
  802012:	8b 55 08             	mov    0x8(%ebp),%edx
  802015:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802018:	b8 04 00 00 00       	mov    $0x4,%eax
  80201d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802020:	89 f7                	mov    %esi,%edi
  802022:	cd 30                	int    $0x30
	if(check && ret > 0)
  802024:	85 c0                	test   %eax,%eax
  802026:	7f 08                	jg     802030 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5f                   	pop    %edi
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	50                   	push   %eax
  802034:	6a 04                	push   $0x4
  802036:	68 e0 3b 80 00       	push   $0x803be0
  80203b:	6a 43                	push   $0x43
  80203d:	68 fd 3b 80 00       	push   $0x803bfd
  802042:	e8 76 f3 ff ff       	call   8013bd <_panic>

00802047 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	57                   	push   %edi
  80204b:	56                   	push   %esi
  80204c:	53                   	push   %ebx
  80204d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802050:	8b 55 08             	mov    0x8(%ebp),%edx
  802053:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802056:	b8 05 00 00 00       	mov    $0x5,%eax
  80205b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80205e:	8b 7d 14             	mov    0x14(%ebp),%edi
  802061:	8b 75 18             	mov    0x18(%ebp),%esi
  802064:	cd 30                	int    $0x30
	if(check && ret > 0)
  802066:	85 c0                	test   %eax,%eax
  802068:	7f 08                	jg     802072 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80206a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5f                   	pop    %edi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	50                   	push   %eax
  802076:	6a 05                	push   $0x5
  802078:	68 e0 3b 80 00       	push   $0x803be0
  80207d:	6a 43                	push   $0x43
  80207f:	68 fd 3b 80 00       	push   $0x803bfd
  802084:	e8 34 f3 ff ff       	call   8013bd <_panic>

00802089 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	57                   	push   %edi
  80208d:	56                   	push   %esi
  80208e:	53                   	push   %ebx
  80208f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802092:	bb 00 00 00 00       	mov    $0x0,%ebx
  802097:	8b 55 08             	mov    0x8(%ebp),%edx
  80209a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80209d:	b8 06 00 00 00       	mov    $0x6,%eax
  8020a2:	89 df                	mov    %ebx,%edi
  8020a4:	89 de                	mov    %ebx,%esi
  8020a6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	7f 08                	jg     8020b4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8020ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5e                   	pop    %esi
  8020b1:	5f                   	pop    %edi
  8020b2:	5d                   	pop    %ebp
  8020b3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	50                   	push   %eax
  8020b8:	6a 06                	push   $0x6
  8020ba:	68 e0 3b 80 00       	push   $0x803be0
  8020bf:	6a 43                	push   $0x43
  8020c1:	68 fd 3b 80 00       	push   $0x803bfd
  8020c6:	e8 f2 f2 ff ff       	call   8013bd <_panic>

008020cb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	57                   	push   %edi
  8020cf:	56                   	push   %esi
  8020d0:	53                   	push   %ebx
  8020d1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8020d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020df:	b8 08 00 00 00       	mov    $0x8,%eax
  8020e4:	89 df                	mov    %ebx,%edi
  8020e6:	89 de                	mov    %ebx,%esi
  8020e8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	7f 08                	jg     8020f6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8020ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5f                   	pop    %edi
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8020f6:	83 ec 0c             	sub    $0xc,%esp
  8020f9:	50                   	push   %eax
  8020fa:	6a 08                	push   $0x8
  8020fc:	68 e0 3b 80 00       	push   $0x803be0
  802101:	6a 43                	push   $0x43
  802103:	68 fd 3b 80 00       	push   $0x803bfd
  802108:	e8 b0 f2 ff ff       	call   8013bd <_panic>

0080210d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	57                   	push   %edi
  802111:	56                   	push   %esi
  802112:	53                   	push   %ebx
  802113:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802116:	bb 00 00 00 00       	mov    $0x0,%ebx
  80211b:	8b 55 08             	mov    0x8(%ebp),%edx
  80211e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802121:	b8 09 00 00 00       	mov    $0x9,%eax
  802126:	89 df                	mov    %ebx,%edi
  802128:	89 de                	mov    %ebx,%esi
  80212a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80212c:	85 c0                	test   %eax,%eax
  80212e:	7f 08                	jg     802138 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802130:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5f                   	pop    %edi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802138:	83 ec 0c             	sub    $0xc,%esp
  80213b:	50                   	push   %eax
  80213c:	6a 09                	push   $0x9
  80213e:	68 e0 3b 80 00       	push   $0x803be0
  802143:	6a 43                	push   $0x43
  802145:	68 fd 3b 80 00       	push   $0x803bfd
  80214a:	e8 6e f2 ff ff       	call   8013bd <_panic>

0080214f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	57                   	push   %edi
  802153:	56                   	push   %esi
  802154:	53                   	push   %ebx
  802155:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802158:	bb 00 00 00 00       	mov    $0x0,%ebx
  80215d:	8b 55 08             	mov    0x8(%ebp),%edx
  802160:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802163:	b8 0a 00 00 00       	mov    $0xa,%eax
  802168:	89 df                	mov    %ebx,%edi
  80216a:	89 de                	mov    %ebx,%esi
  80216c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80216e:	85 c0                	test   %eax,%eax
  802170:	7f 08                	jg     80217a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802172:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802175:	5b                   	pop    %ebx
  802176:	5e                   	pop    %esi
  802177:	5f                   	pop    %edi
  802178:	5d                   	pop    %ebp
  802179:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80217a:	83 ec 0c             	sub    $0xc,%esp
  80217d:	50                   	push   %eax
  80217e:	6a 0a                	push   $0xa
  802180:	68 e0 3b 80 00       	push   $0x803be0
  802185:	6a 43                	push   $0x43
  802187:	68 fd 3b 80 00       	push   $0x803bfd
  80218c:	e8 2c f2 ff ff       	call   8013bd <_panic>

00802191 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	57                   	push   %edi
  802195:	56                   	push   %esi
  802196:	53                   	push   %ebx
	asm volatile("int %1\n"
  802197:	8b 55 08             	mov    0x8(%ebp),%edx
  80219a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80219d:	b8 0c 00 00 00       	mov    $0xc,%eax
  8021a2:	be 00 00 00 00       	mov    $0x0,%esi
  8021a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021aa:	8b 7d 14             	mov    0x14(%ebp),%edi
  8021ad:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    

008021b4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	57                   	push   %edi
  8021b8:	56                   	push   %esi
  8021b9:	53                   	push   %ebx
  8021ba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8021bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8021ca:	89 cb                	mov    %ecx,%ebx
  8021cc:	89 cf                	mov    %ecx,%edi
  8021ce:	89 ce                	mov    %ecx,%esi
  8021d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	7f 08                	jg     8021de <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8021d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d9:	5b                   	pop    %ebx
  8021da:	5e                   	pop    %esi
  8021db:	5f                   	pop    %edi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	50                   	push   %eax
  8021e2:	6a 0d                	push   $0xd
  8021e4:	68 e0 3b 80 00       	push   $0x803be0
  8021e9:	6a 43                	push   $0x43
  8021eb:	68 fd 3b 80 00       	push   $0x803bfd
  8021f0:	e8 c8 f1 ff ff       	call   8013bd <_panic>

008021f5 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	57                   	push   %edi
  8021f9:	56                   	push   %esi
  8021fa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8021fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802200:	8b 55 08             	mov    0x8(%ebp),%edx
  802203:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802206:	b8 0e 00 00 00       	mov    $0xe,%eax
  80220b:	89 df                	mov    %ebx,%edi
  80220d:	89 de                	mov    %ebx,%esi
  80220f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5f                   	pop    %edi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    

00802216 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	57                   	push   %edi
  80221a:	56                   	push   %esi
  80221b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80221c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802221:	8b 55 08             	mov    0x8(%ebp),%edx
  802224:	b8 0f 00 00 00       	mov    $0xf,%eax
  802229:	89 cb                	mov    %ecx,%ebx
  80222b:	89 cf                	mov    %ecx,%edi
  80222d:	89 ce                	mov    %ecx,%esi
  80222f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    

00802236 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80223c:	83 3d 10 90 80 00 00 	cmpl   $0x0,0x809010
  802243:	74 0a                	je     80224f <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	a3 10 90 80 00       	mov    %eax,0x809010
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	6a 07                	push   $0x7
  802254:	68 00 f0 bf ee       	push   $0xeebff000
  802259:	6a 00                	push   $0x0
  80225b:	e8 a4 fd ff ff       	call   802004 <sys_page_alloc>
		if(r < 0)
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	85 c0                	test   %eax,%eax
  802265:	78 2a                	js     802291 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802267:	83 ec 08             	sub    $0x8,%esp
  80226a:	68 a5 22 80 00       	push   $0x8022a5
  80226f:	6a 00                	push   $0x0
  802271:	e8 d9 fe ff ff       	call   80214f <sys_env_set_pgfault_upcall>
		if(r < 0)
  802276:	83 c4 10             	add    $0x10,%esp
  802279:	85 c0                	test   %eax,%eax
  80227b:	79 c8                	jns    802245 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80227d:	83 ec 04             	sub    $0x4,%esp
  802280:	68 3c 3c 80 00       	push   $0x803c3c
  802285:	6a 25                	push   $0x25
  802287:	68 75 3c 80 00       	push   $0x803c75
  80228c:	e8 2c f1 ff ff       	call   8013bd <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802291:	83 ec 04             	sub    $0x4,%esp
  802294:	68 0c 3c 80 00       	push   $0x803c0c
  802299:	6a 22                	push   $0x22
  80229b:	68 75 3c 80 00       	push   $0x803c75
  8022a0:	e8 18 f1 ff ff       	call   8013bd <_panic>

008022a5 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8022a5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8022a6:	a1 10 90 80 00       	mov    0x809010,%eax
	call *%eax
  8022ab:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022ad:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8022b0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8022b4:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8022b8:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8022bb:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8022bd:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8022c1:	83 c4 08             	add    $0x8,%esp
	popal
  8022c4:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8022c5:	83 c4 04             	add    $0x4,%esp
	popfl
  8022c8:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8022c9:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8022ca:	c3                   	ret    

008022cb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	56                   	push   %esi
  8022cf:	53                   	push   %ebx
  8022d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8022d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8022d9:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022db:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022e0:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022e3:	83 ec 0c             	sub    $0xc,%esp
  8022e6:	50                   	push   %eax
  8022e7:	e8 c8 fe ff ff       	call   8021b4 <sys_ipc_recv>
	if(ret < 0){
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	78 2b                	js     80231e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022f3:	85 f6                	test   %esi,%esi
  8022f5:	74 0a                	je     802301 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8022f7:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8022fc:	8b 40 74             	mov    0x74(%eax),%eax
  8022ff:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802301:	85 db                	test   %ebx,%ebx
  802303:	74 0a                	je     80230f <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802305:	a1 0c 90 80 00       	mov    0x80900c,%eax
  80230a:	8b 40 78             	mov    0x78(%eax),%eax
  80230d:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80230f:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802314:	8b 40 70             	mov    0x70(%eax),%eax
}
  802317:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80231a:	5b                   	pop    %ebx
  80231b:	5e                   	pop    %esi
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    
		if(from_env_store)
  80231e:	85 f6                	test   %esi,%esi
  802320:	74 06                	je     802328 <ipc_recv+0x5d>
			*from_env_store = 0;
  802322:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802328:	85 db                	test   %ebx,%ebx
  80232a:	74 eb                	je     802317 <ipc_recv+0x4c>
			*perm_store = 0;
  80232c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802332:	eb e3                	jmp    802317 <ipc_recv+0x4c>

00802334 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	57                   	push   %edi
  802338:	56                   	push   %esi
  802339:	53                   	push   %ebx
  80233a:	83 ec 0c             	sub    $0xc,%esp
  80233d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802340:	8b 75 0c             	mov    0xc(%ebp),%esi
  802343:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802346:	85 db                	test   %ebx,%ebx
  802348:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80234d:	0f 44 d8             	cmove  %eax,%ebx
  802350:	eb 05                	jmp    802357 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802352:	e8 8e fc ff ff       	call   801fe5 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802357:	ff 75 14             	pushl  0x14(%ebp)
  80235a:	53                   	push   %ebx
  80235b:	56                   	push   %esi
  80235c:	57                   	push   %edi
  80235d:	e8 2f fe ff ff       	call   802191 <sys_ipc_try_send>
  802362:	83 c4 10             	add    $0x10,%esp
  802365:	85 c0                	test   %eax,%eax
  802367:	74 1b                	je     802384 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802369:	79 e7                	jns    802352 <ipc_send+0x1e>
  80236b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80236e:	74 e2                	je     802352 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802370:	83 ec 04             	sub    $0x4,%esp
  802373:	68 83 3c 80 00       	push   $0x803c83
  802378:	6a 49                	push   $0x49
  80237a:	68 98 3c 80 00       	push   $0x803c98
  80237f:	e8 39 f0 ff ff       	call   8013bd <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802384:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5f                   	pop    %edi
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    

0080238c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802392:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802397:	89 c2                	mov    %eax,%edx
  802399:	c1 e2 07             	shl    $0x7,%edx
  80239c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023a2:	8b 52 50             	mov    0x50(%edx),%edx
  8023a5:	39 ca                	cmp    %ecx,%edx
  8023a7:	74 11                	je     8023ba <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023a9:	83 c0 01             	add    $0x1,%eax
  8023ac:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023b1:	75 e4                	jne    802397 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b8:	eb 0b                	jmp    8023c5 <ipc_find_env+0x39>
			return envs[i].env_id;
  8023ba:	c1 e0 07             	shl    $0x7,%eax
  8023bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023c2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023c5:	5d                   	pop    %ebp
  8023c6:	c3                   	ret    

008023c7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	56                   	push   %esi
  8023cb:	53                   	push   %ebx
  8023cc:	89 c6                	mov    %eax,%esi
  8023ce:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8023d0:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8023d7:	74 27                	je     802400 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8023d9:	6a 07                	push   $0x7
  8023db:	68 00 a0 80 00       	push   $0x80a000
  8023e0:	56                   	push   %esi
  8023e1:	ff 35 00 90 80 00    	pushl  0x809000
  8023e7:	e8 48 ff ff ff       	call   802334 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8023ec:	83 c4 0c             	add    $0xc,%esp
  8023ef:	6a 00                	push   $0x0
  8023f1:	53                   	push   %ebx
  8023f2:	6a 00                	push   $0x0
  8023f4:	e8 d2 fe ff ff       	call   8022cb <ipc_recv>
}
  8023f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802400:	83 ec 0c             	sub    $0xc,%esp
  802403:	6a 01                	push   $0x1
  802405:	e8 82 ff ff ff       	call   80238c <ipc_find_env>
  80240a:	a3 00 90 80 00       	mov    %eax,0x809000
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	eb c5                	jmp    8023d9 <fsipc+0x12>

00802414 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	8b 40 0c             	mov    0xc(%eax),%eax
  802420:	a3 00 a0 80 00       	mov    %eax,0x80a000
	fsipcbuf.set_size.req_size = newsize;
  802425:	8b 45 0c             	mov    0xc(%ebp),%eax
  802428:	a3 04 a0 80 00       	mov    %eax,0x80a004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80242d:	ba 00 00 00 00       	mov    $0x0,%edx
  802432:	b8 02 00 00 00       	mov    $0x2,%eax
  802437:	e8 8b ff ff ff       	call   8023c7 <fsipc>
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <devfile_flush>:
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	8b 40 0c             	mov    0xc(%eax),%eax
  80244a:	a3 00 a0 80 00       	mov    %eax,0x80a000
	return fsipc(FSREQ_FLUSH, NULL);
  80244f:	ba 00 00 00 00       	mov    $0x0,%edx
  802454:	b8 06 00 00 00       	mov    $0x6,%eax
  802459:	e8 69 ff ff ff       	call   8023c7 <fsipc>
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <devfile_stat>:
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	53                   	push   %ebx
  802464:	83 ec 04             	sub    $0x4,%esp
  802467:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	8b 40 0c             	mov    0xc(%eax),%eax
  802470:	a3 00 a0 80 00       	mov    %eax,0x80a000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802475:	ba 00 00 00 00       	mov    $0x0,%edx
  80247a:	b8 05 00 00 00       	mov    $0x5,%eax
  80247f:	e8 43 ff ff ff       	call   8023c7 <fsipc>
  802484:	85 c0                	test   %eax,%eax
  802486:	78 2c                	js     8024b4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802488:	83 ec 08             	sub    $0x8,%esp
  80248b:	68 00 a0 80 00       	push   $0x80a000
  802490:	53                   	push   %ebx
  802491:	e8 7c f7 ff ff       	call   801c12 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802496:	a1 80 a0 80 00       	mov    0x80a080,%eax
  80249b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8024a1:	a1 84 a0 80 00       	mov    0x80a084,%eax
  8024a6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8024ac:	83 c4 10             	add    $0x10,%esp
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <devfile_write>:
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  8024bf:	68 a2 3c 80 00       	push   $0x803ca2
  8024c4:	68 90 00 00 00       	push   $0x90
  8024c9:	68 c0 3c 80 00       	push   $0x803cc0
  8024ce:	e8 ea ee ff ff       	call   8013bd <_panic>

008024d3 <devfile_read>:
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	56                   	push   %esi
  8024d7:	53                   	push   %ebx
  8024d8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e1:	a3 00 a0 80 00       	mov    %eax,0x80a000
	fsipcbuf.read.req_n = n;
  8024e6:	89 35 04 a0 80 00    	mov    %esi,0x80a004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8024ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8024f6:	e8 cc fe ff ff       	call   8023c7 <fsipc>
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	78 1f                	js     802520 <devfile_read+0x4d>
	assert(r <= n);
  802501:	39 f0                	cmp    %esi,%eax
  802503:	77 24                	ja     802529 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802505:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80250a:	7f 33                	jg     80253f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	50                   	push   %eax
  802510:	68 00 a0 80 00       	push   $0x80a000
  802515:	ff 75 0c             	pushl  0xc(%ebp)
  802518:	e8 83 f8 ff ff       	call   801da0 <memmove>
	return r;
  80251d:	83 c4 10             	add    $0x10,%esp
}
  802520:	89 d8                	mov    %ebx,%eax
  802522:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802525:	5b                   	pop    %ebx
  802526:	5e                   	pop    %esi
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    
	assert(r <= n);
  802529:	68 cb 3c 80 00       	push   $0x803ccb
  80252e:	68 1d 33 80 00       	push   $0x80331d
  802533:	6a 7c                	push   $0x7c
  802535:	68 c0 3c 80 00       	push   $0x803cc0
  80253a:	e8 7e ee ff ff       	call   8013bd <_panic>
	assert(r <= PGSIZE);
  80253f:	68 d2 3c 80 00       	push   $0x803cd2
  802544:	68 1d 33 80 00       	push   $0x80331d
  802549:	6a 7d                	push   $0x7d
  80254b:	68 c0 3c 80 00       	push   $0x803cc0
  802550:	e8 68 ee ff ff       	call   8013bd <_panic>

00802555 <open>:
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	56                   	push   %esi
  802559:	53                   	push   %ebx
  80255a:	83 ec 1c             	sub    $0x1c,%esp
  80255d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802560:	56                   	push   %esi
  802561:	e8 73 f6 ff ff       	call   801bd9 <strlen>
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80256e:	7f 6c                	jg     8025dc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802570:	83 ec 0c             	sub    $0xc,%esp
  802573:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802576:	50                   	push   %eax
  802577:	e8 e0 00 00 00       	call   80265c <fd_alloc>
  80257c:	89 c3                	mov    %eax,%ebx
  80257e:	83 c4 10             	add    $0x10,%esp
  802581:	85 c0                	test   %eax,%eax
  802583:	78 3c                	js     8025c1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802585:	83 ec 08             	sub    $0x8,%esp
  802588:	56                   	push   %esi
  802589:	68 00 a0 80 00       	push   $0x80a000
  80258e:	e8 7f f6 ff ff       	call   801c12 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802593:	8b 45 0c             	mov    0xc(%ebp),%eax
  802596:	a3 00 a4 80 00       	mov    %eax,0x80a400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80259b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a3:	e8 1f fe ff ff       	call   8023c7 <fsipc>
  8025a8:	89 c3                	mov    %eax,%ebx
  8025aa:	83 c4 10             	add    $0x10,%esp
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	78 19                	js     8025ca <open+0x75>
	return fd2num(fd);
  8025b1:	83 ec 0c             	sub    $0xc,%esp
  8025b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b7:	e8 79 00 00 00       	call   802635 <fd2num>
  8025bc:	89 c3                	mov    %eax,%ebx
  8025be:	83 c4 10             	add    $0x10,%esp
}
  8025c1:	89 d8                	mov    %ebx,%eax
  8025c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c6:	5b                   	pop    %ebx
  8025c7:	5e                   	pop    %esi
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    
		fd_close(fd, 0);
  8025ca:	83 ec 08             	sub    $0x8,%esp
  8025cd:	6a 00                	push   $0x0
  8025cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d2:	e8 7d 01 00 00       	call   802754 <fd_close>
		return r;
  8025d7:	83 c4 10             	add    $0x10,%esp
  8025da:	eb e5                	jmp    8025c1 <open+0x6c>
		return -E_BAD_PATH;
  8025dc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8025e1:	eb de                	jmp    8025c1 <open+0x6c>

008025e3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8025e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8025f3:	e8 cf fd ff ff       	call   8023c7 <fsipc>
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802600:	89 d0                	mov    %edx,%eax
  802602:	c1 e8 16             	shr    $0x16,%eax
  802605:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80260c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802611:	f6 c1 01             	test   $0x1,%cl
  802614:	74 1d                	je     802633 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802616:	c1 ea 0c             	shr    $0xc,%edx
  802619:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802620:	f6 c2 01             	test   $0x1,%dl
  802623:	74 0e                	je     802633 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802625:	c1 ea 0c             	shr    $0xc,%edx
  802628:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80262f:	ef 
  802630:	0f b7 c0             	movzwl %ax,%eax
}
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    

00802635 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	05 00 00 00 30       	add    $0x30000000,%eax
  802640:	c1 e8 0c             	shr    $0xc,%eax
}
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    

00802645 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802650:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802655:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80265a:	5d                   	pop    %ebp
  80265b:	c3                   	ret    

0080265c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802664:	89 c2                	mov    %eax,%edx
  802666:	c1 ea 16             	shr    $0x16,%edx
  802669:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802670:	f6 c2 01             	test   $0x1,%dl
  802673:	74 2d                	je     8026a2 <fd_alloc+0x46>
  802675:	89 c2                	mov    %eax,%edx
  802677:	c1 ea 0c             	shr    $0xc,%edx
  80267a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802681:	f6 c2 01             	test   $0x1,%dl
  802684:	74 1c                	je     8026a2 <fd_alloc+0x46>
  802686:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80268b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802690:	75 d2                	jne    802664 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80269b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8026a0:	eb 0a                	jmp    8026ac <fd_alloc+0x50>
			*fd_store = fd;
  8026a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026a5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ac:	5d                   	pop    %ebp
  8026ad:	c3                   	ret    

008026ae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
  8026b1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026b4:	83 f8 1f             	cmp    $0x1f,%eax
  8026b7:	77 30                	ja     8026e9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8026b9:	c1 e0 0c             	shl    $0xc,%eax
  8026bc:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026c1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8026c7:	f6 c2 01             	test   $0x1,%dl
  8026ca:	74 24                	je     8026f0 <fd_lookup+0x42>
  8026cc:	89 c2                	mov    %eax,%edx
  8026ce:	c1 ea 0c             	shr    $0xc,%edx
  8026d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8026d8:	f6 c2 01             	test   $0x1,%dl
  8026db:	74 1a                	je     8026f7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8026dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e0:	89 02                	mov    %eax,(%edx)
	return 0;
  8026e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e7:	5d                   	pop    %ebp
  8026e8:	c3                   	ret    
		return -E_INVAL;
  8026e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026ee:	eb f7                	jmp    8026e7 <fd_lookup+0x39>
		return -E_INVAL;
  8026f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026f5:	eb f0                	jmp    8026e7 <fd_lookup+0x39>
  8026f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026fc:	eb e9                	jmp    8026e7 <fd_lookup+0x39>

008026fe <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	83 ec 08             	sub    $0x8,%esp
  802704:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802707:	ba 60 3d 80 00       	mov    $0x803d60,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80270c:	b8 64 80 80 00       	mov    $0x808064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802711:	39 08                	cmp    %ecx,(%eax)
  802713:	74 33                	je     802748 <dev_lookup+0x4a>
  802715:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  802718:	8b 02                	mov    (%edx),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	75 f3                	jne    802711 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80271e:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802723:	8b 40 48             	mov    0x48(%eax),%eax
  802726:	83 ec 04             	sub    $0x4,%esp
  802729:	51                   	push   %ecx
  80272a:	50                   	push   %eax
  80272b:	68 e0 3c 80 00       	push   $0x803ce0
  802730:	e8 7e ed ff ff       	call   8014b3 <cprintf>
	*dev = 0;
  802735:	8b 45 0c             	mov    0xc(%ebp),%eax
  802738:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80273e:	83 c4 10             	add    $0x10,%esp
  802741:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    
			*dev = devtab[i];
  802748:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80274b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
  802752:	eb f2                	jmp    802746 <dev_lookup+0x48>

00802754 <fd_close>:
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	57                   	push   %edi
  802758:	56                   	push   %esi
  802759:	53                   	push   %ebx
  80275a:	83 ec 24             	sub    $0x24,%esp
  80275d:	8b 75 08             	mov    0x8(%ebp),%esi
  802760:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802763:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802766:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802767:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80276d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802770:	50                   	push   %eax
  802771:	e8 38 ff ff ff       	call   8026ae <fd_lookup>
  802776:	89 c3                	mov    %eax,%ebx
  802778:	83 c4 10             	add    $0x10,%esp
  80277b:	85 c0                	test   %eax,%eax
  80277d:	78 05                	js     802784 <fd_close+0x30>
	    || fd != fd2)
  80277f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802782:	74 16                	je     80279a <fd_close+0x46>
		return (must_exist ? r : 0);
  802784:	89 f8                	mov    %edi,%eax
  802786:	84 c0                	test   %al,%al
  802788:	b8 00 00 00 00       	mov    $0x0,%eax
  80278d:	0f 44 d8             	cmove  %eax,%ebx
}
  802790:	89 d8                	mov    %ebx,%eax
  802792:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802795:	5b                   	pop    %ebx
  802796:	5e                   	pop    %esi
  802797:	5f                   	pop    %edi
  802798:	5d                   	pop    %ebp
  802799:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80279a:	83 ec 08             	sub    $0x8,%esp
  80279d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8027a0:	50                   	push   %eax
  8027a1:	ff 36                	pushl  (%esi)
  8027a3:	e8 56 ff ff ff       	call   8026fe <dev_lookup>
  8027a8:	89 c3                	mov    %eax,%ebx
  8027aa:	83 c4 10             	add    $0x10,%esp
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	78 1a                	js     8027cb <fd_close+0x77>
		if (dev->dev_close)
  8027b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8027b7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	74 0b                	je     8027cb <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8027c0:	83 ec 0c             	sub    $0xc,%esp
  8027c3:	56                   	push   %esi
  8027c4:	ff d0                	call   *%eax
  8027c6:	89 c3                	mov    %eax,%ebx
  8027c8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8027cb:	83 ec 08             	sub    $0x8,%esp
  8027ce:	56                   	push   %esi
  8027cf:	6a 00                	push   $0x0
  8027d1:	e8 b3 f8 ff ff       	call   802089 <sys_page_unmap>
	return r;
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	eb b5                	jmp    802790 <fd_close+0x3c>

008027db <close>:

int
close(int fdnum)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e4:	50                   	push   %eax
  8027e5:	ff 75 08             	pushl  0x8(%ebp)
  8027e8:	e8 c1 fe ff ff       	call   8026ae <fd_lookup>
  8027ed:	83 c4 10             	add    $0x10,%esp
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	79 02                	jns    8027f6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    
		return fd_close(fd, 1);
  8027f6:	83 ec 08             	sub    $0x8,%esp
  8027f9:	6a 01                	push   $0x1
  8027fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8027fe:	e8 51 ff ff ff       	call   802754 <fd_close>
  802803:	83 c4 10             	add    $0x10,%esp
  802806:	eb ec                	jmp    8027f4 <close+0x19>

00802808 <close_all>:

void
close_all(void)
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
  80280b:	53                   	push   %ebx
  80280c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80280f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802814:	83 ec 0c             	sub    $0xc,%esp
  802817:	53                   	push   %ebx
  802818:	e8 be ff ff ff       	call   8027db <close>
	for (i = 0; i < MAXFD; i++)
  80281d:	83 c3 01             	add    $0x1,%ebx
  802820:	83 c4 10             	add    $0x10,%esp
  802823:	83 fb 20             	cmp    $0x20,%ebx
  802826:	75 ec                	jne    802814 <close_all+0xc>
}
  802828:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	57                   	push   %edi
  802831:	56                   	push   %esi
  802832:	53                   	push   %ebx
  802833:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802836:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802839:	50                   	push   %eax
  80283a:	ff 75 08             	pushl  0x8(%ebp)
  80283d:	e8 6c fe ff ff       	call   8026ae <fd_lookup>
  802842:	89 c3                	mov    %eax,%ebx
  802844:	83 c4 10             	add    $0x10,%esp
  802847:	85 c0                	test   %eax,%eax
  802849:	0f 88 81 00 00 00    	js     8028d0 <dup+0xa3>
		return r;
	close(newfdnum);
  80284f:	83 ec 0c             	sub    $0xc,%esp
  802852:	ff 75 0c             	pushl  0xc(%ebp)
  802855:	e8 81 ff ff ff       	call   8027db <close>

	newfd = INDEX2FD(newfdnum);
  80285a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80285d:	c1 e6 0c             	shl    $0xc,%esi
  802860:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802866:	83 c4 04             	add    $0x4,%esp
  802869:	ff 75 e4             	pushl  -0x1c(%ebp)
  80286c:	e8 d4 fd ff ff       	call   802645 <fd2data>
  802871:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802873:	89 34 24             	mov    %esi,(%esp)
  802876:	e8 ca fd ff ff       	call   802645 <fd2data>
  80287b:	83 c4 10             	add    $0x10,%esp
  80287e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802880:	89 d8                	mov    %ebx,%eax
  802882:	c1 e8 16             	shr    $0x16,%eax
  802885:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80288c:	a8 01                	test   $0x1,%al
  80288e:	74 11                	je     8028a1 <dup+0x74>
  802890:	89 d8                	mov    %ebx,%eax
  802892:	c1 e8 0c             	shr    $0xc,%eax
  802895:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80289c:	f6 c2 01             	test   $0x1,%dl
  80289f:	75 39                	jne    8028da <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a4:	89 d0                	mov    %edx,%eax
  8028a6:	c1 e8 0c             	shr    $0xc,%eax
  8028a9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8028b0:	83 ec 0c             	sub    $0xc,%esp
  8028b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8028b8:	50                   	push   %eax
  8028b9:	56                   	push   %esi
  8028ba:	6a 00                	push   $0x0
  8028bc:	52                   	push   %edx
  8028bd:	6a 00                	push   $0x0
  8028bf:	e8 83 f7 ff ff       	call   802047 <sys_page_map>
  8028c4:	89 c3                	mov    %eax,%ebx
  8028c6:	83 c4 20             	add    $0x20,%esp
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	78 31                	js     8028fe <dup+0xd1>
		goto err;

	return newfdnum;
  8028cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8028d0:	89 d8                	mov    %ebx,%eax
  8028d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028d5:	5b                   	pop    %ebx
  8028d6:	5e                   	pop    %esi
  8028d7:	5f                   	pop    %edi
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8028e1:	83 ec 0c             	sub    $0xc,%esp
  8028e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8028e9:	50                   	push   %eax
  8028ea:	57                   	push   %edi
  8028eb:	6a 00                	push   $0x0
  8028ed:	53                   	push   %ebx
  8028ee:	6a 00                	push   $0x0
  8028f0:	e8 52 f7 ff ff       	call   802047 <sys_page_map>
  8028f5:	89 c3                	mov    %eax,%ebx
  8028f7:	83 c4 20             	add    $0x20,%esp
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	79 a3                	jns    8028a1 <dup+0x74>
	sys_page_unmap(0, newfd);
  8028fe:	83 ec 08             	sub    $0x8,%esp
  802901:	56                   	push   %esi
  802902:	6a 00                	push   $0x0
  802904:	e8 80 f7 ff ff       	call   802089 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802909:	83 c4 08             	add    $0x8,%esp
  80290c:	57                   	push   %edi
  80290d:	6a 00                	push   $0x0
  80290f:	e8 75 f7 ff ff       	call   802089 <sys_page_unmap>
	return r;
  802914:	83 c4 10             	add    $0x10,%esp
  802917:	eb b7                	jmp    8028d0 <dup+0xa3>

00802919 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802919:	55                   	push   %ebp
  80291a:	89 e5                	mov    %esp,%ebp
  80291c:	53                   	push   %ebx
  80291d:	83 ec 1c             	sub    $0x1c,%esp
  802920:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802923:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802926:	50                   	push   %eax
  802927:	53                   	push   %ebx
  802928:	e8 81 fd ff ff       	call   8026ae <fd_lookup>
  80292d:	83 c4 10             	add    $0x10,%esp
  802930:	85 c0                	test   %eax,%eax
  802932:	78 3f                	js     802973 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802934:	83 ec 08             	sub    $0x8,%esp
  802937:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80293a:	50                   	push   %eax
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	ff 30                	pushl  (%eax)
  802940:	e8 b9 fd ff ff       	call   8026fe <dev_lookup>
  802945:	83 c4 10             	add    $0x10,%esp
  802948:	85 c0                	test   %eax,%eax
  80294a:	78 27                	js     802973 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80294c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294f:	8b 42 08             	mov    0x8(%edx),%eax
  802952:	83 e0 03             	and    $0x3,%eax
  802955:	83 f8 01             	cmp    $0x1,%eax
  802958:	74 1e                	je     802978 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 40 08             	mov    0x8(%eax),%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	74 35                	je     802999 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	ff 75 10             	pushl  0x10(%ebp)
  80296a:	ff 75 0c             	pushl  0xc(%ebp)
  80296d:	52                   	push   %edx
  80296e:	ff d0                	call   *%eax
  802970:	83 c4 10             	add    $0x10,%esp
}
  802973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802976:	c9                   	leave  
  802977:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802978:	a1 0c 90 80 00       	mov    0x80900c,%eax
  80297d:	8b 40 48             	mov    0x48(%eax),%eax
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	53                   	push   %ebx
  802984:	50                   	push   %eax
  802985:	68 24 3d 80 00       	push   $0x803d24
  80298a:	e8 24 eb ff ff       	call   8014b3 <cprintf>
		return -E_INVAL;
  80298f:	83 c4 10             	add    $0x10,%esp
  802992:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802997:	eb da                	jmp    802973 <read+0x5a>
		return -E_NOT_SUPP;
  802999:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80299e:	eb d3                	jmp    802973 <read+0x5a>

008029a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
  8029a3:	57                   	push   %edi
  8029a4:	56                   	push   %esi
  8029a5:	53                   	push   %ebx
  8029a6:	83 ec 0c             	sub    $0xc,%esp
  8029a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029b4:	39 f3                	cmp    %esi,%ebx
  8029b6:	73 23                	jae    8029db <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029b8:	83 ec 04             	sub    $0x4,%esp
  8029bb:	89 f0                	mov    %esi,%eax
  8029bd:	29 d8                	sub    %ebx,%eax
  8029bf:	50                   	push   %eax
  8029c0:	89 d8                	mov    %ebx,%eax
  8029c2:	03 45 0c             	add    0xc(%ebp),%eax
  8029c5:	50                   	push   %eax
  8029c6:	57                   	push   %edi
  8029c7:	e8 4d ff ff ff       	call   802919 <read>
		if (m < 0)
  8029cc:	83 c4 10             	add    $0x10,%esp
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	78 06                	js     8029d9 <readn+0x39>
			return m;
		if (m == 0)
  8029d3:	74 06                	je     8029db <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8029d5:	01 c3                	add    %eax,%ebx
  8029d7:	eb db                	jmp    8029b4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029d9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8029db:	89 d8                	mov    %ebx,%eax
  8029dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029e0:	5b                   	pop    %ebx
  8029e1:	5e                   	pop    %esi
  8029e2:	5f                   	pop    %edi
  8029e3:	5d                   	pop    %ebp
  8029e4:	c3                   	ret    

008029e5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
  8029e8:	53                   	push   %ebx
  8029e9:	83 ec 1c             	sub    $0x1c,%esp
  8029ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8029f2:	50                   	push   %eax
  8029f3:	53                   	push   %ebx
  8029f4:	e8 b5 fc ff ff       	call   8026ae <fd_lookup>
  8029f9:	83 c4 10             	add    $0x10,%esp
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	78 3a                	js     802a3a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a00:	83 ec 08             	sub    $0x8,%esp
  802a03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a06:	50                   	push   %eax
  802a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0a:	ff 30                	pushl  (%eax)
  802a0c:	e8 ed fc ff ff       	call   8026fe <dev_lookup>
  802a11:	83 c4 10             	add    $0x10,%esp
  802a14:	85 c0                	test   %eax,%eax
  802a16:	78 22                	js     802a3a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802a1f:	74 1e                	je     802a3f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a24:	8b 52 0c             	mov    0xc(%edx),%edx
  802a27:	85 d2                	test   %edx,%edx
  802a29:	74 35                	je     802a60 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	ff 75 10             	pushl  0x10(%ebp)
  802a31:	ff 75 0c             	pushl  0xc(%ebp)
  802a34:	50                   	push   %eax
  802a35:	ff d2                	call   *%edx
  802a37:	83 c4 10             	add    $0x10,%esp
}
  802a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a3f:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802a44:	8b 40 48             	mov    0x48(%eax),%eax
  802a47:	83 ec 04             	sub    $0x4,%esp
  802a4a:	53                   	push   %ebx
  802a4b:	50                   	push   %eax
  802a4c:	68 40 3d 80 00       	push   $0x803d40
  802a51:	e8 5d ea ff ff       	call   8014b3 <cprintf>
		return -E_INVAL;
  802a56:	83 c4 10             	add    $0x10,%esp
  802a59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a5e:	eb da                	jmp    802a3a <write+0x55>
		return -E_NOT_SUPP;
  802a60:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802a65:	eb d3                	jmp    802a3a <write+0x55>

00802a67 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
  802a6a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a70:	50                   	push   %eax
  802a71:	ff 75 08             	pushl  0x8(%ebp)
  802a74:	e8 35 fc ff ff       	call   8026ae <fd_lookup>
  802a79:	83 c4 10             	add    $0x10,%esp
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	78 0e                	js     802a8e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802a89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8e:	c9                   	leave  
  802a8f:	c3                   	ret    

00802a90 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a90:	55                   	push   %ebp
  802a91:	89 e5                	mov    %esp,%ebp
  802a93:	53                   	push   %ebx
  802a94:	83 ec 1c             	sub    $0x1c,%esp
  802a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a9d:	50                   	push   %eax
  802a9e:	53                   	push   %ebx
  802a9f:	e8 0a fc ff ff       	call   8026ae <fd_lookup>
  802aa4:	83 c4 10             	add    $0x10,%esp
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	78 37                	js     802ae2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aab:	83 ec 08             	sub    $0x8,%esp
  802aae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ab1:	50                   	push   %eax
  802ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab5:	ff 30                	pushl  (%eax)
  802ab7:	e8 42 fc ff ff       	call   8026fe <dev_lookup>
  802abc:	83 c4 10             	add    $0x10,%esp
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	78 1f                	js     802ae2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802aca:	74 1b                	je     802ae7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acf:	8b 52 18             	mov    0x18(%edx),%edx
  802ad2:	85 d2                	test   %edx,%edx
  802ad4:	74 32                	je     802b08 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802ad6:	83 ec 08             	sub    $0x8,%esp
  802ad9:	ff 75 0c             	pushl  0xc(%ebp)
  802adc:	50                   	push   %eax
  802add:	ff d2                	call   *%edx
  802adf:	83 c4 10             	add    $0x10,%esp
}
  802ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ae5:	c9                   	leave  
  802ae6:	c3                   	ret    
			thisenv->env_id, fdnum);
  802ae7:	a1 0c 90 80 00       	mov    0x80900c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802aec:	8b 40 48             	mov    0x48(%eax),%eax
  802aef:	83 ec 04             	sub    $0x4,%esp
  802af2:	53                   	push   %ebx
  802af3:	50                   	push   %eax
  802af4:	68 00 3d 80 00       	push   $0x803d00
  802af9:	e8 b5 e9 ff ff       	call   8014b3 <cprintf>
		return -E_INVAL;
  802afe:	83 c4 10             	add    $0x10,%esp
  802b01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b06:	eb da                	jmp    802ae2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  802b08:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802b0d:	eb d3                	jmp    802ae2 <ftruncate+0x52>

00802b0f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
  802b12:	53                   	push   %ebx
  802b13:	83 ec 1c             	sub    $0x1c,%esp
  802b16:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b19:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b1c:	50                   	push   %eax
  802b1d:	ff 75 08             	pushl  0x8(%ebp)
  802b20:	e8 89 fb ff ff       	call   8026ae <fd_lookup>
  802b25:	83 c4 10             	add    $0x10,%esp
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	78 4b                	js     802b77 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b2c:	83 ec 08             	sub    $0x8,%esp
  802b2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b32:	50                   	push   %eax
  802b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b36:	ff 30                	pushl  (%eax)
  802b38:	e8 c1 fb ff ff       	call   8026fe <dev_lookup>
  802b3d:	83 c4 10             	add    $0x10,%esp
  802b40:	85 c0                	test   %eax,%eax
  802b42:	78 33                	js     802b77 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802b4b:	74 2f                	je     802b7c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802b4d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802b50:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802b57:	00 00 00 
	stat->st_isdir = 0;
  802b5a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802b61:	00 00 00 
	stat->st_dev = dev;
  802b64:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802b6a:	83 ec 08             	sub    $0x8,%esp
  802b6d:	53                   	push   %ebx
  802b6e:	ff 75 f0             	pushl  -0x10(%ebp)
  802b71:	ff 50 14             	call   *0x14(%eax)
  802b74:	83 c4 10             	add    $0x10,%esp
}
  802b77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b7a:	c9                   	leave  
  802b7b:	c3                   	ret    
		return -E_NOT_SUPP;
  802b7c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802b81:	eb f4                	jmp    802b77 <fstat+0x68>

00802b83 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b83:	55                   	push   %ebp
  802b84:	89 e5                	mov    %esp,%ebp
  802b86:	56                   	push   %esi
  802b87:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b88:	83 ec 08             	sub    $0x8,%esp
  802b8b:	6a 00                	push   $0x0
  802b8d:	ff 75 08             	pushl  0x8(%ebp)
  802b90:	e8 c0 f9 ff ff       	call   802555 <open>
  802b95:	89 c3                	mov    %eax,%ebx
  802b97:	83 c4 10             	add    $0x10,%esp
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	78 1b                	js     802bb9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802b9e:	83 ec 08             	sub    $0x8,%esp
  802ba1:	ff 75 0c             	pushl  0xc(%ebp)
  802ba4:	50                   	push   %eax
  802ba5:	e8 65 ff ff ff       	call   802b0f <fstat>
  802baa:	89 c6                	mov    %eax,%esi
	close(fd);
  802bac:	89 1c 24             	mov    %ebx,(%esp)
  802baf:	e8 27 fc ff ff       	call   8027db <close>
	return r;
  802bb4:	83 c4 10             	add    $0x10,%esp
  802bb7:	89 f3                	mov    %esi,%ebx
}
  802bb9:	89 d8                	mov    %ebx,%eax
  802bbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bbe:	5b                   	pop    %ebx
  802bbf:	5e                   	pop    %esi
  802bc0:	5d                   	pop    %ebp
  802bc1:	c3                   	ret    

00802bc2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
  802bc5:	56                   	push   %esi
  802bc6:	53                   	push   %ebx
  802bc7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802bca:	83 ec 0c             	sub    $0xc,%esp
  802bcd:	ff 75 08             	pushl  0x8(%ebp)
  802bd0:	e8 70 fa ff ff       	call   802645 <fd2data>
  802bd5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802bd7:	83 c4 08             	add    $0x8,%esp
  802bda:	68 70 3d 80 00       	push   $0x803d70
  802bdf:	53                   	push   %ebx
  802be0:	e8 2d f0 ff ff       	call   801c12 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802be5:	8b 46 04             	mov    0x4(%esi),%eax
  802be8:	2b 06                	sub    (%esi),%eax
  802bea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802bf0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802bf7:	00 00 00 
	stat->st_dev = &devpipe;
  802bfa:	c7 83 88 00 00 00 80 	movl   $0x808080,0x88(%ebx)
  802c01:	80 80 00 
	return 0;
}
  802c04:	b8 00 00 00 00       	mov    $0x0,%eax
  802c09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c0c:	5b                   	pop    %ebx
  802c0d:	5e                   	pop    %esi
  802c0e:	5d                   	pop    %ebp
  802c0f:	c3                   	ret    

00802c10 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c10:	55                   	push   %ebp
  802c11:	89 e5                	mov    %esp,%ebp
  802c13:	53                   	push   %ebx
  802c14:	83 ec 0c             	sub    $0xc,%esp
  802c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c1a:	53                   	push   %ebx
  802c1b:	6a 00                	push   $0x0
  802c1d:	e8 67 f4 ff ff       	call   802089 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c22:	89 1c 24             	mov    %ebx,(%esp)
  802c25:	e8 1b fa ff ff       	call   802645 <fd2data>
  802c2a:	83 c4 08             	add    $0x8,%esp
  802c2d:	50                   	push   %eax
  802c2e:	6a 00                	push   $0x0
  802c30:	e8 54 f4 ff ff       	call   802089 <sys_page_unmap>
}
  802c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c38:	c9                   	leave  
  802c39:	c3                   	ret    

00802c3a <_pipeisclosed>:
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
  802c3d:	57                   	push   %edi
  802c3e:	56                   	push   %esi
  802c3f:	53                   	push   %ebx
  802c40:	83 ec 1c             	sub    $0x1c,%esp
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802c47:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802c4c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c4f:	83 ec 0c             	sub    $0xc,%esp
  802c52:	57                   	push   %edi
  802c53:	e8 a2 f9 ff ff       	call   8025fa <pageref>
  802c58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802c5b:	89 34 24             	mov    %esi,(%esp)
  802c5e:	e8 97 f9 ff ff       	call   8025fa <pageref>
		nn = thisenv->env_runs;
  802c63:	8b 15 0c 90 80 00    	mov    0x80900c,%edx
  802c69:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802c6c:	83 c4 10             	add    $0x10,%esp
  802c6f:	39 cb                	cmp    %ecx,%ebx
  802c71:	74 1b                	je     802c8e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802c73:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802c76:	75 cf                	jne    802c47 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c78:	8b 42 58             	mov    0x58(%edx),%eax
  802c7b:	6a 01                	push   $0x1
  802c7d:	50                   	push   %eax
  802c7e:	53                   	push   %ebx
  802c7f:	68 77 3d 80 00       	push   $0x803d77
  802c84:	e8 2a e8 ff ff       	call   8014b3 <cprintf>
  802c89:	83 c4 10             	add    $0x10,%esp
  802c8c:	eb b9                	jmp    802c47 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802c8e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802c91:	0f 94 c0             	sete   %al
  802c94:	0f b6 c0             	movzbl %al,%eax
}
  802c97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c9a:	5b                   	pop    %ebx
  802c9b:	5e                   	pop    %esi
  802c9c:	5f                   	pop    %edi
  802c9d:	5d                   	pop    %ebp
  802c9e:	c3                   	ret    

00802c9f <devpipe_write>:
{
  802c9f:	55                   	push   %ebp
  802ca0:	89 e5                	mov    %esp,%ebp
  802ca2:	57                   	push   %edi
  802ca3:	56                   	push   %esi
  802ca4:	53                   	push   %ebx
  802ca5:	83 ec 28             	sub    $0x28,%esp
  802ca8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802cab:	56                   	push   %esi
  802cac:	e8 94 f9 ff ff       	call   802645 <fd2data>
  802cb1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802cb3:	83 c4 10             	add    $0x10,%esp
  802cb6:	bf 00 00 00 00       	mov    $0x0,%edi
  802cbb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cbe:	74 4f                	je     802d0f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802cc0:	8b 43 04             	mov    0x4(%ebx),%eax
  802cc3:	8b 0b                	mov    (%ebx),%ecx
  802cc5:	8d 51 20             	lea    0x20(%ecx),%edx
  802cc8:	39 d0                	cmp    %edx,%eax
  802cca:	72 14                	jb     802ce0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802ccc:	89 da                	mov    %ebx,%edx
  802cce:	89 f0                	mov    %esi,%eax
  802cd0:	e8 65 ff ff ff       	call   802c3a <_pipeisclosed>
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	75 3b                	jne    802d14 <devpipe_write+0x75>
			sys_yield();
  802cd9:	e8 07 f3 ff ff       	call   801fe5 <sys_yield>
  802cde:	eb e0                	jmp    802cc0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ce3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802ce7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802cea:	89 c2                	mov    %eax,%edx
  802cec:	c1 fa 1f             	sar    $0x1f,%edx
  802cef:	89 d1                	mov    %edx,%ecx
  802cf1:	c1 e9 1b             	shr    $0x1b,%ecx
  802cf4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802cf7:	83 e2 1f             	and    $0x1f,%edx
  802cfa:	29 ca                	sub    %ecx,%edx
  802cfc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802d00:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802d04:	83 c0 01             	add    $0x1,%eax
  802d07:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802d0a:	83 c7 01             	add    $0x1,%edi
  802d0d:	eb ac                	jmp    802cbb <devpipe_write+0x1c>
	return i;
  802d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  802d12:	eb 05                	jmp    802d19 <devpipe_write+0x7a>
				return 0;
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d1c:	5b                   	pop    %ebx
  802d1d:	5e                   	pop    %esi
  802d1e:	5f                   	pop    %edi
  802d1f:	5d                   	pop    %ebp
  802d20:	c3                   	ret    

00802d21 <devpipe_read>:
{
  802d21:	55                   	push   %ebp
  802d22:	89 e5                	mov    %esp,%ebp
  802d24:	57                   	push   %edi
  802d25:	56                   	push   %esi
  802d26:	53                   	push   %ebx
  802d27:	83 ec 18             	sub    $0x18,%esp
  802d2a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802d2d:	57                   	push   %edi
  802d2e:	e8 12 f9 ff ff       	call   802645 <fd2data>
  802d33:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d35:	83 c4 10             	add    $0x10,%esp
  802d38:	be 00 00 00 00       	mov    $0x0,%esi
  802d3d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d40:	75 14                	jne    802d56 <devpipe_read+0x35>
	return i;
  802d42:	8b 45 10             	mov    0x10(%ebp),%eax
  802d45:	eb 02                	jmp    802d49 <devpipe_read+0x28>
				return i;
  802d47:	89 f0                	mov    %esi,%eax
}
  802d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d4c:	5b                   	pop    %ebx
  802d4d:	5e                   	pop    %esi
  802d4e:	5f                   	pop    %edi
  802d4f:	5d                   	pop    %ebp
  802d50:	c3                   	ret    
			sys_yield();
  802d51:	e8 8f f2 ff ff       	call   801fe5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802d56:	8b 03                	mov    (%ebx),%eax
  802d58:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d5b:	75 18                	jne    802d75 <devpipe_read+0x54>
			if (i > 0)
  802d5d:	85 f6                	test   %esi,%esi
  802d5f:	75 e6                	jne    802d47 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802d61:	89 da                	mov    %ebx,%edx
  802d63:	89 f8                	mov    %edi,%eax
  802d65:	e8 d0 fe ff ff       	call   802c3a <_pipeisclosed>
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	74 e3                	je     802d51 <devpipe_read+0x30>
				return 0;
  802d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d73:	eb d4                	jmp    802d49 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d75:	99                   	cltd   
  802d76:	c1 ea 1b             	shr    $0x1b,%edx
  802d79:	01 d0                	add    %edx,%eax
  802d7b:	83 e0 1f             	and    $0x1f,%eax
  802d7e:	29 d0                	sub    %edx,%eax
  802d80:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802d85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d88:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802d8b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802d8e:	83 c6 01             	add    $0x1,%esi
  802d91:	eb aa                	jmp    802d3d <devpipe_read+0x1c>

00802d93 <pipe>:
{
  802d93:	55                   	push   %ebp
  802d94:	89 e5                	mov    %esp,%ebp
  802d96:	56                   	push   %esi
  802d97:	53                   	push   %ebx
  802d98:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802d9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d9e:	50                   	push   %eax
  802d9f:	e8 b8 f8 ff ff       	call   80265c <fd_alloc>
  802da4:	89 c3                	mov    %eax,%ebx
  802da6:	83 c4 10             	add    $0x10,%esp
  802da9:	85 c0                	test   %eax,%eax
  802dab:	0f 88 23 01 00 00    	js     802ed4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802db1:	83 ec 04             	sub    $0x4,%esp
  802db4:	68 07 04 00 00       	push   $0x407
  802db9:	ff 75 f4             	pushl  -0xc(%ebp)
  802dbc:	6a 00                	push   $0x0
  802dbe:	e8 41 f2 ff ff       	call   802004 <sys_page_alloc>
  802dc3:	89 c3                	mov    %eax,%ebx
  802dc5:	83 c4 10             	add    $0x10,%esp
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	0f 88 04 01 00 00    	js     802ed4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802dd0:	83 ec 0c             	sub    $0xc,%esp
  802dd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802dd6:	50                   	push   %eax
  802dd7:	e8 80 f8 ff ff       	call   80265c <fd_alloc>
  802ddc:	89 c3                	mov    %eax,%ebx
  802dde:	83 c4 10             	add    $0x10,%esp
  802de1:	85 c0                	test   %eax,%eax
  802de3:	0f 88 db 00 00 00    	js     802ec4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802de9:	83 ec 04             	sub    $0x4,%esp
  802dec:	68 07 04 00 00       	push   $0x407
  802df1:	ff 75 f0             	pushl  -0x10(%ebp)
  802df4:	6a 00                	push   $0x0
  802df6:	e8 09 f2 ff ff       	call   802004 <sys_page_alloc>
  802dfb:	89 c3                	mov    %eax,%ebx
  802dfd:	83 c4 10             	add    $0x10,%esp
  802e00:	85 c0                	test   %eax,%eax
  802e02:	0f 88 bc 00 00 00    	js     802ec4 <pipe+0x131>
	va = fd2data(fd0);
  802e08:	83 ec 0c             	sub    $0xc,%esp
  802e0b:	ff 75 f4             	pushl  -0xc(%ebp)
  802e0e:	e8 32 f8 ff ff       	call   802645 <fd2data>
  802e13:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e15:	83 c4 0c             	add    $0xc,%esp
  802e18:	68 07 04 00 00       	push   $0x407
  802e1d:	50                   	push   %eax
  802e1e:	6a 00                	push   $0x0
  802e20:	e8 df f1 ff ff       	call   802004 <sys_page_alloc>
  802e25:	89 c3                	mov    %eax,%ebx
  802e27:	83 c4 10             	add    $0x10,%esp
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	0f 88 82 00 00 00    	js     802eb4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e32:	83 ec 0c             	sub    $0xc,%esp
  802e35:	ff 75 f0             	pushl  -0x10(%ebp)
  802e38:	e8 08 f8 ff ff       	call   802645 <fd2data>
  802e3d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802e44:	50                   	push   %eax
  802e45:	6a 00                	push   $0x0
  802e47:	56                   	push   %esi
  802e48:	6a 00                	push   $0x0
  802e4a:	e8 f8 f1 ff ff       	call   802047 <sys_page_map>
  802e4f:	89 c3                	mov    %eax,%ebx
  802e51:	83 c4 20             	add    $0x20,%esp
  802e54:	85 c0                	test   %eax,%eax
  802e56:	78 4e                	js     802ea6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802e58:	a1 80 80 80 00       	mov    0x808080,%eax
  802e5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e60:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e65:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802e6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802e7b:	83 ec 0c             	sub    $0xc,%esp
  802e7e:	ff 75 f4             	pushl  -0xc(%ebp)
  802e81:	e8 af f7 ff ff       	call   802635 <fd2num>
  802e86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e89:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802e8b:	83 c4 04             	add    $0x4,%esp
  802e8e:	ff 75 f0             	pushl  -0x10(%ebp)
  802e91:	e8 9f f7 ff ff       	call   802635 <fd2num>
  802e96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e99:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802e9c:	83 c4 10             	add    $0x10,%esp
  802e9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ea4:	eb 2e                	jmp    802ed4 <pipe+0x141>
	sys_page_unmap(0, va);
  802ea6:	83 ec 08             	sub    $0x8,%esp
  802ea9:	56                   	push   %esi
  802eaa:	6a 00                	push   $0x0
  802eac:	e8 d8 f1 ff ff       	call   802089 <sys_page_unmap>
  802eb1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802eb4:	83 ec 08             	sub    $0x8,%esp
  802eb7:	ff 75 f0             	pushl  -0x10(%ebp)
  802eba:	6a 00                	push   $0x0
  802ebc:	e8 c8 f1 ff ff       	call   802089 <sys_page_unmap>
  802ec1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802ec4:	83 ec 08             	sub    $0x8,%esp
  802ec7:	ff 75 f4             	pushl  -0xc(%ebp)
  802eca:	6a 00                	push   $0x0
  802ecc:	e8 b8 f1 ff ff       	call   802089 <sys_page_unmap>
  802ed1:	83 c4 10             	add    $0x10,%esp
}
  802ed4:	89 d8                	mov    %ebx,%eax
  802ed6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ed9:	5b                   	pop    %ebx
  802eda:	5e                   	pop    %esi
  802edb:	5d                   	pop    %ebp
  802edc:	c3                   	ret    

00802edd <pipeisclosed>:
{
  802edd:	55                   	push   %ebp
  802ede:	89 e5                	mov    %esp,%ebp
  802ee0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ee3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ee6:	50                   	push   %eax
  802ee7:	ff 75 08             	pushl  0x8(%ebp)
  802eea:	e8 bf f7 ff ff       	call   8026ae <fd_lookup>
  802eef:	83 c4 10             	add    $0x10,%esp
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	78 18                	js     802f0e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802ef6:	83 ec 0c             	sub    $0xc,%esp
  802ef9:	ff 75 f4             	pushl  -0xc(%ebp)
  802efc:	e8 44 f7 ff ff       	call   802645 <fd2data>
	return _pipeisclosed(fd, p);
  802f01:	89 c2                	mov    %eax,%edx
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	e8 2f fd ff ff       	call   802c3a <_pipeisclosed>
  802f0b:	83 c4 10             	add    $0x10,%esp
}
  802f0e:	c9                   	leave  
  802f0f:	c3                   	ret    

00802f10 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802f10:	b8 00 00 00 00       	mov    $0x0,%eax
  802f15:	c3                   	ret    

00802f16 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802f16:	55                   	push   %ebp
  802f17:	89 e5                	mov    %esp,%ebp
  802f19:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802f1c:	68 8f 3d 80 00       	push   $0x803d8f
  802f21:	ff 75 0c             	pushl  0xc(%ebp)
  802f24:	e8 e9 ec ff ff       	call   801c12 <strcpy>
	return 0;
}
  802f29:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2e:	c9                   	leave  
  802f2f:	c3                   	ret    

00802f30 <devcons_write>:
{
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
  802f33:	57                   	push   %edi
  802f34:	56                   	push   %esi
  802f35:	53                   	push   %ebx
  802f36:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802f3c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802f41:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802f47:	3b 75 10             	cmp    0x10(%ebp),%esi
  802f4a:	73 31                	jae    802f7d <devcons_write+0x4d>
		m = n - tot;
  802f4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802f4f:	29 f3                	sub    %esi,%ebx
  802f51:	83 fb 7f             	cmp    $0x7f,%ebx
  802f54:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802f59:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802f5c:	83 ec 04             	sub    $0x4,%esp
  802f5f:	53                   	push   %ebx
  802f60:	89 f0                	mov    %esi,%eax
  802f62:	03 45 0c             	add    0xc(%ebp),%eax
  802f65:	50                   	push   %eax
  802f66:	57                   	push   %edi
  802f67:	e8 34 ee ff ff       	call   801da0 <memmove>
		sys_cputs(buf, m);
  802f6c:	83 c4 08             	add    $0x8,%esp
  802f6f:	53                   	push   %ebx
  802f70:	57                   	push   %edi
  802f71:	e8 d2 ef ff ff       	call   801f48 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802f76:	01 de                	add    %ebx,%esi
  802f78:	83 c4 10             	add    $0x10,%esp
  802f7b:	eb ca                	jmp    802f47 <devcons_write+0x17>
}
  802f7d:	89 f0                	mov    %esi,%eax
  802f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f82:	5b                   	pop    %ebx
  802f83:	5e                   	pop    %esi
  802f84:	5f                   	pop    %edi
  802f85:	5d                   	pop    %ebp
  802f86:	c3                   	ret    

00802f87 <devcons_read>:
{
  802f87:	55                   	push   %ebp
  802f88:	89 e5                	mov    %esp,%ebp
  802f8a:	83 ec 08             	sub    $0x8,%esp
  802f8d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802f92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802f96:	74 21                	je     802fb9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802f98:	e8 c9 ef ff ff       	call   801f66 <sys_cgetc>
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	75 07                	jne    802fa8 <devcons_read+0x21>
		sys_yield();
  802fa1:	e8 3f f0 ff ff       	call   801fe5 <sys_yield>
  802fa6:	eb f0                	jmp    802f98 <devcons_read+0x11>
	if (c < 0)
  802fa8:	78 0f                	js     802fb9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802faa:	83 f8 04             	cmp    $0x4,%eax
  802fad:	74 0c                	je     802fbb <devcons_read+0x34>
	*(char*)vbuf = c;
  802faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb2:	88 02                	mov    %al,(%edx)
	return 1;
  802fb4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802fb9:	c9                   	leave  
  802fba:	c3                   	ret    
		return 0;
  802fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc0:	eb f7                	jmp    802fb9 <devcons_read+0x32>

00802fc2 <cputchar>:
{
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
  802fc5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802fce:	6a 01                	push   $0x1
  802fd0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802fd3:	50                   	push   %eax
  802fd4:	e8 6f ef ff ff       	call   801f48 <sys_cputs>
}
  802fd9:	83 c4 10             	add    $0x10,%esp
  802fdc:	c9                   	leave  
  802fdd:	c3                   	ret    

00802fde <getchar>:
{
  802fde:	55                   	push   %ebp
  802fdf:	89 e5                	mov    %esp,%ebp
  802fe1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802fe4:	6a 01                	push   $0x1
  802fe6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802fe9:	50                   	push   %eax
  802fea:	6a 00                	push   $0x0
  802fec:	e8 28 f9 ff ff       	call   802919 <read>
	if (r < 0)
  802ff1:	83 c4 10             	add    $0x10,%esp
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	78 06                	js     802ffe <getchar+0x20>
	if (r < 1)
  802ff8:	74 06                	je     803000 <getchar+0x22>
	return c;
  802ffa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ffe:	c9                   	leave  
  802fff:	c3                   	ret    
		return -E_EOF;
  803000:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803005:	eb f7                	jmp    802ffe <getchar+0x20>

00803007 <iscons>:
{
  803007:	55                   	push   %ebp
  803008:	89 e5                	mov    %esp,%ebp
  80300a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80300d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803010:	50                   	push   %eax
  803011:	ff 75 08             	pushl  0x8(%ebp)
  803014:	e8 95 f6 ff ff       	call   8026ae <fd_lookup>
  803019:	83 c4 10             	add    $0x10,%esp
  80301c:	85 c0                	test   %eax,%eax
  80301e:	78 11                	js     803031 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 15 9c 80 80 00    	mov    0x80809c,%edx
  803029:	39 10                	cmp    %edx,(%eax)
  80302b:	0f 94 c0             	sete   %al
  80302e:	0f b6 c0             	movzbl %al,%eax
}
  803031:	c9                   	leave  
  803032:	c3                   	ret    

00803033 <opencons>:
{
  803033:	55                   	push   %ebp
  803034:	89 e5                	mov    %esp,%ebp
  803036:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803039:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80303c:	50                   	push   %eax
  80303d:	e8 1a f6 ff ff       	call   80265c <fd_alloc>
  803042:	83 c4 10             	add    $0x10,%esp
  803045:	85 c0                	test   %eax,%eax
  803047:	78 3a                	js     803083 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 07 04 00 00       	push   $0x407
  803051:	ff 75 f4             	pushl  -0xc(%ebp)
  803054:	6a 00                	push   $0x0
  803056:	e8 a9 ef ff ff       	call   802004 <sys_page_alloc>
  80305b:	83 c4 10             	add    $0x10,%esp
  80305e:	85 c0                	test   %eax,%eax
  803060:	78 21                	js     803083 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 15 9c 80 80 00    	mov    0x80809c,%edx
  80306b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803077:	83 ec 0c             	sub    $0xc,%esp
  80307a:	50                   	push   %eax
  80307b:	e8 b5 f5 ff ff       	call   802635 <fd2num>
  803080:	83 c4 10             	add    $0x10,%esp
}
  803083:	c9                   	leave  
  803084:	c3                   	ret    
  803085:	66 90                	xchg   %ax,%ax
  803087:	66 90                	xchg   %ax,%ax
  803089:	66 90                	xchg   %ax,%ax
  80308b:	66 90                	xchg   %ax,%ax
  80308d:	66 90                	xchg   %ax,%ax
  80308f:	90                   	nop

00803090 <__udivdi3>:
  803090:	55                   	push   %ebp
  803091:	57                   	push   %edi
  803092:	56                   	push   %esi
  803093:	53                   	push   %ebx
  803094:	83 ec 1c             	sub    $0x1c,%esp
  803097:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80309b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80309f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8030a7:	85 d2                	test   %edx,%edx
  8030a9:	75 4d                	jne    8030f8 <__udivdi3+0x68>
  8030ab:	39 f3                	cmp    %esi,%ebx
  8030ad:	76 19                	jbe    8030c8 <__udivdi3+0x38>
  8030af:	31 ff                	xor    %edi,%edi
  8030b1:	89 e8                	mov    %ebp,%eax
  8030b3:	89 f2                	mov    %esi,%edx
  8030b5:	f7 f3                	div    %ebx
  8030b7:	89 fa                	mov    %edi,%edx
  8030b9:	83 c4 1c             	add    $0x1c,%esp
  8030bc:	5b                   	pop    %ebx
  8030bd:	5e                   	pop    %esi
  8030be:	5f                   	pop    %edi
  8030bf:	5d                   	pop    %ebp
  8030c0:	c3                   	ret    
  8030c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030c8:	89 d9                	mov    %ebx,%ecx
  8030ca:	85 db                	test   %ebx,%ebx
  8030cc:	75 0b                	jne    8030d9 <__udivdi3+0x49>
  8030ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8030d3:	31 d2                	xor    %edx,%edx
  8030d5:	f7 f3                	div    %ebx
  8030d7:	89 c1                	mov    %eax,%ecx
  8030d9:	31 d2                	xor    %edx,%edx
  8030db:	89 f0                	mov    %esi,%eax
  8030dd:	f7 f1                	div    %ecx
  8030df:	89 c6                	mov    %eax,%esi
  8030e1:	89 e8                	mov    %ebp,%eax
  8030e3:	89 f7                	mov    %esi,%edi
  8030e5:	f7 f1                	div    %ecx
  8030e7:	89 fa                	mov    %edi,%edx
  8030e9:	83 c4 1c             	add    $0x1c,%esp
  8030ec:	5b                   	pop    %ebx
  8030ed:	5e                   	pop    %esi
  8030ee:	5f                   	pop    %edi
  8030ef:	5d                   	pop    %ebp
  8030f0:	c3                   	ret    
  8030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030f8:	39 f2                	cmp    %esi,%edx
  8030fa:	77 1c                	ja     803118 <__udivdi3+0x88>
  8030fc:	0f bd fa             	bsr    %edx,%edi
  8030ff:	83 f7 1f             	xor    $0x1f,%edi
  803102:	75 2c                	jne    803130 <__udivdi3+0xa0>
  803104:	39 f2                	cmp    %esi,%edx
  803106:	72 06                	jb     80310e <__udivdi3+0x7e>
  803108:	31 c0                	xor    %eax,%eax
  80310a:	39 eb                	cmp    %ebp,%ebx
  80310c:	77 a9                	ja     8030b7 <__udivdi3+0x27>
  80310e:	b8 01 00 00 00       	mov    $0x1,%eax
  803113:	eb a2                	jmp    8030b7 <__udivdi3+0x27>
  803115:	8d 76 00             	lea    0x0(%esi),%esi
  803118:	31 ff                	xor    %edi,%edi
  80311a:	31 c0                	xor    %eax,%eax
  80311c:	89 fa                	mov    %edi,%edx
  80311e:	83 c4 1c             	add    $0x1c,%esp
  803121:	5b                   	pop    %ebx
  803122:	5e                   	pop    %esi
  803123:	5f                   	pop    %edi
  803124:	5d                   	pop    %ebp
  803125:	c3                   	ret    
  803126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80312d:	8d 76 00             	lea    0x0(%esi),%esi
  803130:	89 f9                	mov    %edi,%ecx
  803132:	b8 20 00 00 00       	mov    $0x20,%eax
  803137:	29 f8                	sub    %edi,%eax
  803139:	d3 e2                	shl    %cl,%edx
  80313b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80313f:	89 c1                	mov    %eax,%ecx
  803141:	89 da                	mov    %ebx,%edx
  803143:	d3 ea                	shr    %cl,%edx
  803145:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803149:	09 d1                	or     %edx,%ecx
  80314b:	89 f2                	mov    %esi,%edx
  80314d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803151:	89 f9                	mov    %edi,%ecx
  803153:	d3 e3                	shl    %cl,%ebx
  803155:	89 c1                	mov    %eax,%ecx
  803157:	d3 ea                	shr    %cl,%edx
  803159:	89 f9                	mov    %edi,%ecx
  80315b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80315f:	89 eb                	mov    %ebp,%ebx
  803161:	d3 e6                	shl    %cl,%esi
  803163:	89 c1                	mov    %eax,%ecx
  803165:	d3 eb                	shr    %cl,%ebx
  803167:	09 de                	or     %ebx,%esi
  803169:	89 f0                	mov    %esi,%eax
  80316b:	f7 74 24 08          	divl   0x8(%esp)
  80316f:	89 d6                	mov    %edx,%esi
  803171:	89 c3                	mov    %eax,%ebx
  803173:	f7 64 24 0c          	mull   0xc(%esp)
  803177:	39 d6                	cmp    %edx,%esi
  803179:	72 15                	jb     803190 <__udivdi3+0x100>
  80317b:	89 f9                	mov    %edi,%ecx
  80317d:	d3 e5                	shl    %cl,%ebp
  80317f:	39 c5                	cmp    %eax,%ebp
  803181:	73 04                	jae    803187 <__udivdi3+0xf7>
  803183:	39 d6                	cmp    %edx,%esi
  803185:	74 09                	je     803190 <__udivdi3+0x100>
  803187:	89 d8                	mov    %ebx,%eax
  803189:	31 ff                	xor    %edi,%edi
  80318b:	e9 27 ff ff ff       	jmp    8030b7 <__udivdi3+0x27>
  803190:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803193:	31 ff                	xor    %edi,%edi
  803195:	e9 1d ff ff ff       	jmp    8030b7 <__udivdi3+0x27>
  80319a:	66 90                	xchg   %ax,%ax
  80319c:	66 90                	xchg   %ax,%ax
  80319e:	66 90                	xchg   %ax,%ax

008031a0 <__umoddi3>:
  8031a0:	55                   	push   %ebp
  8031a1:	57                   	push   %edi
  8031a2:	56                   	push   %esi
  8031a3:	53                   	push   %ebx
  8031a4:	83 ec 1c             	sub    $0x1c,%esp
  8031a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8031ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8031b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031b7:	89 da                	mov    %ebx,%edx
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	75 43                	jne    803200 <__umoddi3+0x60>
  8031bd:	39 df                	cmp    %ebx,%edi
  8031bf:	76 17                	jbe    8031d8 <__umoddi3+0x38>
  8031c1:	89 f0                	mov    %esi,%eax
  8031c3:	f7 f7                	div    %edi
  8031c5:	89 d0                	mov    %edx,%eax
  8031c7:	31 d2                	xor    %edx,%edx
  8031c9:	83 c4 1c             	add    $0x1c,%esp
  8031cc:	5b                   	pop    %ebx
  8031cd:	5e                   	pop    %esi
  8031ce:	5f                   	pop    %edi
  8031cf:	5d                   	pop    %ebp
  8031d0:	c3                   	ret    
  8031d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031d8:	89 fd                	mov    %edi,%ebp
  8031da:	85 ff                	test   %edi,%edi
  8031dc:	75 0b                	jne    8031e9 <__umoddi3+0x49>
  8031de:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e3:	31 d2                	xor    %edx,%edx
  8031e5:	f7 f7                	div    %edi
  8031e7:	89 c5                	mov    %eax,%ebp
  8031e9:	89 d8                	mov    %ebx,%eax
  8031eb:	31 d2                	xor    %edx,%edx
  8031ed:	f7 f5                	div    %ebp
  8031ef:	89 f0                	mov    %esi,%eax
  8031f1:	f7 f5                	div    %ebp
  8031f3:	89 d0                	mov    %edx,%eax
  8031f5:	eb d0                	jmp    8031c7 <__umoddi3+0x27>
  8031f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031fe:	66 90                	xchg   %ax,%ax
  803200:	89 f1                	mov    %esi,%ecx
  803202:	39 d8                	cmp    %ebx,%eax
  803204:	76 0a                	jbe    803210 <__umoddi3+0x70>
  803206:	89 f0                	mov    %esi,%eax
  803208:	83 c4 1c             	add    $0x1c,%esp
  80320b:	5b                   	pop    %ebx
  80320c:	5e                   	pop    %esi
  80320d:	5f                   	pop    %edi
  80320e:	5d                   	pop    %ebp
  80320f:	c3                   	ret    
  803210:	0f bd e8             	bsr    %eax,%ebp
  803213:	83 f5 1f             	xor    $0x1f,%ebp
  803216:	75 20                	jne    803238 <__umoddi3+0x98>
  803218:	39 d8                	cmp    %ebx,%eax
  80321a:	0f 82 b0 00 00 00    	jb     8032d0 <__umoddi3+0x130>
  803220:	39 f7                	cmp    %esi,%edi
  803222:	0f 86 a8 00 00 00    	jbe    8032d0 <__umoddi3+0x130>
  803228:	89 c8                	mov    %ecx,%eax
  80322a:	83 c4 1c             	add    $0x1c,%esp
  80322d:	5b                   	pop    %ebx
  80322e:	5e                   	pop    %esi
  80322f:	5f                   	pop    %edi
  803230:	5d                   	pop    %ebp
  803231:	c3                   	ret    
  803232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803238:	89 e9                	mov    %ebp,%ecx
  80323a:	ba 20 00 00 00       	mov    $0x20,%edx
  80323f:	29 ea                	sub    %ebp,%edx
  803241:	d3 e0                	shl    %cl,%eax
  803243:	89 44 24 08          	mov    %eax,0x8(%esp)
  803247:	89 d1                	mov    %edx,%ecx
  803249:	89 f8                	mov    %edi,%eax
  80324b:	d3 e8                	shr    %cl,%eax
  80324d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803251:	89 54 24 04          	mov    %edx,0x4(%esp)
  803255:	8b 54 24 04          	mov    0x4(%esp),%edx
  803259:	09 c1                	or     %eax,%ecx
  80325b:	89 d8                	mov    %ebx,%eax
  80325d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803261:	89 e9                	mov    %ebp,%ecx
  803263:	d3 e7                	shl    %cl,%edi
  803265:	89 d1                	mov    %edx,%ecx
  803267:	d3 e8                	shr    %cl,%eax
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80326f:	d3 e3                	shl    %cl,%ebx
  803271:	89 c7                	mov    %eax,%edi
  803273:	89 d1                	mov    %edx,%ecx
  803275:	89 f0                	mov    %esi,%eax
  803277:	d3 e8                	shr    %cl,%eax
  803279:	89 e9                	mov    %ebp,%ecx
  80327b:	89 fa                	mov    %edi,%edx
  80327d:	d3 e6                	shl    %cl,%esi
  80327f:	09 d8                	or     %ebx,%eax
  803281:	f7 74 24 08          	divl   0x8(%esp)
  803285:	89 d1                	mov    %edx,%ecx
  803287:	89 f3                	mov    %esi,%ebx
  803289:	f7 64 24 0c          	mull   0xc(%esp)
  80328d:	89 c6                	mov    %eax,%esi
  80328f:	89 d7                	mov    %edx,%edi
  803291:	39 d1                	cmp    %edx,%ecx
  803293:	72 06                	jb     80329b <__umoddi3+0xfb>
  803295:	75 10                	jne    8032a7 <__umoddi3+0x107>
  803297:	39 c3                	cmp    %eax,%ebx
  803299:	73 0c                	jae    8032a7 <__umoddi3+0x107>
  80329b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80329f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8032a3:	89 d7                	mov    %edx,%edi
  8032a5:	89 c6                	mov    %eax,%esi
  8032a7:	89 ca                	mov    %ecx,%edx
  8032a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8032ae:	29 f3                	sub    %esi,%ebx
  8032b0:	19 fa                	sbb    %edi,%edx
  8032b2:	89 d0                	mov    %edx,%eax
  8032b4:	d3 e0                	shl    %cl,%eax
  8032b6:	89 e9                	mov    %ebp,%ecx
  8032b8:	d3 eb                	shr    %cl,%ebx
  8032ba:	d3 ea                	shr    %cl,%edx
  8032bc:	09 d8                	or     %ebx,%eax
  8032be:	83 c4 1c             	add    $0x1c,%esp
  8032c1:	5b                   	pop    %ebx
  8032c2:	5e                   	pop    %esi
  8032c3:	5f                   	pop    %edi
  8032c4:	5d                   	pop    %ebp
  8032c5:	c3                   	ret    
  8032c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8032cd:	8d 76 00             	lea    0x0(%esi),%esi
  8032d0:	89 da                	mov    %ebx,%edx
  8032d2:	29 fe                	sub    %edi,%esi
  8032d4:	19 c2                	sbb    %eax,%edx
  8032d6:	89 f1                	mov    %esi,%ecx
  8032d8:	89 c8                	mov    %ecx,%eax
  8032da:	e9 4b ff ff ff       	jmp    80322a <__umoddi3+0x8a>
