
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 63 01 00 00       	call   800194 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 ad 0a 00 00       	call   800af6 <strcpy>
	exit();
  800049:	e8 1f 02 00 00       	call   80026d <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d0 00 00 00    	jne    800134 <umain+0xe1>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 70 0e 00 00       	call   800ee8 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 8a 13 00 00       	call   801412 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 00 2c 00 00       	call   802ca1 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 ed 0a 00 00       	call   800ba1 <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 a0 32 80 00       	mov    $0x8032a0,%eax
  8000be:	ba a6 32 80 00       	mov    $0x8032a6,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 dc 32 80 00       	push   $0x8032dc
  8000cc:	e8 c6 02 00 00       	call   800397 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 f7 32 80 00       	push   $0x8032f7
  8000d8:	68 fc 32 80 00       	push   $0x8032fc
  8000dd:	68 fb 32 80 00       	push   $0x8032fb
  8000e2:	e8 76 23 00 00       	call   80245d <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 a6 2b 00 00       	call   802ca1 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 93 0a 00 00       	call   800ba1 <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 a0 32 80 00       	mov    $0x8032a0,%eax
  800118:	ba a6 32 80 00       	mov    $0x8032a6,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 13 33 80 00       	push   $0x803313
  800126:	e8 6c 02 00 00       	call   800397 <cprintf>
  : "c" (msr), "a" (val1), "d" (val2))

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012b:	cc                   	int3   
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800132:	c9                   	leave  
  800133:	c3                   	ret    
		childofspawn();
  800134:	e8 fa fe ff ff       	call   800033 <childofspawn>
  800139:	e9 26 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  80013e:	50                   	push   %eax
  80013f:	68 ac 32 80 00       	push   $0x8032ac
  800144:	6a 13                	push   $0x13
  800146:	68 bf 32 80 00       	push   $0x8032bf
  80014b:	e8 51 01 00 00       	call   8002a1 <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 d3 32 80 00       	push   $0x8032d3
  800156:	6a 17                	push   $0x17
  800158:	68 bf 32 80 00       	push   $0x8032bf
  80015d:	e8 3f 01 00 00       	call   8002a1 <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 40 80 00    	pushl  0x804004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 81 09 00 00       	call   800af6 <strcpy>
		exit();
  800175:	e8 f3 00 00 00       	call   80026d <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 09 33 80 00       	push   $0x803309
  800188:	6a 21                	push   $0x21
  80018a:	68 bf 32 80 00       	push   $0x8032bf
  80018f:	e8 0d 01 00 00       	call   8002a1 <_panic>

00800194 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80019d:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001a4:	00 00 00 
	envid_t find = sys_getenvid();
  8001a7:	e8 fe 0c 00 00       	call   800eaa <sys_getenvid>
  8001ac:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  8001b2:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001b7:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001bc:	bf 01 00 00 00       	mov    $0x1,%edi
  8001c1:	eb 0b                	jmp    8001ce <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001c3:	83 c2 01             	add    $0x1,%edx
  8001c6:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8001cc:	74 21                	je     8001ef <libmain+0x5b>
		if(envs[i].env_id == find)
  8001ce:	89 d1                	mov    %edx,%ecx
  8001d0:	c1 e1 07             	shl    $0x7,%ecx
  8001d3:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8001d9:	8b 49 48             	mov    0x48(%ecx),%ecx
  8001dc:	39 c1                	cmp    %eax,%ecx
  8001de:	75 e3                	jne    8001c3 <libmain+0x2f>
  8001e0:	89 d3                	mov    %edx,%ebx
  8001e2:	c1 e3 07             	shl    $0x7,%ebx
  8001e5:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001eb:	89 fe                	mov    %edi,%esi
  8001ed:	eb d4                	jmp    8001c3 <libmain+0x2f>
  8001ef:	89 f0                	mov    %esi,%eax
  8001f1:	84 c0                	test   %al,%al
  8001f3:	74 06                	je     8001fb <libmain+0x67>
  8001f5:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ff:	7e 0a                	jle    80020b <libmain+0x77>
		binaryname = argv[0];
  800201:	8b 45 0c             	mov    0xc(%ebp),%eax
  800204:	8b 00                	mov    (%eax),%eax
  800206:	a3 08 40 80 00       	mov    %eax,0x804008

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80020b:	a1 08 50 80 00       	mov    0x805008,%eax
  800210:	8b 40 48             	mov    0x48(%eax),%eax
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	50                   	push   %eax
  800217:	68 4d 33 80 00       	push   $0x80334d
  80021c:	e8 76 01 00 00       	call   800397 <cprintf>
	cprintf("before umain\n");
  800221:	c7 04 24 6b 33 80 00 	movl   $0x80336b,(%esp)
  800228:	e8 6a 01 00 00       	call   800397 <cprintf>
	// call user main routine
	umain(argc, argv);
  80022d:	83 c4 08             	add    $0x8,%esp
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	e8 18 fe ff ff       	call   800053 <umain>
	cprintf("after umain\n");
  80023b:	c7 04 24 79 33 80 00 	movl   $0x803379,(%esp)
  800242:	e8 50 01 00 00       	call   800397 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800247:	a1 08 50 80 00       	mov    0x805008,%eax
  80024c:	8b 40 48             	mov    0x48(%eax),%eax
  80024f:	83 c4 08             	add    $0x8,%esp
  800252:	50                   	push   %eax
  800253:	68 86 33 80 00       	push   $0x803386
  800258:	e8 3a 01 00 00       	call   800397 <cprintf>
	// exit gracefully
	exit();
  80025d:	e8 0b 00 00 00       	call   80026d <exit>
}
  800262:	83 c4 10             	add    $0x10,%esp
  800265:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800268:	5b                   	pop    %ebx
  800269:	5e                   	pop    %esi
  80026a:	5f                   	pop    %edi
  80026b:	5d                   	pop    %ebp
  80026c:	c3                   	ret    

0080026d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800273:	a1 08 50 80 00       	mov    0x805008,%eax
  800278:	8b 40 48             	mov    0x48(%eax),%eax
  80027b:	68 b0 33 80 00       	push   $0x8033b0
  800280:	50                   	push   %eax
  800281:	68 a5 33 80 00       	push   $0x8033a5
  800286:	e8 0c 01 00 00       	call   800397 <cprintf>
	close_all();
  80028b:	e8 ec 15 00 00       	call   80187c <close_all>
	sys_env_destroy(0);
  800290:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800297:	e8 cd 0b 00 00       	call   800e69 <sys_env_destroy>
}
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002a6:	a1 08 50 80 00       	mov    0x805008,%eax
  8002ab:	8b 40 48             	mov    0x48(%eax),%eax
  8002ae:	83 ec 04             	sub    $0x4,%esp
  8002b1:	68 dc 33 80 00       	push   $0x8033dc
  8002b6:	50                   	push   %eax
  8002b7:	68 a5 33 80 00       	push   $0x8033a5
  8002bc:	e8 d6 00 00 00       	call   800397 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002c1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002c4:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8002ca:	e8 db 0b 00 00       	call   800eaa <sys_getenvid>
  8002cf:	83 c4 04             	add    $0x4,%esp
  8002d2:	ff 75 0c             	pushl  0xc(%ebp)
  8002d5:	ff 75 08             	pushl  0x8(%ebp)
  8002d8:	56                   	push   %esi
  8002d9:	50                   	push   %eax
  8002da:	68 b8 33 80 00       	push   $0x8033b8
  8002df:	e8 b3 00 00 00       	call   800397 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e4:	83 c4 18             	add    $0x18,%esp
  8002e7:	53                   	push   %ebx
  8002e8:	ff 75 10             	pushl  0x10(%ebp)
  8002eb:	e8 56 00 00 00       	call   800346 <vcprintf>
	cprintf("\n");
  8002f0:	c7 04 24 69 33 80 00 	movl   $0x803369,(%esp)
  8002f7:	e8 9b 00 00 00       	call   800397 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ff:	cc                   	int3   
  800300:	eb fd                	jmp    8002ff <_panic+0x5e>

00800302 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	53                   	push   %ebx
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030c:	8b 13                	mov    (%ebx),%edx
  80030e:	8d 42 01             	lea    0x1(%edx),%eax
  800311:	89 03                	mov    %eax,(%ebx)
  800313:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800316:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80031a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80031f:	74 09                	je     80032a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800321:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800328:	c9                   	leave  
  800329:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	68 ff 00 00 00       	push   $0xff
  800332:	8d 43 08             	lea    0x8(%ebx),%eax
  800335:	50                   	push   %eax
  800336:	e8 f1 0a 00 00       	call   800e2c <sys_cputs>
		b->idx = 0;
  80033b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	eb db                	jmp    800321 <putch+0x1f>

00800346 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80034f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800356:	00 00 00 
	b.cnt = 0;
  800359:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800360:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800363:	ff 75 0c             	pushl  0xc(%ebp)
  800366:	ff 75 08             	pushl  0x8(%ebp)
  800369:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036f:	50                   	push   %eax
  800370:	68 02 03 80 00       	push   $0x800302
  800375:	e8 4a 01 00 00       	call   8004c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80037a:	83 c4 08             	add    $0x8,%esp
  80037d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800383:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800389:	50                   	push   %eax
  80038a:	e8 9d 0a 00 00       	call   800e2c <sys_cputs>

	return b.cnt;
}
  80038f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80039d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003a0:	50                   	push   %eax
  8003a1:	ff 75 08             	pushl  0x8(%ebp)
  8003a4:	e8 9d ff ff ff       	call   800346 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	57                   	push   %edi
  8003af:	56                   	push   %esi
  8003b0:	53                   	push   %ebx
  8003b1:	83 ec 1c             	sub    $0x1c,%esp
  8003b4:	89 c6                	mov    %eax,%esi
  8003b6:	89 d7                	mov    %edx,%edi
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003ca:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003ce:	74 2c                	je     8003fc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e0:	39 c2                	cmp    %eax,%edx
  8003e2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003e5:	73 43                	jae    80042a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003e7:	83 eb 01             	sub    $0x1,%ebx
  8003ea:	85 db                	test   %ebx,%ebx
  8003ec:	7e 6c                	jle    80045a <printnum+0xaf>
				putch(padc, putdat);
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	57                   	push   %edi
  8003f2:	ff 75 18             	pushl  0x18(%ebp)
  8003f5:	ff d6                	call   *%esi
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	eb eb                	jmp    8003e7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003fc:	83 ec 0c             	sub    $0xc,%esp
  8003ff:	6a 20                	push   $0x20
  800401:	6a 00                	push   $0x0
  800403:	50                   	push   %eax
  800404:	ff 75 e4             	pushl  -0x1c(%ebp)
  800407:	ff 75 e0             	pushl  -0x20(%ebp)
  80040a:	89 fa                	mov    %edi,%edx
  80040c:	89 f0                	mov    %esi,%eax
  80040e:	e8 98 ff ff ff       	call   8003ab <printnum>
		while (--width > 0)
  800413:	83 c4 20             	add    $0x20,%esp
  800416:	83 eb 01             	sub    $0x1,%ebx
  800419:	85 db                	test   %ebx,%ebx
  80041b:	7e 65                	jle    800482 <printnum+0xd7>
			putch(padc, putdat);
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	57                   	push   %edi
  800421:	6a 20                	push   $0x20
  800423:	ff d6                	call   *%esi
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	eb ec                	jmp    800416 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	ff 75 18             	pushl  0x18(%ebp)
  800430:	83 eb 01             	sub    $0x1,%ebx
  800433:	53                   	push   %ebx
  800434:	50                   	push   %eax
  800435:	83 ec 08             	sub    $0x8,%esp
  800438:	ff 75 dc             	pushl  -0x24(%ebp)
  80043b:	ff 75 d8             	pushl  -0x28(%ebp)
  80043e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800441:	ff 75 e0             	pushl  -0x20(%ebp)
  800444:	e8 f7 2b 00 00       	call   803040 <__udivdi3>
  800449:	83 c4 18             	add    $0x18,%esp
  80044c:	52                   	push   %edx
  80044d:	50                   	push   %eax
  80044e:	89 fa                	mov    %edi,%edx
  800450:	89 f0                	mov    %esi,%eax
  800452:	e8 54 ff ff ff       	call   8003ab <printnum>
  800457:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	57                   	push   %edi
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	ff 75 dc             	pushl  -0x24(%ebp)
  800464:	ff 75 d8             	pushl  -0x28(%ebp)
  800467:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046a:	ff 75 e0             	pushl  -0x20(%ebp)
  80046d:	e8 de 2c 00 00       	call   803150 <__umoddi3>
  800472:	83 c4 14             	add    $0x14,%esp
  800475:	0f be 80 e3 33 80 00 	movsbl 0x8033e3(%eax),%eax
  80047c:	50                   	push   %eax
  80047d:	ff d6                	call   *%esi
  80047f:	83 c4 10             	add    $0x10,%esp
	}
}
  800482:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800485:	5b                   	pop    %ebx
  800486:	5e                   	pop    %esi
  800487:	5f                   	pop    %edi
  800488:	5d                   	pop    %ebp
  800489:	c3                   	ret    

0080048a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800490:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800494:	8b 10                	mov    (%eax),%edx
  800496:	3b 50 04             	cmp    0x4(%eax),%edx
  800499:	73 0a                	jae    8004a5 <sprintputch+0x1b>
		*b->buf++ = ch;
  80049b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80049e:	89 08                	mov    %ecx,(%eax)
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	88 02                	mov    %al,(%edx)
}
  8004a5:	5d                   	pop    %ebp
  8004a6:	c3                   	ret    

008004a7 <printfmt>:
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004ad:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004b0:	50                   	push   %eax
  8004b1:	ff 75 10             	pushl  0x10(%ebp)
  8004b4:	ff 75 0c             	pushl  0xc(%ebp)
  8004b7:	ff 75 08             	pushl  0x8(%ebp)
  8004ba:	e8 05 00 00 00       	call   8004c4 <vprintfmt>
}
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <vprintfmt>:
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	57                   	push   %edi
  8004c8:	56                   	push   %esi
  8004c9:	53                   	push   %ebx
  8004ca:	83 ec 3c             	sub    $0x3c,%esp
  8004cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004d6:	e9 32 04 00 00       	jmp    80090d <vprintfmt+0x449>
		padc = ' ';
  8004db:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004df:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004e6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004ed:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004fb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800502:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800507:	8d 47 01             	lea    0x1(%edi),%eax
  80050a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050d:	0f b6 17             	movzbl (%edi),%edx
  800510:	8d 42 dd             	lea    -0x23(%edx),%eax
  800513:	3c 55                	cmp    $0x55,%al
  800515:	0f 87 12 05 00 00    	ja     800a2d <vprintfmt+0x569>
  80051b:	0f b6 c0             	movzbl %al,%eax
  80051e:	ff 24 85 c0 35 80 00 	jmp    *0x8035c0(,%eax,4)
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800528:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80052c:	eb d9                	jmp    800507 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800531:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800535:	eb d0                	jmp    800507 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800537:	0f b6 d2             	movzbl %dl,%edx
  80053a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80053d:	b8 00 00 00 00       	mov    $0x0,%eax
  800542:	89 75 08             	mov    %esi,0x8(%ebp)
  800545:	eb 03                	jmp    80054a <vprintfmt+0x86>
  800547:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80054a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80054d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800551:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800554:	8d 72 d0             	lea    -0x30(%edx),%esi
  800557:	83 fe 09             	cmp    $0x9,%esi
  80055a:	76 eb                	jbe    800547 <vprintfmt+0x83>
  80055c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055f:	8b 75 08             	mov    0x8(%ebp),%esi
  800562:	eb 14                	jmp    800578 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8d 40 04             	lea    0x4(%eax),%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800578:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057c:	79 89                	jns    800507 <vprintfmt+0x43>
				width = precision, precision = -1;
  80057e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800581:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800584:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80058b:	e9 77 ff ff ff       	jmp    800507 <vprintfmt+0x43>
  800590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800593:	85 c0                	test   %eax,%eax
  800595:	0f 48 c1             	cmovs  %ecx,%eax
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80059e:	e9 64 ff ff ff       	jmp    800507 <vprintfmt+0x43>
  8005a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005ad:	e9 55 ff ff ff       	jmp    800507 <vprintfmt+0x43>
			lflag++;
  8005b2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005b9:	e9 49 ff ff ff       	jmp    800507 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 78 04             	lea    0x4(%eax),%edi
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	53                   	push   %ebx
  8005c8:	ff 30                	pushl  (%eax)
  8005ca:	ff d6                	call   *%esi
			break;
  8005cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005cf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d2:	e9 33 03 00 00       	jmp    80090a <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 78 04             	lea    0x4(%eax),%edi
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	99                   	cltd   
  8005e0:	31 d0                	xor    %edx,%eax
  8005e2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e4:	83 f8 11             	cmp    $0x11,%eax
  8005e7:	7f 23                	jg     80060c <vprintfmt+0x148>
  8005e9:	8b 14 85 20 37 80 00 	mov    0x803720(,%eax,4),%edx
  8005f0:	85 d2                	test   %edx,%edx
  8005f2:	74 18                	je     80060c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005f4:	52                   	push   %edx
  8005f5:	68 2d 39 80 00       	push   $0x80392d
  8005fa:	53                   	push   %ebx
  8005fb:	56                   	push   %esi
  8005fc:	e8 a6 fe ff ff       	call   8004a7 <printfmt>
  800601:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800604:	89 7d 14             	mov    %edi,0x14(%ebp)
  800607:	e9 fe 02 00 00       	jmp    80090a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80060c:	50                   	push   %eax
  80060d:	68 fb 33 80 00       	push   $0x8033fb
  800612:	53                   	push   %ebx
  800613:	56                   	push   %esi
  800614:	e8 8e fe ff ff       	call   8004a7 <printfmt>
  800619:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80061c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80061f:	e9 e6 02 00 00       	jmp    80090a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	83 c0 04             	add    $0x4,%eax
  80062a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800632:	85 c9                	test   %ecx,%ecx
  800634:	b8 f4 33 80 00       	mov    $0x8033f4,%eax
  800639:	0f 45 c1             	cmovne %ecx,%eax
  80063c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80063f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800643:	7e 06                	jle    80064b <vprintfmt+0x187>
  800645:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800649:	75 0d                	jne    800658 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80064e:	89 c7                	mov    %eax,%edi
  800650:	03 45 e0             	add    -0x20(%ebp),%eax
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800656:	eb 53                	jmp    8006ab <vprintfmt+0x1e7>
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	ff 75 d8             	pushl  -0x28(%ebp)
  80065e:	50                   	push   %eax
  80065f:	e8 71 04 00 00       	call   800ad5 <strnlen>
  800664:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800667:	29 c1                	sub    %eax,%ecx
  800669:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80066c:	83 c4 10             	add    $0x10,%esp
  80066f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800671:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800675:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800678:	eb 0f                	jmp    800689 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	53                   	push   %ebx
  80067e:	ff 75 e0             	pushl  -0x20(%ebp)
  800681:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800683:	83 ef 01             	sub    $0x1,%edi
  800686:	83 c4 10             	add    $0x10,%esp
  800689:	85 ff                	test   %edi,%edi
  80068b:	7f ed                	jg     80067a <vprintfmt+0x1b6>
  80068d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800690:	85 c9                	test   %ecx,%ecx
  800692:	b8 00 00 00 00       	mov    $0x0,%eax
  800697:	0f 49 c1             	cmovns %ecx,%eax
  80069a:	29 c1                	sub    %eax,%ecx
  80069c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80069f:	eb aa                	jmp    80064b <vprintfmt+0x187>
					putch(ch, putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	52                   	push   %edx
  8006a6:	ff d6                	call   *%esi
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006ae:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b0:	83 c7 01             	add    $0x1,%edi
  8006b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b7:	0f be d0             	movsbl %al,%edx
  8006ba:	85 d2                	test   %edx,%edx
  8006bc:	74 4b                	je     800709 <vprintfmt+0x245>
  8006be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c2:	78 06                	js     8006ca <vprintfmt+0x206>
  8006c4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006c8:	78 1e                	js     8006e8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ca:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006ce:	74 d1                	je     8006a1 <vprintfmt+0x1dd>
  8006d0:	0f be c0             	movsbl %al,%eax
  8006d3:	83 e8 20             	sub    $0x20,%eax
  8006d6:	83 f8 5e             	cmp    $0x5e,%eax
  8006d9:	76 c6                	jbe    8006a1 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	6a 3f                	push   $0x3f
  8006e1:	ff d6                	call   *%esi
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	eb c3                	jmp    8006ab <vprintfmt+0x1e7>
  8006e8:	89 cf                	mov    %ecx,%edi
  8006ea:	eb 0e                	jmp    8006fa <vprintfmt+0x236>
				putch(' ', putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	53                   	push   %ebx
  8006f0:	6a 20                	push   $0x20
  8006f2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006f4:	83 ef 01             	sub    $0x1,%edi
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	85 ff                	test   %edi,%edi
  8006fc:	7f ee                	jg     8006ec <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
  800704:	e9 01 02 00 00       	jmp    80090a <vprintfmt+0x446>
  800709:	89 cf                	mov    %ecx,%edi
  80070b:	eb ed                	jmp    8006fa <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80070d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800710:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800717:	e9 eb fd ff ff       	jmp    800507 <vprintfmt+0x43>
	if (lflag >= 2)
  80071c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800720:	7f 21                	jg     800743 <vprintfmt+0x27f>
	else if (lflag)
  800722:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800726:	74 68                	je     800790 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800730:	89 c1                	mov    %eax,%ecx
  800732:	c1 f9 1f             	sar    $0x1f,%ecx
  800735:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
  800741:	eb 17                	jmp    80075a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 50 04             	mov    0x4(%eax),%edx
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80074e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 08             	lea    0x8(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80075a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80075d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800760:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800763:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800766:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80076a:	78 3f                	js     8007ab <vprintfmt+0x2e7>
			base = 10;
  80076c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800771:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800775:	0f 84 71 01 00 00    	je     8008ec <vprintfmt+0x428>
				putch('+', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	6a 2b                	push   $0x2b
  800781:	ff d6                	call   *%esi
  800783:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800786:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078b:	e9 5c 01 00 00       	jmp    8008ec <vprintfmt+0x428>
		return va_arg(*ap, int);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800798:	89 c1                	mov    %eax,%ecx
  80079a:	c1 f9 1f             	sar    $0x1f,%ecx
  80079d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a9:	eb af                	jmp    80075a <vprintfmt+0x296>
				putch('-', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	53                   	push   %ebx
  8007af:	6a 2d                	push   $0x2d
  8007b1:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007b9:	f7 d8                	neg    %eax
  8007bb:	83 d2 00             	adc    $0x0,%edx
  8007be:	f7 da                	neg    %edx
  8007c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ce:	e9 19 01 00 00       	jmp    8008ec <vprintfmt+0x428>
	if (lflag >= 2)
  8007d3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007d7:	7f 29                	jg     800802 <vprintfmt+0x33e>
	else if (lflag)
  8007d9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007dd:	74 44                	je     800823 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fd:	e9 ea 00 00 00       	jmp    8008ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8b 50 04             	mov    0x4(%eax),%edx
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8d 40 08             	lea    0x8(%eax),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800819:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081e:	e9 c9 00 00 00       	jmp    8008ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
  80082d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800830:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8d 40 04             	lea    0x4(%eax),%eax
  800839:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800841:	e9 a6 00 00 00       	jmp    8008ec <vprintfmt+0x428>
			putch('0', putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	53                   	push   %ebx
  80084a:	6a 30                	push   $0x30
  80084c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80084e:	83 c4 10             	add    $0x10,%esp
  800851:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800855:	7f 26                	jg     80087d <vprintfmt+0x3b9>
	else if (lflag)
  800857:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80085b:	74 3e                	je     80089b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	ba 00 00 00 00       	mov    $0x0,%edx
  800867:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	8d 40 04             	lea    0x4(%eax),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800876:	b8 08 00 00 00       	mov    $0x8,%eax
  80087b:	eb 6f                	jmp    8008ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8b 50 04             	mov    0x4(%eax),%edx
  800883:	8b 00                	mov    (%eax),%eax
  800885:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800888:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	8d 40 08             	lea    0x8(%eax),%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800894:	b8 08 00 00 00       	mov    $0x8,%eax
  800899:	eb 51                	jmp    8008ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8d 40 04             	lea    0x4(%eax),%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b9:	eb 31                	jmp    8008ec <vprintfmt+0x428>
			putch('0', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	6a 30                	push   $0x30
  8008c1:	ff d6                	call   *%esi
			putch('x', putdat);
  8008c3:	83 c4 08             	add    $0x8,%esp
  8008c6:	53                   	push   %ebx
  8008c7:	6a 78                	push   $0x78
  8008c9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008db:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	8d 40 04             	lea    0x4(%eax),%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008ec:	83 ec 0c             	sub    $0xc,%esp
  8008ef:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008f3:	52                   	push   %edx
  8008f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8008f7:	50                   	push   %eax
  8008f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8008fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8008fe:	89 da                	mov    %ebx,%edx
  800900:	89 f0                	mov    %esi,%eax
  800902:	e8 a4 fa ff ff       	call   8003ab <printnum>
			break;
  800907:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80090a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090d:	83 c7 01             	add    $0x1,%edi
  800910:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800914:	83 f8 25             	cmp    $0x25,%eax
  800917:	0f 84 be fb ff ff    	je     8004db <vprintfmt+0x17>
			if (ch == '\0')
  80091d:	85 c0                	test   %eax,%eax
  80091f:	0f 84 28 01 00 00    	je     800a4d <vprintfmt+0x589>
			putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	53                   	push   %ebx
  800929:	50                   	push   %eax
  80092a:	ff d6                	call   *%esi
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	eb dc                	jmp    80090d <vprintfmt+0x449>
	if (lflag >= 2)
  800931:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800935:	7f 26                	jg     80095d <vprintfmt+0x499>
	else if (lflag)
  800937:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80093b:	74 41                	je     80097e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	ba 00 00 00 00       	mov    $0x0,%edx
  800947:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8d 40 04             	lea    0x4(%eax),%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800956:	b8 10 00 00 00       	mov    $0x10,%eax
  80095b:	eb 8f                	jmp    8008ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	8b 50 04             	mov    0x4(%eax),%edx
  800963:	8b 00                	mov    (%eax),%eax
  800965:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800968:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8d 40 08             	lea    0x8(%eax),%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800974:	b8 10 00 00 00       	mov    $0x10,%eax
  800979:	e9 6e ff ff ff       	jmp    8008ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	8b 00                	mov    (%eax),%eax
  800983:	ba 00 00 00 00       	mov    $0x0,%edx
  800988:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80098b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	8d 40 04             	lea    0x4(%eax),%eax
  800994:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800997:	b8 10 00 00 00       	mov    $0x10,%eax
  80099c:	e9 4b ff ff ff       	jmp    8008ec <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 c0 04             	add    $0x4,%eax
  8009a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	8b 00                	mov    (%eax),%eax
  8009af:	85 c0                	test   %eax,%eax
  8009b1:	74 14                	je     8009c7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009b3:	8b 13                	mov    (%ebx),%edx
  8009b5:	83 fa 7f             	cmp    $0x7f,%edx
  8009b8:	7f 37                	jg     8009f1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009ba:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c2:	e9 43 ff ff ff       	jmp    80090a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009cc:	bf 19 35 80 00       	mov    $0x803519,%edi
							putch(ch, putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	53                   	push   %ebx
  8009d5:	50                   	push   %eax
  8009d6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009d8:	83 c7 01             	add    $0x1,%edi
  8009db:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	85 c0                	test   %eax,%eax
  8009e4:	75 eb                	jne    8009d1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ec:	e9 19 ff ff ff       	jmp    80090a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009f1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f8:	bf 51 35 80 00       	mov    $0x803551,%edi
							putch(ch, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	53                   	push   %ebx
  800a01:	50                   	push   %eax
  800a02:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a04:	83 c7 01             	add    $0x1,%edi
  800a07:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
  800a0e:	85 c0                	test   %eax,%eax
  800a10:	75 eb                	jne    8009fd <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a12:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a15:	89 45 14             	mov    %eax,0x14(%ebp)
  800a18:	e9 ed fe ff ff       	jmp    80090a <vprintfmt+0x446>
			putch(ch, putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	53                   	push   %ebx
  800a21:	6a 25                	push   $0x25
  800a23:	ff d6                	call   *%esi
			break;
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	e9 dd fe ff ff       	jmp    80090a <vprintfmt+0x446>
			putch('%', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	53                   	push   %ebx
  800a31:	6a 25                	push   $0x25
  800a33:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	89 f8                	mov    %edi,%eax
  800a3a:	eb 03                	jmp    800a3f <vprintfmt+0x57b>
  800a3c:	83 e8 01             	sub    $0x1,%eax
  800a3f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a43:	75 f7                	jne    800a3c <vprintfmt+0x578>
  800a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a48:	e9 bd fe ff ff       	jmp    80090a <vprintfmt+0x446>
}
  800a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	5f                   	pop    %edi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 18             	sub    $0x18,%esp
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a61:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a64:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a68:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a72:	85 c0                	test   %eax,%eax
  800a74:	74 26                	je     800a9c <vsnprintf+0x47>
  800a76:	85 d2                	test   %edx,%edx
  800a78:	7e 22                	jle    800a9c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a7a:	ff 75 14             	pushl  0x14(%ebp)
  800a7d:	ff 75 10             	pushl  0x10(%ebp)
  800a80:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a83:	50                   	push   %eax
  800a84:	68 8a 04 80 00       	push   $0x80048a
  800a89:	e8 36 fa ff ff       	call   8004c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a97:	83 c4 10             	add    $0x10,%esp
}
  800a9a:	c9                   	leave  
  800a9b:	c3                   	ret    
		return -E_INVAL;
  800a9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa1:	eb f7                	jmp    800a9a <vsnprintf+0x45>

00800aa3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aac:	50                   	push   %eax
  800aad:	ff 75 10             	pushl  0x10(%ebp)
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	ff 75 08             	pushl  0x8(%ebp)
  800ab6:	e8 9a ff ff ff       	call   800a55 <vsnprintf>
	va_end(ap);

	return rc;
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800acc:	74 05                	je     800ad3 <strlen+0x16>
		n++;
  800ace:	83 c0 01             	add    $0x1,%eax
  800ad1:	eb f5                	jmp    800ac8 <strlen+0xb>
	return n;
}
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800adb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ade:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae3:	39 c2                	cmp    %eax,%edx
  800ae5:	74 0d                	je     800af4 <strnlen+0x1f>
  800ae7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800aeb:	74 05                	je     800af2 <strnlen+0x1d>
		n++;
  800aed:	83 c2 01             	add    $0x1,%edx
  800af0:	eb f1                	jmp    800ae3 <strnlen+0xe>
  800af2:	89 d0                	mov    %edx,%eax
	return n;
}
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	53                   	push   %ebx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b09:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b0c:	83 c2 01             	add    $0x1,%edx
  800b0f:	84 c9                	test   %cl,%cl
  800b11:	75 f2                	jne    800b05 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b13:	5b                   	pop    %ebx
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	53                   	push   %ebx
  800b1a:	83 ec 10             	sub    $0x10,%esp
  800b1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b20:	53                   	push   %ebx
  800b21:	e8 97 ff ff ff       	call   800abd <strlen>
  800b26:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	01 d8                	add    %ebx,%eax
  800b2e:	50                   	push   %eax
  800b2f:	e8 c2 ff ff ff       	call   800af6 <strcpy>
	return dst;
}
  800b34:	89 d8                	mov    %ebx,%eax
  800b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	56                   	push   %esi
  800b3f:	53                   	push   %ebx
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b46:	89 c6                	mov    %eax,%esi
  800b48:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4b:	89 c2                	mov    %eax,%edx
  800b4d:	39 f2                	cmp    %esi,%edx
  800b4f:	74 11                	je     800b62 <strncpy+0x27>
		*dst++ = *src;
  800b51:	83 c2 01             	add    $0x1,%edx
  800b54:	0f b6 19             	movzbl (%ecx),%ebx
  800b57:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b5a:	80 fb 01             	cmp    $0x1,%bl
  800b5d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b60:	eb eb                	jmp    800b4d <strncpy+0x12>
	}
	return ret;
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
  800b6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b71:	8b 55 10             	mov    0x10(%ebp),%edx
  800b74:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b76:	85 d2                	test   %edx,%edx
  800b78:	74 21                	je     800b9b <strlcpy+0x35>
  800b7a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b7e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	74 14                	je     800b98 <strlcpy+0x32>
  800b84:	0f b6 19             	movzbl (%ecx),%ebx
  800b87:	84 db                	test   %bl,%bl
  800b89:	74 0b                	je     800b96 <strlcpy+0x30>
			*dst++ = *src++;
  800b8b:	83 c1 01             	add    $0x1,%ecx
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b94:	eb ea                	jmp    800b80 <strlcpy+0x1a>
  800b96:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b9b:	29 f0                	sub    %esi,%eax
}
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800baa:	0f b6 01             	movzbl (%ecx),%eax
  800bad:	84 c0                	test   %al,%al
  800baf:	74 0c                	je     800bbd <strcmp+0x1c>
  800bb1:	3a 02                	cmp    (%edx),%al
  800bb3:	75 08                	jne    800bbd <strcmp+0x1c>
		p++, q++;
  800bb5:	83 c1 01             	add    $0x1,%ecx
  800bb8:	83 c2 01             	add    $0x1,%edx
  800bbb:	eb ed                	jmp    800baa <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbd:	0f b6 c0             	movzbl %al,%eax
  800bc0:	0f b6 12             	movzbl (%edx),%edx
  800bc3:	29 d0                	sub    %edx,%eax
}
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	53                   	push   %ebx
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd1:	89 c3                	mov    %eax,%ebx
  800bd3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bd6:	eb 06                	jmp    800bde <strncmp+0x17>
		n--, p++, q++;
  800bd8:	83 c0 01             	add    $0x1,%eax
  800bdb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bde:	39 d8                	cmp    %ebx,%eax
  800be0:	74 16                	je     800bf8 <strncmp+0x31>
  800be2:	0f b6 08             	movzbl (%eax),%ecx
  800be5:	84 c9                	test   %cl,%cl
  800be7:	74 04                	je     800bed <strncmp+0x26>
  800be9:	3a 0a                	cmp    (%edx),%cl
  800beb:	74 eb                	je     800bd8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bed:	0f b6 00             	movzbl (%eax),%eax
  800bf0:	0f b6 12             	movzbl (%edx),%edx
  800bf3:	29 d0                	sub    %edx,%eax
}
  800bf5:	5b                   	pop    %ebx
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    
		return 0;
  800bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfd:	eb f6                	jmp    800bf5 <strncmp+0x2e>

00800bff <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c09:	0f b6 10             	movzbl (%eax),%edx
  800c0c:	84 d2                	test   %dl,%dl
  800c0e:	74 09                	je     800c19 <strchr+0x1a>
		if (*s == c)
  800c10:	38 ca                	cmp    %cl,%dl
  800c12:	74 0a                	je     800c1e <strchr+0x1f>
	for (; *s; s++)
  800c14:	83 c0 01             	add    $0x1,%eax
  800c17:	eb f0                	jmp    800c09 <strchr+0xa>
			return (char *) s;
	return 0;
  800c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c2a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c2d:	38 ca                	cmp    %cl,%dl
  800c2f:	74 09                	je     800c3a <strfind+0x1a>
  800c31:	84 d2                	test   %dl,%dl
  800c33:	74 05                	je     800c3a <strfind+0x1a>
	for (; *s; s++)
  800c35:	83 c0 01             	add    $0x1,%eax
  800c38:	eb f0                	jmp    800c2a <strfind+0xa>
			break;
	return (char *) s;
}
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	57                   	push   %edi
  800c40:	56                   	push   %esi
  800c41:	53                   	push   %ebx
  800c42:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c48:	85 c9                	test   %ecx,%ecx
  800c4a:	74 31                	je     800c7d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c4c:	89 f8                	mov    %edi,%eax
  800c4e:	09 c8                	or     %ecx,%eax
  800c50:	a8 03                	test   $0x3,%al
  800c52:	75 23                	jne    800c77 <memset+0x3b>
		c &= 0xFF;
  800c54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c58:	89 d3                	mov    %edx,%ebx
  800c5a:	c1 e3 08             	shl    $0x8,%ebx
  800c5d:	89 d0                	mov    %edx,%eax
  800c5f:	c1 e0 18             	shl    $0x18,%eax
  800c62:	89 d6                	mov    %edx,%esi
  800c64:	c1 e6 10             	shl    $0x10,%esi
  800c67:	09 f0                	or     %esi,%eax
  800c69:	09 c2                	or     %eax,%edx
  800c6b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c6d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c70:	89 d0                	mov    %edx,%eax
  800c72:	fc                   	cld    
  800c73:	f3 ab                	rep stos %eax,%es:(%edi)
  800c75:	eb 06                	jmp    800c7d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	fc                   	cld    
  800c7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7d:	89 f8                	mov    %edi,%eax
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	57                   	push   %edi
  800c88:	56                   	push   %esi
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c92:	39 c6                	cmp    %eax,%esi
  800c94:	73 32                	jae    800cc8 <memmove+0x44>
  800c96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c99:	39 c2                	cmp    %eax,%edx
  800c9b:	76 2b                	jbe    800cc8 <memmove+0x44>
		s += n;
		d += n;
  800c9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca0:	89 fe                	mov    %edi,%esi
  800ca2:	09 ce                	or     %ecx,%esi
  800ca4:	09 d6                	or     %edx,%esi
  800ca6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cac:	75 0e                	jne    800cbc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cae:	83 ef 04             	sub    $0x4,%edi
  800cb1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cb7:	fd                   	std    
  800cb8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cba:	eb 09                	jmp    800cc5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cbc:	83 ef 01             	sub    $0x1,%edi
  800cbf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cc2:	fd                   	std    
  800cc3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc5:	fc                   	cld    
  800cc6:	eb 1a                	jmp    800ce2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc8:	89 c2                	mov    %eax,%edx
  800cca:	09 ca                	or     %ecx,%edx
  800ccc:	09 f2                	or     %esi,%edx
  800cce:	f6 c2 03             	test   $0x3,%dl
  800cd1:	75 0a                	jne    800cdd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cd6:	89 c7                	mov    %eax,%edi
  800cd8:	fc                   	cld    
  800cd9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cdb:	eb 05                	jmp    800ce2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cdd:	89 c7                	mov    %eax,%edi
  800cdf:	fc                   	cld    
  800ce0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cec:	ff 75 10             	pushl  0x10(%ebp)
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 8a ff ff ff       	call   800c84 <memmove>
}
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d07:	89 c6                	mov    %eax,%esi
  800d09:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d0c:	39 f0                	cmp    %esi,%eax
  800d0e:	74 1c                	je     800d2c <memcmp+0x30>
		if (*s1 != *s2)
  800d10:	0f b6 08             	movzbl (%eax),%ecx
  800d13:	0f b6 1a             	movzbl (%edx),%ebx
  800d16:	38 d9                	cmp    %bl,%cl
  800d18:	75 08                	jne    800d22 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d1a:	83 c0 01             	add    $0x1,%eax
  800d1d:	83 c2 01             	add    $0x1,%edx
  800d20:	eb ea                	jmp    800d0c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d22:	0f b6 c1             	movzbl %cl,%eax
  800d25:	0f b6 db             	movzbl %bl,%ebx
  800d28:	29 d8                	sub    %ebx,%eax
  800d2a:	eb 05                	jmp    800d31 <memcmp+0x35>
	}

	return 0;
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d3e:	89 c2                	mov    %eax,%edx
  800d40:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d43:	39 d0                	cmp    %edx,%eax
  800d45:	73 09                	jae    800d50 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d47:	38 08                	cmp    %cl,(%eax)
  800d49:	74 05                	je     800d50 <memfind+0x1b>
	for (; s < ends; s++)
  800d4b:	83 c0 01             	add    $0x1,%eax
  800d4e:	eb f3                	jmp    800d43 <memfind+0xe>
			break;
	return (void *) s;
}
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5e:	eb 03                	jmp    800d63 <strtol+0x11>
		s++;
  800d60:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d63:	0f b6 01             	movzbl (%ecx),%eax
  800d66:	3c 20                	cmp    $0x20,%al
  800d68:	74 f6                	je     800d60 <strtol+0xe>
  800d6a:	3c 09                	cmp    $0x9,%al
  800d6c:	74 f2                	je     800d60 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d6e:	3c 2b                	cmp    $0x2b,%al
  800d70:	74 2a                	je     800d9c <strtol+0x4a>
	int neg = 0;
  800d72:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d77:	3c 2d                	cmp    $0x2d,%al
  800d79:	74 2b                	je     800da6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d81:	75 0f                	jne    800d92 <strtol+0x40>
  800d83:	80 39 30             	cmpb   $0x30,(%ecx)
  800d86:	74 28                	je     800db0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d88:	85 db                	test   %ebx,%ebx
  800d8a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d8f:	0f 44 d8             	cmove  %eax,%ebx
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
  800d97:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d9a:	eb 50                	jmp    800dec <strtol+0x9a>
		s++;
  800d9c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d9f:	bf 00 00 00 00       	mov    $0x0,%edi
  800da4:	eb d5                	jmp    800d7b <strtol+0x29>
		s++, neg = 1;
  800da6:	83 c1 01             	add    $0x1,%ecx
  800da9:	bf 01 00 00 00       	mov    $0x1,%edi
  800dae:	eb cb                	jmp    800d7b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800db4:	74 0e                	je     800dc4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800db6:	85 db                	test   %ebx,%ebx
  800db8:	75 d8                	jne    800d92 <strtol+0x40>
		s++, base = 8;
  800dba:	83 c1 01             	add    $0x1,%ecx
  800dbd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dc2:	eb ce                	jmp    800d92 <strtol+0x40>
		s += 2, base = 16;
  800dc4:	83 c1 02             	add    $0x2,%ecx
  800dc7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dcc:	eb c4                	jmp    800d92 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dce:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dd1:	89 f3                	mov    %esi,%ebx
  800dd3:	80 fb 19             	cmp    $0x19,%bl
  800dd6:	77 29                	ja     800e01 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dd8:	0f be d2             	movsbl %dl,%edx
  800ddb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dde:	3b 55 10             	cmp    0x10(%ebp),%edx
  800de1:	7d 30                	jge    800e13 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800de3:	83 c1 01             	add    $0x1,%ecx
  800de6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dea:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dec:	0f b6 11             	movzbl (%ecx),%edx
  800def:	8d 72 d0             	lea    -0x30(%edx),%esi
  800df2:	89 f3                	mov    %esi,%ebx
  800df4:	80 fb 09             	cmp    $0x9,%bl
  800df7:	77 d5                	ja     800dce <strtol+0x7c>
			dig = *s - '0';
  800df9:	0f be d2             	movsbl %dl,%edx
  800dfc:	83 ea 30             	sub    $0x30,%edx
  800dff:	eb dd                	jmp    800dde <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e01:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e04:	89 f3                	mov    %esi,%ebx
  800e06:	80 fb 19             	cmp    $0x19,%bl
  800e09:	77 08                	ja     800e13 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e0b:	0f be d2             	movsbl %dl,%edx
  800e0e:	83 ea 37             	sub    $0x37,%edx
  800e11:	eb cb                	jmp    800dde <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e17:	74 05                	je     800e1e <strtol+0xcc>
		*endptr = (char *) s;
  800e19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e1c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e1e:	89 c2                	mov    %eax,%edx
  800e20:	f7 da                	neg    %edx
  800e22:	85 ff                	test   %edi,%edi
  800e24:	0f 45 c2             	cmovne %edx,%eax
}
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	57                   	push   %edi
  800e30:	56                   	push   %esi
  800e31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e32:	b8 00 00 00 00       	mov    $0x0,%eax
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3d:	89 c3                	mov    %eax,%ebx
  800e3f:	89 c7                	mov    %eax,%edi
  800e41:	89 c6                	mov    %eax,%esi
  800e43:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    

00800e4a <sys_cgetc>:

int
sys_cgetc(void)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	57                   	push   %edi
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e50:	ba 00 00 00 00       	mov    $0x0,%edx
  800e55:	b8 01 00 00 00       	mov    $0x1,%eax
  800e5a:	89 d1                	mov    %edx,%ecx
  800e5c:	89 d3                	mov    %edx,%ebx
  800e5e:	89 d7                	mov    %edx,%edi
  800e60:	89 d6                	mov    %edx,%esi
  800e62:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e77:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800e7f:	89 cb                	mov    %ecx,%ebx
  800e81:	89 cf                	mov    %ecx,%edi
  800e83:	89 ce                	mov    %ecx,%esi
  800e85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e87:	85 c0                	test   %eax,%eax
  800e89:	7f 08                	jg     800e93 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	50                   	push   %eax
  800e97:	6a 03                	push   $0x3
  800e99:	68 68 37 80 00       	push   $0x803768
  800e9e:	6a 43                	push   $0x43
  800ea0:	68 85 37 80 00       	push   $0x803785
  800ea5:	e8 f7 f3 ff ff       	call   8002a1 <_panic>

00800eaa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb5:	b8 02 00 00 00       	mov    $0x2,%eax
  800eba:	89 d1                	mov    %edx,%ecx
  800ebc:	89 d3                	mov    %edx,%ebx
  800ebe:	89 d7                	mov    %edx,%edi
  800ec0:	89 d6                	mov    %edx,%esi
  800ec2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_yield>:

void
sys_yield(void)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ed9:	89 d1                	mov    %edx,%ecx
  800edb:	89 d3                	mov    %edx,%ebx
  800edd:	89 d7                	mov    %edx,%edi
  800edf:	89 d6                	mov    %edx,%esi
  800ee1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ee3:	5b                   	pop    %ebx
  800ee4:	5e                   	pop    %esi
  800ee5:	5f                   	pop    %edi
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
  800eee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef1:	be 00 00 00 00       	mov    $0x0,%esi
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efc:	b8 04 00 00 00       	mov    $0x4,%eax
  800f01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f04:	89 f7                	mov    %esi,%edi
  800f06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	7f 08                	jg     800f14 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	50                   	push   %eax
  800f18:	6a 04                	push   $0x4
  800f1a:	68 68 37 80 00       	push   $0x803768
  800f1f:	6a 43                	push   $0x43
  800f21:	68 85 37 80 00       	push   $0x803785
  800f26:	e8 76 f3 ff ff       	call   8002a1 <_panic>

00800f2b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
  800f31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3a:	b8 05 00 00 00       	mov    $0x5,%eax
  800f3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f42:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f45:	8b 75 18             	mov    0x18(%ebp),%esi
  800f48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	7f 08                	jg     800f56 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f56:	83 ec 0c             	sub    $0xc,%esp
  800f59:	50                   	push   %eax
  800f5a:	6a 05                	push   $0x5
  800f5c:	68 68 37 80 00       	push   $0x803768
  800f61:	6a 43                	push   $0x43
  800f63:	68 85 37 80 00       	push   $0x803785
  800f68:	e8 34 f3 ff ff       	call   8002a1 <_panic>

00800f6d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	57                   	push   %edi
  800f71:	56                   	push   %esi
  800f72:	53                   	push   %ebx
  800f73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f81:	b8 06 00 00 00       	mov    $0x6,%eax
  800f86:	89 df                	mov    %ebx,%edi
  800f88:	89 de                	mov    %ebx,%esi
  800f8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	7f 08                	jg     800f98 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	6a 06                	push   $0x6
  800f9e:	68 68 37 80 00       	push   $0x803768
  800fa3:	6a 43                	push   $0x43
  800fa5:	68 85 37 80 00       	push   $0x803785
  800faa:	e8 f2 f2 ff ff       	call   8002a1 <_panic>

00800faf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
  800fb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	b8 08 00 00 00       	mov    $0x8,%eax
  800fc8:	89 df                	mov    %ebx,%edi
  800fca:	89 de                	mov    %ebx,%esi
  800fcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	7f 08                	jg     800fda <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd5:	5b                   	pop    %ebx
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fda:	83 ec 0c             	sub    $0xc,%esp
  800fdd:	50                   	push   %eax
  800fde:	6a 08                	push   $0x8
  800fe0:	68 68 37 80 00       	push   $0x803768
  800fe5:	6a 43                	push   $0x43
  800fe7:	68 85 37 80 00       	push   $0x803785
  800fec:	e8 b0 f2 ff ff       	call   8002a1 <_panic>

00800ff1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	57                   	push   %edi
  800ff5:	56                   	push   %esi
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801005:	b8 09 00 00 00       	mov    $0x9,%eax
  80100a:	89 df                	mov    %ebx,%edi
  80100c:	89 de                	mov    %ebx,%esi
  80100e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801010:	85 c0                	test   %eax,%eax
  801012:	7f 08                	jg     80101c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801014:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101c:	83 ec 0c             	sub    $0xc,%esp
  80101f:	50                   	push   %eax
  801020:	6a 09                	push   $0x9
  801022:	68 68 37 80 00       	push   $0x803768
  801027:	6a 43                	push   $0x43
  801029:	68 85 37 80 00       	push   $0x803785
  80102e:	e8 6e f2 ff ff       	call   8002a1 <_panic>

00801033 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
  801044:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801047:	b8 0a 00 00 00       	mov    $0xa,%eax
  80104c:	89 df                	mov    %ebx,%edi
  80104e:	89 de                	mov    %ebx,%esi
  801050:	cd 30                	int    $0x30
	if(check && ret > 0)
  801052:	85 c0                	test   %eax,%eax
  801054:	7f 08                	jg     80105e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801056:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105e:	83 ec 0c             	sub    $0xc,%esp
  801061:	50                   	push   %eax
  801062:	6a 0a                	push   $0xa
  801064:	68 68 37 80 00       	push   $0x803768
  801069:	6a 43                	push   $0x43
  80106b:	68 85 37 80 00       	push   $0x803785
  801070:	e8 2c f2 ff ff       	call   8002a1 <_panic>

00801075 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	57                   	push   %edi
  801079:	56                   	push   %esi
  80107a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801081:	b8 0c 00 00 00       	mov    $0xc,%eax
  801086:	be 00 00 00 00       	mov    $0x0,%esi
  80108b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80108e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801091:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5f                   	pop    %edi
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    

00801098 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	57                   	push   %edi
  80109c:	56                   	push   %esi
  80109d:	53                   	push   %ebx
  80109e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ae:	89 cb                	mov    %ecx,%ebx
  8010b0:	89 cf                	mov    %ecx,%edi
  8010b2:	89 ce                	mov    %ecx,%esi
  8010b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	7f 08                	jg     8010c2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bd:	5b                   	pop    %ebx
  8010be:	5e                   	pop    %esi
  8010bf:	5f                   	pop    %edi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c2:	83 ec 0c             	sub    $0xc,%esp
  8010c5:	50                   	push   %eax
  8010c6:	6a 0d                	push   $0xd
  8010c8:	68 68 37 80 00       	push   $0x803768
  8010cd:	6a 43                	push   $0x43
  8010cf:	68 85 37 80 00       	push   $0x803785
  8010d4:	e8 c8 f1 ff ff       	call   8002a1 <_panic>

008010d9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ea:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010ef:	89 df                	mov    %ebx,%edi
  8010f1:	89 de                	mov    %ebx,%esi
  8010f3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010f5:	5b                   	pop    %ebx
  8010f6:	5e                   	pop    %esi
  8010f7:	5f                   	pop    %edi
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    

008010fa <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	57                   	push   %edi
  8010fe:	56                   	push   %esi
  8010ff:	53                   	push   %ebx
	asm volatile("int %1\n"
  801100:	b9 00 00 00 00       	mov    $0x0,%ecx
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	b8 0f 00 00 00       	mov    $0xf,%eax
  80110d:	89 cb                	mov    %ecx,%ebx
  80110f:	89 cf                	mov    %ecx,%edi
  801111:	89 ce                	mov    %ecx,%esi
  801113:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	57                   	push   %edi
  80111e:	56                   	push   %esi
  80111f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801120:	ba 00 00 00 00       	mov    $0x0,%edx
  801125:	b8 10 00 00 00       	mov    $0x10,%eax
  80112a:	89 d1                	mov    %edx,%ecx
  80112c:	89 d3                	mov    %edx,%ebx
  80112e:	89 d7                	mov    %edx,%edi
  801130:	89 d6                	mov    %edx,%esi
  801132:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801134:	5b                   	pop    %ebx
  801135:	5e                   	pop    %esi
  801136:	5f                   	pop    %edi
  801137:	5d                   	pop    %ebp
  801138:	c3                   	ret    

00801139 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	57                   	push   %edi
  80113d:	56                   	push   %esi
  80113e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80113f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801144:	8b 55 08             	mov    0x8(%ebp),%edx
  801147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114a:	b8 11 00 00 00       	mov    $0x11,%eax
  80114f:	89 df                	mov    %ebx,%edi
  801151:	89 de                	mov    %ebx,%esi
  801153:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    

0080115a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	57                   	push   %edi
  80115e:	56                   	push   %esi
  80115f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801160:	bb 00 00 00 00       	mov    $0x0,%ebx
  801165:	8b 55 08             	mov    0x8(%ebp),%edx
  801168:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116b:	b8 12 00 00 00       	mov    $0x12,%eax
  801170:	89 df                	mov    %ebx,%edi
  801172:	89 de                	mov    %ebx,%esi
  801174:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5f                   	pop    %edi
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	57                   	push   %edi
  80117f:	56                   	push   %esi
  801180:	53                   	push   %ebx
  801181:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801184:	bb 00 00 00 00       	mov    $0x0,%ebx
  801189:	8b 55 08             	mov    0x8(%ebp),%edx
  80118c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118f:	b8 13 00 00 00       	mov    $0x13,%eax
  801194:	89 df                	mov    %ebx,%edi
  801196:	89 de                	mov    %ebx,%esi
  801198:	cd 30                	int    $0x30
	if(check && ret > 0)
  80119a:	85 c0                	test   %eax,%eax
  80119c:	7f 08                	jg     8011a6 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80119e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a6:	83 ec 0c             	sub    $0xc,%esp
  8011a9:	50                   	push   %eax
  8011aa:	6a 13                	push   $0x13
  8011ac:	68 68 37 80 00       	push   $0x803768
  8011b1:	6a 43                	push   $0x43
  8011b3:	68 85 37 80 00       	push   $0x803785
  8011b8:	e8 e4 f0 ff ff       	call   8002a1 <_panic>

008011bd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	53                   	push   %ebx
  8011c1:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011c4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011cb:	f6 c5 04             	test   $0x4,%ch
  8011ce:	75 45                	jne    801215 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011d0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011d7:	83 e1 07             	and    $0x7,%ecx
  8011da:	83 f9 07             	cmp    $0x7,%ecx
  8011dd:	74 6f                	je     80124e <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011df:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011e6:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011ec:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011f2:	0f 84 b6 00 00 00    	je     8012ae <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011f8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011ff:	83 e1 05             	and    $0x5,%ecx
  801202:	83 f9 05             	cmp    $0x5,%ecx
  801205:	0f 84 d7 00 00 00    	je     8012e2 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80120b:	b8 00 00 00 00       	mov    $0x0,%eax
  801210:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801213:	c9                   	leave  
  801214:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801215:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80121c:	c1 e2 0c             	shl    $0xc,%edx
  80121f:	83 ec 0c             	sub    $0xc,%esp
  801222:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801228:	51                   	push   %ecx
  801229:	52                   	push   %edx
  80122a:	50                   	push   %eax
  80122b:	52                   	push   %edx
  80122c:	6a 00                	push   $0x0
  80122e:	e8 f8 fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  801233:	83 c4 20             	add    $0x20,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	79 d1                	jns    80120b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80123a:	83 ec 04             	sub    $0x4,%esp
  80123d:	68 93 37 80 00       	push   $0x803793
  801242:	6a 54                	push   $0x54
  801244:	68 a9 37 80 00       	push   $0x8037a9
  801249:	e8 53 f0 ff ff       	call   8002a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80124e:	89 d3                	mov    %edx,%ebx
  801250:	c1 e3 0c             	shl    $0xc,%ebx
  801253:	83 ec 0c             	sub    $0xc,%esp
  801256:	68 05 08 00 00       	push   $0x805
  80125b:	53                   	push   %ebx
  80125c:	50                   	push   %eax
  80125d:	53                   	push   %ebx
  80125e:	6a 00                	push   $0x0
  801260:	e8 c6 fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  801265:	83 c4 20             	add    $0x20,%esp
  801268:	85 c0                	test   %eax,%eax
  80126a:	78 2e                	js     80129a <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	68 05 08 00 00       	push   $0x805
  801274:	53                   	push   %ebx
  801275:	6a 00                	push   $0x0
  801277:	53                   	push   %ebx
  801278:	6a 00                	push   $0x0
  80127a:	e8 ac fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  80127f:	83 c4 20             	add    $0x20,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	79 85                	jns    80120b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801286:	83 ec 04             	sub    $0x4,%esp
  801289:	68 93 37 80 00       	push   $0x803793
  80128e:	6a 5f                	push   $0x5f
  801290:	68 a9 37 80 00       	push   $0x8037a9
  801295:	e8 07 f0 ff ff       	call   8002a1 <_panic>
			panic("sys_page_map() panic\n");
  80129a:	83 ec 04             	sub    $0x4,%esp
  80129d:	68 93 37 80 00       	push   $0x803793
  8012a2:	6a 5b                	push   $0x5b
  8012a4:	68 a9 37 80 00       	push   $0x8037a9
  8012a9:	e8 f3 ef ff ff       	call   8002a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012ae:	c1 e2 0c             	shl    $0xc,%edx
  8012b1:	83 ec 0c             	sub    $0xc,%esp
  8012b4:	68 05 08 00 00       	push   $0x805
  8012b9:	52                   	push   %edx
  8012ba:	50                   	push   %eax
  8012bb:	52                   	push   %edx
  8012bc:	6a 00                	push   $0x0
  8012be:	e8 68 fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  8012c3:	83 c4 20             	add    $0x20,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	0f 89 3d ff ff ff    	jns    80120b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	68 93 37 80 00       	push   $0x803793
  8012d6:	6a 66                	push   $0x66
  8012d8:	68 a9 37 80 00       	push   $0x8037a9
  8012dd:	e8 bf ef ff ff       	call   8002a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012e2:	c1 e2 0c             	shl    $0xc,%edx
  8012e5:	83 ec 0c             	sub    $0xc,%esp
  8012e8:	6a 05                	push   $0x5
  8012ea:	52                   	push   %edx
  8012eb:	50                   	push   %eax
  8012ec:	52                   	push   %edx
  8012ed:	6a 00                	push   $0x0
  8012ef:	e8 37 fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  8012f4:	83 c4 20             	add    $0x20,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	0f 89 0c ff ff ff    	jns    80120b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012ff:	83 ec 04             	sub    $0x4,%esp
  801302:	68 93 37 80 00       	push   $0x803793
  801307:	6a 6d                	push   $0x6d
  801309:	68 a9 37 80 00       	push   $0x8037a9
  80130e:	e8 8e ef ff ff       	call   8002a1 <_panic>

00801313 <pgfault>:
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	53                   	push   %ebx
  801317:	83 ec 04             	sub    $0x4,%esp
  80131a:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80131d:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80131f:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801323:	0f 84 99 00 00 00    	je     8013c2 <pgfault+0xaf>
  801329:	89 c2                	mov    %eax,%edx
  80132b:	c1 ea 16             	shr    $0x16,%edx
  80132e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801335:	f6 c2 01             	test   $0x1,%dl
  801338:	0f 84 84 00 00 00    	je     8013c2 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80133e:	89 c2                	mov    %eax,%edx
  801340:	c1 ea 0c             	shr    $0xc,%edx
  801343:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134a:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801350:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801356:	75 6a                	jne    8013c2 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801358:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135d:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80135f:	83 ec 04             	sub    $0x4,%esp
  801362:	6a 07                	push   $0x7
  801364:	68 00 f0 7f 00       	push   $0x7ff000
  801369:	6a 00                	push   $0x0
  80136b:	e8 78 fb ff ff       	call   800ee8 <sys_page_alloc>
	if(ret < 0)
  801370:	83 c4 10             	add    $0x10,%esp
  801373:	85 c0                	test   %eax,%eax
  801375:	78 5f                	js     8013d6 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	68 00 10 00 00       	push   $0x1000
  80137f:	53                   	push   %ebx
  801380:	68 00 f0 7f 00       	push   $0x7ff000
  801385:	e8 5c f9 ff ff       	call   800ce6 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80138a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801391:	53                   	push   %ebx
  801392:	6a 00                	push   $0x0
  801394:	68 00 f0 7f 00       	push   $0x7ff000
  801399:	6a 00                	push   $0x0
  80139b:	e8 8b fb ff ff       	call   800f2b <sys_page_map>
	if(ret < 0)
  8013a0:	83 c4 20             	add    $0x20,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 43                	js     8013ea <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	68 00 f0 7f 00       	push   $0x7ff000
  8013af:	6a 00                	push   $0x0
  8013b1:	e8 b7 fb ff ff       	call   800f6d <sys_page_unmap>
	if(ret < 0)
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 41                	js     8013fe <pgfault+0xeb>
}
  8013bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	68 b4 37 80 00       	push   $0x8037b4
  8013ca:	6a 26                	push   $0x26
  8013cc:	68 a9 37 80 00       	push   $0x8037a9
  8013d1:	e8 cb ee ff ff       	call   8002a1 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	68 c8 37 80 00       	push   $0x8037c8
  8013de:	6a 31                	push   $0x31
  8013e0:	68 a9 37 80 00       	push   $0x8037a9
  8013e5:	e8 b7 ee ff ff       	call   8002a1 <_panic>
		panic("panic in sys_page_map()\n");
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	68 e3 37 80 00       	push   $0x8037e3
  8013f2:	6a 36                	push   $0x36
  8013f4:	68 a9 37 80 00       	push   $0x8037a9
  8013f9:	e8 a3 ee ff ff       	call   8002a1 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013fe:	83 ec 04             	sub    $0x4,%esp
  801401:	68 fc 37 80 00       	push   $0x8037fc
  801406:	6a 39                	push   $0x39
  801408:	68 a9 37 80 00       	push   $0x8037a9
  80140d:	e8 8f ee ff ff       	call   8002a1 <_panic>

00801412 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	57                   	push   %edi
  801416:	56                   	push   %esi
  801417:	53                   	push   %ebx
  801418:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80141b:	68 13 13 80 00       	push   $0x801313
  801420:	e8 40 1a 00 00       	call   802e65 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801425:	b8 07 00 00 00       	mov    $0x7,%eax
  80142a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 27                	js     80145a <fork+0x48>
  801433:	89 c6                	mov    %eax,%esi
  801435:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801437:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80143c:	75 48                	jne    801486 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80143e:	e8 67 fa ff ff       	call   800eaa <sys_getenvid>
  801443:	25 ff 03 00 00       	and    $0x3ff,%eax
  801448:	c1 e0 07             	shl    $0x7,%eax
  80144b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801450:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801455:	e9 90 00 00 00       	jmp    8014ea <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	68 18 38 80 00       	push   $0x803818
  801462:	68 8c 00 00 00       	push   $0x8c
  801467:	68 a9 37 80 00       	push   $0x8037a9
  80146c:	e8 30 ee ff ff       	call   8002a1 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801471:	89 f8                	mov    %edi,%eax
  801473:	e8 45 fd ff ff       	call   8011bd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801478:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80147e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801484:	74 26                	je     8014ac <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801486:	89 d8                	mov    %ebx,%eax
  801488:	c1 e8 16             	shr    $0x16,%eax
  80148b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801492:	a8 01                	test   $0x1,%al
  801494:	74 e2                	je     801478 <fork+0x66>
  801496:	89 da                	mov    %ebx,%edx
  801498:	c1 ea 0c             	shr    $0xc,%edx
  80149b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014a2:	83 e0 05             	and    $0x5,%eax
  8014a5:	83 f8 05             	cmp    $0x5,%eax
  8014a8:	75 ce                	jne    801478 <fork+0x66>
  8014aa:	eb c5                	jmp    801471 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	6a 07                	push   $0x7
  8014b1:	68 00 f0 bf ee       	push   $0xeebff000
  8014b6:	56                   	push   %esi
  8014b7:	e8 2c fa ff ff       	call   800ee8 <sys_page_alloc>
	if(ret < 0)
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 31                	js     8014f4 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	68 d4 2e 80 00       	push   $0x802ed4
  8014cb:	56                   	push   %esi
  8014cc:	e8 62 fb ff ff       	call   801033 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 33                	js     80150b <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	6a 02                	push   $0x2
  8014dd:	56                   	push   %esi
  8014de:	e8 cc fa ff ff       	call   800faf <sys_env_set_status>
	if(ret < 0)
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 38                	js     801522 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014ea:	89 f0                	mov    %esi,%eax
  8014ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ef:	5b                   	pop    %ebx
  8014f0:	5e                   	pop    %esi
  8014f1:	5f                   	pop    %edi
  8014f2:	5d                   	pop    %ebp
  8014f3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	68 c8 37 80 00       	push   $0x8037c8
  8014fc:	68 98 00 00 00       	push   $0x98
  801501:	68 a9 37 80 00       	push   $0x8037a9
  801506:	e8 96 ed ff ff       	call   8002a1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80150b:	83 ec 04             	sub    $0x4,%esp
  80150e:	68 3c 38 80 00       	push   $0x80383c
  801513:	68 9b 00 00 00       	push   $0x9b
  801518:	68 a9 37 80 00       	push   $0x8037a9
  80151d:	e8 7f ed ff ff       	call   8002a1 <_panic>
		panic("panic in sys_env_set_status()\n");
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	68 64 38 80 00       	push   $0x803864
  80152a:	68 9e 00 00 00       	push   $0x9e
  80152f:	68 a9 37 80 00       	push   $0x8037a9
  801534:	e8 68 ed ff ff       	call   8002a1 <_panic>

00801539 <sfork>:

// Challenge!
int
sfork(void)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	57                   	push   %edi
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801542:	68 13 13 80 00       	push   $0x801313
  801547:	e8 19 19 00 00       	call   802e65 <set_pgfault_handler>
  80154c:	b8 07 00 00 00       	mov    $0x7,%eax
  801551:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	78 27                	js     801581 <sfork+0x48>
  80155a:	89 c7                	mov    %eax,%edi
  80155c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80155e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801563:	75 55                	jne    8015ba <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801565:	e8 40 f9 ff ff       	call   800eaa <sys_getenvid>
  80156a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80156f:	c1 e0 07             	shl    $0x7,%eax
  801572:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801577:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80157c:	e9 d4 00 00 00       	jmp    801655 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	68 18 38 80 00       	push   $0x803818
  801589:	68 af 00 00 00       	push   $0xaf
  80158e:	68 a9 37 80 00       	push   $0x8037a9
  801593:	e8 09 ed ff ff       	call   8002a1 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801598:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80159d:	89 f0                	mov    %esi,%eax
  80159f:	e8 19 fc ff ff       	call   8011bd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015a4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015aa:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015b0:	77 65                	ja     801617 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015b2:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015b8:	74 de                	je     801598 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015ba:	89 d8                	mov    %ebx,%eax
  8015bc:	c1 e8 16             	shr    $0x16,%eax
  8015bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c6:	a8 01                	test   $0x1,%al
  8015c8:	74 da                	je     8015a4 <sfork+0x6b>
  8015ca:	89 da                	mov    %ebx,%edx
  8015cc:	c1 ea 0c             	shr    $0xc,%edx
  8015cf:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015d6:	83 e0 05             	and    $0x5,%eax
  8015d9:	83 f8 05             	cmp    $0x5,%eax
  8015dc:	75 c6                	jne    8015a4 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015de:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015e5:	c1 e2 0c             	shl    $0xc,%edx
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	83 e0 07             	and    $0x7,%eax
  8015ee:	50                   	push   %eax
  8015ef:	52                   	push   %edx
  8015f0:	56                   	push   %esi
  8015f1:	52                   	push   %edx
  8015f2:	6a 00                	push   $0x0
  8015f4:	e8 32 f9 ff ff       	call   800f2b <sys_page_map>
  8015f9:	83 c4 20             	add    $0x20,%esp
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	74 a4                	je     8015a4 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	68 93 37 80 00       	push   $0x803793
  801608:	68 ba 00 00 00       	push   $0xba
  80160d:	68 a9 37 80 00       	push   $0x8037a9
  801612:	e8 8a ec ff ff       	call   8002a1 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	6a 07                	push   $0x7
  80161c:	68 00 f0 bf ee       	push   $0xeebff000
  801621:	57                   	push   %edi
  801622:	e8 c1 f8 ff ff       	call   800ee8 <sys_page_alloc>
	if(ret < 0)
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 31                	js     80165f <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	68 d4 2e 80 00       	push   $0x802ed4
  801636:	57                   	push   %edi
  801637:	e8 f7 f9 ff ff       	call   801033 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	85 c0                	test   %eax,%eax
  801641:	78 33                	js     801676 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801643:	83 ec 08             	sub    $0x8,%esp
  801646:	6a 02                	push   $0x2
  801648:	57                   	push   %edi
  801649:	e8 61 f9 ff ff       	call   800faf <sys_env_set_status>
	if(ret < 0)
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 38                	js     80168d <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801655:	89 f8                	mov    %edi,%eax
  801657:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165a:	5b                   	pop    %ebx
  80165b:	5e                   	pop    %esi
  80165c:	5f                   	pop    %edi
  80165d:	5d                   	pop    %ebp
  80165e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80165f:	83 ec 04             	sub    $0x4,%esp
  801662:	68 c8 37 80 00       	push   $0x8037c8
  801667:	68 c0 00 00 00       	push   $0xc0
  80166c:	68 a9 37 80 00       	push   $0x8037a9
  801671:	e8 2b ec ff ff       	call   8002a1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	68 3c 38 80 00       	push   $0x80383c
  80167e:	68 c3 00 00 00       	push   $0xc3
  801683:	68 a9 37 80 00       	push   $0x8037a9
  801688:	e8 14 ec ff ff       	call   8002a1 <_panic>
		panic("panic in sys_env_set_status()\n");
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 64 38 80 00       	push   $0x803864
  801695:	68 c6 00 00 00       	push   $0xc6
  80169a:	68 a9 37 80 00       	push   $0x8037a9
  80169f:	e8 fd eb ff ff       	call   8002a1 <_panic>

008016a4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	05 00 00 00 30       	add    $0x30000000,%eax
  8016af:	c1 e8 0c             	shr    $0xc,%eax
}
  8016b2:	5d                   	pop    %ebp
  8016b3:	c3                   	ret    

008016b4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016d3:	89 c2                	mov    %eax,%edx
  8016d5:	c1 ea 16             	shr    $0x16,%edx
  8016d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016df:	f6 c2 01             	test   $0x1,%dl
  8016e2:	74 2d                	je     801711 <fd_alloc+0x46>
  8016e4:	89 c2                	mov    %eax,%edx
  8016e6:	c1 ea 0c             	shr    $0xc,%edx
  8016e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016f0:	f6 c2 01             	test   $0x1,%dl
  8016f3:	74 1c                	je     801711 <fd_alloc+0x46>
  8016f5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016fa:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016ff:	75 d2                	jne    8016d3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80170a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80170f:	eb 0a                	jmp    80171b <fd_alloc+0x50>
			*fd_store = fd;
  801711:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801714:	89 01                	mov    %eax,(%ecx)
			return 0;
  801716:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    

0080171d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801723:	83 f8 1f             	cmp    $0x1f,%eax
  801726:	77 30                	ja     801758 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801728:	c1 e0 0c             	shl    $0xc,%eax
  80172b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801730:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801736:	f6 c2 01             	test   $0x1,%dl
  801739:	74 24                	je     80175f <fd_lookup+0x42>
  80173b:	89 c2                	mov    %eax,%edx
  80173d:	c1 ea 0c             	shr    $0xc,%edx
  801740:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801747:	f6 c2 01             	test   $0x1,%dl
  80174a:	74 1a                	je     801766 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80174c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174f:	89 02                	mov    %eax,(%edx)
	return 0;
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    
		return -E_INVAL;
  801758:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175d:	eb f7                	jmp    801756 <fd_lookup+0x39>
		return -E_INVAL;
  80175f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801764:	eb f0                	jmp    801756 <fd_lookup+0x39>
  801766:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176b:	eb e9                	jmp    801756 <fd_lookup+0x39>

0080176d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801776:	ba 00 00 00 00       	mov    $0x0,%edx
  80177b:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801780:	39 08                	cmp    %ecx,(%eax)
  801782:	74 38                	je     8017bc <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801784:	83 c2 01             	add    $0x1,%edx
  801787:	8b 04 95 00 39 80 00 	mov    0x803900(,%edx,4),%eax
  80178e:	85 c0                	test   %eax,%eax
  801790:	75 ee                	jne    801780 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801792:	a1 08 50 80 00       	mov    0x805008,%eax
  801797:	8b 40 48             	mov    0x48(%eax),%eax
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	51                   	push   %ecx
  80179e:	50                   	push   %eax
  80179f:	68 84 38 80 00       	push   $0x803884
  8017a4:	e8 ee eb ff ff       	call   800397 <cprintf>
	*dev = 0;
  8017a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    
			*dev = devtab[i];
  8017bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	eb f2                	jmp    8017ba <dev_lookup+0x4d>

008017c8 <fd_close>:
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	57                   	push   %edi
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
  8017ce:	83 ec 24             	sub    $0x24,%esp
  8017d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8017d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017da:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017e1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017e4:	50                   	push   %eax
  8017e5:	e8 33 ff ff ff       	call   80171d <fd_lookup>
  8017ea:	89 c3                	mov    %eax,%ebx
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 05                	js     8017f8 <fd_close+0x30>
	    || fd != fd2)
  8017f3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017f6:	74 16                	je     80180e <fd_close+0x46>
		return (must_exist ? r : 0);
  8017f8:	89 f8                	mov    %edi,%eax
  8017fa:	84 c0                	test   %al,%al
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801801:	0f 44 d8             	cmove  %eax,%ebx
}
  801804:	89 d8                	mov    %ebx,%eax
  801806:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801809:	5b                   	pop    %ebx
  80180a:	5e                   	pop    %esi
  80180b:	5f                   	pop    %edi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80180e:	83 ec 08             	sub    $0x8,%esp
  801811:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801814:	50                   	push   %eax
  801815:	ff 36                	pushl  (%esi)
  801817:	e8 51 ff ff ff       	call   80176d <dev_lookup>
  80181c:	89 c3                	mov    %eax,%ebx
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	85 c0                	test   %eax,%eax
  801823:	78 1a                	js     80183f <fd_close+0x77>
		if (dev->dev_close)
  801825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801828:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80182b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801830:	85 c0                	test   %eax,%eax
  801832:	74 0b                	je     80183f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801834:	83 ec 0c             	sub    $0xc,%esp
  801837:	56                   	push   %esi
  801838:	ff d0                	call   *%eax
  80183a:	89 c3                	mov    %eax,%ebx
  80183c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80183f:	83 ec 08             	sub    $0x8,%esp
  801842:	56                   	push   %esi
  801843:	6a 00                	push   $0x0
  801845:	e8 23 f7 ff ff       	call   800f6d <sys_page_unmap>
	return r;
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	eb b5                	jmp    801804 <fd_close+0x3c>

0080184f <close>:

int
close(int fdnum)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801855:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801858:	50                   	push   %eax
  801859:	ff 75 08             	pushl  0x8(%ebp)
  80185c:	e8 bc fe ff ff       	call   80171d <fd_lookup>
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	85 c0                	test   %eax,%eax
  801866:	79 02                	jns    80186a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    
		return fd_close(fd, 1);
  80186a:	83 ec 08             	sub    $0x8,%esp
  80186d:	6a 01                	push   $0x1
  80186f:	ff 75 f4             	pushl  -0xc(%ebp)
  801872:	e8 51 ff ff ff       	call   8017c8 <fd_close>
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	eb ec                	jmp    801868 <close+0x19>

0080187c <close_all>:

void
close_all(void)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	53                   	push   %ebx
  801880:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801883:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801888:	83 ec 0c             	sub    $0xc,%esp
  80188b:	53                   	push   %ebx
  80188c:	e8 be ff ff ff       	call   80184f <close>
	for (i = 0; i < MAXFD; i++)
  801891:	83 c3 01             	add    $0x1,%ebx
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	83 fb 20             	cmp    $0x20,%ebx
  80189a:	75 ec                	jne    801888 <close_all+0xc>
}
  80189c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	57                   	push   %edi
  8018a5:	56                   	push   %esi
  8018a6:	53                   	push   %ebx
  8018a7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ad:	50                   	push   %eax
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	e8 67 fe ff ff       	call   80171d <fd_lookup>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	0f 88 81 00 00 00    	js     801944 <dup+0xa3>
		return r;
	close(newfdnum);
  8018c3:	83 ec 0c             	sub    $0xc,%esp
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	e8 81 ff ff ff       	call   80184f <close>

	newfd = INDEX2FD(newfdnum);
  8018ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018d1:	c1 e6 0c             	shl    $0xc,%esi
  8018d4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018da:	83 c4 04             	add    $0x4,%esp
  8018dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018e0:	e8 cf fd ff ff       	call   8016b4 <fd2data>
  8018e5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018e7:	89 34 24             	mov    %esi,(%esp)
  8018ea:	e8 c5 fd ff ff       	call   8016b4 <fd2data>
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	c1 e8 16             	shr    $0x16,%eax
  8018f9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801900:	a8 01                	test   $0x1,%al
  801902:	74 11                	je     801915 <dup+0x74>
  801904:	89 d8                	mov    %ebx,%eax
  801906:	c1 e8 0c             	shr    $0xc,%eax
  801909:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801910:	f6 c2 01             	test   $0x1,%dl
  801913:	75 39                	jne    80194e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801915:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801918:	89 d0                	mov    %edx,%eax
  80191a:	c1 e8 0c             	shr    $0xc,%eax
  80191d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801924:	83 ec 0c             	sub    $0xc,%esp
  801927:	25 07 0e 00 00       	and    $0xe07,%eax
  80192c:	50                   	push   %eax
  80192d:	56                   	push   %esi
  80192e:	6a 00                	push   $0x0
  801930:	52                   	push   %edx
  801931:	6a 00                	push   $0x0
  801933:	e8 f3 f5 ff ff       	call   800f2b <sys_page_map>
  801938:	89 c3                	mov    %eax,%ebx
  80193a:	83 c4 20             	add    $0x20,%esp
  80193d:	85 c0                	test   %eax,%eax
  80193f:	78 31                	js     801972 <dup+0xd1>
		goto err;

	return newfdnum;
  801941:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801944:	89 d8                	mov    %ebx,%eax
  801946:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80194e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801955:	83 ec 0c             	sub    $0xc,%esp
  801958:	25 07 0e 00 00       	and    $0xe07,%eax
  80195d:	50                   	push   %eax
  80195e:	57                   	push   %edi
  80195f:	6a 00                	push   $0x0
  801961:	53                   	push   %ebx
  801962:	6a 00                	push   $0x0
  801964:	e8 c2 f5 ff ff       	call   800f2b <sys_page_map>
  801969:	89 c3                	mov    %eax,%ebx
  80196b:	83 c4 20             	add    $0x20,%esp
  80196e:	85 c0                	test   %eax,%eax
  801970:	79 a3                	jns    801915 <dup+0x74>
	sys_page_unmap(0, newfd);
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	56                   	push   %esi
  801976:	6a 00                	push   $0x0
  801978:	e8 f0 f5 ff ff       	call   800f6d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80197d:	83 c4 08             	add    $0x8,%esp
  801980:	57                   	push   %edi
  801981:	6a 00                	push   $0x0
  801983:	e8 e5 f5 ff ff       	call   800f6d <sys_page_unmap>
	return r;
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	eb b7                	jmp    801944 <dup+0xa3>

0080198d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	53                   	push   %ebx
  801991:	83 ec 1c             	sub    $0x1c,%esp
  801994:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801997:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80199a:	50                   	push   %eax
  80199b:	53                   	push   %ebx
  80199c:	e8 7c fd ff ff       	call   80171d <fd_lookup>
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 3f                	js     8019e7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a8:	83 ec 08             	sub    $0x8,%esp
  8019ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ae:	50                   	push   %eax
  8019af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b2:	ff 30                	pushl  (%eax)
  8019b4:	e8 b4 fd ff ff       	call   80176d <dev_lookup>
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 27                	js     8019e7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019c3:	8b 42 08             	mov    0x8(%edx),%eax
  8019c6:	83 e0 03             	and    $0x3,%eax
  8019c9:	83 f8 01             	cmp    $0x1,%eax
  8019cc:	74 1e                	je     8019ec <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	8b 40 08             	mov    0x8(%eax),%eax
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	74 35                	je     801a0d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019d8:	83 ec 04             	sub    $0x4,%esp
  8019db:	ff 75 10             	pushl  0x10(%ebp)
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	52                   	push   %edx
  8019e2:	ff d0                	call   *%eax
  8019e4:	83 c4 10             	add    $0x10,%esp
}
  8019e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ec:	a1 08 50 80 00       	mov    0x805008,%eax
  8019f1:	8b 40 48             	mov    0x48(%eax),%eax
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	53                   	push   %ebx
  8019f8:	50                   	push   %eax
  8019f9:	68 c5 38 80 00       	push   $0x8038c5
  8019fe:	e8 94 e9 ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a0b:	eb da                	jmp    8019e7 <read+0x5a>
		return -E_NOT_SUPP;
  801a0d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a12:	eb d3                	jmp    8019e7 <read+0x5a>

00801a14 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	57                   	push   %edi
  801a18:	56                   	push   %esi
  801a19:	53                   	push   %ebx
  801a1a:	83 ec 0c             	sub    $0xc,%esp
  801a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a20:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a23:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a28:	39 f3                	cmp    %esi,%ebx
  801a2a:	73 23                	jae    801a4f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	89 f0                	mov    %esi,%eax
  801a31:	29 d8                	sub    %ebx,%eax
  801a33:	50                   	push   %eax
  801a34:	89 d8                	mov    %ebx,%eax
  801a36:	03 45 0c             	add    0xc(%ebp),%eax
  801a39:	50                   	push   %eax
  801a3a:	57                   	push   %edi
  801a3b:	e8 4d ff ff ff       	call   80198d <read>
		if (m < 0)
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	85 c0                	test   %eax,%eax
  801a45:	78 06                	js     801a4d <readn+0x39>
			return m;
		if (m == 0)
  801a47:	74 06                	je     801a4f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a49:	01 c3                	add    %eax,%ebx
  801a4b:	eb db                	jmp    801a28 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a4d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a4f:	89 d8                	mov    %ebx,%eax
  801a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a54:	5b                   	pop    %ebx
  801a55:	5e                   	pop    %esi
  801a56:	5f                   	pop    %edi
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    

00801a59 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 1c             	sub    $0x1c,%esp
  801a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a63:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a66:	50                   	push   %eax
  801a67:	53                   	push   %ebx
  801a68:	e8 b0 fc ff ff       	call   80171d <fd_lookup>
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	78 3a                	js     801aae <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a74:	83 ec 08             	sub    $0x8,%esp
  801a77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7a:	50                   	push   %eax
  801a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7e:	ff 30                	pushl  (%eax)
  801a80:	e8 e8 fc ff ff       	call   80176d <dev_lookup>
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 22                	js     801aae <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a93:	74 1e                	je     801ab3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a98:	8b 52 0c             	mov    0xc(%edx),%edx
  801a9b:	85 d2                	test   %edx,%edx
  801a9d:	74 35                	je     801ad4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	ff 75 10             	pushl  0x10(%ebp)
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	50                   	push   %eax
  801aa9:	ff d2                	call   *%edx
  801aab:	83 c4 10             	add    $0x10,%esp
}
  801aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ab3:	a1 08 50 80 00       	mov    0x805008,%eax
  801ab8:	8b 40 48             	mov    0x48(%eax),%eax
  801abb:	83 ec 04             	sub    $0x4,%esp
  801abe:	53                   	push   %ebx
  801abf:	50                   	push   %eax
  801ac0:	68 e1 38 80 00       	push   $0x8038e1
  801ac5:	e8 cd e8 ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad2:	eb da                	jmp    801aae <write+0x55>
		return -E_NOT_SUPP;
  801ad4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad9:	eb d3                	jmp    801aae <write+0x55>

00801adb <seek>:

int
seek(int fdnum, off_t offset)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ae1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae4:	50                   	push   %eax
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	e8 30 fc ff ff       	call   80171d <fd_lookup>
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 0e                	js     801b02 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afa:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	53                   	push   %ebx
  801b08:	83 ec 1c             	sub    $0x1c,%esp
  801b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b11:	50                   	push   %eax
  801b12:	53                   	push   %ebx
  801b13:	e8 05 fc ff ff       	call   80171d <fd_lookup>
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 37                	js     801b56 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b1f:	83 ec 08             	sub    $0x8,%esp
  801b22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b25:	50                   	push   %eax
  801b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b29:	ff 30                	pushl  (%eax)
  801b2b:	e8 3d fc ff ff       	call   80176d <dev_lookup>
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 1f                	js     801b56 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b3e:	74 1b                	je     801b5b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b43:	8b 52 18             	mov    0x18(%edx),%edx
  801b46:	85 d2                	test   %edx,%edx
  801b48:	74 32                	je     801b7c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	50                   	push   %eax
  801b51:	ff d2                	call   *%edx
  801b53:	83 c4 10             	add    $0x10,%esp
}
  801b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b5b:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b60:	8b 40 48             	mov    0x48(%eax),%eax
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	53                   	push   %ebx
  801b67:	50                   	push   %eax
  801b68:	68 a4 38 80 00       	push   $0x8038a4
  801b6d:	e8 25 e8 ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b7a:	eb da                	jmp    801b56 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b7c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b81:	eb d3                	jmp    801b56 <ftruncate+0x52>

00801b83 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	53                   	push   %ebx
  801b87:	83 ec 1c             	sub    $0x1c,%esp
  801b8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b90:	50                   	push   %eax
  801b91:	ff 75 08             	pushl  0x8(%ebp)
  801b94:	e8 84 fb ff ff       	call   80171d <fd_lookup>
  801b99:	83 c4 10             	add    $0x10,%esp
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	78 4b                	js     801beb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba6:	50                   	push   %eax
  801ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801baa:	ff 30                	pushl  (%eax)
  801bac:	e8 bc fb ff ff       	call   80176d <dev_lookup>
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 33                	js     801beb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bbf:	74 2f                	je     801bf0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bc1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bc4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bcb:	00 00 00 
	stat->st_isdir = 0;
  801bce:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bd5:	00 00 00 
	stat->st_dev = dev;
  801bd8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bde:	83 ec 08             	sub    $0x8,%esp
  801be1:	53                   	push   %ebx
  801be2:	ff 75 f0             	pushl  -0x10(%ebp)
  801be5:	ff 50 14             	call   *0x14(%eax)
  801be8:	83 c4 10             	add    $0x10,%esp
}
  801beb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    
		return -E_NOT_SUPP;
  801bf0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bf5:	eb f4                	jmp    801beb <fstat+0x68>

00801bf7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	56                   	push   %esi
  801bfb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bfc:	83 ec 08             	sub    $0x8,%esp
  801bff:	6a 00                	push   $0x0
  801c01:	ff 75 08             	pushl  0x8(%ebp)
  801c04:	e8 22 02 00 00       	call   801e2b <open>
  801c09:	89 c3                	mov    %eax,%ebx
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	78 1b                	js     801c2d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c12:	83 ec 08             	sub    $0x8,%esp
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	50                   	push   %eax
  801c19:	e8 65 ff ff ff       	call   801b83 <fstat>
  801c1e:	89 c6                	mov    %eax,%esi
	close(fd);
  801c20:	89 1c 24             	mov    %ebx,(%esp)
  801c23:	e8 27 fc ff ff       	call   80184f <close>
	return r;
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	89 f3                	mov    %esi,%ebx
}
  801c2d:	89 d8                	mov    %ebx,%eax
  801c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c32:	5b                   	pop    %ebx
  801c33:	5e                   	pop    %esi
  801c34:	5d                   	pop    %ebp
  801c35:	c3                   	ret    

00801c36 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	56                   	push   %esi
  801c3a:	53                   	push   %ebx
  801c3b:	89 c6                	mov    %eax,%esi
  801c3d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c3f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c46:	74 27                	je     801c6f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c48:	6a 07                	push   $0x7
  801c4a:	68 00 60 80 00       	push   $0x806000
  801c4f:	56                   	push   %esi
  801c50:	ff 35 00 50 80 00    	pushl  0x805000
  801c56:	e8 08 13 00 00       	call   802f63 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c5b:	83 c4 0c             	add    $0xc,%esp
  801c5e:	6a 00                	push   $0x0
  801c60:	53                   	push   %ebx
  801c61:	6a 00                	push   $0x0
  801c63:	e8 92 12 00 00       	call   802efa <ipc_recv>
}
  801c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	6a 01                	push   $0x1
  801c74:	e8 42 13 00 00       	call   802fbb <ipc_find_env>
  801c79:	a3 00 50 80 00       	mov    %eax,0x805000
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	eb c5                	jmp    801c48 <fsipc+0x12>

00801c83 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca1:	b8 02 00 00 00       	mov    $0x2,%eax
  801ca6:	e8 8b ff ff ff       	call   801c36 <fsipc>
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <devfile_flush>:
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb9:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc3:	b8 06 00 00 00       	mov    $0x6,%eax
  801cc8:	e8 69 ff ff ff       	call   801c36 <fsipc>
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <devfile_stat>:
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	53                   	push   %ebx
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801cdf:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce9:	b8 05 00 00 00       	mov    $0x5,%eax
  801cee:	e8 43 ff ff ff       	call   801c36 <fsipc>
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	78 2c                	js     801d23 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cf7:	83 ec 08             	sub    $0x8,%esp
  801cfa:	68 00 60 80 00       	push   $0x806000
  801cff:	53                   	push   %ebx
  801d00:	e8 f1 ed ff ff       	call   800af6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d05:	a1 80 60 80 00       	mov    0x806080,%eax
  801d0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d10:	a1 84 60 80 00       	mov    0x806084,%eax
  801d15:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <devfile_write>:
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 08             	sub    $0x8,%esp
  801d2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	8b 40 0c             	mov    0xc(%eax),%eax
  801d38:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d3d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d43:	53                   	push   %ebx
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	68 08 60 80 00       	push   $0x806008
  801d4c:	e8 95 ef ff ff       	call   800ce6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d51:	ba 00 00 00 00       	mov    $0x0,%edx
  801d56:	b8 04 00 00 00       	mov    $0x4,%eax
  801d5b:	e8 d6 fe ff ff       	call   801c36 <fsipc>
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 0b                	js     801d72 <devfile_write+0x4a>
	assert(r <= n);
  801d67:	39 d8                	cmp    %ebx,%eax
  801d69:	77 0c                	ja     801d77 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d6b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d70:	7f 1e                	jg     801d90 <devfile_write+0x68>
}
  801d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    
	assert(r <= n);
  801d77:	68 14 39 80 00       	push   $0x803914
  801d7c:	68 1b 39 80 00       	push   $0x80391b
  801d81:	68 98 00 00 00       	push   $0x98
  801d86:	68 30 39 80 00       	push   $0x803930
  801d8b:	e8 11 e5 ff ff       	call   8002a1 <_panic>
	assert(r <= PGSIZE);
  801d90:	68 3b 39 80 00       	push   $0x80393b
  801d95:	68 1b 39 80 00       	push   $0x80391b
  801d9a:	68 99 00 00 00       	push   $0x99
  801d9f:	68 30 39 80 00       	push   $0x803930
  801da4:	e8 f8 e4 ff ff       	call   8002a1 <_panic>

00801da9 <devfile_read>:
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
  801dae:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	8b 40 0c             	mov    0xc(%eax),%eax
  801db7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dbc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc7:	b8 03 00 00 00       	mov    $0x3,%eax
  801dcc:	e8 65 fe ff ff       	call   801c36 <fsipc>
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	78 1f                	js     801df6 <devfile_read+0x4d>
	assert(r <= n);
  801dd7:	39 f0                	cmp    %esi,%eax
  801dd9:	77 24                	ja     801dff <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ddb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801de0:	7f 33                	jg     801e15 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801de2:	83 ec 04             	sub    $0x4,%esp
  801de5:	50                   	push   %eax
  801de6:	68 00 60 80 00       	push   $0x806000
  801deb:	ff 75 0c             	pushl  0xc(%ebp)
  801dee:	e8 91 ee ff ff       	call   800c84 <memmove>
	return r;
  801df3:	83 c4 10             	add    $0x10,%esp
}
  801df6:	89 d8                	mov    %ebx,%eax
  801df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfb:	5b                   	pop    %ebx
  801dfc:	5e                   	pop    %esi
  801dfd:	5d                   	pop    %ebp
  801dfe:	c3                   	ret    
	assert(r <= n);
  801dff:	68 14 39 80 00       	push   $0x803914
  801e04:	68 1b 39 80 00       	push   $0x80391b
  801e09:	6a 7c                	push   $0x7c
  801e0b:	68 30 39 80 00       	push   $0x803930
  801e10:	e8 8c e4 ff ff       	call   8002a1 <_panic>
	assert(r <= PGSIZE);
  801e15:	68 3b 39 80 00       	push   $0x80393b
  801e1a:	68 1b 39 80 00       	push   $0x80391b
  801e1f:	6a 7d                	push   $0x7d
  801e21:	68 30 39 80 00       	push   $0x803930
  801e26:	e8 76 e4 ff ff       	call   8002a1 <_panic>

00801e2b <open>:
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	83 ec 1c             	sub    $0x1c,%esp
  801e33:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e36:	56                   	push   %esi
  801e37:	e8 81 ec ff ff       	call   800abd <strlen>
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e44:	7f 6c                	jg     801eb2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e46:	83 ec 0c             	sub    $0xc,%esp
  801e49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4c:	50                   	push   %eax
  801e4d:	e8 79 f8 ff ff       	call   8016cb <fd_alloc>
  801e52:	89 c3                	mov    %eax,%ebx
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	85 c0                	test   %eax,%eax
  801e59:	78 3c                	js     801e97 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e5b:	83 ec 08             	sub    $0x8,%esp
  801e5e:	56                   	push   %esi
  801e5f:	68 00 60 80 00       	push   $0x806000
  801e64:	e8 8d ec ff ff       	call   800af6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e74:	b8 01 00 00 00       	mov    $0x1,%eax
  801e79:	e8 b8 fd ff ff       	call   801c36 <fsipc>
  801e7e:	89 c3                	mov    %eax,%ebx
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	85 c0                	test   %eax,%eax
  801e85:	78 19                	js     801ea0 <open+0x75>
	return fd2num(fd);
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8d:	e8 12 f8 ff ff       	call   8016a4 <fd2num>
  801e92:	89 c3                	mov    %eax,%ebx
  801e94:	83 c4 10             	add    $0x10,%esp
}
  801e97:	89 d8                	mov    %ebx,%eax
  801e99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e9c:	5b                   	pop    %ebx
  801e9d:	5e                   	pop    %esi
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    
		fd_close(fd, 0);
  801ea0:	83 ec 08             	sub    $0x8,%esp
  801ea3:	6a 00                	push   $0x0
  801ea5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea8:	e8 1b f9 ff ff       	call   8017c8 <fd_close>
		return r;
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	eb e5                	jmp    801e97 <open+0x6c>
		return -E_BAD_PATH;
  801eb2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801eb7:	eb de                	jmp    801e97 <open+0x6c>

00801eb9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec4:	b8 08 00 00 00       	mov    $0x8,%eax
  801ec9:	e8 68 fd ff ff       	call   801c36 <fsipc>
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	57                   	push   %edi
  801ed4:	56                   	push   %esi
  801ed5:	53                   	push   %ebx
  801ed6:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801edc:	68 20 3a 80 00       	push   $0x803a20
  801ee1:	68 a9 33 80 00       	push   $0x8033a9
  801ee6:	e8 ac e4 ff ff       	call   800397 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801eeb:	83 c4 08             	add    $0x8,%esp
  801eee:	6a 00                	push   $0x0
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	e8 33 ff ff ff       	call   801e2b <open>
  801ef8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	0f 88 0a 05 00 00    	js     802413 <spawn+0x543>
  801f09:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801f0b:	83 ec 04             	sub    $0x4,%esp
  801f0e:	68 00 02 00 00       	push   $0x200
  801f13:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801f19:	50                   	push   %eax
  801f1a:	51                   	push   %ecx
  801f1b:	e8 f4 fa ff ff       	call   801a14 <readn>
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	3d 00 02 00 00       	cmp    $0x200,%eax
  801f28:	75 74                	jne    801f9e <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801f2a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801f31:	45 4c 46 
  801f34:	75 68                	jne    801f9e <spawn+0xce>
  801f36:	b8 07 00 00 00       	mov    $0x7,%eax
  801f3b:	cd 30                	int    $0x30
  801f3d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801f43:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	0f 88 b6 04 00 00    	js     802407 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801f51:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f56:	89 c6                	mov    %eax,%esi
  801f58:	c1 e6 07             	shl    $0x7,%esi
  801f5b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801f61:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801f67:	b9 11 00 00 00       	mov    $0x11,%ecx
  801f6c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801f6e:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801f74:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801f7a:	83 ec 08             	sub    $0x8,%esp
  801f7d:	68 14 3a 80 00       	push   $0x803a14
  801f82:	68 a9 33 80 00       	push   $0x8033a9
  801f87:	e8 0b e4 ff ff       	call   800397 <cprintf>
  801f8c:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801f8f:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801f94:	be 00 00 00 00       	mov    $0x0,%esi
  801f99:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f9c:	eb 4b                	jmp    801fe9 <spawn+0x119>
		close(fd);
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801fa7:	e8 a3 f8 ff ff       	call   80184f <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801fac:	83 c4 0c             	add    $0xc,%esp
  801faf:	68 7f 45 4c 46       	push   $0x464c457f
  801fb4:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801fba:	68 47 39 80 00       	push   $0x803947
  801fbf:	e8 d3 e3 ff ff       	call   800397 <cprintf>
		return -E_NOT_EXEC;
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801fce:	ff ff ff 
  801fd1:	e9 3d 04 00 00       	jmp    802413 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	50                   	push   %eax
  801fda:	e8 de ea ff ff       	call   800abd <strlen>
  801fdf:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801fe3:	83 c3 01             	add    $0x1,%ebx
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801ff0:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	75 df                	jne    801fd6 <spawn+0x106>
  801ff7:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801ffd:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802003:	bf 00 10 40 00       	mov    $0x401000,%edi
  802008:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80200a:	89 fa                	mov    %edi,%edx
  80200c:	83 e2 fc             	and    $0xfffffffc,%edx
  80200f:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802016:	29 c2                	sub    %eax,%edx
  802018:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80201e:	8d 42 f8             	lea    -0x8(%edx),%eax
  802021:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802026:	0f 86 0a 04 00 00    	jbe    802436 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80202c:	83 ec 04             	sub    $0x4,%esp
  80202f:	6a 07                	push   $0x7
  802031:	68 00 00 40 00       	push   $0x400000
  802036:	6a 00                	push   $0x0
  802038:	e8 ab ee ff ff       	call   800ee8 <sys_page_alloc>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	85 c0                	test   %eax,%eax
  802042:	0f 88 f3 03 00 00    	js     80243b <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802048:	be 00 00 00 00       	mov    $0x0,%esi
  80204d:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802053:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802056:	eb 30                	jmp    802088 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  802058:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80205e:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802064:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802067:	83 ec 08             	sub    $0x8,%esp
  80206a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80206d:	57                   	push   %edi
  80206e:	e8 83 ea ff ff       	call   800af6 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802073:	83 c4 04             	add    $0x4,%esp
  802076:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802079:	e8 3f ea ff ff       	call   800abd <strlen>
  80207e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802082:	83 c6 01             	add    $0x1,%esi
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80208e:	7f c8                	jg     802058 <spawn+0x188>
	}
	argv_store[argc] = 0;
  802090:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802096:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80209c:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020a3:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8020a9:	0f 85 86 00 00 00    	jne    802135 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8020af:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8020b5:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  8020bb:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8020be:	89 d0                	mov    %edx,%eax
  8020c0:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8020c6:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8020c9:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8020ce:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	6a 07                	push   $0x7
  8020d9:	68 00 d0 bf ee       	push   $0xeebfd000
  8020de:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020e4:	68 00 00 40 00       	push   $0x400000
  8020e9:	6a 00                	push   $0x0
  8020eb:	e8 3b ee ff ff       	call   800f2b <sys_page_map>
  8020f0:	89 c3                	mov    %eax,%ebx
  8020f2:	83 c4 20             	add    $0x20,%esp
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	0f 88 46 03 00 00    	js     802443 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8020fd:	83 ec 08             	sub    $0x8,%esp
  802100:	68 00 00 40 00       	push   $0x400000
  802105:	6a 00                	push   $0x0
  802107:	e8 61 ee ff ff       	call   800f6d <sys_page_unmap>
  80210c:	89 c3                	mov    %eax,%ebx
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	0f 88 2a 03 00 00    	js     802443 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802119:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80211f:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802126:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  80212d:	00 00 00 
  802130:	e9 4f 01 00 00       	jmp    802284 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802135:	68 d0 39 80 00       	push   $0x8039d0
  80213a:	68 1b 39 80 00       	push   $0x80391b
  80213f:	68 f8 00 00 00       	push   $0xf8
  802144:	68 61 39 80 00       	push   $0x803961
  802149:	e8 53 e1 ff ff       	call   8002a1 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80214e:	83 ec 04             	sub    $0x4,%esp
  802151:	6a 07                	push   $0x7
  802153:	68 00 00 40 00       	push   $0x400000
  802158:	6a 00                	push   $0x0
  80215a:	e8 89 ed ff ff       	call   800ee8 <sys_page_alloc>
  80215f:	83 c4 10             	add    $0x10,%esp
  802162:	85 c0                	test   %eax,%eax
  802164:	0f 88 b7 02 00 00    	js     802421 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80216a:	83 ec 08             	sub    $0x8,%esp
  80216d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802173:	01 f0                	add    %esi,%eax
  802175:	50                   	push   %eax
  802176:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80217c:	e8 5a f9 ff ff       	call   801adb <seek>
  802181:	83 c4 10             	add    $0x10,%esp
  802184:	85 c0                	test   %eax,%eax
  802186:	0f 88 9c 02 00 00    	js     802428 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802195:	29 f0                	sub    %esi,%eax
  802197:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80219c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021a1:	0f 47 c1             	cmova  %ecx,%eax
  8021a4:	50                   	push   %eax
  8021a5:	68 00 00 40 00       	push   $0x400000
  8021aa:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021b0:	e8 5f f8 ff ff       	call   801a14 <readn>
  8021b5:	83 c4 10             	add    $0x10,%esp
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	0f 88 6f 02 00 00    	js     80242f <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8021c0:	83 ec 0c             	sub    $0xc,%esp
  8021c3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8021c9:	53                   	push   %ebx
  8021ca:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8021d0:	68 00 00 40 00       	push   $0x400000
  8021d5:	6a 00                	push   $0x0
  8021d7:	e8 4f ed ff ff       	call   800f2b <sys_page_map>
  8021dc:	83 c4 20             	add    $0x20,%esp
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 7c                	js     80225f <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8021e3:	83 ec 08             	sub    $0x8,%esp
  8021e6:	68 00 00 40 00       	push   $0x400000
  8021eb:	6a 00                	push   $0x0
  8021ed:	e8 7b ed ff ff       	call   800f6d <sys_page_unmap>
  8021f2:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8021f5:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8021fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802201:	89 fe                	mov    %edi,%esi
  802203:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802209:	76 69                	jbe    802274 <spawn+0x3a4>
		if (i >= filesz) {
  80220b:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802211:	0f 87 37 ff ff ff    	ja     80214e <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802217:	83 ec 04             	sub    $0x4,%esp
  80221a:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802220:	53                   	push   %ebx
  802221:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802227:	e8 bc ec ff ff       	call   800ee8 <sys_page_alloc>
  80222c:	83 c4 10             	add    $0x10,%esp
  80222f:	85 c0                	test   %eax,%eax
  802231:	79 c2                	jns    8021f5 <spawn+0x325>
  802233:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802235:	83 ec 0c             	sub    $0xc,%esp
  802238:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80223e:	e8 26 ec ff ff       	call   800e69 <sys_env_destroy>
	close(fd);
  802243:	83 c4 04             	add    $0x4,%esp
  802246:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80224c:	e8 fe f5 ff ff       	call   80184f <close>
	return r;
  802251:	83 c4 10             	add    $0x10,%esp
  802254:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  80225a:	e9 b4 01 00 00       	jmp    802413 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  80225f:	50                   	push   %eax
  802260:	68 6d 39 80 00       	push   $0x80396d
  802265:	68 2b 01 00 00       	push   $0x12b
  80226a:	68 61 39 80 00       	push   $0x803961
  80226f:	e8 2d e0 ff ff       	call   8002a1 <_panic>
  802274:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80227a:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802281:	83 c6 20             	add    $0x20,%esi
  802284:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80228b:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802291:	7e 6d                	jle    802300 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802293:	83 3e 01             	cmpl   $0x1,(%esi)
  802296:	75 e2                	jne    80227a <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802298:	8b 46 18             	mov    0x18(%esi),%eax
  80229b:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80229e:	83 f8 01             	cmp    $0x1,%eax
  8022a1:	19 c0                	sbb    %eax,%eax
  8022a3:	83 e0 fe             	and    $0xfffffffe,%eax
  8022a6:	83 c0 07             	add    $0x7,%eax
  8022a9:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8022af:	8b 4e 04             	mov    0x4(%esi),%ecx
  8022b2:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8022b8:	8b 56 10             	mov    0x10(%esi),%edx
  8022bb:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8022c1:	8b 7e 14             	mov    0x14(%esi),%edi
  8022c4:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8022ca:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8022cd:	89 d8                	mov    %ebx,%eax
  8022cf:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022d4:	74 1a                	je     8022f0 <spawn+0x420>
		va -= i;
  8022d6:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8022d8:	01 c7                	add    %eax,%edi
  8022da:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8022e0:	01 c2                	add    %eax,%edx
  8022e2:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  8022e8:	29 c1                	sub    %eax,%ecx
  8022ea:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8022f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f5:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8022fb:	e9 01 ff ff ff       	jmp    802201 <spawn+0x331>
	close(fd);
  802300:	83 ec 0c             	sub    $0xc,%esp
  802303:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802309:	e8 41 f5 ff ff       	call   80184f <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  80230e:	83 c4 08             	add    $0x8,%esp
  802311:	68 00 3a 80 00       	push   $0x803a00
  802316:	68 a9 33 80 00       	push   $0x8033a9
  80231b:	e8 77 e0 ff ff       	call   800397 <cprintf>
  802320:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802323:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802328:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  80232e:	eb 0e                	jmp    80233e <spawn+0x46e>
  802330:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802336:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80233c:	74 5e                	je     80239c <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  80233e:	89 d8                	mov    %ebx,%eax
  802340:	c1 e8 16             	shr    $0x16,%eax
  802343:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80234a:	a8 01                	test   $0x1,%al
  80234c:	74 e2                	je     802330 <spawn+0x460>
  80234e:	89 da                	mov    %ebx,%edx
  802350:	c1 ea 0c             	shr    $0xc,%edx
  802353:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80235a:	25 05 04 00 00       	and    $0x405,%eax
  80235f:	3d 05 04 00 00       	cmp    $0x405,%eax
  802364:	75 ca                	jne    802330 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802366:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80236d:	83 ec 0c             	sub    $0xc,%esp
  802370:	25 07 0e 00 00       	and    $0xe07,%eax
  802375:	50                   	push   %eax
  802376:	53                   	push   %ebx
  802377:	56                   	push   %esi
  802378:	53                   	push   %ebx
  802379:	6a 00                	push   $0x0
  80237b:	e8 ab eb ff ff       	call   800f2b <sys_page_map>
  802380:	83 c4 20             	add    $0x20,%esp
  802383:	85 c0                	test   %eax,%eax
  802385:	79 a9                	jns    802330 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802387:	50                   	push   %eax
  802388:	68 8a 39 80 00       	push   $0x80398a
  80238d:	68 3b 01 00 00       	push   $0x13b
  802392:	68 61 39 80 00       	push   $0x803961
  802397:	e8 05 df ff ff       	call   8002a1 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80239c:	83 ec 08             	sub    $0x8,%esp
  80239f:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8023a5:	50                   	push   %eax
  8023a6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023ac:	e8 40 ec ff ff       	call   800ff1 <sys_env_set_trapframe>
  8023b1:	83 c4 10             	add    $0x10,%esp
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	78 25                	js     8023dd <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8023b8:	83 ec 08             	sub    $0x8,%esp
  8023bb:	6a 02                	push   $0x2
  8023bd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023c3:	e8 e7 eb ff ff       	call   800faf <sys_env_set_status>
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	78 23                	js     8023f2 <spawn+0x522>
	return child;
  8023cf:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8023d5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8023db:	eb 36                	jmp    802413 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  8023dd:	50                   	push   %eax
  8023de:	68 9c 39 80 00       	push   $0x80399c
  8023e3:	68 8a 00 00 00       	push   $0x8a
  8023e8:	68 61 39 80 00       	push   $0x803961
  8023ed:	e8 af de ff ff       	call   8002a1 <_panic>
		panic("sys_env_set_status: %e", r);
  8023f2:	50                   	push   %eax
  8023f3:	68 b6 39 80 00       	push   $0x8039b6
  8023f8:	68 8d 00 00 00       	push   $0x8d
  8023fd:	68 61 39 80 00       	push   $0x803961
  802402:	e8 9a de ff ff       	call   8002a1 <_panic>
		return r;
  802407:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80240d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802413:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802419:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80241c:	5b                   	pop    %ebx
  80241d:	5e                   	pop    %esi
  80241e:	5f                   	pop    %edi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    
  802421:	89 c7                	mov    %eax,%edi
  802423:	e9 0d fe ff ff       	jmp    802235 <spawn+0x365>
  802428:	89 c7                	mov    %eax,%edi
  80242a:	e9 06 fe ff ff       	jmp    802235 <spawn+0x365>
  80242f:	89 c7                	mov    %eax,%edi
  802431:	e9 ff fd ff ff       	jmp    802235 <spawn+0x365>
		return -E_NO_MEM;
  802436:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80243b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802441:	eb d0                	jmp    802413 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  802443:	83 ec 08             	sub    $0x8,%esp
  802446:	68 00 00 40 00       	push   $0x400000
  80244b:	6a 00                	push   $0x0
  80244d:	e8 1b eb ff ff       	call   800f6d <sys_page_unmap>
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80245b:	eb b6                	jmp    802413 <spawn+0x543>

0080245d <spawnl>:
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
  802460:	57                   	push   %edi
  802461:	56                   	push   %esi
  802462:	53                   	push   %ebx
  802463:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802466:	68 f8 39 80 00       	push   $0x8039f8
  80246b:	68 a9 33 80 00       	push   $0x8033a9
  802470:	e8 22 df ff ff       	call   800397 <cprintf>
	va_start(vl, arg0);
  802475:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802478:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802480:	8d 4a 04             	lea    0x4(%edx),%ecx
  802483:	83 3a 00             	cmpl   $0x0,(%edx)
  802486:	74 07                	je     80248f <spawnl+0x32>
		argc++;
  802488:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80248b:	89 ca                	mov    %ecx,%edx
  80248d:	eb f1                	jmp    802480 <spawnl+0x23>
	const char *argv[argc+2];
  80248f:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802496:	83 e2 f0             	and    $0xfffffff0,%edx
  802499:	29 d4                	sub    %edx,%esp
  80249b:	8d 54 24 03          	lea    0x3(%esp),%edx
  80249f:	c1 ea 02             	shr    $0x2,%edx
  8024a2:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8024a9:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8024ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ae:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8024b5:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8024bc:	00 
	va_start(vl, arg0);
  8024bd:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8024c0:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8024c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c7:	eb 0b                	jmp    8024d4 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8024c9:	83 c0 01             	add    $0x1,%eax
  8024cc:	8b 39                	mov    (%ecx),%edi
  8024ce:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8024d1:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8024d4:	39 d0                	cmp    %edx,%eax
  8024d6:	75 f1                	jne    8024c9 <spawnl+0x6c>
	return spawn(prog, argv);
  8024d8:	83 ec 08             	sub    $0x8,%esp
  8024db:	56                   	push   %esi
  8024dc:	ff 75 08             	pushl  0x8(%ebp)
  8024df:	e8 ec f9 ff ff       	call   801ed0 <spawn>
}
  8024e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5e                   	pop    %esi
  8024e9:	5f                   	pop    %edi
  8024ea:	5d                   	pop    %ebp
  8024eb:	c3                   	ret    

008024ec <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8024f2:	68 26 3a 80 00       	push   $0x803a26
  8024f7:	ff 75 0c             	pushl  0xc(%ebp)
  8024fa:	e8 f7 e5 ff ff       	call   800af6 <strcpy>
	return 0;
}
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <devsock_close>:
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	53                   	push   %ebx
  80250a:	83 ec 10             	sub    $0x10,%esp
  80250d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802510:	53                   	push   %ebx
  802511:	e8 e0 0a 00 00       	call   802ff6 <pageref>
  802516:	83 c4 10             	add    $0x10,%esp
		return 0;
  802519:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80251e:	83 f8 01             	cmp    $0x1,%eax
  802521:	74 07                	je     80252a <devsock_close+0x24>
}
  802523:	89 d0                	mov    %edx,%eax
  802525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802528:	c9                   	leave  
  802529:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80252a:	83 ec 0c             	sub    $0xc,%esp
  80252d:	ff 73 0c             	pushl  0xc(%ebx)
  802530:	e8 b9 02 00 00       	call   8027ee <nsipc_close>
  802535:	89 c2                	mov    %eax,%edx
  802537:	83 c4 10             	add    $0x10,%esp
  80253a:	eb e7                	jmp    802523 <devsock_close+0x1d>

0080253c <devsock_write>:
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802542:	6a 00                	push   $0x0
  802544:	ff 75 10             	pushl  0x10(%ebp)
  802547:	ff 75 0c             	pushl  0xc(%ebp)
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	ff 70 0c             	pushl  0xc(%eax)
  802550:	e8 76 03 00 00       	call   8028cb <nsipc_send>
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <devsock_read>:
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80255d:	6a 00                	push   $0x0
  80255f:	ff 75 10             	pushl  0x10(%ebp)
  802562:	ff 75 0c             	pushl  0xc(%ebp)
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	ff 70 0c             	pushl  0xc(%eax)
  80256b:	e8 ef 02 00 00       	call   80285f <nsipc_recv>
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <fd2sockid>:
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802578:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80257b:	52                   	push   %edx
  80257c:	50                   	push   %eax
  80257d:	e8 9b f1 ff ff       	call   80171d <fd_lookup>
  802582:	83 c4 10             	add    $0x10,%esp
  802585:	85 c0                	test   %eax,%eax
  802587:	78 10                	js     802599 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  802592:	39 08                	cmp    %ecx,(%eax)
  802594:	75 05                	jne    80259b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802596:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    
		return -E_NOT_SUPP;
  80259b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025a0:	eb f7                	jmp    802599 <fd2sockid+0x27>

008025a2 <alloc_sockfd>:
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
  8025a5:	56                   	push   %esi
  8025a6:	53                   	push   %ebx
  8025a7:	83 ec 1c             	sub    $0x1c,%esp
  8025aa:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8025ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025af:	50                   	push   %eax
  8025b0:	e8 16 f1 ff ff       	call   8016cb <fd_alloc>
  8025b5:	89 c3                	mov    %eax,%ebx
  8025b7:	83 c4 10             	add    $0x10,%esp
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	78 43                	js     802601 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8025be:	83 ec 04             	sub    $0x4,%esp
  8025c1:	68 07 04 00 00       	push   $0x407
  8025c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c9:	6a 00                	push   $0x0
  8025cb:	e8 18 e9 ff ff       	call   800ee8 <sys_page_alloc>
  8025d0:	89 c3                	mov    %eax,%ebx
  8025d2:	83 c4 10             	add    $0x10,%esp
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	78 28                	js     802601 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8025e2:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8025ee:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8025f1:	83 ec 0c             	sub    $0xc,%esp
  8025f4:	50                   	push   %eax
  8025f5:	e8 aa f0 ff ff       	call   8016a4 <fd2num>
  8025fa:	89 c3                	mov    %eax,%ebx
  8025fc:	83 c4 10             	add    $0x10,%esp
  8025ff:	eb 0c                	jmp    80260d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802601:	83 ec 0c             	sub    $0xc,%esp
  802604:	56                   	push   %esi
  802605:	e8 e4 01 00 00       	call   8027ee <nsipc_close>
		return r;
  80260a:	83 c4 10             	add    $0x10,%esp
}
  80260d:	89 d8                	mov    %ebx,%eax
  80260f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802612:	5b                   	pop    %ebx
  802613:	5e                   	pop    %esi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    

00802616 <accept>:
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	e8 4e ff ff ff       	call   802572 <fd2sockid>
  802624:	85 c0                	test   %eax,%eax
  802626:	78 1b                	js     802643 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802628:	83 ec 04             	sub    $0x4,%esp
  80262b:	ff 75 10             	pushl  0x10(%ebp)
  80262e:	ff 75 0c             	pushl  0xc(%ebp)
  802631:	50                   	push   %eax
  802632:	e8 0e 01 00 00       	call   802745 <nsipc_accept>
  802637:	83 c4 10             	add    $0x10,%esp
  80263a:	85 c0                	test   %eax,%eax
  80263c:	78 05                	js     802643 <accept+0x2d>
	return alloc_sockfd(r);
  80263e:	e8 5f ff ff ff       	call   8025a2 <alloc_sockfd>
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <bind>:
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	e8 1f ff ff ff       	call   802572 <fd2sockid>
  802653:	85 c0                	test   %eax,%eax
  802655:	78 12                	js     802669 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802657:	83 ec 04             	sub    $0x4,%esp
  80265a:	ff 75 10             	pushl  0x10(%ebp)
  80265d:	ff 75 0c             	pushl  0xc(%ebp)
  802660:	50                   	push   %eax
  802661:	e8 31 01 00 00       	call   802797 <nsipc_bind>
  802666:	83 c4 10             	add    $0x10,%esp
}
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <shutdown>:
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	e8 f9 fe ff ff       	call   802572 <fd2sockid>
  802679:	85 c0                	test   %eax,%eax
  80267b:	78 0f                	js     80268c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80267d:	83 ec 08             	sub    $0x8,%esp
  802680:	ff 75 0c             	pushl  0xc(%ebp)
  802683:	50                   	push   %eax
  802684:	e8 43 01 00 00       	call   8027cc <nsipc_shutdown>
  802689:	83 c4 10             	add    $0x10,%esp
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <connect>:
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	e8 d6 fe ff ff       	call   802572 <fd2sockid>
  80269c:	85 c0                	test   %eax,%eax
  80269e:	78 12                	js     8026b2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8026a0:	83 ec 04             	sub    $0x4,%esp
  8026a3:	ff 75 10             	pushl  0x10(%ebp)
  8026a6:	ff 75 0c             	pushl  0xc(%ebp)
  8026a9:	50                   	push   %eax
  8026aa:	e8 59 01 00 00       	call   802808 <nsipc_connect>
  8026af:	83 c4 10             	add    $0x10,%esp
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <listen>:
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	e8 b0 fe ff ff       	call   802572 <fd2sockid>
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	78 0f                	js     8026d5 <listen+0x21>
	return nsipc_listen(r, backlog);
  8026c6:	83 ec 08             	sub    $0x8,%esp
  8026c9:	ff 75 0c             	pushl  0xc(%ebp)
  8026cc:	50                   	push   %eax
  8026cd:	e8 6b 01 00 00       	call   80283d <nsipc_listen>
  8026d2:	83 c4 10             	add    $0x10,%esp
}
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <socket>:

int
socket(int domain, int type, int protocol)
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
  8026da:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8026dd:	ff 75 10             	pushl  0x10(%ebp)
  8026e0:	ff 75 0c             	pushl  0xc(%ebp)
  8026e3:	ff 75 08             	pushl  0x8(%ebp)
  8026e6:	e8 3e 02 00 00       	call   802929 <nsipc_socket>
  8026eb:	83 c4 10             	add    $0x10,%esp
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	78 05                	js     8026f7 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8026f2:	e8 ab fe ff ff       	call   8025a2 <alloc_sockfd>
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	53                   	push   %ebx
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802702:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802709:	74 26                	je     802731 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80270b:	6a 07                	push   $0x7
  80270d:	68 00 70 80 00       	push   $0x807000
  802712:	53                   	push   %ebx
  802713:	ff 35 04 50 80 00    	pushl  0x805004
  802719:	e8 45 08 00 00       	call   802f63 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80271e:	83 c4 0c             	add    $0xc,%esp
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	e8 ce 07 00 00       	call   802efa <ipc_recv>
}
  80272c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80272f:	c9                   	leave  
  802730:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802731:	83 ec 0c             	sub    $0xc,%esp
  802734:	6a 02                	push   $0x2
  802736:	e8 80 08 00 00       	call   802fbb <ipc_find_env>
  80273b:	a3 04 50 80 00       	mov    %eax,0x805004
  802740:	83 c4 10             	add    $0x10,%esp
  802743:	eb c6                	jmp    80270b <nsipc+0x12>

00802745 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	56                   	push   %esi
  802749:	53                   	push   %ebx
  80274a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802755:	8b 06                	mov    (%esi),%eax
  802757:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80275c:	b8 01 00 00 00       	mov    $0x1,%eax
  802761:	e8 93 ff ff ff       	call   8026f9 <nsipc>
  802766:	89 c3                	mov    %eax,%ebx
  802768:	85 c0                	test   %eax,%eax
  80276a:	79 09                	jns    802775 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80276c:	89 d8                	mov    %ebx,%eax
  80276e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802771:	5b                   	pop    %ebx
  802772:	5e                   	pop    %esi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802775:	83 ec 04             	sub    $0x4,%esp
  802778:	ff 35 10 70 80 00    	pushl  0x807010
  80277e:	68 00 70 80 00       	push   $0x807000
  802783:	ff 75 0c             	pushl  0xc(%ebp)
  802786:	e8 f9 e4 ff ff       	call   800c84 <memmove>
		*addrlen = ret->ret_addrlen;
  80278b:	a1 10 70 80 00       	mov    0x807010,%eax
  802790:	89 06                	mov    %eax,(%esi)
  802792:	83 c4 10             	add    $0x10,%esp
	return r;
  802795:	eb d5                	jmp    80276c <nsipc_accept+0x27>

00802797 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
  80279a:	53                   	push   %ebx
  80279b:	83 ec 08             	sub    $0x8,%esp
  80279e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8027a9:	53                   	push   %ebx
  8027aa:	ff 75 0c             	pushl  0xc(%ebp)
  8027ad:	68 04 70 80 00       	push   $0x807004
  8027b2:	e8 cd e4 ff ff       	call   800c84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8027b7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8027bd:	b8 02 00 00 00       	mov    $0x2,%eax
  8027c2:	e8 32 ff ff ff       	call   8026f9 <nsipc>
}
  8027c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
  8027cf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8027da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027dd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8027e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8027e7:	e8 0d ff ff ff       	call   8026f9 <nsipc>
}
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <nsipc_close>:

int
nsipc_close(int s)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8027fc:	b8 04 00 00 00       	mov    $0x4,%eax
  802801:	e8 f3 fe ff ff       	call   8026f9 <nsipc>
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
  80280b:	53                   	push   %ebx
  80280c:	83 ec 08             	sub    $0x8,%esp
  80280f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80281a:	53                   	push   %ebx
  80281b:	ff 75 0c             	pushl  0xc(%ebp)
  80281e:	68 04 70 80 00       	push   $0x807004
  802823:	e8 5c e4 ff ff       	call   800c84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802828:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80282e:	b8 05 00 00 00       	mov    $0x5,%eax
  802833:	e8 c1 fe ff ff       	call   8026f9 <nsipc>
}
  802838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
  802840:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80284b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802853:	b8 06 00 00 00       	mov    $0x6,%eax
  802858:	e8 9c fe ff ff       	call   8026f9 <nsipc>
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	56                   	push   %esi
  802863:	53                   	push   %ebx
  802864:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80286f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802875:	8b 45 14             	mov    0x14(%ebp),%eax
  802878:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80287d:	b8 07 00 00 00       	mov    $0x7,%eax
  802882:	e8 72 fe ff ff       	call   8026f9 <nsipc>
  802887:	89 c3                	mov    %eax,%ebx
  802889:	85 c0                	test   %eax,%eax
  80288b:	78 1f                	js     8028ac <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80288d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802892:	7f 21                	jg     8028b5 <nsipc_recv+0x56>
  802894:	39 c6                	cmp    %eax,%esi
  802896:	7c 1d                	jl     8028b5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802898:	83 ec 04             	sub    $0x4,%esp
  80289b:	50                   	push   %eax
  80289c:	68 00 70 80 00       	push   $0x807000
  8028a1:	ff 75 0c             	pushl  0xc(%ebp)
  8028a4:	e8 db e3 ff ff       	call   800c84 <memmove>
  8028a9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8028ac:	89 d8                	mov    %ebx,%eax
  8028ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028b1:	5b                   	pop    %ebx
  8028b2:	5e                   	pop    %esi
  8028b3:	5d                   	pop    %ebp
  8028b4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8028b5:	68 32 3a 80 00       	push   $0x803a32
  8028ba:	68 1b 39 80 00       	push   $0x80391b
  8028bf:	6a 62                	push   $0x62
  8028c1:	68 47 3a 80 00       	push   $0x803a47
  8028c6:	e8 d6 d9 ff ff       	call   8002a1 <_panic>

008028cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	53                   	push   %ebx
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8028dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8028e3:	7f 2e                	jg     802913 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8028e5:	83 ec 04             	sub    $0x4,%esp
  8028e8:	53                   	push   %ebx
  8028e9:	ff 75 0c             	pushl  0xc(%ebp)
  8028ec:	68 0c 70 80 00       	push   $0x80700c
  8028f1:	e8 8e e3 ff ff       	call   800c84 <memmove>
	nsipcbuf.send.req_size = size;
  8028f6:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8028fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8028ff:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802904:	b8 08 00 00 00       	mov    $0x8,%eax
  802909:	e8 eb fd ff ff       	call   8026f9 <nsipc>
}
  80290e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802911:	c9                   	leave  
  802912:	c3                   	ret    
	assert(size < 1600);
  802913:	68 53 3a 80 00       	push   $0x803a53
  802918:	68 1b 39 80 00       	push   $0x80391b
  80291d:	6a 6d                	push   $0x6d
  80291f:	68 47 3a 80 00       	push   $0x803a47
  802924:	e8 78 d9 ff ff       	call   8002a1 <_panic>

00802929 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
  80292c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80293a:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80293f:	8b 45 10             	mov    0x10(%ebp),%eax
  802942:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802947:	b8 09 00 00 00       	mov    $0x9,%eax
  80294c:	e8 a8 fd ff ff       	call   8026f9 <nsipc>
}
  802951:	c9                   	leave  
  802952:	c3                   	ret    

00802953 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
  802956:	56                   	push   %esi
  802957:	53                   	push   %ebx
  802958:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80295b:	83 ec 0c             	sub    $0xc,%esp
  80295e:	ff 75 08             	pushl  0x8(%ebp)
  802961:	e8 4e ed ff ff       	call   8016b4 <fd2data>
  802966:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802968:	83 c4 08             	add    $0x8,%esp
  80296b:	68 5f 3a 80 00       	push   $0x803a5f
  802970:	53                   	push   %ebx
  802971:	e8 80 e1 ff ff       	call   800af6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802976:	8b 46 04             	mov    0x4(%esi),%eax
  802979:	2b 06                	sub    (%esi),%eax
  80297b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802981:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802988:	00 00 00 
	stat->st_dev = &devpipe;
  80298b:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802992:	40 80 00 
	return 0;
}
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
  80299a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80299d:	5b                   	pop    %ebx
  80299e:	5e                   	pop    %esi
  80299f:	5d                   	pop    %ebp
  8029a0:	c3                   	ret    

008029a1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8029a1:	55                   	push   %ebp
  8029a2:	89 e5                	mov    %esp,%ebp
  8029a4:	53                   	push   %ebx
  8029a5:	83 ec 0c             	sub    $0xc,%esp
  8029a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8029ab:	53                   	push   %ebx
  8029ac:	6a 00                	push   $0x0
  8029ae:	e8 ba e5 ff ff       	call   800f6d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8029b3:	89 1c 24             	mov    %ebx,(%esp)
  8029b6:	e8 f9 ec ff ff       	call   8016b4 <fd2data>
  8029bb:	83 c4 08             	add    $0x8,%esp
  8029be:	50                   	push   %eax
  8029bf:	6a 00                	push   $0x0
  8029c1:	e8 a7 e5 ff ff       	call   800f6d <sys_page_unmap>
}
  8029c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029c9:	c9                   	leave  
  8029ca:	c3                   	ret    

008029cb <_pipeisclosed>:
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
  8029ce:	57                   	push   %edi
  8029cf:	56                   	push   %esi
  8029d0:	53                   	push   %ebx
  8029d1:	83 ec 1c             	sub    $0x1c,%esp
  8029d4:	89 c7                	mov    %eax,%edi
  8029d6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8029d8:	a1 08 50 80 00       	mov    0x805008,%eax
  8029dd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8029e0:	83 ec 0c             	sub    $0xc,%esp
  8029e3:	57                   	push   %edi
  8029e4:	e8 0d 06 00 00       	call   802ff6 <pageref>
  8029e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8029ec:	89 34 24             	mov    %esi,(%esp)
  8029ef:	e8 02 06 00 00       	call   802ff6 <pageref>
		nn = thisenv->env_runs;
  8029f4:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8029fa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8029fd:	83 c4 10             	add    $0x10,%esp
  802a00:	39 cb                	cmp    %ecx,%ebx
  802a02:	74 1b                	je     802a1f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802a04:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802a07:	75 cf                	jne    8029d8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802a09:	8b 42 58             	mov    0x58(%edx),%eax
  802a0c:	6a 01                	push   $0x1
  802a0e:	50                   	push   %eax
  802a0f:	53                   	push   %ebx
  802a10:	68 66 3a 80 00       	push   $0x803a66
  802a15:	e8 7d d9 ff ff       	call   800397 <cprintf>
  802a1a:	83 c4 10             	add    $0x10,%esp
  802a1d:	eb b9                	jmp    8029d8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802a1f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802a22:	0f 94 c0             	sete   %al
  802a25:	0f b6 c0             	movzbl %al,%eax
}
  802a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a2b:	5b                   	pop    %ebx
  802a2c:	5e                   	pop    %esi
  802a2d:	5f                   	pop    %edi
  802a2e:	5d                   	pop    %ebp
  802a2f:	c3                   	ret    

00802a30 <devpipe_write>:
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
  802a33:	57                   	push   %edi
  802a34:	56                   	push   %esi
  802a35:	53                   	push   %ebx
  802a36:	83 ec 28             	sub    $0x28,%esp
  802a39:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802a3c:	56                   	push   %esi
  802a3d:	e8 72 ec ff ff       	call   8016b4 <fd2data>
  802a42:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a44:	83 c4 10             	add    $0x10,%esp
  802a47:	bf 00 00 00 00       	mov    $0x0,%edi
  802a4c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a4f:	74 4f                	je     802aa0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a51:	8b 43 04             	mov    0x4(%ebx),%eax
  802a54:	8b 0b                	mov    (%ebx),%ecx
  802a56:	8d 51 20             	lea    0x20(%ecx),%edx
  802a59:	39 d0                	cmp    %edx,%eax
  802a5b:	72 14                	jb     802a71 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802a5d:	89 da                	mov    %ebx,%edx
  802a5f:	89 f0                	mov    %esi,%eax
  802a61:	e8 65 ff ff ff       	call   8029cb <_pipeisclosed>
  802a66:	85 c0                	test   %eax,%eax
  802a68:	75 3b                	jne    802aa5 <devpipe_write+0x75>
			sys_yield();
  802a6a:	e8 5a e4 ff ff       	call   800ec9 <sys_yield>
  802a6f:	eb e0                	jmp    802a51 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a74:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802a78:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802a7b:	89 c2                	mov    %eax,%edx
  802a7d:	c1 fa 1f             	sar    $0x1f,%edx
  802a80:	89 d1                	mov    %edx,%ecx
  802a82:	c1 e9 1b             	shr    $0x1b,%ecx
  802a85:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802a88:	83 e2 1f             	and    $0x1f,%edx
  802a8b:	29 ca                	sub    %ecx,%edx
  802a8d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802a91:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a95:	83 c0 01             	add    $0x1,%eax
  802a98:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802a9b:	83 c7 01             	add    $0x1,%edi
  802a9e:	eb ac                	jmp    802a4c <devpipe_write+0x1c>
	return i;
  802aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  802aa3:	eb 05                	jmp    802aaa <devpipe_write+0x7a>
				return 0;
  802aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802aad:	5b                   	pop    %ebx
  802aae:	5e                   	pop    %esi
  802aaf:	5f                   	pop    %edi
  802ab0:	5d                   	pop    %ebp
  802ab1:	c3                   	ret    

00802ab2 <devpipe_read>:
{
  802ab2:	55                   	push   %ebp
  802ab3:	89 e5                	mov    %esp,%ebp
  802ab5:	57                   	push   %edi
  802ab6:	56                   	push   %esi
  802ab7:	53                   	push   %ebx
  802ab8:	83 ec 18             	sub    $0x18,%esp
  802abb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802abe:	57                   	push   %edi
  802abf:	e8 f0 eb ff ff       	call   8016b4 <fd2data>
  802ac4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802ac6:	83 c4 10             	add    $0x10,%esp
  802ac9:	be 00 00 00 00       	mov    $0x0,%esi
  802ace:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ad1:	75 14                	jne    802ae7 <devpipe_read+0x35>
	return i;
  802ad3:	8b 45 10             	mov    0x10(%ebp),%eax
  802ad6:	eb 02                	jmp    802ada <devpipe_read+0x28>
				return i;
  802ad8:	89 f0                	mov    %esi,%eax
}
  802ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802add:	5b                   	pop    %ebx
  802ade:	5e                   	pop    %esi
  802adf:	5f                   	pop    %edi
  802ae0:	5d                   	pop    %ebp
  802ae1:	c3                   	ret    
			sys_yield();
  802ae2:	e8 e2 e3 ff ff       	call   800ec9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802ae7:	8b 03                	mov    (%ebx),%eax
  802ae9:	3b 43 04             	cmp    0x4(%ebx),%eax
  802aec:	75 18                	jne    802b06 <devpipe_read+0x54>
			if (i > 0)
  802aee:	85 f6                	test   %esi,%esi
  802af0:	75 e6                	jne    802ad8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802af2:	89 da                	mov    %ebx,%edx
  802af4:	89 f8                	mov    %edi,%eax
  802af6:	e8 d0 fe ff ff       	call   8029cb <_pipeisclosed>
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 e3                	je     802ae2 <devpipe_read+0x30>
				return 0;
  802aff:	b8 00 00 00 00       	mov    $0x0,%eax
  802b04:	eb d4                	jmp    802ada <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b06:	99                   	cltd   
  802b07:	c1 ea 1b             	shr    $0x1b,%edx
  802b0a:	01 d0                	add    %edx,%eax
  802b0c:	83 e0 1f             	and    $0x1f,%eax
  802b0f:	29 d0                	sub    %edx,%eax
  802b11:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802b16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b19:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802b1c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802b1f:	83 c6 01             	add    $0x1,%esi
  802b22:	eb aa                	jmp    802ace <devpipe_read+0x1c>

00802b24 <pipe>:
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
  802b27:	56                   	push   %esi
  802b28:	53                   	push   %ebx
  802b29:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802b2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b2f:	50                   	push   %eax
  802b30:	e8 96 eb ff ff       	call   8016cb <fd_alloc>
  802b35:	89 c3                	mov    %eax,%ebx
  802b37:	83 c4 10             	add    $0x10,%esp
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	0f 88 23 01 00 00    	js     802c65 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	68 07 04 00 00       	push   $0x407
  802b4a:	ff 75 f4             	pushl  -0xc(%ebp)
  802b4d:	6a 00                	push   $0x0
  802b4f:	e8 94 e3 ff ff       	call   800ee8 <sys_page_alloc>
  802b54:	89 c3                	mov    %eax,%ebx
  802b56:	83 c4 10             	add    $0x10,%esp
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	0f 88 04 01 00 00    	js     802c65 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802b61:	83 ec 0c             	sub    $0xc,%esp
  802b64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b67:	50                   	push   %eax
  802b68:	e8 5e eb ff ff       	call   8016cb <fd_alloc>
  802b6d:	89 c3                	mov    %eax,%ebx
  802b6f:	83 c4 10             	add    $0x10,%esp
  802b72:	85 c0                	test   %eax,%eax
  802b74:	0f 88 db 00 00 00    	js     802c55 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b7a:	83 ec 04             	sub    $0x4,%esp
  802b7d:	68 07 04 00 00       	push   $0x407
  802b82:	ff 75 f0             	pushl  -0x10(%ebp)
  802b85:	6a 00                	push   $0x0
  802b87:	e8 5c e3 ff ff       	call   800ee8 <sys_page_alloc>
  802b8c:	89 c3                	mov    %eax,%ebx
  802b8e:	83 c4 10             	add    $0x10,%esp
  802b91:	85 c0                	test   %eax,%eax
  802b93:	0f 88 bc 00 00 00    	js     802c55 <pipe+0x131>
	va = fd2data(fd0);
  802b99:	83 ec 0c             	sub    $0xc,%esp
  802b9c:	ff 75 f4             	pushl  -0xc(%ebp)
  802b9f:	e8 10 eb ff ff       	call   8016b4 <fd2data>
  802ba4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ba6:	83 c4 0c             	add    $0xc,%esp
  802ba9:	68 07 04 00 00       	push   $0x407
  802bae:	50                   	push   %eax
  802baf:	6a 00                	push   $0x0
  802bb1:	e8 32 e3 ff ff       	call   800ee8 <sys_page_alloc>
  802bb6:	89 c3                	mov    %eax,%ebx
  802bb8:	83 c4 10             	add    $0x10,%esp
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	0f 88 82 00 00 00    	js     802c45 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bc3:	83 ec 0c             	sub    $0xc,%esp
  802bc6:	ff 75 f0             	pushl  -0x10(%ebp)
  802bc9:	e8 e6 ea ff ff       	call   8016b4 <fd2data>
  802bce:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802bd5:	50                   	push   %eax
  802bd6:	6a 00                	push   $0x0
  802bd8:	56                   	push   %esi
  802bd9:	6a 00                	push   $0x0
  802bdb:	e8 4b e3 ff ff       	call   800f2b <sys_page_map>
  802be0:	89 c3                	mov    %eax,%ebx
  802be2:	83 c4 20             	add    $0x20,%esp
  802be5:	85 c0                	test   %eax,%eax
  802be7:	78 4e                	js     802c37 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802be9:	a1 44 40 80 00       	mov    0x804044,%eax
  802bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802bf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802bfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c00:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802c0c:	83 ec 0c             	sub    $0xc,%esp
  802c0f:	ff 75 f4             	pushl  -0xc(%ebp)
  802c12:	e8 8d ea ff ff       	call   8016a4 <fd2num>
  802c17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c1a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802c1c:	83 c4 04             	add    $0x4,%esp
  802c1f:	ff 75 f0             	pushl  -0x10(%ebp)
  802c22:	e8 7d ea ff ff       	call   8016a4 <fd2num>
  802c27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c2a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802c2d:	83 c4 10             	add    $0x10,%esp
  802c30:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c35:	eb 2e                	jmp    802c65 <pipe+0x141>
	sys_page_unmap(0, va);
  802c37:	83 ec 08             	sub    $0x8,%esp
  802c3a:	56                   	push   %esi
  802c3b:	6a 00                	push   $0x0
  802c3d:	e8 2b e3 ff ff       	call   800f6d <sys_page_unmap>
  802c42:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802c45:	83 ec 08             	sub    $0x8,%esp
  802c48:	ff 75 f0             	pushl  -0x10(%ebp)
  802c4b:	6a 00                	push   $0x0
  802c4d:	e8 1b e3 ff ff       	call   800f6d <sys_page_unmap>
  802c52:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802c55:	83 ec 08             	sub    $0x8,%esp
  802c58:	ff 75 f4             	pushl  -0xc(%ebp)
  802c5b:	6a 00                	push   $0x0
  802c5d:	e8 0b e3 ff ff       	call   800f6d <sys_page_unmap>
  802c62:	83 c4 10             	add    $0x10,%esp
}
  802c65:	89 d8                	mov    %ebx,%eax
  802c67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c6a:	5b                   	pop    %ebx
  802c6b:	5e                   	pop    %esi
  802c6c:	5d                   	pop    %ebp
  802c6d:	c3                   	ret    

00802c6e <pipeisclosed>:
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
  802c71:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c77:	50                   	push   %eax
  802c78:	ff 75 08             	pushl  0x8(%ebp)
  802c7b:	e8 9d ea ff ff       	call   80171d <fd_lookup>
  802c80:	83 c4 10             	add    $0x10,%esp
  802c83:	85 c0                	test   %eax,%eax
  802c85:	78 18                	js     802c9f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802c87:	83 ec 0c             	sub    $0xc,%esp
  802c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  802c8d:	e8 22 ea ff ff       	call   8016b4 <fd2data>
	return _pipeisclosed(fd, p);
  802c92:	89 c2                	mov    %eax,%edx
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	e8 2f fd ff ff       	call   8029cb <_pipeisclosed>
  802c9c:	83 c4 10             	add    $0x10,%esp
}
  802c9f:	c9                   	leave  
  802ca0:	c3                   	ret    

00802ca1 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
  802ca4:	56                   	push   %esi
  802ca5:	53                   	push   %ebx
  802ca6:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802ca9:	85 f6                	test   %esi,%esi
  802cab:	74 13                	je     802cc0 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802cad:	89 f3                	mov    %esi,%ebx
  802caf:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cb5:	c1 e3 07             	shl    $0x7,%ebx
  802cb8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802cbe:	eb 1b                	jmp    802cdb <wait+0x3a>
	assert(envid != 0);
  802cc0:	68 7e 3a 80 00       	push   $0x803a7e
  802cc5:	68 1b 39 80 00       	push   $0x80391b
  802cca:	6a 09                	push   $0x9
  802ccc:	68 89 3a 80 00       	push   $0x803a89
  802cd1:	e8 cb d5 ff ff       	call   8002a1 <_panic>
		sys_yield();
  802cd6:	e8 ee e1 ff ff       	call   800ec9 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cdb:	8b 43 48             	mov    0x48(%ebx),%eax
  802cde:	39 f0                	cmp    %esi,%eax
  802ce0:	75 07                	jne    802ce9 <wait+0x48>
  802ce2:	8b 43 54             	mov    0x54(%ebx),%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	75 ed                	jne    802cd6 <wait+0x35>
}
  802ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cec:	5b                   	pop    %ebx
  802ced:	5e                   	pop    %esi
  802cee:	5d                   	pop    %ebp
  802cef:	c3                   	ret    

00802cf0 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf5:	c3                   	ret    

00802cf6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802cf6:	55                   	push   %ebp
  802cf7:	89 e5                	mov    %esp,%ebp
  802cf9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802cfc:	68 94 3a 80 00       	push   $0x803a94
  802d01:	ff 75 0c             	pushl  0xc(%ebp)
  802d04:	e8 ed dd ff ff       	call   800af6 <strcpy>
	return 0;
}
  802d09:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0e:	c9                   	leave  
  802d0f:	c3                   	ret    

00802d10 <devcons_write>:
{
  802d10:	55                   	push   %ebp
  802d11:	89 e5                	mov    %esp,%ebp
  802d13:	57                   	push   %edi
  802d14:	56                   	push   %esi
  802d15:	53                   	push   %ebx
  802d16:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802d1c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802d21:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802d27:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d2a:	73 31                	jae    802d5d <devcons_write+0x4d>
		m = n - tot;
  802d2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802d2f:	29 f3                	sub    %esi,%ebx
  802d31:	83 fb 7f             	cmp    $0x7f,%ebx
  802d34:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d39:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802d3c:	83 ec 04             	sub    $0x4,%esp
  802d3f:	53                   	push   %ebx
  802d40:	89 f0                	mov    %esi,%eax
  802d42:	03 45 0c             	add    0xc(%ebp),%eax
  802d45:	50                   	push   %eax
  802d46:	57                   	push   %edi
  802d47:	e8 38 df ff ff       	call   800c84 <memmove>
		sys_cputs(buf, m);
  802d4c:	83 c4 08             	add    $0x8,%esp
  802d4f:	53                   	push   %ebx
  802d50:	57                   	push   %edi
  802d51:	e8 d6 e0 ff ff       	call   800e2c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802d56:	01 de                	add    %ebx,%esi
  802d58:	83 c4 10             	add    $0x10,%esp
  802d5b:	eb ca                	jmp    802d27 <devcons_write+0x17>
}
  802d5d:	89 f0                	mov    %esi,%eax
  802d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d62:	5b                   	pop    %ebx
  802d63:	5e                   	pop    %esi
  802d64:	5f                   	pop    %edi
  802d65:	5d                   	pop    %ebp
  802d66:	c3                   	ret    

00802d67 <devcons_read>:
{
  802d67:	55                   	push   %ebp
  802d68:	89 e5                	mov    %esp,%ebp
  802d6a:	83 ec 08             	sub    $0x8,%esp
  802d6d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802d72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d76:	74 21                	je     802d99 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802d78:	e8 cd e0 ff ff       	call   800e4a <sys_cgetc>
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	75 07                	jne    802d88 <devcons_read+0x21>
		sys_yield();
  802d81:	e8 43 e1 ff ff       	call   800ec9 <sys_yield>
  802d86:	eb f0                	jmp    802d78 <devcons_read+0x11>
	if (c < 0)
  802d88:	78 0f                	js     802d99 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802d8a:	83 f8 04             	cmp    $0x4,%eax
  802d8d:	74 0c                	je     802d9b <devcons_read+0x34>
	*(char*)vbuf = c;
  802d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d92:	88 02                	mov    %al,(%edx)
	return 1;
  802d94:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802d99:	c9                   	leave  
  802d9a:	c3                   	ret    
		return 0;
  802d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802da0:	eb f7                	jmp    802d99 <devcons_read+0x32>

00802da2 <cputchar>:
{
  802da2:	55                   	push   %ebp
  802da3:	89 e5                	mov    %esp,%ebp
  802da5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802dae:	6a 01                	push   $0x1
  802db0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802db3:	50                   	push   %eax
  802db4:	e8 73 e0 ff ff       	call   800e2c <sys_cputs>
}
  802db9:	83 c4 10             	add    $0x10,%esp
  802dbc:	c9                   	leave  
  802dbd:	c3                   	ret    

00802dbe <getchar>:
{
  802dbe:	55                   	push   %ebp
  802dbf:	89 e5                	mov    %esp,%ebp
  802dc1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802dc4:	6a 01                	push   $0x1
  802dc6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802dc9:	50                   	push   %eax
  802dca:	6a 00                	push   $0x0
  802dcc:	e8 bc eb ff ff       	call   80198d <read>
	if (r < 0)
  802dd1:	83 c4 10             	add    $0x10,%esp
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	78 06                	js     802dde <getchar+0x20>
	if (r < 1)
  802dd8:	74 06                	je     802de0 <getchar+0x22>
	return c;
  802dda:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802dde:	c9                   	leave  
  802ddf:	c3                   	ret    
		return -E_EOF;
  802de0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802de5:	eb f7                	jmp    802dde <getchar+0x20>

00802de7 <iscons>:
{
  802de7:	55                   	push   %ebp
  802de8:	89 e5                	mov    %esp,%ebp
  802dea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ded:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802df0:	50                   	push   %eax
  802df1:	ff 75 08             	pushl  0x8(%ebp)
  802df4:	e8 24 e9 ff ff       	call   80171d <fd_lookup>
  802df9:	83 c4 10             	add    $0x10,%esp
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	78 11                	js     802e11 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802e09:	39 10                	cmp    %edx,(%eax)
  802e0b:	0f 94 c0             	sete   %al
  802e0e:	0f b6 c0             	movzbl %al,%eax
}
  802e11:	c9                   	leave  
  802e12:	c3                   	ret    

00802e13 <opencons>:
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
  802e16:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e1c:	50                   	push   %eax
  802e1d:	e8 a9 e8 ff ff       	call   8016cb <fd_alloc>
  802e22:	83 c4 10             	add    $0x10,%esp
  802e25:	85 c0                	test   %eax,%eax
  802e27:	78 3a                	js     802e63 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802e29:	83 ec 04             	sub    $0x4,%esp
  802e2c:	68 07 04 00 00       	push   $0x407
  802e31:	ff 75 f4             	pushl  -0xc(%ebp)
  802e34:	6a 00                	push   $0x0
  802e36:	e8 ad e0 ff ff       	call   800ee8 <sys_page_alloc>
  802e3b:	83 c4 10             	add    $0x10,%esp
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	78 21                	js     802e63 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802e4b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802e57:	83 ec 0c             	sub    $0xc,%esp
  802e5a:	50                   	push   %eax
  802e5b:	e8 44 e8 ff ff       	call   8016a4 <fd2num>
  802e60:	83 c4 10             	add    $0x10,%esp
}
  802e63:	c9                   	leave  
  802e64:	c3                   	ret    

00802e65 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e65:	55                   	push   %ebp
  802e66:	89 e5                	mov    %esp,%ebp
  802e68:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e6b:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802e72:	74 0a                	je     802e7e <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802e7c:	c9                   	leave  
  802e7d:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802e7e:	83 ec 04             	sub    $0x4,%esp
  802e81:	6a 07                	push   $0x7
  802e83:	68 00 f0 bf ee       	push   $0xeebff000
  802e88:	6a 00                	push   $0x0
  802e8a:	e8 59 e0 ff ff       	call   800ee8 <sys_page_alloc>
		if(r < 0)
  802e8f:	83 c4 10             	add    $0x10,%esp
  802e92:	85 c0                	test   %eax,%eax
  802e94:	78 2a                	js     802ec0 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802e96:	83 ec 08             	sub    $0x8,%esp
  802e99:	68 d4 2e 80 00       	push   $0x802ed4
  802e9e:	6a 00                	push   $0x0
  802ea0:	e8 8e e1 ff ff       	call   801033 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802ea5:	83 c4 10             	add    $0x10,%esp
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	79 c8                	jns    802e74 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802eac:	83 ec 04             	sub    $0x4,%esp
  802eaf:	68 d0 3a 80 00       	push   $0x803ad0
  802eb4:	6a 25                	push   $0x25
  802eb6:	68 0c 3b 80 00       	push   $0x803b0c
  802ebb:	e8 e1 d3 ff ff       	call   8002a1 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802ec0:	83 ec 04             	sub    $0x4,%esp
  802ec3:	68 a0 3a 80 00       	push   $0x803aa0
  802ec8:	6a 22                	push   $0x22
  802eca:	68 0c 3b 80 00       	push   $0x803b0c
  802ecf:	e8 cd d3 ff ff       	call   8002a1 <_panic>

00802ed4 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ed4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ed5:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802eda:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802edc:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802edf:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802ee3:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802ee7:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802eea:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802eec:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802ef0:	83 c4 08             	add    $0x8,%esp
	popal
  802ef3:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802ef4:	83 c4 04             	add    $0x4,%esp
	popfl
  802ef7:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ef8:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ef9:	c3                   	ret    

00802efa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
  802efd:	56                   	push   %esi
  802efe:	53                   	push   %ebx
  802eff:	8b 75 08             	mov    0x8(%ebp),%esi
  802f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f05:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802f08:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802f0a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802f0f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802f12:	83 ec 0c             	sub    $0xc,%esp
  802f15:	50                   	push   %eax
  802f16:	e8 7d e1 ff ff       	call   801098 <sys_ipc_recv>
	if(ret < 0){
  802f1b:	83 c4 10             	add    $0x10,%esp
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	78 2b                	js     802f4d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802f22:	85 f6                	test   %esi,%esi
  802f24:	74 0a                	je     802f30 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802f26:	a1 08 50 80 00       	mov    0x805008,%eax
  802f2b:	8b 40 74             	mov    0x74(%eax),%eax
  802f2e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802f30:	85 db                	test   %ebx,%ebx
  802f32:	74 0a                	je     802f3e <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802f34:	a1 08 50 80 00       	mov    0x805008,%eax
  802f39:	8b 40 78             	mov    0x78(%eax),%eax
  802f3c:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802f3e:	a1 08 50 80 00       	mov    0x805008,%eax
  802f43:	8b 40 70             	mov    0x70(%eax),%eax
}
  802f46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f49:	5b                   	pop    %ebx
  802f4a:	5e                   	pop    %esi
  802f4b:	5d                   	pop    %ebp
  802f4c:	c3                   	ret    
		if(from_env_store)
  802f4d:	85 f6                	test   %esi,%esi
  802f4f:	74 06                	je     802f57 <ipc_recv+0x5d>
			*from_env_store = 0;
  802f51:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802f57:	85 db                	test   %ebx,%ebx
  802f59:	74 eb                	je     802f46 <ipc_recv+0x4c>
			*perm_store = 0;
  802f5b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802f61:	eb e3                	jmp    802f46 <ipc_recv+0x4c>

00802f63 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802f63:	55                   	push   %ebp
  802f64:	89 e5                	mov    %esp,%ebp
  802f66:	57                   	push   %edi
  802f67:	56                   	push   %esi
  802f68:	53                   	push   %ebx
  802f69:	83 ec 0c             	sub    $0xc,%esp
  802f6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  802f6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802f75:	85 db                	test   %ebx,%ebx
  802f77:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802f7c:	0f 44 d8             	cmove  %eax,%ebx
  802f7f:	eb 05                	jmp    802f86 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802f81:	e8 43 df ff ff       	call   800ec9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802f86:	ff 75 14             	pushl  0x14(%ebp)
  802f89:	53                   	push   %ebx
  802f8a:	56                   	push   %esi
  802f8b:	57                   	push   %edi
  802f8c:	e8 e4 e0 ff ff       	call   801075 <sys_ipc_try_send>
  802f91:	83 c4 10             	add    $0x10,%esp
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 1b                	je     802fb3 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802f98:	79 e7                	jns    802f81 <ipc_send+0x1e>
  802f9a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802f9d:	74 e2                	je     802f81 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	68 1a 3b 80 00       	push   $0x803b1a
  802fa7:	6a 4a                	push   $0x4a
  802fa9:	68 2f 3b 80 00       	push   $0x803b2f
  802fae:	e8 ee d2 ff ff       	call   8002a1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802fb6:	5b                   	pop    %ebx
  802fb7:	5e                   	pop    %esi
  802fb8:	5f                   	pop    %edi
  802fb9:	5d                   	pop    %ebp
  802fba:	c3                   	ret    

00802fbb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802fbb:	55                   	push   %ebp
  802fbc:	89 e5                	mov    %esp,%ebp
  802fbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802fc6:	89 c2                	mov    %eax,%edx
  802fc8:	c1 e2 07             	shl    $0x7,%edx
  802fcb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802fd1:	8b 52 50             	mov    0x50(%edx),%edx
  802fd4:	39 ca                	cmp    %ecx,%edx
  802fd6:	74 11                	je     802fe9 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802fd8:	83 c0 01             	add    $0x1,%eax
  802fdb:	3d 00 04 00 00       	cmp    $0x400,%eax
  802fe0:	75 e4                	jne    802fc6 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe7:	eb 0b                	jmp    802ff4 <ipc_find_env+0x39>
			return envs[i].env_id;
  802fe9:	c1 e0 07             	shl    $0x7,%eax
  802fec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802ff1:	8b 40 48             	mov    0x48(%eax),%eax
}
  802ff4:	5d                   	pop    %ebp
  802ff5:	c3                   	ret    

00802ff6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ff6:	55                   	push   %ebp
  802ff7:	89 e5                	mov    %esp,%ebp
  802ff9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ffc:	89 d0                	mov    %edx,%eax
  802ffe:	c1 e8 16             	shr    $0x16,%eax
  803001:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803008:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80300d:	f6 c1 01             	test   $0x1,%cl
  803010:	74 1d                	je     80302f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803012:	c1 ea 0c             	shr    $0xc,%edx
  803015:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80301c:	f6 c2 01             	test   $0x1,%dl
  80301f:	74 0e                	je     80302f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803021:	c1 ea 0c             	shr    $0xc,%edx
  803024:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80302b:	ef 
  80302c:	0f b7 c0             	movzwl %ax,%eax
}
  80302f:	5d                   	pop    %ebp
  803030:	c3                   	ret    
  803031:	66 90                	xchg   %ax,%ax
  803033:	66 90                	xchg   %ax,%ax
  803035:	66 90                	xchg   %ax,%ax
  803037:	66 90                	xchg   %ax,%ax
  803039:	66 90                	xchg   %ax,%ax
  80303b:	66 90                	xchg   %ax,%ax
  80303d:	66 90                	xchg   %ax,%ax
  80303f:	90                   	nop

00803040 <__udivdi3>:
  803040:	55                   	push   %ebp
  803041:	57                   	push   %edi
  803042:	56                   	push   %esi
  803043:	53                   	push   %ebx
  803044:	83 ec 1c             	sub    $0x1c,%esp
  803047:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80304b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80304f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803053:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803057:	85 d2                	test   %edx,%edx
  803059:	75 4d                	jne    8030a8 <__udivdi3+0x68>
  80305b:	39 f3                	cmp    %esi,%ebx
  80305d:	76 19                	jbe    803078 <__udivdi3+0x38>
  80305f:	31 ff                	xor    %edi,%edi
  803061:	89 e8                	mov    %ebp,%eax
  803063:	89 f2                	mov    %esi,%edx
  803065:	f7 f3                	div    %ebx
  803067:	89 fa                	mov    %edi,%edx
  803069:	83 c4 1c             	add    $0x1c,%esp
  80306c:	5b                   	pop    %ebx
  80306d:	5e                   	pop    %esi
  80306e:	5f                   	pop    %edi
  80306f:	5d                   	pop    %ebp
  803070:	c3                   	ret    
  803071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803078:	89 d9                	mov    %ebx,%ecx
  80307a:	85 db                	test   %ebx,%ebx
  80307c:	75 0b                	jne    803089 <__udivdi3+0x49>
  80307e:	b8 01 00 00 00       	mov    $0x1,%eax
  803083:	31 d2                	xor    %edx,%edx
  803085:	f7 f3                	div    %ebx
  803087:	89 c1                	mov    %eax,%ecx
  803089:	31 d2                	xor    %edx,%edx
  80308b:	89 f0                	mov    %esi,%eax
  80308d:	f7 f1                	div    %ecx
  80308f:	89 c6                	mov    %eax,%esi
  803091:	89 e8                	mov    %ebp,%eax
  803093:	89 f7                	mov    %esi,%edi
  803095:	f7 f1                	div    %ecx
  803097:	89 fa                	mov    %edi,%edx
  803099:	83 c4 1c             	add    $0x1c,%esp
  80309c:	5b                   	pop    %ebx
  80309d:	5e                   	pop    %esi
  80309e:	5f                   	pop    %edi
  80309f:	5d                   	pop    %ebp
  8030a0:	c3                   	ret    
  8030a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030a8:	39 f2                	cmp    %esi,%edx
  8030aa:	77 1c                	ja     8030c8 <__udivdi3+0x88>
  8030ac:	0f bd fa             	bsr    %edx,%edi
  8030af:	83 f7 1f             	xor    $0x1f,%edi
  8030b2:	75 2c                	jne    8030e0 <__udivdi3+0xa0>
  8030b4:	39 f2                	cmp    %esi,%edx
  8030b6:	72 06                	jb     8030be <__udivdi3+0x7e>
  8030b8:	31 c0                	xor    %eax,%eax
  8030ba:	39 eb                	cmp    %ebp,%ebx
  8030bc:	77 a9                	ja     803067 <__udivdi3+0x27>
  8030be:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c3:	eb a2                	jmp    803067 <__udivdi3+0x27>
  8030c5:	8d 76 00             	lea    0x0(%esi),%esi
  8030c8:	31 ff                	xor    %edi,%edi
  8030ca:	31 c0                	xor    %eax,%eax
  8030cc:	89 fa                	mov    %edi,%edx
  8030ce:	83 c4 1c             	add    $0x1c,%esp
  8030d1:	5b                   	pop    %ebx
  8030d2:	5e                   	pop    %esi
  8030d3:	5f                   	pop    %edi
  8030d4:	5d                   	pop    %ebp
  8030d5:	c3                   	ret    
  8030d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030dd:	8d 76 00             	lea    0x0(%esi),%esi
  8030e0:	89 f9                	mov    %edi,%ecx
  8030e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8030e7:	29 f8                	sub    %edi,%eax
  8030e9:	d3 e2                	shl    %cl,%edx
  8030eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8030ef:	89 c1                	mov    %eax,%ecx
  8030f1:	89 da                	mov    %ebx,%edx
  8030f3:	d3 ea                	shr    %cl,%edx
  8030f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8030f9:	09 d1                	or     %edx,%ecx
  8030fb:	89 f2                	mov    %esi,%edx
  8030fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803101:	89 f9                	mov    %edi,%ecx
  803103:	d3 e3                	shl    %cl,%ebx
  803105:	89 c1                	mov    %eax,%ecx
  803107:	d3 ea                	shr    %cl,%edx
  803109:	89 f9                	mov    %edi,%ecx
  80310b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80310f:	89 eb                	mov    %ebp,%ebx
  803111:	d3 e6                	shl    %cl,%esi
  803113:	89 c1                	mov    %eax,%ecx
  803115:	d3 eb                	shr    %cl,%ebx
  803117:	09 de                	or     %ebx,%esi
  803119:	89 f0                	mov    %esi,%eax
  80311b:	f7 74 24 08          	divl   0x8(%esp)
  80311f:	89 d6                	mov    %edx,%esi
  803121:	89 c3                	mov    %eax,%ebx
  803123:	f7 64 24 0c          	mull   0xc(%esp)
  803127:	39 d6                	cmp    %edx,%esi
  803129:	72 15                	jb     803140 <__udivdi3+0x100>
  80312b:	89 f9                	mov    %edi,%ecx
  80312d:	d3 e5                	shl    %cl,%ebp
  80312f:	39 c5                	cmp    %eax,%ebp
  803131:	73 04                	jae    803137 <__udivdi3+0xf7>
  803133:	39 d6                	cmp    %edx,%esi
  803135:	74 09                	je     803140 <__udivdi3+0x100>
  803137:	89 d8                	mov    %ebx,%eax
  803139:	31 ff                	xor    %edi,%edi
  80313b:	e9 27 ff ff ff       	jmp    803067 <__udivdi3+0x27>
  803140:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803143:	31 ff                	xor    %edi,%edi
  803145:	e9 1d ff ff ff       	jmp    803067 <__udivdi3+0x27>
  80314a:	66 90                	xchg   %ax,%ax
  80314c:	66 90                	xchg   %ax,%ax
  80314e:	66 90                	xchg   %ax,%ax

00803150 <__umoddi3>:
  803150:	55                   	push   %ebp
  803151:	57                   	push   %edi
  803152:	56                   	push   %esi
  803153:	53                   	push   %ebx
  803154:	83 ec 1c             	sub    $0x1c,%esp
  803157:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80315b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80315f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803163:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803167:	89 da                	mov    %ebx,%edx
  803169:	85 c0                	test   %eax,%eax
  80316b:	75 43                	jne    8031b0 <__umoddi3+0x60>
  80316d:	39 df                	cmp    %ebx,%edi
  80316f:	76 17                	jbe    803188 <__umoddi3+0x38>
  803171:	89 f0                	mov    %esi,%eax
  803173:	f7 f7                	div    %edi
  803175:	89 d0                	mov    %edx,%eax
  803177:	31 d2                	xor    %edx,%edx
  803179:	83 c4 1c             	add    $0x1c,%esp
  80317c:	5b                   	pop    %ebx
  80317d:	5e                   	pop    %esi
  80317e:	5f                   	pop    %edi
  80317f:	5d                   	pop    %ebp
  803180:	c3                   	ret    
  803181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803188:	89 fd                	mov    %edi,%ebp
  80318a:	85 ff                	test   %edi,%edi
  80318c:	75 0b                	jne    803199 <__umoddi3+0x49>
  80318e:	b8 01 00 00 00       	mov    $0x1,%eax
  803193:	31 d2                	xor    %edx,%edx
  803195:	f7 f7                	div    %edi
  803197:	89 c5                	mov    %eax,%ebp
  803199:	89 d8                	mov    %ebx,%eax
  80319b:	31 d2                	xor    %edx,%edx
  80319d:	f7 f5                	div    %ebp
  80319f:	89 f0                	mov    %esi,%eax
  8031a1:	f7 f5                	div    %ebp
  8031a3:	89 d0                	mov    %edx,%eax
  8031a5:	eb d0                	jmp    803177 <__umoddi3+0x27>
  8031a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	89 f1                	mov    %esi,%ecx
  8031b2:	39 d8                	cmp    %ebx,%eax
  8031b4:	76 0a                	jbe    8031c0 <__umoddi3+0x70>
  8031b6:	89 f0                	mov    %esi,%eax
  8031b8:	83 c4 1c             	add    $0x1c,%esp
  8031bb:	5b                   	pop    %ebx
  8031bc:	5e                   	pop    %esi
  8031bd:	5f                   	pop    %edi
  8031be:	5d                   	pop    %ebp
  8031bf:	c3                   	ret    
  8031c0:	0f bd e8             	bsr    %eax,%ebp
  8031c3:	83 f5 1f             	xor    $0x1f,%ebp
  8031c6:	75 20                	jne    8031e8 <__umoddi3+0x98>
  8031c8:	39 d8                	cmp    %ebx,%eax
  8031ca:	0f 82 b0 00 00 00    	jb     803280 <__umoddi3+0x130>
  8031d0:	39 f7                	cmp    %esi,%edi
  8031d2:	0f 86 a8 00 00 00    	jbe    803280 <__umoddi3+0x130>
  8031d8:	89 c8                	mov    %ecx,%eax
  8031da:	83 c4 1c             	add    $0x1c,%esp
  8031dd:	5b                   	pop    %ebx
  8031de:	5e                   	pop    %esi
  8031df:	5f                   	pop    %edi
  8031e0:	5d                   	pop    %ebp
  8031e1:	c3                   	ret    
  8031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8031e8:	89 e9                	mov    %ebp,%ecx
  8031ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8031ef:	29 ea                	sub    %ebp,%edx
  8031f1:	d3 e0                	shl    %cl,%eax
  8031f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031f7:	89 d1                	mov    %edx,%ecx
  8031f9:	89 f8                	mov    %edi,%eax
  8031fb:	d3 e8                	shr    %cl,%eax
  8031fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803201:	89 54 24 04          	mov    %edx,0x4(%esp)
  803205:	8b 54 24 04          	mov    0x4(%esp),%edx
  803209:	09 c1                	or     %eax,%ecx
  80320b:	89 d8                	mov    %ebx,%eax
  80320d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803211:	89 e9                	mov    %ebp,%ecx
  803213:	d3 e7                	shl    %cl,%edi
  803215:	89 d1                	mov    %edx,%ecx
  803217:	d3 e8                	shr    %cl,%eax
  803219:	89 e9                	mov    %ebp,%ecx
  80321b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80321f:	d3 e3                	shl    %cl,%ebx
  803221:	89 c7                	mov    %eax,%edi
  803223:	89 d1                	mov    %edx,%ecx
  803225:	89 f0                	mov    %esi,%eax
  803227:	d3 e8                	shr    %cl,%eax
  803229:	89 e9                	mov    %ebp,%ecx
  80322b:	89 fa                	mov    %edi,%edx
  80322d:	d3 e6                	shl    %cl,%esi
  80322f:	09 d8                	or     %ebx,%eax
  803231:	f7 74 24 08          	divl   0x8(%esp)
  803235:	89 d1                	mov    %edx,%ecx
  803237:	89 f3                	mov    %esi,%ebx
  803239:	f7 64 24 0c          	mull   0xc(%esp)
  80323d:	89 c6                	mov    %eax,%esi
  80323f:	89 d7                	mov    %edx,%edi
  803241:	39 d1                	cmp    %edx,%ecx
  803243:	72 06                	jb     80324b <__umoddi3+0xfb>
  803245:	75 10                	jne    803257 <__umoddi3+0x107>
  803247:	39 c3                	cmp    %eax,%ebx
  803249:	73 0c                	jae    803257 <__umoddi3+0x107>
  80324b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80324f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803253:	89 d7                	mov    %edx,%edi
  803255:	89 c6                	mov    %eax,%esi
  803257:	89 ca                	mov    %ecx,%edx
  803259:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80325e:	29 f3                	sub    %esi,%ebx
  803260:	19 fa                	sbb    %edi,%edx
  803262:	89 d0                	mov    %edx,%eax
  803264:	d3 e0                	shl    %cl,%eax
  803266:	89 e9                	mov    %ebp,%ecx
  803268:	d3 eb                	shr    %cl,%ebx
  80326a:	d3 ea                	shr    %cl,%edx
  80326c:	09 d8                	or     %ebx,%eax
  80326e:	83 c4 1c             	add    $0x1c,%esp
  803271:	5b                   	pop    %ebx
  803272:	5e                   	pop    %esi
  803273:	5f                   	pop    %edi
  803274:	5d                   	pop    %ebp
  803275:	c3                   	ret    
  803276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80327d:	8d 76 00             	lea    0x0(%esi),%esi
  803280:	89 da                	mov    %ebx,%edx
  803282:	29 fe                	sub    %edi,%esi
  803284:	19 c2                	sbb    %eax,%edx
  803286:	89 f1                	mov    %esi,%ecx
  803288:	89 c8                	mov    %ecx,%eax
  80328a:	e9 4b ff ff ff       	jmp    8031da <__umoddi3+0x8a>
