
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
  800083:	e8 aa 13 00 00       	call   801432 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 20 2c 00 00       	call   802cc1 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 ed 0a 00 00       	call   800ba1 <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 c0 32 80 00       	mov    $0x8032c0,%eax
  8000be:	ba c6 32 80 00       	mov    $0x8032c6,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 fc 32 80 00       	push   $0x8032fc
  8000cc:	e8 c6 02 00 00       	call   800397 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 17 33 80 00       	push   $0x803317
  8000d8:	68 1c 33 80 00       	push   $0x80331c
  8000dd:	68 1b 33 80 00       	push   $0x80331b
  8000e2:	e8 96 23 00 00       	call   80247d <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 c6 2b 00 00       	call   802cc1 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 93 0a 00 00       	call   800ba1 <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 c0 32 80 00       	mov    $0x8032c0,%eax
  800118:	ba c6 32 80 00       	mov    $0x8032c6,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 33 33 80 00       	push   $0x803333
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
  80013f:	68 cc 32 80 00       	push   $0x8032cc
  800144:	6a 13                	push   $0x13
  800146:	68 df 32 80 00       	push   $0x8032df
  80014b:	e8 51 01 00 00       	call   8002a1 <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 f3 32 80 00       	push   $0x8032f3
  800156:	6a 17                	push   $0x17
  800158:	68 df 32 80 00       	push   $0x8032df
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
  800183:	68 29 33 80 00       	push   $0x803329
  800188:	6a 21                	push   $0x21
  80018a:	68 df 32 80 00       	push   $0x8032df
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
  800217:	68 6d 33 80 00       	push   $0x80336d
  80021c:	e8 76 01 00 00       	call   800397 <cprintf>
	cprintf("before umain\n");
  800221:	c7 04 24 8b 33 80 00 	movl   $0x80338b,(%esp)
  800228:	e8 6a 01 00 00       	call   800397 <cprintf>
	// call user main routine
	umain(argc, argv);
  80022d:	83 c4 08             	add    $0x8,%esp
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	e8 18 fe ff ff       	call   800053 <umain>
	cprintf("after umain\n");
  80023b:	c7 04 24 99 33 80 00 	movl   $0x803399,(%esp)
  800242:	e8 50 01 00 00       	call   800397 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800247:	a1 08 50 80 00       	mov    0x805008,%eax
  80024c:	8b 40 48             	mov    0x48(%eax),%eax
  80024f:	83 c4 08             	add    $0x8,%esp
  800252:	50                   	push   %eax
  800253:	68 a6 33 80 00       	push   $0x8033a6
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
  80027b:	68 d0 33 80 00       	push   $0x8033d0
  800280:	50                   	push   %eax
  800281:	68 c5 33 80 00       	push   $0x8033c5
  800286:	e8 0c 01 00 00       	call   800397 <cprintf>
	close_all();
  80028b:	e8 0c 16 00 00       	call   80189c <close_all>
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
  8002b1:	68 fc 33 80 00       	push   $0x8033fc
  8002b6:	50                   	push   %eax
  8002b7:	68 c5 33 80 00       	push   $0x8033c5
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
  8002da:	68 d8 33 80 00       	push   $0x8033d8
  8002df:	e8 b3 00 00 00       	call   800397 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e4:	83 c4 18             	add    $0x18,%esp
  8002e7:	53                   	push   %ebx
  8002e8:	ff 75 10             	pushl  0x10(%ebp)
  8002eb:	e8 56 00 00 00       	call   800346 <vcprintf>
	cprintf("\n");
  8002f0:	c7 04 24 89 33 80 00 	movl   $0x803389,(%esp)
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
  800444:	e8 17 2c 00 00       	call   803060 <__udivdi3>
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
  80046d:	e8 fe 2c 00 00       	call   803170 <__umoddi3>
  800472:	83 c4 14             	add    $0x14,%esp
  800475:	0f be 80 03 34 80 00 	movsbl 0x803403(%eax),%eax
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
  80051e:	ff 24 85 e0 35 80 00 	jmp    *0x8035e0(,%eax,4)
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
  8005e9:	8b 14 85 40 37 80 00 	mov    0x803740(,%eax,4),%edx
  8005f0:	85 d2                	test   %edx,%edx
  8005f2:	74 18                	je     80060c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005f4:	52                   	push   %edx
  8005f5:	68 4d 39 80 00       	push   $0x80394d
  8005fa:	53                   	push   %ebx
  8005fb:	56                   	push   %esi
  8005fc:	e8 a6 fe ff ff       	call   8004a7 <printfmt>
  800601:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800604:	89 7d 14             	mov    %edi,0x14(%ebp)
  800607:	e9 fe 02 00 00       	jmp    80090a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80060c:	50                   	push   %eax
  80060d:	68 1b 34 80 00       	push   $0x80341b
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
  800634:	b8 14 34 80 00       	mov    $0x803414,%eax
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
  8009cc:	bf 39 35 80 00       	mov    $0x803539,%edi
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
  8009f8:	bf 71 35 80 00       	mov    $0x803571,%edi
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
  800e99:	68 88 37 80 00       	push   $0x803788
  800e9e:	6a 43                	push   $0x43
  800ea0:	68 a5 37 80 00       	push   $0x8037a5
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
  800f1a:	68 88 37 80 00       	push   $0x803788
  800f1f:	6a 43                	push   $0x43
  800f21:	68 a5 37 80 00       	push   $0x8037a5
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
  800f5c:	68 88 37 80 00       	push   $0x803788
  800f61:	6a 43                	push   $0x43
  800f63:	68 a5 37 80 00       	push   $0x8037a5
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
  800f9e:	68 88 37 80 00       	push   $0x803788
  800fa3:	6a 43                	push   $0x43
  800fa5:	68 a5 37 80 00       	push   $0x8037a5
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
  800fe0:	68 88 37 80 00       	push   $0x803788
  800fe5:	6a 43                	push   $0x43
  800fe7:	68 a5 37 80 00       	push   $0x8037a5
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
  801022:	68 88 37 80 00       	push   $0x803788
  801027:	6a 43                	push   $0x43
  801029:	68 a5 37 80 00       	push   $0x8037a5
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
  801064:	68 88 37 80 00       	push   $0x803788
  801069:	6a 43                	push   $0x43
  80106b:	68 a5 37 80 00       	push   $0x8037a5
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
  8010c8:	68 88 37 80 00       	push   $0x803788
  8010cd:	6a 43                	push   $0x43
  8010cf:	68 a5 37 80 00       	push   $0x8037a5
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
  8011ac:	68 88 37 80 00       	push   $0x803788
  8011b1:	6a 43                	push   $0x43
  8011b3:	68 a5 37 80 00       	push   $0x8037a5
  8011b8:	e8 e4 f0 ff ff       	call   8002a1 <_panic>

008011bd <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	57                   	push   %edi
  8011c1:	56                   	push   %esi
  8011c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cb:	b8 14 00 00 00       	mov    $0x14,%eax
  8011d0:	89 cb                	mov    %ecx,%ebx
  8011d2:	89 cf                	mov    %ecx,%edi
  8011d4:	89 ce                	mov    %ecx,%esi
  8011d6:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5f                   	pop    %edi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011e4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011eb:	f6 c5 04             	test   $0x4,%ch
  8011ee:	75 45                	jne    801235 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011f0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011f7:	83 e1 07             	and    $0x7,%ecx
  8011fa:	83 f9 07             	cmp    $0x7,%ecx
  8011fd:	74 6f                	je     80126e <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011ff:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801206:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80120c:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801212:	0f 84 b6 00 00 00    	je     8012ce <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801218:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80121f:	83 e1 05             	and    $0x5,%ecx
  801222:	83 f9 05             	cmp    $0x5,%ecx
  801225:	0f 84 d7 00 00 00    	je     801302 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80122b:	b8 00 00 00 00       	mov    $0x0,%eax
  801230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801233:	c9                   	leave  
  801234:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801235:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80123c:	c1 e2 0c             	shl    $0xc,%edx
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801248:	51                   	push   %ecx
  801249:	52                   	push   %edx
  80124a:	50                   	push   %eax
  80124b:	52                   	push   %edx
  80124c:	6a 00                	push   $0x0
  80124e:	e8 d8 fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  801253:	83 c4 20             	add    $0x20,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	79 d1                	jns    80122b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80125a:	83 ec 04             	sub    $0x4,%esp
  80125d:	68 b3 37 80 00       	push   $0x8037b3
  801262:	6a 54                	push   $0x54
  801264:	68 c9 37 80 00       	push   $0x8037c9
  801269:	e8 33 f0 ff ff       	call   8002a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80126e:	89 d3                	mov    %edx,%ebx
  801270:	c1 e3 0c             	shl    $0xc,%ebx
  801273:	83 ec 0c             	sub    $0xc,%esp
  801276:	68 05 08 00 00       	push   $0x805
  80127b:	53                   	push   %ebx
  80127c:	50                   	push   %eax
  80127d:	53                   	push   %ebx
  80127e:	6a 00                	push   $0x0
  801280:	e8 a6 fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  801285:	83 c4 20             	add    $0x20,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	78 2e                	js     8012ba <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	68 05 08 00 00       	push   $0x805
  801294:	53                   	push   %ebx
  801295:	6a 00                	push   $0x0
  801297:	53                   	push   %ebx
  801298:	6a 00                	push   $0x0
  80129a:	e8 8c fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  80129f:	83 c4 20             	add    $0x20,%esp
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	79 85                	jns    80122b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	68 b3 37 80 00       	push   $0x8037b3
  8012ae:	6a 5f                	push   $0x5f
  8012b0:	68 c9 37 80 00       	push   $0x8037c9
  8012b5:	e8 e7 ef ff ff       	call   8002a1 <_panic>
			panic("sys_page_map() panic\n");
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	68 b3 37 80 00       	push   $0x8037b3
  8012c2:	6a 5b                	push   $0x5b
  8012c4:	68 c9 37 80 00       	push   $0x8037c9
  8012c9:	e8 d3 ef ff ff       	call   8002a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012ce:	c1 e2 0c             	shl    $0xc,%edx
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 05 08 00 00       	push   $0x805
  8012d9:	52                   	push   %edx
  8012da:	50                   	push   %eax
  8012db:	52                   	push   %edx
  8012dc:	6a 00                	push   $0x0
  8012de:	e8 48 fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  8012e3:	83 c4 20             	add    $0x20,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	0f 89 3d ff ff ff    	jns    80122b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 b3 37 80 00       	push   $0x8037b3
  8012f6:	6a 66                	push   $0x66
  8012f8:	68 c9 37 80 00       	push   $0x8037c9
  8012fd:	e8 9f ef ff ff       	call   8002a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801302:	c1 e2 0c             	shl    $0xc,%edx
  801305:	83 ec 0c             	sub    $0xc,%esp
  801308:	6a 05                	push   $0x5
  80130a:	52                   	push   %edx
  80130b:	50                   	push   %eax
  80130c:	52                   	push   %edx
  80130d:	6a 00                	push   $0x0
  80130f:	e8 17 fc ff ff       	call   800f2b <sys_page_map>
		if(r < 0)
  801314:	83 c4 20             	add    $0x20,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	0f 89 0c ff ff ff    	jns    80122b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80131f:	83 ec 04             	sub    $0x4,%esp
  801322:	68 b3 37 80 00       	push   $0x8037b3
  801327:	6a 6d                	push   $0x6d
  801329:	68 c9 37 80 00       	push   $0x8037c9
  80132e:	e8 6e ef ff ff       	call   8002a1 <_panic>

00801333 <pgfault>:
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	53                   	push   %ebx
  801337:	83 ec 04             	sub    $0x4,%esp
  80133a:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80133d:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80133f:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801343:	0f 84 99 00 00 00    	je     8013e2 <pgfault+0xaf>
  801349:	89 c2                	mov    %eax,%edx
  80134b:	c1 ea 16             	shr    $0x16,%edx
  80134e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801355:	f6 c2 01             	test   $0x1,%dl
  801358:	0f 84 84 00 00 00    	je     8013e2 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80135e:	89 c2                	mov    %eax,%edx
  801360:	c1 ea 0c             	shr    $0xc,%edx
  801363:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136a:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801370:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801376:	75 6a                	jne    8013e2 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801378:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137d:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	6a 07                	push   $0x7
  801384:	68 00 f0 7f 00       	push   $0x7ff000
  801389:	6a 00                	push   $0x0
  80138b:	e8 58 fb ff ff       	call   800ee8 <sys_page_alloc>
	if(ret < 0)
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	85 c0                	test   %eax,%eax
  801395:	78 5f                	js     8013f6 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	68 00 10 00 00       	push   $0x1000
  80139f:	53                   	push   %ebx
  8013a0:	68 00 f0 7f 00       	push   $0x7ff000
  8013a5:	e8 3c f9 ff ff       	call   800ce6 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8013aa:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013b1:	53                   	push   %ebx
  8013b2:	6a 00                	push   $0x0
  8013b4:	68 00 f0 7f 00       	push   $0x7ff000
  8013b9:	6a 00                	push   $0x0
  8013bb:	e8 6b fb ff ff       	call   800f2b <sys_page_map>
	if(ret < 0)
  8013c0:	83 c4 20             	add    $0x20,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 43                	js     80140a <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	68 00 f0 7f 00       	push   $0x7ff000
  8013cf:	6a 00                	push   $0x0
  8013d1:	e8 97 fb ff ff       	call   800f6d <sys_page_unmap>
	if(ret < 0)
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 41                	js     80141e <pgfault+0xeb>
}
  8013dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	68 d4 37 80 00       	push   $0x8037d4
  8013ea:	6a 26                	push   $0x26
  8013ec:	68 c9 37 80 00       	push   $0x8037c9
  8013f1:	e8 ab ee ff ff       	call   8002a1 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	68 e8 37 80 00       	push   $0x8037e8
  8013fe:	6a 31                	push   $0x31
  801400:	68 c9 37 80 00       	push   $0x8037c9
  801405:	e8 97 ee ff ff       	call   8002a1 <_panic>
		panic("panic in sys_page_map()\n");
  80140a:	83 ec 04             	sub    $0x4,%esp
  80140d:	68 03 38 80 00       	push   $0x803803
  801412:	6a 36                	push   $0x36
  801414:	68 c9 37 80 00       	push   $0x8037c9
  801419:	e8 83 ee ff ff       	call   8002a1 <_panic>
		panic("panic in sys_page_unmap()\n");
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	68 1c 38 80 00       	push   $0x80381c
  801426:	6a 39                	push   $0x39
  801428:	68 c9 37 80 00       	push   $0x8037c9
  80142d:	e8 6f ee ff ff       	call   8002a1 <_panic>

00801432 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	57                   	push   %edi
  801436:	56                   	push   %esi
  801437:	53                   	push   %ebx
  801438:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80143b:	68 33 13 80 00       	push   $0x801333
  801440:	e8 40 1a 00 00       	call   802e85 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801445:	b8 07 00 00 00       	mov    $0x7,%eax
  80144a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 27                	js     80147a <fork+0x48>
  801453:	89 c6                	mov    %eax,%esi
  801455:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801457:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80145c:	75 48                	jne    8014a6 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80145e:	e8 47 fa ff ff       	call   800eaa <sys_getenvid>
  801463:	25 ff 03 00 00       	and    $0x3ff,%eax
  801468:	c1 e0 07             	shl    $0x7,%eax
  80146b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801470:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801475:	e9 90 00 00 00       	jmp    80150a <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	68 38 38 80 00       	push   $0x803838
  801482:	68 8c 00 00 00       	push   $0x8c
  801487:	68 c9 37 80 00       	push   $0x8037c9
  80148c:	e8 10 ee ff ff       	call   8002a1 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801491:	89 f8                	mov    %edi,%eax
  801493:	e8 45 fd ff ff       	call   8011dd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801498:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80149e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8014a4:	74 26                	je     8014cc <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8014a6:	89 d8                	mov    %ebx,%eax
  8014a8:	c1 e8 16             	shr    $0x16,%eax
  8014ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b2:	a8 01                	test   $0x1,%al
  8014b4:	74 e2                	je     801498 <fork+0x66>
  8014b6:	89 da                	mov    %ebx,%edx
  8014b8:	c1 ea 0c             	shr    $0xc,%edx
  8014bb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014c2:	83 e0 05             	and    $0x5,%eax
  8014c5:	83 f8 05             	cmp    $0x5,%eax
  8014c8:	75 ce                	jne    801498 <fork+0x66>
  8014ca:	eb c5                	jmp    801491 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	6a 07                	push   $0x7
  8014d1:	68 00 f0 bf ee       	push   $0xeebff000
  8014d6:	56                   	push   %esi
  8014d7:	e8 0c fa ff ff       	call   800ee8 <sys_page_alloc>
	if(ret < 0)
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	78 31                	js     801514 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014e3:	83 ec 08             	sub    $0x8,%esp
  8014e6:	68 f4 2e 80 00       	push   $0x802ef4
  8014eb:	56                   	push   %esi
  8014ec:	e8 42 fb ff ff       	call   801033 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014f1:	83 c4 10             	add    $0x10,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	78 33                	js     80152b <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	6a 02                	push   $0x2
  8014fd:	56                   	push   %esi
  8014fe:	e8 ac fa ff ff       	call   800faf <sys_env_set_status>
	if(ret < 0)
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	78 38                	js     801542 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80150a:	89 f0                	mov    %esi,%eax
  80150c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5f                   	pop    %edi
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	68 e8 37 80 00       	push   $0x8037e8
  80151c:	68 98 00 00 00       	push   $0x98
  801521:	68 c9 37 80 00       	push   $0x8037c9
  801526:	e8 76 ed ff ff       	call   8002a1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	68 5c 38 80 00       	push   $0x80385c
  801533:	68 9b 00 00 00       	push   $0x9b
  801538:	68 c9 37 80 00       	push   $0x8037c9
  80153d:	e8 5f ed ff ff       	call   8002a1 <_panic>
		panic("panic in sys_env_set_status()\n");
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	68 84 38 80 00       	push   $0x803884
  80154a:	68 9e 00 00 00       	push   $0x9e
  80154f:	68 c9 37 80 00       	push   $0x8037c9
  801554:	e8 48 ed ff ff       	call   8002a1 <_panic>

00801559 <sfork>:

// Challenge!
int
sfork(void)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	57                   	push   %edi
  80155d:	56                   	push   %esi
  80155e:	53                   	push   %ebx
  80155f:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801562:	68 33 13 80 00       	push   $0x801333
  801567:	e8 19 19 00 00       	call   802e85 <set_pgfault_handler>
  80156c:	b8 07 00 00 00       	mov    $0x7,%eax
  801571:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 27                	js     8015a1 <sfork+0x48>
  80157a:	89 c7                	mov    %eax,%edi
  80157c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80157e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801583:	75 55                	jne    8015da <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801585:	e8 20 f9 ff ff       	call   800eaa <sys_getenvid>
  80158a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80158f:	c1 e0 07             	shl    $0x7,%eax
  801592:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801597:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80159c:	e9 d4 00 00 00       	jmp    801675 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	68 38 38 80 00       	push   $0x803838
  8015a9:	68 af 00 00 00       	push   $0xaf
  8015ae:	68 c9 37 80 00       	push   $0x8037c9
  8015b3:	e8 e9 ec ff ff       	call   8002a1 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8015b8:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015bd:	89 f0                	mov    %esi,%eax
  8015bf:	e8 19 fc ff ff       	call   8011dd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015c4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015ca:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015d0:	77 65                	ja     801637 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015d2:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015d8:	74 de                	je     8015b8 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015da:	89 d8                	mov    %ebx,%eax
  8015dc:	c1 e8 16             	shr    $0x16,%eax
  8015df:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015e6:	a8 01                	test   $0x1,%al
  8015e8:	74 da                	je     8015c4 <sfork+0x6b>
  8015ea:	89 da                	mov    %ebx,%edx
  8015ec:	c1 ea 0c             	shr    $0xc,%edx
  8015ef:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015f6:	83 e0 05             	and    $0x5,%eax
  8015f9:	83 f8 05             	cmp    $0x5,%eax
  8015fc:	75 c6                	jne    8015c4 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015fe:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801605:	c1 e2 0c             	shl    $0xc,%edx
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	83 e0 07             	and    $0x7,%eax
  80160e:	50                   	push   %eax
  80160f:	52                   	push   %edx
  801610:	56                   	push   %esi
  801611:	52                   	push   %edx
  801612:	6a 00                	push   $0x0
  801614:	e8 12 f9 ff ff       	call   800f2b <sys_page_map>
  801619:	83 c4 20             	add    $0x20,%esp
  80161c:	85 c0                	test   %eax,%eax
  80161e:	74 a4                	je     8015c4 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	68 b3 37 80 00       	push   $0x8037b3
  801628:	68 ba 00 00 00       	push   $0xba
  80162d:	68 c9 37 80 00       	push   $0x8037c9
  801632:	e8 6a ec ff ff       	call   8002a1 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	6a 07                	push   $0x7
  80163c:	68 00 f0 bf ee       	push   $0xeebff000
  801641:	57                   	push   %edi
  801642:	e8 a1 f8 ff ff       	call   800ee8 <sys_page_alloc>
	if(ret < 0)
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 31                	js     80167f <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	68 f4 2e 80 00       	push   $0x802ef4
  801656:	57                   	push   %edi
  801657:	e8 d7 f9 ff ff       	call   801033 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	85 c0                	test   %eax,%eax
  801661:	78 33                	js     801696 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	6a 02                	push   $0x2
  801668:	57                   	push   %edi
  801669:	e8 41 f9 ff ff       	call   800faf <sys_env_set_status>
	if(ret < 0)
  80166e:	83 c4 10             	add    $0x10,%esp
  801671:	85 c0                	test   %eax,%eax
  801673:	78 38                	js     8016ad <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801675:	89 f8                	mov    %edi,%eax
  801677:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167a:	5b                   	pop    %ebx
  80167b:	5e                   	pop    %esi
  80167c:	5f                   	pop    %edi
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	68 e8 37 80 00       	push   $0x8037e8
  801687:	68 c0 00 00 00       	push   $0xc0
  80168c:	68 c9 37 80 00       	push   $0x8037c9
  801691:	e8 0b ec ff ff       	call   8002a1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	68 5c 38 80 00       	push   $0x80385c
  80169e:	68 c3 00 00 00       	push   $0xc3
  8016a3:	68 c9 37 80 00       	push   $0x8037c9
  8016a8:	e8 f4 eb ff ff       	call   8002a1 <_panic>
		panic("panic in sys_env_set_status()\n");
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	68 84 38 80 00       	push   $0x803884
  8016b5:	68 c6 00 00 00       	push   $0xc6
  8016ba:	68 c9 37 80 00       	push   $0x8037c9
  8016bf:	e8 dd eb ff ff       	call   8002a1 <_panic>

008016c4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	05 00 00 00 30       	add    $0x30000000,%eax
  8016cf:	c1 e8 0c             	shr    $0xc,%eax
}
  8016d2:	5d                   	pop    %ebp
  8016d3:	c3                   	ret    

008016d4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016e4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016f3:	89 c2                	mov    %eax,%edx
  8016f5:	c1 ea 16             	shr    $0x16,%edx
  8016f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ff:	f6 c2 01             	test   $0x1,%dl
  801702:	74 2d                	je     801731 <fd_alloc+0x46>
  801704:	89 c2                	mov    %eax,%edx
  801706:	c1 ea 0c             	shr    $0xc,%edx
  801709:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801710:	f6 c2 01             	test   $0x1,%dl
  801713:	74 1c                	je     801731 <fd_alloc+0x46>
  801715:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80171a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80171f:	75 d2                	jne    8016f3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80172a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80172f:	eb 0a                	jmp    80173b <fd_alloc+0x50>
			*fd_store = fd;
  801731:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801734:	89 01                	mov    %eax,(%ecx)
			return 0;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    

0080173d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801743:	83 f8 1f             	cmp    $0x1f,%eax
  801746:	77 30                	ja     801778 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801748:	c1 e0 0c             	shl    $0xc,%eax
  80174b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801750:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801756:	f6 c2 01             	test   $0x1,%dl
  801759:	74 24                	je     80177f <fd_lookup+0x42>
  80175b:	89 c2                	mov    %eax,%edx
  80175d:	c1 ea 0c             	shr    $0xc,%edx
  801760:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801767:	f6 c2 01             	test   $0x1,%dl
  80176a:	74 1a                	je     801786 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80176c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176f:	89 02                	mov    %eax,(%edx)
	return 0;
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801776:	5d                   	pop    %ebp
  801777:	c3                   	ret    
		return -E_INVAL;
  801778:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177d:	eb f7                	jmp    801776 <fd_lookup+0x39>
		return -E_INVAL;
  80177f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801784:	eb f0                	jmp    801776 <fd_lookup+0x39>
  801786:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178b:	eb e9                	jmp    801776 <fd_lookup+0x39>

0080178d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801796:	ba 00 00 00 00       	mov    $0x0,%edx
  80179b:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017a0:	39 08                	cmp    %ecx,(%eax)
  8017a2:	74 38                	je     8017dc <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017a4:	83 c2 01             	add    $0x1,%edx
  8017a7:	8b 04 95 20 39 80 00 	mov    0x803920(,%edx,4),%eax
  8017ae:	85 c0                	test   %eax,%eax
  8017b0:	75 ee                	jne    8017a0 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017b2:	a1 08 50 80 00       	mov    0x805008,%eax
  8017b7:	8b 40 48             	mov    0x48(%eax),%eax
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	51                   	push   %ecx
  8017be:	50                   	push   %eax
  8017bf:	68 a4 38 80 00       	push   $0x8038a4
  8017c4:	e8 ce eb ff ff       	call   800397 <cprintf>
	*dev = 0;
  8017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    
			*dev = devtab[i];
  8017dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017df:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	eb f2                	jmp    8017da <dev_lookup+0x4d>

008017e8 <fd_close>:
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	57                   	push   %edi
  8017ec:	56                   	push   %esi
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 24             	sub    $0x24,%esp
  8017f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8017f4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017fa:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801801:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801804:	50                   	push   %eax
  801805:	e8 33 ff ff ff       	call   80173d <fd_lookup>
  80180a:	89 c3                	mov    %eax,%ebx
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 05                	js     801818 <fd_close+0x30>
	    || fd != fd2)
  801813:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801816:	74 16                	je     80182e <fd_close+0x46>
		return (must_exist ? r : 0);
  801818:	89 f8                	mov    %edi,%eax
  80181a:	84 c0                	test   %al,%al
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
  801821:	0f 44 d8             	cmove  %eax,%ebx
}
  801824:	89 d8                	mov    %ebx,%eax
  801826:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801829:	5b                   	pop    %ebx
  80182a:	5e                   	pop    %esi
  80182b:	5f                   	pop    %edi
  80182c:	5d                   	pop    %ebp
  80182d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801834:	50                   	push   %eax
  801835:	ff 36                	pushl  (%esi)
  801837:	e8 51 ff ff ff       	call   80178d <dev_lookup>
  80183c:	89 c3                	mov    %eax,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	78 1a                	js     80185f <fd_close+0x77>
		if (dev->dev_close)
  801845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801848:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80184b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801850:	85 c0                	test   %eax,%eax
  801852:	74 0b                	je     80185f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	56                   	push   %esi
  801858:	ff d0                	call   *%eax
  80185a:	89 c3                	mov    %eax,%ebx
  80185c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	56                   	push   %esi
  801863:	6a 00                	push   $0x0
  801865:	e8 03 f7 ff ff       	call   800f6d <sys_page_unmap>
	return r;
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	eb b5                	jmp    801824 <fd_close+0x3c>

0080186f <close>:

int
close(int fdnum)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801875:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801878:	50                   	push   %eax
  801879:	ff 75 08             	pushl  0x8(%ebp)
  80187c:	e8 bc fe ff ff       	call   80173d <fd_lookup>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	85 c0                	test   %eax,%eax
  801886:	79 02                	jns    80188a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    
		return fd_close(fd, 1);
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	6a 01                	push   $0x1
  80188f:	ff 75 f4             	pushl  -0xc(%ebp)
  801892:	e8 51 ff ff ff       	call   8017e8 <fd_close>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	eb ec                	jmp    801888 <close+0x19>

0080189c <close_all>:

void
close_all(void)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018a8:	83 ec 0c             	sub    $0xc,%esp
  8018ab:	53                   	push   %ebx
  8018ac:	e8 be ff ff ff       	call   80186f <close>
	for (i = 0; i < MAXFD; i++)
  8018b1:	83 c3 01             	add    $0x1,%ebx
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	83 fb 20             	cmp    $0x20,%ebx
  8018ba:	75 ec                	jne    8018a8 <close_all+0xc>
}
  8018bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	57                   	push   %edi
  8018c5:	56                   	push   %esi
  8018c6:	53                   	push   %ebx
  8018c7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018cd:	50                   	push   %eax
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	e8 67 fe ff ff       	call   80173d <fd_lookup>
  8018d6:	89 c3                	mov    %eax,%ebx
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	0f 88 81 00 00 00    	js     801964 <dup+0xa3>
		return r;
	close(newfdnum);
  8018e3:	83 ec 0c             	sub    $0xc,%esp
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	e8 81 ff ff ff       	call   80186f <close>

	newfd = INDEX2FD(newfdnum);
  8018ee:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018f1:	c1 e6 0c             	shl    $0xc,%esi
  8018f4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018fa:	83 c4 04             	add    $0x4,%esp
  8018fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801900:	e8 cf fd ff ff       	call   8016d4 <fd2data>
  801905:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801907:	89 34 24             	mov    %esi,(%esp)
  80190a:	e8 c5 fd ff ff       	call   8016d4 <fd2data>
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801914:	89 d8                	mov    %ebx,%eax
  801916:	c1 e8 16             	shr    $0x16,%eax
  801919:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801920:	a8 01                	test   $0x1,%al
  801922:	74 11                	je     801935 <dup+0x74>
  801924:	89 d8                	mov    %ebx,%eax
  801926:	c1 e8 0c             	shr    $0xc,%eax
  801929:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801930:	f6 c2 01             	test   $0x1,%dl
  801933:	75 39                	jne    80196e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801935:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801938:	89 d0                	mov    %edx,%eax
  80193a:	c1 e8 0c             	shr    $0xc,%eax
  80193d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801944:	83 ec 0c             	sub    $0xc,%esp
  801947:	25 07 0e 00 00       	and    $0xe07,%eax
  80194c:	50                   	push   %eax
  80194d:	56                   	push   %esi
  80194e:	6a 00                	push   $0x0
  801950:	52                   	push   %edx
  801951:	6a 00                	push   $0x0
  801953:	e8 d3 f5 ff ff       	call   800f2b <sys_page_map>
  801958:	89 c3                	mov    %eax,%ebx
  80195a:	83 c4 20             	add    $0x20,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	78 31                	js     801992 <dup+0xd1>
		goto err;

	return newfdnum;
  801961:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801964:	89 d8                	mov    %ebx,%eax
  801966:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801969:	5b                   	pop    %ebx
  80196a:	5e                   	pop    %esi
  80196b:	5f                   	pop    %edi
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80196e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801975:	83 ec 0c             	sub    $0xc,%esp
  801978:	25 07 0e 00 00       	and    $0xe07,%eax
  80197d:	50                   	push   %eax
  80197e:	57                   	push   %edi
  80197f:	6a 00                	push   $0x0
  801981:	53                   	push   %ebx
  801982:	6a 00                	push   $0x0
  801984:	e8 a2 f5 ff ff       	call   800f2b <sys_page_map>
  801989:	89 c3                	mov    %eax,%ebx
  80198b:	83 c4 20             	add    $0x20,%esp
  80198e:	85 c0                	test   %eax,%eax
  801990:	79 a3                	jns    801935 <dup+0x74>
	sys_page_unmap(0, newfd);
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	56                   	push   %esi
  801996:	6a 00                	push   $0x0
  801998:	e8 d0 f5 ff ff       	call   800f6d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80199d:	83 c4 08             	add    $0x8,%esp
  8019a0:	57                   	push   %edi
  8019a1:	6a 00                	push   $0x0
  8019a3:	e8 c5 f5 ff ff       	call   800f6d <sys_page_unmap>
	return r;
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	eb b7                	jmp    801964 <dup+0xa3>

008019ad <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	53                   	push   %ebx
  8019b1:	83 ec 1c             	sub    $0x1c,%esp
  8019b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ba:	50                   	push   %eax
  8019bb:	53                   	push   %ebx
  8019bc:	e8 7c fd ff ff       	call   80173d <fd_lookup>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 3f                	js     801a07 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ce:	50                   	push   %eax
  8019cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d2:	ff 30                	pushl  (%eax)
  8019d4:	e8 b4 fd ff ff       	call   80178d <dev_lookup>
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 27                	js     801a07 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e3:	8b 42 08             	mov    0x8(%edx),%eax
  8019e6:	83 e0 03             	and    $0x3,%eax
  8019e9:	83 f8 01             	cmp    $0x1,%eax
  8019ec:	74 1e                	je     801a0c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	8b 40 08             	mov    0x8(%eax),%eax
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	74 35                	je     801a2d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	ff 75 10             	pushl  0x10(%ebp)
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	52                   	push   %edx
  801a02:	ff d0                	call   *%eax
  801a04:	83 c4 10             	add    $0x10,%esp
}
  801a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a0c:	a1 08 50 80 00       	mov    0x805008,%eax
  801a11:	8b 40 48             	mov    0x48(%eax),%eax
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	53                   	push   %ebx
  801a18:	50                   	push   %eax
  801a19:	68 e5 38 80 00       	push   $0x8038e5
  801a1e:	e8 74 e9 ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a2b:	eb da                	jmp    801a07 <read+0x5a>
		return -E_NOT_SUPP;
  801a2d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a32:	eb d3                	jmp    801a07 <read+0x5a>

00801a34 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	57                   	push   %edi
  801a38:	56                   	push   %esi
  801a39:	53                   	push   %ebx
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a40:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a43:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a48:	39 f3                	cmp    %esi,%ebx
  801a4a:	73 23                	jae    801a6f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	89 f0                	mov    %esi,%eax
  801a51:	29 d8                	sub    %ebx,%eax
  801a53:	50                   	push   %eax
  801a54:	89 d8                	mov    %ebx,%eax
  801a56:	03 45 0c             	add    0xc(%ebp),%eax
  801a59:	50                   	push   %eax
  801a5a:	57                   	push   %edi
  801a5b:	e8 4d ff ff ff       	call   8019ad <read>
		if (m < 0)
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 06                	js     801a6d <readn+0x39>
			return m;
		if (m == 0)
  801a67:	74 06                	je     801a6f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a69:	01 c3                	add    %eax,%ebx
  801a6b:	eb db                	jmp    801a48 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a6d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a6f:	89 d8                	mov    %ebx,%eax
  801a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5f                   	pop    %edi
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    

00801a79 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	53                   	push   %ebx
  801a7d:	83 ec 1c             	sub    $0x1c,%esp
  801a80:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a83:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a86:	50                   	push   %eax
  801a87:	53                   	push   %ebx
  801a88:	e8 b0 fc ff ff       	call   80173d <fd_lookup>
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 3a                	js     801ace <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9a:	50                   	push   %eax
  801a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9e:	ff 30                	pushl  (%eax)
  801aa0:	e8 e8 fc ff ff       	call   80178d <dev_lookup>
  801aa5:	83 c4 10             	add    $0x10,%esp
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	78 22                	js     801ace <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aaf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ab3:	74 1e                	je     801ad3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab8:	8b 52 0c             	mov    0xc(%edx),%edx
  801abb:	85 d2                	test   %edx,%edx
  801abd:	74 35                	je     801af4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	ff 75 10             	pushl  0x10(%ebp)
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	50                   	push   %eax
  801ac9:	ff d2                	call   *%edx
  801acb:	83 c4 10             	add    $0x10,%esp
}
  801ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ad3:	a1 08 50 80 00       	mov    0x805008,%eax
  801ad8:	8b 40 48             	mov    0x48(%eax),%eax
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	53                   	push   %ebx
  801adf:	50                   	push   %eax
  801ae0:	68 01 39 80 00       	push   $0x803901
  801ae5:	e8 ad e8 ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af2:	eb da                	jmp    801ace <write+0x55>
		return -E_NOT_SUPP;
  801af4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af9:	eb d3                	jmp    801ace <write+0x55>

00801afb <seek>:

int
seek(int fdnum, off_t offset)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b04:	50                   	push   %eax
  801b05:	ff 75 08             	pushl  0x8(%ebp)
  801b08:	e8 30 fc ff ff       	call   80173d <fd_lookup>
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 0e                	js     801b22 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	53                   	push   %ebx
  801b28:	83 ec 1c             	sub    $0x1c,%esp
  801b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b31:	50                   	push   %eax
  801b32:	53                   	push   %ebx
  801b33:	e8 05 fc ff ff       	call   80173d <fd_lookup>
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 37                	js     801b76 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b45:	50                   	push   %eax
  801b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b49:	ff 30                	pushl  (%eax)
  801b4b:	e8 3d fc ff ff       	call   80178d <dev_lookup>
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 1f                	js     801b76 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b5e:	74 1b                	je     801b7b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b63:	8b 52 18             	mov    0x18(%edx),%edx
  801b66:	85 d2                	test   %edx,%edx
  801b68:	74 32                	je     801b9c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b6a:	83 ec 08             	sub    $0x8,%esp
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	50                   	push   %eax
  801b71:	ff d2                	call   *%edx
  801b73:	83 c4 10             	add    $0x10,%esp
}
  801b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b7b:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b80:	8b 40 48             	mov    0x48(%eax),%eax
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	53                   	push   %ebx
  801b87:	50                   	push   %eax
  801b88:	68 c4 38 80 00       	push   $0x8038c4
  801b8d:	e8 05 e8 ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b9a:	eb da                	jmp    801b76 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b9c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba1:	eb d3                	jmp    801b76 <ftruncate+0x52>

00801ba3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	53                   	push   %ebx
  801ba7:	83 ec 1c             	sub    $0x1c,%esp
  801baa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bb0:	50                   	push   %eax
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	e8 84 fb ff ff       	call   80173d <fd_lookup>
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 4b                	js     801c0b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bc0:	83 ec 08             	sub    $0x8,%esp
  801bc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc6:	50                   	push   %eax
  801bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bca:	ff 30                	pushl  (%eax)
  801bcc:	e8 bc fb ff ff       	call   80178d <dev_lookup>
  801bd1:	83 c4 10             	add    $0x10,%esp
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	78 33                	js     801c0b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bdf:	74 2f                	je     801c10 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801be1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801be4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801beb:	00 00 00 
	stat->st_isdir = 0;
  801bee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bf5:	00 00 00 
	stat->st_dev = dev;
  801bf8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bfe:	83 ec 08             	sub    $0x8,%esp
  801c01:	53                   	push   %ebx
  801c02:	ff 75 f0             	pushl  -0x10(%ebp)
  801c05:	ff 50 14             	call   *0x14(%eax)
  801c08:	83 c4 10             	add    $0x10,%esp
}
  801c0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    
		return -E_NOT_SUPP;
  801c10:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c15:	eb f4                	jmp    801c0b <fstat+0x68>

00801c17 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c1c:	83 ec 08             	sub    $0x8,%esp
  801c1f:	6a 00                	push   $0x0
  801c21:	ff 75 08             	pushl  0x8(%ebp)
  801c24:	e8 22 02 00 00       	call   801e4b <open>
  801c29:	89 c3                	mov    %eax,%ebx
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 1b                	js     801c4d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c32:	83 ec 08             	sub    $0x8,%esp
  801c35:	ff 75 0c             	pushl  0xc(%ebp)
  801c38:	50                   	push   %eax
  801c39:	e8 65 ff ff ff       	call   801ba3 <fstat>
  801c3e:	89 c6                	mov    %eax,%esi
	close(fd);
  801c40:	89 1c 24             	mov    %ebx,(%esp)
  801c43:	e8 27 fc ff ff       	call   80186f <close>
	return r;
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	89 f3                	mov    %esi,%ebx
}
  801c4d:	89 d8                	mov    %ebx,%eax
  801c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    

00801c56 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	56                   	push   %esi
  801c5a:	53                   	push   %ebx
  801c5b:	89 c6                	mov    %eax,%esi
  801c5d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c5f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c66:	74 27                	je     801c8f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c68:	6a 07                	push   $0x7
  801c6a:	68 00 60 80 00       	push   $0x806000
  801c6f:	56                   	push   %esi
  801c70:	ff 35 00 50 80 00    	pushl  0x805000
  801c76:	e8 08 13 00 00       	call   802f83 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c7b:	83 c4 0c             	add    $0xc,%esp
  801c7e:	6a 00                	push   $0x0
  801c80:	53                   	push   %ebx
  801c81:	6a 00                	push   $0x0
  801c83:	e8 92 12 00 00       	call   802f1a <ipc_recv>
}
  801c88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8b:	5b                   	pop    %ebx
  801c8c:	5e                   	pop    %esi
  801c8d:	5d                   	pop    %ebp
  801c8e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c8f:	83 ec 0c             	sub    $0xc,%esp
  801c92:	6a 01                	push   $0x1
  801c94:	e8 42 13 00 00       	call   802fdb <ipc_find_env>
  801c99:	a3 00 50 80 00       	mov    %eax,0x805000
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	eb c5                	jmp    801c68 <fsipc+0x12>

00801ca3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	8b 40 0c             	mov    0xc(%eax),%eax
  801caf:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb7:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc1:	b8 02 00 00 00       	mov    $0x2,%eax
  801cc6:	e8 8b ff ff ff       	call   801c56 <fsipc>
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <devfile_flush>:
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd9:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cde:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce3:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce8:	e8 69 ff ff ff       	call   801c56 <fsipc>
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <devfile_stat>:
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	53                   	push   %ebx
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  801cff:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d04:	ba 00 00 00 00       	mov    $0x0,%edx
  801d09:	b8 05 00 00 00       	mov    $0x5,%eax
  801d0e:	e8 43 ff ff ff       	call   801c56 <fsipc>
  801d13:	85 c0                	test   %eax,%eax
  801d15:	78 2c                	js     801d43 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d17:	83 ec 08             	sub    $0x8,%esp
  801d1a:	68 00 60 80 00       	push   $0x806000
  801d1f:	53                   	push   %ebx
  801d20:	e8 d1 ed ff ff       	call   800af6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d25:	a1 80 60 80 00       	mov    0x806080,%eax
  801d2a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d30:	a1 84 60 80 00       	mov    0x806084,%eax
  801d35:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <devfile_write>:
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	53                   	push   %ebx
  801d4c:	83 ec 08             	sub    $0x8,%esp
  801d4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	8b 40 0c             	mov    0xc(%eax),%eax
  801d58:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d5d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d63:	53                   	push   %ebx
  801d64:	ff 75 0c             	pushl  0xc(%ebp)
  801d67:	68 08 60 80 00       	push   $0x806008
  801d6c:	e8 75 ef ff ff       	call   800ce6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d71:	ba 00 00 00 00       	mov    $0x0,%edx
  801d76:	b8 04 00 00 00       	mov    $0x4,%eax
  801d7b:	e8 d6 fe ff ff       	call   801c56 <fsipc>
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	85 c0                	test   %eax,%eax
  801d85:	78 0b                	js     801d92 <devfile_write+0x4a>
	assert(r <= n);
  801d87:	39 d8                	cmp    %ebx,%eax
  801d89:	77 0c                	ja     801d97 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d8b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d90:	7f 1e                	jg     801db0 <devfile_write+0x68>
}
  801d92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    
	assert(r <= n);
  801d97:	68 34 39 80 00       	push   $0x803934
  801d9c:	68 3b 39 80 00       	push   $0x80393b
  801da1:	68 98 00 00 00       	push   $0x98
  801da6:	68 50 39 80 00       	push   $0x803950
  801dab:	e8 f1 e4 ff ff       	call   8002a1 <_panic>
	assert(r <= PGSIZE);
  801db0:	68 5b 39 80 00       	push   $0x80395b
  801db5:	68 3b 39 80 00       	push   $0x80393b
  801dba:	68 99 00 00 00       	push   $0x99
  801dbf:	68 50 39 80 00       	push   $0x803950
  801dc4:	e8 d8 e4 ff ff       	call   8002a1 <_panic>

00801dc9 <devfile_read>:
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	56                   	push   %esi
  801dcd:	53                   	push   %ebx
  801dce:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ddc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801de2:	ba 00 00 00 00       	mov    $0x0,%edx
  801de7:	b8 03 00 00 00       	mov    $0x3,%eax
  801dec:	e8 65 fe ff ff       	call   801c56 <fsipc>
  801df1:	89 c3                	mov    %eax,%ebx
  801df3:	85 c0                	test   %eax,%eax
  801df5:	78 1f                	js     801e16 <devfile_read+0x4d>
	assert(r <= n);
  801df7:	39 f0                	cmp    %esi,%eax
  801df9:	77 24                	ja     801e1f <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dfb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e00:	7f 33                	jg     801e35 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e02:	83 ec 04             	sub    $0x4,%esp
  801e05:	50                   	push   %eax
  801e06:	68 00 60 80 00       	push   $0x806000
  801e0b:	ff 75 0c             	pushl  0xc(%ebp)
  801e0e:	e8 71 ee ff ff       	call   800c84 <memmove>
	return r;
  801e13:	83 c4 10             	add    $0x10,%esp
}
  801e16:	89 d8                	mov    %ebx,%eax
  801e18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5e                   	pop    %esi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    
	assert(r <= n);
  801e1f:	68 34 39 80 00       	push   $0x803934
  801e24:	68 3b 39 80 00       	push   $0x80393b
  801e29:	6a 7c                	push   $0x7c
  801e2b:	68 50 39 80 00       	push   $0x803950
  801e30:	e8 6c e4 ff ff       	call   8002a1 <_panic>
	assert(r <= PGSIZE);
  801e35:	68 5b 39 80 00       	push   $0x80395b
  801e3a:	68 3b 39 80 00       	push   $0x80393b
  801e3f:	6a 7d                	push   $0x7d
  801e41:	68 50 39 80 00       	push   $0x803950
  801e46:	e8 56 e4 ff ff       	call   8002a1 <_panic>

00801e4b <open>:
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	56                   	push   %esi
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 1c             	sub    $0x1c,%esp
  801e53:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e56:	56                   	push   %esi
  801e57:	e8 61 ec ff ff       	call   800abd <strlen>
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e64:	7f 6c                	jg     801ed2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e66:	83 ec 0c             	sub    $0xc,%esp
  801e69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6c:	50                   	push   %eax
  801e6d:	e8 79 f8 ff ff       	call   8016eb <fd_alloc>
  801e72:	89 c3                	mov    %eax,%ebx
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	85 c0                	test   %eax,%eax
  801e79:	78 3c                	js     801eb7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e7b:	83 ec 08             	sub    $0x8,%esp
  801e7e:	56                   	push   %esi
  801e7f:	68 00 60 80 00       	push   $0x806000
  801e84:	e8 6d ec ff ff       	call   800af6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e94:	b8 01 00 00 00       	mov    $0x1,%eax
  801e99:	e8 b8 fd ff ff       	call   801c56 <fsipc>
  801e9e:	89 c3                	mov    %eax,%ebx
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	78 19                	js     801ec0 <open+0x75>
	return fd2num(fd);
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ead:	e8 12 f8 ff ff       	call   8016c4 <fd2num>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	83 c4 10             	add    $0x10,%esp
}
  801eb7:	89 d8                	mov    %ebx,%eax
  801eb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ebc:	5b                   	pop    %ebx
  801ebd:	5e                   	pop    %esi
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    
		fd_close(fd, 0);
  801ec0:	83 ec 08             	sub    $0x8,%esp
  801ec3:	6a 00                	push   $0x0
  801ec5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec8:	e8 1b f9 ff ff       	call   8017e8 <fd_close>
		return r;
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	eb e5                	jmp    801eb7 <open+0x6c>
		return -E_BAD_PATH;
  801ed2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ed7:	eb de                	jmp    801eb7 <open+0x6c>

00801ed9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801edf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee4:	b8 08 00 00 00       	mov    $0x8,%eax
  801ee9:	e8 68 fd ff ff       	call   801c56 <fsipc>
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	57                   	push   %edi
  801ef4:	56                   	push   %esi
  801ef5:	53                   	push   %ebx
  801ef6:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801efc:	68 40 3a 80 00       	push   $0x803a40
  801f01:	68 c9 33 80 00       	push   $0x8033c9
  801f06:	e8 8c e4 ff ff       	call   800397 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801f0b:	83 c4 08             	add    $0x8,%esp
  801f0e:	6a 00                	push   $0x0
  801f10:	ff 75 08             	pushl  0x8(%ebp)
  801f13:	e8 33 ff ff ff       	call   801e4b <open>
  801f18:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	85 c0                	test   %eax,%eax
  801f23:	0f 88 0a 05 00 00    	js     802433 <spawn+0x543>
  801f29:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801f2b:	83 ec 04             	sub    $0x4,%esp
  801f2e:	68 00 02 00 00       	push   $0x200
  801f33:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801f39:	50                   	push   %eax
  801f3a:	51                   	push   %ecx
  801f3b:	e8 f4 fa ff ff       	call   801a34 <readn>
  801f40:	83 c4 10             	add    $0x10,%esp
  801f43:	3d 00 02 00 00       	cmp    $0x200,%eax
  801f48:	75 74                	jne    801fbe <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801f4a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801f51:	45 4c 46 
  801f54:	75 68                	jne    801fbe <spawn+0xce>
  801f56:	b8 07 00 00 00       	mov    $0x7,%eax
  801f5b:	cd 30                	int    $0x30
  801f5d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801f63:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	0f 88 b6 04 00 00    	js     802427 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801f71:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f76:	89 c6                	mov    %eax,%esi
  801f78:	c1 e6 07             	shl    $0x7,%esi
  801f7b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801f81:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801f87:	b9 11 00 00 00       	mov    $0x11,%ecx
  801f8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801f8e:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801f94:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801f9a:	83 ec 08             	sub    $0x8,%esp
  801f9d:	68 34 3a 80 00       	push   $0x803a34
  801fa2:	68 c9 33 80 00       	push   $0x8033c9
  801fa7:	e8 eb e3 ff ff       	call   800397 <cprintf>
  801fac:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801faf:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801fb4:	be 00 00 00 00       	mov    $0x0,%esi
  801fb9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801fbc:	eb 4b                	jmp    802009 <spawn+0x119>
		close(fd);
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801fc7:	e8 a3 f8 ff ff       	call   80186f <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801fcc:	83 c4 0c             	add    $0xc,%esp
  801fcf:	68 7f 45 4c 46       	push   $0x464c457f
  801fd4:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801fda:	68 67 39 80 00       	push   $0x803967
  801fdf:	e8 b3 e3 ff ff       	call   800397 <cprintf>
		return -E_NOT_EXEC;
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801fee:	ff ff ff 
  801ff1:	e9 3d 04 00 00       	jmp    802433 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	50                   	push   %eax
  801ffa:	e8 be ea ff ff       	call   800abd <strlen>
  801fff:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802003:	83 c3 01             	add    $0x1,%ebx
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802010:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	75 df                	jne    801ff6 <spawn+0x106>
  802017:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80201d:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802023:	bf 00 10 40 00       	mov    $0x401000,%edi
  802028:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80202a:	89 fa                	mov    %edi,%edx
  80202c:	83 e2 fc             	and    $0xfffffffc,%edx
  80202f:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802036:	29 c2                	sub    %eax,%edx
  802038:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80203e:	8d 42 f8             	lea    -0x8(%edx),%eax
  802041:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802046:	0f 86 0a 04 00 00    	jbe    802456 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80204c:	83 ec 04             	sub    $0x4,%esp
  80204f:	6a 07                	push   $0x7
  802051:	68 00 00 40 00       	push   $0x400000
  802056:	6a 00                	push   $0x0
  802058:	e8 8b ee ff ff       	call   800ee8 <sys_page_alloc>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	85 c0                	test   %eax,%eax
  802062:	0f 88 f3 03 00 00    	js     80245b <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802068:	be 00 00 00 00       	mov    $0x0,%esi
  80206d:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802073:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802076:	eb 30                	jmp    8020a8 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  802078:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80207e:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802084:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802087:	83 ec 08             	sub    $0x8,%esp
  80208a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80208d:	57                   	push   %edi
  80208e:	e8 63 ea ff ff       	call   800af6 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802093:	83 c4 04             	add    $0x4,%esp
  802096:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802099:	e8 1f ea ff ff       	call   800abd <strlen>
  80209e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8020a2:	83 c6 01             	add    $0x1,%esi
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8020ae:	7f c8                	jg     802078 <spawn+0x188>
	}
	argv_store[argc] = 0;
  8020b0:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8020b6:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8020bc:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020c3:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8020c9:	0f 85 86 00 00 00    	jne    802155 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8020cf:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  8020d5:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  8020db:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  8020de:	89 d0                	mov    %edx,%eax
  8020e0:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8020e6:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8020e9:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8020ee:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	6a 07                	push   $0x7
  8020f9:	68 00 d0 bf ee       	push   $0xeebfd000
  8020fe:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802104:	68 00 00 40 00       	push   $0x400000
  802109:	6a 00                	push   $0x0
  80210b:	e8 1b ee ff ff       	call   800f2b <sys_page_map>
  802110:	89 c3                	mov    %eax,%ebx
  802112:	83 c4 20             	add    $0x20,%esp
  802115:	85 c0                	test   %eax,%eax
  802117:	0f 88 46 03 00 00    	js     802463 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80211d:	83 ec 08             	sub    $0x8,%esp
  802120:	68 00 00 40 00       	push   $0x400000
  802125:	6a 00                	push   $0x0
  802127:	e8 41 ee ff ff       	call   800f6d <sys_page_unmap>
  80212c:	89 c3                	mov    %eax,%ebx
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	85 c0                	test   %eax,%eax
  802133:	0f 88 2a 03 00 00    	js     802463 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802139:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80213f:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802146:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  80214d:	00 00 00 
  802150:	e9 4f 01 00 00       	jmp    8022a4 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802155:	68 f0 39 80 00       	push   $0x8039f0
  80215a:	68 3b 39 80 00       	push   $0x80393b
  80215f:	68 f8 00 00 00       	push   $0xf8
  802164:	68 81 39 80 00       	push   $0x803981
  802169:	e8 33 e1 ff ff       	call   8002a1 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80216e:	83 ec 04             	sub    $0x4,%esp
  802171:	6a 07                	push   $0x7
  802173:	68 00 00 40 00       	push   $0x400000
  802178:	6a 00                	push   $0x0
  80217a:	e8 69 ed ff ff       	call   800ee8 <sys_page_alloc>
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	85 c0                	test   %eax,%eax
  802184:	0f 88 b7 02 00 00    	js     802441 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80218a:	83 ec 08             	sub    $0x8,%esp
  80218d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802193:	01 f0                	add    %esi,%eax
  802195:	50                   	push   %eax
  802196:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80219c:	e8 5a f9 ff ff       	call   801afb <seek>
  8021a1:	83 c4 10             	add    $0x10,%esp
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	0f 88 9c 02 00 00    	js     802448 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8021b5:	29 f0                	sub    %esi,%eax
  8021b7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8021bc:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021c1:	0f 47 c1             	cmova  %ecx,%eax
  8021c4:	50                   	push   %eax
  8021c5:	68 00 00 40 00       	push   $0x400000
  8021ca:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021d0:	e8 5f f8 ff ff       	call   801a34 <readn>
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	0f 88 6f 02 00 00    	js     80244f <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8021e0:	83 ec 0c             	sub    $0xc,%esp
  8021e3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8021e9:	53                   	push   %ebx
  8021ea:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8021f0:	68 00 00 40 00       	push   $0x400000
  8021f5:	6a 00                	push   $0x0
  8021f7:	e8 2f ed ff ff       	call   800f2b <sys_page_map>
  8021fc:	83 c4 20             	add    $0x20,%esp
  8021ff:	85 c0                	test   %eax,%eax
  802201:	78 7c                	js     80227f <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802203:	83 ec 08             	sub    $0x8,%esp
  802206:	68 00 00 40 00       	push   $0x400000
  80220b:	6a 00                	push   $0x0
  80220d:	e8 5b ed ff ff       	call   800f6d <sys_page_unmap>
  802212:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802215:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80221b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802221:	89 fe                	mov    %edi,%esi
  802223:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802229:	76 69                	jbe    802294 <spawn+0x3a4>
		if (i >= filesz) {
  80222b:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802231:	0f 87 37 ff ff ff    	ja     80216e <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802240:	53                   	push   %ebx
  802241:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802247:	e8 9c ec ff ff       	call   800ee8 <sys_page_alloc>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	79 c2                	jns    802215 <spawn+0x325>
  802253:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80225e:	e8 06 ec ff ff       	call   800e69 <sys_env_destroy>
	close(fd);
  802263:	83 c4 04             	add    $0x4,%esp
  802266:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80226c:	e8 fe f5 ff ff       	call   80186f <close>
	return r;
  802271:	83 c4 10             	add    $0x10,%esp
  802274:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  80227a:	e9 b4 01 00 00       	jmp    802433 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  80227f:	50                   	push   %eax
  802280:	68 8d 39 80 00       	push   $0x80398d
  802285:	68 2b 01 00 00       	push   $0x12b
  80228a:	68 81 39 80 00       	push   $0x803981
  80228f:	e8 0d e0 ff ff       	call   8002a1 <_panic>
  802294:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80229a:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8022a1:	83 c6 20             	add    $0x20,%esi
  8022a4:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8022ab:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8022b1:	7e 6d                	jle    802320 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  8022b3:	83 3e 01             	cmpl   $0x1,(%esi)
  8022b6:	75 e2                	jne    80229a <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8022b8:	8b 46 18             	mov    0x18(%esi),%eax
  8022bb:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8022be:	83 f8 01             	cmp    $0x1,%eax
  8022c1:	19 c0                	sbb    %eax,%eax
  8022c3:	83 e0 fe             	and    $0xfffffffe,%eax
  8022c6:	83 c0 07             	add    $0x7,%eax
  8022c9:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8022cf:	8b 4e 04             	mov    0x4(%esi),%ecx
  8022d2:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8022d8:	8b 56 10             	mov    0x10(%esi),%edx
  8022db:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8022e1:	8b 7e 14             	mov    0x14(%esi),%edi
  8022e4:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  8022ea:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  8022ed:	89 d8                	mov    %ebx,%eax
  8022ef:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022f4:	74 1a                	je     802310 <spawn+0x420>
		va -= i;
  8022f6:	29 c3                	sub    %eax,%ebx
		memsz += i;
  8022f8:	01 c7                	add    %eax,%edi
  8022fa:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802300:	01 c2                	add    %eax,%edx
  802302:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802308:	29 c1                	sub    %eax,%ecx
  80230a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802310:	bf 00 00 00 00       	mov    $0x0,%edi
  802315:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  80231b:	e9 01 ff ff ff       	jmp    802221 <spawn+0x331>
	close(fd);
  802320:	83 ec 0c             	sub    $0xc,%esp
  802323:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802329:	e8 41 f5 ff ff       	call   80186f <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  80232e:	83 c4 08             	add    $0x8,%esp
  802331:	68 20 3a 80 00       	push   $0x803a20
  802336:	68 c9 33 80 00       	push   $0x8033c9
  80233b:	e8 57 e0 ff ff       	call   800397 <cprintf>
  802340:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  802343:	bb 00 00 80 00       	mov    $0x800000,%ebx
  802348:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  80234e:	eb 0e                	jmp    80235e <spawn+0x46e>
  802350:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802356:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80235c:	74 5e                	je     8023bc <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  80235e:	89 d8                	mov    %ebx,%eax
  802360:	c1 e8 16             	shr    $0x16,%eax
  802363:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80236a:	a8 01                	test   $0x1,%al
  80236c:	74 e2                	je     802350 <spawn+0x460>
  80236e:	89 da                	mov    %ebx,%edx
  802370:	c1 ea 0c             	shr    $0xc,%edx
  802373:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80237a:	25 05 04 00 00       	and    $0x405,%eax
  80237f:	3d 05 04 00 00       	cmp    $0x405,%eax
  802384:	75 ca                	jne    802350 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802386:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80238d:	83 ec 0c             	sub    $0xc,%esp
  802390:	25 07 0e 00 00       	and    $0xe07,%eax
  802395:	50                   	push   %eax
  802396:	53                   	push   %ebx
  802397:	56                   	push   %esi
  802398:	53                   	push   %ebx
  802399:	6a 00                	push   $0x0
  80239b:	e8 8b eb ff ff       	call   800f2b <sys_page_map>
  8023a0:	83 c4 20             	add    $0x20,%esp
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	79 a9                	jns    802350 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  8023a7:	50                   	push   %eax
  8023a8:	68 aa 39 80 00       	push   $0x8039aa
  8023ad:	68 3b 01 00 00       	push   $0x13b
  8023b2:	68 81 39 80 00       	push   $0x803981
  8023b7:	e8 e5 de ff ff       	call   8002a1 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8023bc:	83 ec 08             	sub    $0x8,%esp
  8023bf:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8023c5:	50                   	push   %eax
  8023c6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023cc:	e8 20 ec ff ff       	call   800ff1 <sys_env_set_trapframe>
  8023d1:	83 c4 10             	add    $0x10,%esp
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 25                	js     8023fd <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8023d8:	83 ec 08             	sub    $0x8,%esp
  8023db:	6a 02                	push   $0x2
  8023dd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8023e3:	e8 c7 eb ff ff       	call   800faf <sys_env_set_status>
  8023e8:	83 c4 10             	add    $0x10,%esp
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	78 23                	js     802412 <spawn+0x522>
	return child;
  8023ef:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8023f5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8023fb:	eb 36                	jmp    802433 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  8023fd:	50                   	push   %eax
  8023fe:	68 bc 39 80 00       	push   $0x8039bc
  802403:	68 8a 00 00 00       	push   $0x8a
  802408:	68 81 39 80 00       	push   $0x803981
  80240d:	e8 8f de ff ff       	call   8002a1 <_panic>
		panic("sys_env_set_status: %e", r);
  802412:	50                   	push   %eax
  802413:	68 d6 39 80 00       	push   $0x8039d6
  802418:	68 8d 00 00 00       	push   $0x8d
  80241d:	68 81 39 80 00       	push   $0x803981
  802422:	e8 7a de ff ff       	call   8002a1 <_panic>
		return r;
  802427:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80242d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802433:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802439:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	89 c7                	mov    %eax,%edi
  802443:	e9 0d fe ff ff       	jmp    802255 <spawn+0x365>
  802448:	89 c7                	mov    %eax,%edi
  80244a:	e9 06 fe ff ff       	jmp    802255 <spawn+0x365>
  80244f:	89 c7                	mov    %eax,%edi
  802451:	e9 ff fd ff ff       	jmp    802255 <spawn+0x365>
		return -E_NO_MEM;
  802456:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  80245b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802461:	eb d0                	jmp    802433 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  802463:	83 ec 08             	sub    $0x8,%esp
  802466:	68 00 00 40 00       	push   $0x400000
  80246b:	6a 00                	push   $0x0
  80246d:	e8 fb ea ff ff       	call   800f6d <sys_page_unmap>
  802472:	83 c4 10             	add    $0x10,%esp
  802475:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80247b:	eb b6                	jmp    802433 <spawn+0x543>

0080247d <spawnl>:
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	57                   	push   %edi
  802481:	56                   	push   %esi
  802482:	53                   	push   %ebx
  802483:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802486:	68 18 3a 80 00       	push   $0x803a18
  80248b:	68 c9 33 80 00       	push   $0x8033c9
  802490:	e8 02 df ff ff       	call   800397 <cprintf>
	va_start(vl, arg0);
  802495:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802498:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8024a0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8024a3:	83 3a 00             	cmpl   $0x0,(%edx)
  8024a6:	74 07                	je     8024af <spawnl+0x32>
		argc++;
  8024a8:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8024ab:	89 ca                	mov    %ecx,%edx
  8024ad:	eb f1                	jmp    8024a0 <spawnl+0x23>
	const char *argv[argc+2];
  8024af:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8024b6:	83 e2 f0             	and    $0xfffffff0,%edx
  8024b9:	29 d4                	sub    %edx,%esp
  8024bb:	8d 54 24 03          	lea    0x3(%esp),%edx
  8024bf:	c1 ea 02             	shr    $0x2,%edx
  8024c2:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8024c9:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8024cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ce:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8024d5:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8024dc:	00 
	va_start(vl, arg0);
  8024dd:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8024e0:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8024e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e7:	eb 0b                	jmp    8024f4 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  8024e9:	83 c0 01             	add    $0x1,%eax
  8024ec:	8b 39                	mov    (%ecx),%edi
  8024ee:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8024f1:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8024f4:	39 d0                	cmp    %edx,%eax
  8024f6:	75 f1                	jne    8024e9 <spawnl+0x6c>
	return spawn(prog, argv);
  8024f8:	83 ec 08             	sub    $0x8,%esp
  8024fb:	56                   	push   %esi
  8024fc:	ff 75 08             	pushl  0x8(%ebp)
  8024ff:	e8 ec f9 ff ff       	call   801ef0 <spawn>
}
  802504:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802507:	5b                   	pop    %ebx
  802508:	5e                   	pop    %esi
  802509:	5f                   	pop    %edi
  80250a:	5d                   	pop    %ebp
  80250b:	c3                   	ret    

0080250c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802512:	68 46 3a 80 00       	push   $0x803a46
  802517:	ff 75 0c             	pushl  0xc(%ebp)
  80251a:	e8 d7 e5 ff ff       	call   800af6 <strcpy>
	return 0;
}
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <devsock_close>:
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	53                   	push   %ebx
  80252a:	83 ec 10             	sub    $0x10,%esp
  80252d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802530:	53                   	push   %ebx
  802531:	e8 e0 0a 00 00       	call   803016 <pageref>
  802536:	83 c4 10             	add    $0x10,%esp
		return 0;
  802539:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80253e:	83 f8 01             	cmp    $0x1,%eax
  802541:	74 07                	je     80254a <devsock_close+0x24>
}
  802543:	89 d0                	mov    %edx,%eax
  802545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802548:	c9                   	leave  
  802549:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80254a:	83 ec 0c             	sub    $0xc,%esp
  80254d:	ff 73 0c             	pushl  0xc(%ebx)
  802550:	e8 b9 02 00 00       	call   80280e <nsipc_close>
  802555:	89 c2                	mov    %eax,%edx
  802557:	83 c4 10             	add    $0x10,%esp
  80255a:	eb e7                	jmp    802543 <devsock_close+0x1d>

0080255c <devsock_write>:
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802562:	6a 00                	push   $0x0
  802564:	ff 75 10             	pushl  0x10(%ebp)
  802567:	ff 75 0c             	pushl  0xc(%ebp)
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	ff 70 0c             	pushl  0xc(%eax)
  802570:	e8 76 03 00 00       	call   8028eb <nsipc_send>
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <devsock_read>:
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
  80257a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80257d:	6a 00                	push   $0x0
  80257f:	ff 75 10             	pushl  0x10(%ebp)
  802582:	ff 75 0c             	pushl  0xc(%ebp)
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	ff 70 0c             	pushl  0xc(%eax)
  80258b:	e8 ef 02 00 00       	call   80287f <nsipc_recv>
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <fd2sockid>:
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802598:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80259b:	52                   	push   %edx
  80259c:	50                   	push   %eax
  80259d:	e8 9b f1 ff ff       	call   80173d <fd_lookup>
  8025a2:	83 c4 10             	add    $0x10,%esp
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	78 10                	js     8025b9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  8025b2:	39 08                	cmp    %ecx,(%eax)
  8025b4:	75 05                	jne    8025bb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8025b6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    
		return -E_NOT_SUPP;
  8025bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025c0:	eb f7                	jmp    8025b9 <fd2sockid+0x27>

008025c2 <alloc_sockfd>:
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	56                   	push   %esi
  8025c6:	53                   	push   %ebx
  8025c7:	83 ec 1c             	sub    $0x1c,%esp
  8025ca:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8025cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025cf:	50                   	push   %eax
  8025d0:	e8 16 f1 ff ff       	call   8016eb <fd_alloc>
  8025d5:	89 c3                	mov    %eax,%ebx
  8025d7:	83 c4 10             	add    $0x10,%esp
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	78 43                	js     802621 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8025de:	83 ec 04             	sub    $0x4,%esp
  8025e1:	68 07 04 00 00       	push   $0x407
  8025e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e9:	6a 00                	push   $0x0
  8025eb:	e8 f8 e8 ff ff       	call   800ee8 <sys_page_alloc>
  8025f0:	89 c3                	mov    %eax,%ebx
  8025f2:	83 c4 10             	add    $0x10,%esp
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	78 28                	js     802621 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802602:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80260e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802611:	83 ec 0c             	sub    $0xc,%esp
  802614:	50                   	push   %eax
  802615:	e8 aa f0 ff ff       	call   8016c4 <fd2num>
  80261a:	89 c3                	mov    %eax,%ebx
  80261c:	83 c4 10             	add    $0x10,%esp
  80261f:	eb 0c                	jmp    80262d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802621:	83 ec 0c             	sub    $0xc,%esp
  802624:	56                   	push   %esi
  802625:	e8 e4 01 00 00       	call   80280e <nsipc_close>
		return r;
  80262a:	83 c4 10             	add    $0x10,%esp
}
  80262d:	89 d8                	mov    %ebx,%eax
  80262f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802632:	5b                   	pop    %ebx
  802633:	5e                   	pop    %esi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    

00802636 <accept>:
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	e8 4e ff ff ff       	call   802592 <fd2sockid>
  802644:	85 c0                	test   %eax,%eax
  802646:	78 1b                	js     802663 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802648:	83 ec 04             	sub    $0x4,%esp
  80264b:	ff 75 10             	pushl  0x10(%ebp)
  80264e:	ff 75 0c             	pushl  0xc(%ebp)
  802651:	50                   	push   %eax
  802652:	e8 0e 01 00 00       	call   802765 <nsipc_accept>
  802657:	83 c4 10             	add    $0x10,%esp
  80265a:	85 c0                	test   %eax,%eax
  80265c:	78 05                	js     802663 <accept+0x2d>
	return alloc_sockfd(r);
  80265e:	e8 5f ff ff ff       	call   8025c2 <alloc_sockfd>
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <bind>:
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	e8 1f ff ff ff       	call   802592 <fd2sockid>
  802673:	85 c0                	test   %eax,%eax
  802675:	78 12                	js     802689 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802677:	83 ec 04             	sub    $0x4,%esp
  80267a:	ff 75 10             	pushl  0x10(%ebp)
  80267d:	ff 75 0c             	pushl  0xc(%ebp)
  802680:	50                   	push   %eax
  802681:	e8 31 01 00 00       	call   8027b7 <nsipc_bind>
  802686:	83 c4 10             	add    $0x10,%esp
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <shutdown>:
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	e8 f9 fe ff ff       	call   802592 <fd2sockid>
  802699:	85 c0                	test   %eax,%eax
  80269b:	78 0f                	js     8026ac <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80269d:	83 ec 08             	sub    $0x8,%esp
  8026a0:	ff 75 0c             	pushl  0xc(%ebp)
  8026a3:	50                   	push   %eax
  8026a4:	e8 43 01 00 00       	call   8027ec <nsipc_shutdown>
  8026a9:	83 c4 10             	add    $0x10,%esp
}
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <connect>:
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
  8026b1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	e8 d6 fe ff ff       	call   802592 <fd2sockid>
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	78 12                	js     8026d2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8026c0:	83 ec 04             	sub    $0x4,%esp
  8026c3:	ff 75 10             	pushl  0x10(%ebp)
  8026c6:	ff 75 0c             	pushl  0xc(%ebp)
  8026c9:	50                   	push   %eax
  8026ca:	e8 59 01 00 00       	call   802828 <nsipc_connect>
  8026cf:	83 c4 10             	add    $0x10,%esp
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <listen>:
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	e8 b0 fe ff ff       	call   802592 <fd2sockid>
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	78 0f                	js     8026f5 <listen+0x21>
	return nsipc_listen(r, backlog);
  8026e6:	83 ec 08             	sub    $0x8,%esp
  8026e9:	ff 75 0c             	pushl  0xc(%ebp)
  8026ec:	50                   	push   %eax
  8026ed:	e8 6b 01 00 00       	call   80285d <nsipc_listen>
  8026f2:	83 c4 10             	add    $0x10,%esp
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <socket>:

int
socket(int domain, int type, int protocol)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8026fd:	ff 75 10             	pushl  0x10(%ebp)
  802700:	ff 75 0c             	pushl  0xc(%ebp)
  802703:	ff 75 08             	pushl  0x8(%ebp)
  802706:	e8 3e 02 00 00       	call   802949 <nsipc_socket>
  80270b:	83 c4 10             	add    $0x10,%esp
  80270e:	85 c0                	test   %eax,%eax
  802710:	78 05                	js     802717 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802712:	e8 ab fe ff ff       	call   8025c2 <alloc_sockfd>
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	53                   	push   %ebx
  80271d:	83 ec 04             	sub    $0x4,%esp
  802720:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802722:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802729:	74 26                	je     802751 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80272b:	6a 07                	push   $0x7
  80272d:	68 00 70 80 00       	push   $0x807000
  802732:	53                   	push   %ebx
  802733:	ff 35 04 50 80 00    	pushl  0x805004
  802739:	e8 45 08 00 00       	call   802f83 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80273e:	83 c4 0c             	add    $0xc,%esp
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	e8 ce 07 00 00       	call   802f1a <ipc_recv>
}
  80274c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80274f:	c9                   	leave  
  802750:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	6a 02                	push   $0x2
  802756:	e8 80 08 00 00       	call   802fdb <ipc_find_env>
  80275b:	a3 04 50 80 00       	mov    %eax,0x805004
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	eb c6                	jmp    80272b <nsipc+0x12>

00802765 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	56                   	push   %esi
  802769:	53                   	push   %ebx
  80276a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802775:	8b 06                	mov    (%esi),%eax
  802777:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80277c:	b8 01 00 00 00       	mov    $0x1,%eax
  802781:	e8 93 ff ff ff       	call   802719 <nsipc>
  802786:	89 c3                	mov    %eax,%ebx
  802788:	85 c0                	test   %eax,%eax
  80278a:	79 09                	jns    802795 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80278c:	89 d8                	mov    %ebx,%eax
  80278e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802795:	83 ec 04             	sub    $0x4,%esp
  802798:	ff 35 10 70 80 00    	pushl  0x807010
  80279e:	68 00 70 80 00       	push   $0x807000
  8027a3:	ff 75 0c             	pushl  0xc(%ebp)
  8027a6:	e8 d9 e4 ff ff       	call   800c84 <memmove>
		*addrlen = ret->ret_addrlen;
  8027ab:	a1 10 70 80 00       	mov    0x807010,%eax
  8027b0:	89 06                	mov    %eax,(%esi)
  8027b2:	83 c4 10             	add    $0x10,%esp
	return r;
  8027b5:	eb d5                	jmp    80278c <nsipc_accept+0x27>

008027b7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	53                   	push   %ebx
  8027bb:	83 ec 08             	sub    $0x8,%esp
  8027be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8027c9:	53                   	push   %ebx
  8027ca:	ff 75 0c             	pushl  0xc(%ebp)
  8027cd:	68 04 70 80 00       	push   $0x807004
  8027d2:	e8 ad e4 ff ff       	call   800c84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8027d7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8027dd:	b8 02 00 00 00       	mov    $0x2,%eax
  8027e2:	e8 32 ff ff ff       	call   802719 <nsipc>
}
  8027e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8027fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027fd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802802:	b8 03 00 00 00       	mov    $0x3,%eax
  802807:	e8 0d ff ff ff       	call   802719 <nsipc>
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <nsipc_close>:

int
nsipc_close(int s)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80281c:	b8 04 00 00 00       	mov    $0x4,%eax
  802821:	e8 f3 fe ff ff       	call   802719 <nsipc>
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	53                   	push   %ebx
  80282c:	83 ec 08             	sub    $0x8,%esp
  80282f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80283a:	53                   	push   %ebx
  80283b:	ff 75 0c             	pushl  0xc(%ebp)
  80283e:	68 04 70 80 00       	push   $0x807004
  802843:	e8 3c e4 ff ff       	call   800c84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802848:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80284e:	b8 05 00 00 00       	mov    $0x5,%eax
  802853:	e8 c1 fe ff ff       	call   802719 <nsipc>
}
  802858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80286b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802873:	b8 06 00 00 00       	mov    $0x6,%eax
  802878:	e8 9c fe ff ff       	call   802719 <nsipc>
}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	56                   	push   %esi
  802883:	53                   	push   %ebx
  802884:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80288f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802895:	8b 45 14             	mov    0x14(%ebp),%eax
  802898:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80289d:	b8 07 00 00 00       	mov    $0x7,%eax
  8028a2:	e8 72 fe ff ff       	call   802719 <nsipc>
  8028a7:	89 c3                	mov    %eax,%ebx
  8028a9:	85 c0                	test   %eax,%eax
  8028ab:	78 1f                	js     8028cc <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8028ad:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8028b2:	7f 21                	jg     8028d5 <nsipc_recv+0x56>
  8028b4:	39 c6                	cmp    %eax,%esi
  8028b6:	7c 1d                	jl     8028d5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	50                   	push   %eax
  8028bc:	68 00 70 80 00       	push   $0x807000
  8028c1:	ff 75 0c             	pushl  0xc(%ebp)
  8028c4:	e8 bb e3 ff ff       	call   800c84 <memmove>
  8028c9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8028cc:	89 d8                	mov    %ebx,%eax
  8028ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028d1:	5b                   	pop    %ebx
  8028d2:	5e                   	pop    %esi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8028d5:	68 52 3a 80 00       	push   $0x803a52
  8028da:	68 3b 39 80 00       	push   $0x80393b
  8028df:	6a 62                	push   $0x62
  8028e1:	68 67 3a 80 00       	push   $0x803a67
  8028e6:	e8 b6 d9 ff ff       	call   8002a1 <_panic>

008028eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
  8028ee:	53                   	push   %ebx
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8028fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802903:	7f 2e                	jg     802933 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	53                   	push   %ebx
  802909:	ff 75 0c             	pushl  0xc(%ebp)
  80290c:	68 0c 70 80 00       	push   $0x80700c
  802911:	e8 6e e3 ff ff       	call   800c84 <memmove>
	nsipcbuf.send.req_size = size;
  802916:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80291c:	8b 45 14             	mov    0x14(%ebp),%eax
  80291f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802924:	b8 08 00 00 00       	mov    $0x8,%eax
  802929:	e8 eb fd ff ff       	call   802719 <nsipc>
}
  80292e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802931:	c9                   	leave  
  802932:	c3                   	ret    
	assert(size < 1600);
  802933:	68 73 3a 80 00       	push   $0x803a73
  802938:	68 3b 39 80 00       	push   $0x80393b
  80293d:	6a 6d                	push   $0x6d
  80293f:	68 67 3a 80 00       	push   $0x803a67
  802944:	e8 58 d9 ff ff       	call   8002a1 <_panic>

00802949 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295a:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80295f:	8b 45 10             	mov    0x10(%ebp),%eax
  802962:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802967:	b8 09 00 00 00       	mov    $0x9,%eax
  80296c:	e8 a8 fd ff ff       	call   802719 <nsipc>
}
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
  802976:	56                   	push   %esi
  802977:	53                   	push   %ebx
  802978:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80297b:	83 ec 0c             	sub    $0xc,%esp
  80297e:	ff 75 08             	pushl  0x8(%ebp)
  802981:	e8 4e ed ff ff       	call   8016d4 <fd2data>
  802986:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802988:	83 c4 08             	add    $0x8,%esp
  80298b:	68 7f 3a 80 00       	push   $0x803a7f
  802990:	53                   	push   %ebx
  802991:	e8 60 e1 ff ff       	call   800af6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802996:	8b 46 04             	mov    0x4(%esi),%eax
  802999:	2b 06                	sub    (%esi),%eax
  80299b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8029a1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8029a8:	00 00 00 
	stat->st_dev = &devpipe;
  8029ab:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8029b2:	40 80 00 
	return 0;
}
  8029b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029bd:	5b                   	pop    %ebx
  8029be:	5e                   	pop    %esi
  8029bf:	5d                   	pop    %ebp
  8029c0:	c3                   	ret    

008029c1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
  8029c4:	53                   	push   %ebx
  8029c5:	83 ec 0c             	sub    $0xc,%esp
  8029c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8029cb:	53                   	push   %ebx
  8029cc:	6a 00                	push   $0x0
  8029ce:	e8 9a e5 ff ff       	call   800f6d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8029d3:	89 1c 24             	mov    %ebx,(%esp)
  8029d6:	e8 f9 ec ff ff       	call   8016d4 <fd2data>
  8029db:	83 c4 08             	add    $0x8,%esp
  8029de:	50                   	push   %eax
  8029df:	6a 00                	push   $0x0
  8029e1:	e8 87 e5 ff ff       	call   800f6d <sys_page_unmap>
}
  8029e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    

008029eb <_pipeisclosed>:
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
  8029ee:	57                   	push   %edi
  8029ef:	56                   	push   %esi
  8029f0:	53                   	push   %ebx
  8029f1:	83 ec 1c             	sub    $0x1c,%esp
  8029f4:	89 c7                	mov    %eax,%edi
  8029f6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8029f8:	a1 08 50 80 00       	mov    0x805008,%eax
  8029fd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802a00:	83 ec 0c             	sub    $0xc,%esp
  802a03:	57                   	push   %edi
  802a04:	e8 0d 06 00 00       	call   803016 <pageref>
  802a09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a0c:	89 34 24             	mov    %esi,(%esp)
  802a0f:	e8 02 06 00 00       	call   803016 <pageref>
		nn = thisenv->env_runs;
  802a14:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802a1a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802a1d:	83 c4 10             	add    $0x10,%esp
  802a20:	39 cb                	cmp    %ecx,%ebx
  802a22:	74 1b                	je     802a3f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802a24:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802a27:	75 cf                	jne    8029f8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802a29:	8b 42 58             	mov    0x58(%edx),%eax
  802a2c:	6a 01                	push   $0x1
  802a2e:	50                   	push   %eax
  802a2f:	53                   	push   %ebx
  802a30:	68 86 3a 80 00       	push   $0x803a86
  802a35:	e8 5d d9 ff ff       	call   800397 <cprintf>
  802a3a:	83 c4 10             	add    $0x10,%esp
  802a3d:	eb b9                	jmp    8029f8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802a3f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802a42:	0f 94 c0             	sete   %al
  802a45:	0f b6 c0             	movzbl %al,%eax
}
  802a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a4b:	5b                   	pop    %ebx
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    

00802a50 <devpipe_write>:
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
  802a53:	57                   	push   %edi
  802a54:	56                   	push   %esi
  802a55:	53                   	push   %ebx
  802a56:	83 ec 28             	sub    $0x28,%esp
  802a59:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802a5c:	56                   	push   %esi
  802a5d:	e8 72 ec ff ff       	call   8016d4 <fd2data>
  802a62:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a64:	83 c4 10             	add    $0x10,%esp
  802a67:	bf 00 00 00 00       	mov    $0x0,%edi
  802a6c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a6f:	74 4f                	je     802ac0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a71:	8b 43 04             	mov    0x4(%ebx),%eax
  802a74:	8b 0b                	mov    (%ebx),%ecx
  802a76:	8d 51 20             	lea    0x20(%ecx),%edx
  802a79:	39 d0                	cmp    %edx,%eax
  802a7b:	72 14                	jb     802a91 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802a7d:	89 da                	mov    %ebx,%edx
  802a7f:	89 f0                	mov    %esi,%eax
  802a81:	e8 65 ff ff ff       	call   8029eb <_pipeisclosed>
  802a86:	85 c0                	test   %eax,%eax
  802a88:	75 3b                	jne    802ac5 <devpipe_write+0x75>
			sys_yield();
  802a8a:	e8 3a e4 ff ff       	call   800ec9 <sys_yield>
  802a8f:	eb e0                	jmp    802a71 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a94:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802a98:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802a9b:	89 c2                	mov    %eax,%edx
  802a9d:	c1 fa 1f             	sar    $0x1f,%edx
  802aa0:	89 d1                	mov    %edx,%ecx
  802aa2:	c1 e9 1b             	shr    $0x1b,%ecx
  802aa5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802aa8:	83 e2 1f             	and    $0x1f,%edx
  802aab:	29 ca                	sub    %ecx,%edx
  802aad:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802ab1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802ab5:	83 c0 01             	add    $0x1,%eax
  802ab8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802abb:	83 c7 01             	add    $0x1,%edi
  802abe:	eb ac                	jmp    802a6c <devpipe_write+0x1c>
	return i;
  802ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ac3:	eb 05                	jmp    802aca <devpipe_write+0x7a>
				return 0;
  802ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802acd:	5b                   	pop    %ebx
  802ace:	5e                   	pop    %esi
  802acf:	5f                   	pop    %edi
  802ad0:	5d                   	pop    %ebp
  802ad1:	c3                   	ret    

00802ad2 <devpipe_read>:
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
  802ad5:	57                   	push   %edi
  802ad6:	56                   	push   %esi
  802ad7:	53                   	push   %ebx
  802ad8:	83 ec 18             	sub    $0x18,%esp
  802adb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802ade:	57                   	push   %edi
  802adf:	e8 f0 eb ff ff       	call   8016d4 <fd2data>
  802ae4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802ae6:	83 c4 10             	add    $0x10,%esp
  802ae9:	be 00 00 00 00       	mov    $0x0,%esi
  802aee:	3b 75 10             	cmp    0x10(%ebp),%esi
  802af1:	75 14                	jne    802b07 <devpipe_read+0x35>
	return i;
  802af3:	8b 45 10             	mov    0x10(%ebp),%eax
  802af6:	eb 02                	jmp    802afa <devpipe_read+0x28>
				return i;
  802af8:	89 f0                	mov    %esi,%eax
}
  802afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802afd:	5b                   	pop    %ebx
  802afe:	5e                   	pop    %esi
  802aff:	5f                   	pop    %edi
  802b00:	5d                   	pop    %ebp
  802b01:	c3                   	ret    
			sys_yield();
  802b02:	e8 c2 e3 ff ff       	call   800ec9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802b07:	8b 03                	mov    (%ebx),%eax
  802b09:	3b 43 04             	cmp    0x4(%ebx),%eax
  802b0c:	75 18                	jne    802b26 <devpipe_read+0x54>
			if (i > 0)
  802b0e:	85 f6                	test   %esi,%esi
  802b10:	75 e6                	jne    802af8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802b12:	89 da                	mov    %ebx,%edx
  802b14:	89 f8                	mov    %edi,%eax
  802b16:	e8 d0 fe ff ff       	call   8029eb <_pipeisclosed>
  802b1b:	85 c0                	test   %eax,%eax
  802b1d:	74 e3                	je     802b02 <devpipe_read+0x30>
				return 0;
  802b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b24:	eb d4                	jmp    802afa <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b26:	99                   	cltd   
  802b27:	c1 ea 1b             	shr    $0x1b,%edx
  802b2a:	01 d0                	add    %edx,%eax
  802b2c:	83 e0 1f             	and    $0x1f,%eax
  802b2f:	29 d0                	sub    %edx,%eax
  802b31:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802b36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b39:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802b3c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802b3f:	83 c6 01             	add    $0x1,%esi
  802b42:	eb aa                	jmp    802aee <devpipe_read+0x1c>

00802b44 <pipe>:
{
  802b44:	55                   	push   %ebp
  802b45:	89 e5                	mov    %esp,%ebp
  802b47:	56                   	push   %esi
  802b48:	53                   	push   %ebx
  802b49:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802b4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b4f:	50                   	push   %eax
  802b50:	e8 96 eb ff ff       	call   8016eb <fd_alloc>
  802b55:	89 c3                	mov    %eax,%ebx
  802b57:	83 c4 10             	add    $0x10,%esp
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	0f 88 23 01 00 00    	js     802c85 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b62:	83 ec 04             	sub    $0x4,%esp
  802b65:	68 07 04 00 00       	push   $0x407
  802b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  802b6d:	6a 00                	push   $0x0
  802b6f:	e8 74 e3 ff ff       	call   800ee8 <sys_page_alloc>
  802b74:	89 c3                	mov    %eax,%ebx
  802b76:	83 c4 10             	add    $0x10,%esp
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	0f 88 04 01 00 00    	js     802c85 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802b81:	83 ec 0c             	sub    $0xc,%esp
  802b84:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b87:	50                   	push   %eax
  802b88:	e8 5e eb ff ff       	call   8016eb <fd_alloc>
  802b8d:	89 c3                	mov    %eax,%ebx
  802b8f:	83 c4 10             	add    $0x10,%esp
  802b92:	85 c0                	test   %eax,%eax
  802b94:	0f 88 db 00 00 00    	js     802c75 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	68 07 04 00 00       	push   $0x407
  802ba2:	ff 75 f0             	pushl  -0x10(%ebp)
  802ba5:	6a 00                	push   $0x0
  802ba7:	e8 3c e3 ff ff       	call   800ee8 <sys_page_alloc>
  802bac:	89 c3                	mov    %eax,%ebx
  802bae:	83 c4 10             	add    $0x10,%esp
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	0f 88 bc 00 00 00    	js     802c75 <pipe+0x131>
	va = fd2data(fd0);
  802bb9:	83 ec 0c             	sub    $0xc,%esp
  802bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  802bbf:	e8 10 eb ff ff       	call   8016d4 <fd2data>
  802bc4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bc6:	83 c4 0c             	add    $0xc,%esp
  802bc9:	68 07 04 00 00       	push   $0x407
  802bce:	50                   	push   %eax
  802bcf:	6a 00                	push   $0x0
  802bd1:	e8 12 e3 ff ff       	call   800ee8 <sys_page_alloc>
  802bd6:	89 c3                	mov    %eax,%ebx
  802bd8:	83 c4 10             	add    $0x10,%esp
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	0f 88 82 00 00 00    	js     802c65 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802be3:	83 ec 0c             	sub    $0xc,%esp
  802be6:	ff 75 f0             	pushl  -0x10(%ebp)
  802be9:	e8 e6 ea ff ff       	call   8016d4 <fd2data>
  802bee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802bf5:	50                   	push   %eax
  802bf6:	6a 00                	push   $0x0
  802bf8:	56                   	push   %esi
  802bf9:	6a 00                	push   $0x0
  802bfb:	e8 2b e3 ff ff       	call   800f2b <sys_page_map>
  802c00:	89 c3                	mov    %eax,%ebx
  802c02:	83 c4 20             	add    $0x20,%esp
  802c05:	85 c0                	test   %eax,%eax
  802c07:	78 4e                	js     802c57 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802c09:	a1 44 40 80 00       	mov    0x804044,%eax
  802c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c11:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802c13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c16:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802c1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c20:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c25:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802c2c:	83 ec 0c             	sub    $0xc,%esp
  802c2f:	ff 75 f4             	pushl  -0xc(%ebp)
  802c32:	e8 8d ea ff ff       	call   8016c4 <fd2num>
  802c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c3a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802c3c:	83 c4 04             	add    $0x4,%esp
  802c3f:	ff 75 f0             	pushl  -0x10(%ebp)
  802c42:	e8 7d ea ff ff       	call   8016c4 <fd2num>
  802c47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c4a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802c4d:	83 c4 10             	add    $0x10,%esp
  802c50:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c55:	eb 2e                	jmp    802c85 <pipe+0x141>
	sys_page_unmap(0, va);
  802c57:	83 ec 08             	sub    $0x8,%esp
  802c5a:	56                   	push   %esi
  802c5b:	6a 00                	push   $0x0
  802c5d:	e8 0b e3 ff ff       	call   800f6d <sys_page_unmap>
  802c62:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802c65:	83 ec 08             	sub    $0x8,%esp
  802c68:	ff 75 f0             	pushl  -0x10(%ebp)
  802c6b:	6a 00                	push   $0x0
  802c6d:	e8 fb e2 ff ff       	call   800f6d <sys_page_unmap>
  802c72:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802c75:	83 ec 08             	sub    $0x8,%esp
  802c78:	ff 75 f4             	pushl  -0xc(%ebp)
  802c7b:	6a 00                	push   $0x0
  802c7d:	e8 eb e2 ff ff       	call   800f6d <sys_page_unmap>
  802c82:	83 c4 10             	add    $0x10,%esp
}
  802c85:	89 d8                	mov    %ebx,%eax
  802c87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c8a:	5b                   	pop    %ebx
  802c8b:	5e                   	pop    %esi
  802c8c:	5d                   	pop    %ebp
  802c8d:	c3                   	ret    

00802c8e <pipeisclosed>:
{
  802c8e:	55                   	push   %ebp
  802c8f:	89 e5                	mov    %esp,%ebp
  802c91:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c97:	50                   	push   %eax
  802c98:	ff 75 08             	pushl  0x8(%ebp)
  802c9b:	e8 9d ea ff ff       	call   80173d <fd_lookup>
  802ca0:	83 c4 10             	add    $0x10,%esp
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	78 18                	js     802cbf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802ca7:	83 ec 0c             	sub    $0xc,%esp
  802caa:	ff 75 f4             	pushl  -0xc(%ebp)
  802cad:	e8 22 ea ff ff       	call   8016d4 <fd2data>
	return _pipeisclosed(fd, p);
  802cb2:	89 c2                	mov    %eax,%edx
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	e8 2f fd ff ff       	call   8029eb <_pipeisclosed>
  802cbc:	83 c4 10             	add    $0x10,%esp
}
  802cbf:	c9                   	leave  
  802cc0:	c3                   	ret    

00802cc1 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802cc1:	55                   	push   %ebp
  802cc2:	89 e5                	mov    %esp,%ebp
  802cc4:	56                   	push   %esi
  802cc5:	53                   	push   %ebx
  802cc6:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802cc9:	85 f6                	test   %esi,%esi
  802ccb:	74 13                	je     802ce0 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802ccd:	89 f3                	mov    %esi,%ebx
  802ccf:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cd5:	c1 e3 07             	shl    $0x7,%ebx
  802cd8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802cde:	eb 1b                	jmp    802cfb <wait+0x3a>
	assert(envid != 0);
  802ce0:	68 9e 3a 80 00       	push   $0x803a9e
  802ce5:	68 3b 39 80 00       	push   $0x80393b
  802cea:	6a 09                	push   $0x9
  802cec:	68 a9 3a 80 00       	push   $0x803aa9
  802cf1:	e8 ab d5 ff ff       	call   8002a1 <_panic>
		sys_yield();
  802cf6:	e8 ce e1 ff ff       	call   800ec9 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cfb:	8b 43 48             	mov    0x48(%ebx),%eax
  802cfe:	39 f0                	cmp    %esi,%eax
  802d00:	75 07                	jne    802d09 <wait+0x48>
  802d02:	8b 43 54             	mov    0x54(%ebx),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	75 ed                	jne    802cf6 <wait+0x35>
}
  802d09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d0c:	5b                   	pop    %ebx
  802d0d:	5e                   	pop    %esi
  802d0e:	5d                   	pop    %ebp
  802d0f:	c3                   	ret    

00802d10 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	c3                   	ret    

00802d16 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802d16:	55                   	push   %ebp
  802d17:	89 e5                	mov    %esp,%ebp
  802d19:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802d1c:	68 b4 3a 80 00       	push   $0x803ab4
  802d21:	ff 75 0c             	pushl  0xc(%ebp)
  802d24:	e8 cd dd ff ff       	call   800af6 <strcpy>
	return 0;
}
  802d29:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2e:	c9                   	leave  
  802d2f:	c3                   	ret    

00802d30 <devcons_write>:
{
  802d30:	55                   	push   %ebp
  802d31:	89 e5                	mov    %esp,%ebp
  802d33:	57                   	push   %edi
  802d34:	56                   	push   %esi
  802d35:	53                   	push   %ebx
  802d36:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802d3c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802d41:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802d47:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d4a:	73 31                	jae    802d7d <devcons_write+0x4d>
		m = n - tot;
  802d4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802d4f:	29 f3                	sub    %esi,%ebx
  802d51:	83 fb 7f             	cmp    $0x7f,%ebx
  802d54:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d59:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802d5c:	83 ec 04             	sub    $0x4,%esp
  802d5f:	53                   	push   %ebx
  802d60:	89 f0                	mov    %esi,%eax
  802d62:	03 45 0c             	add    0xc(%ebp),%eax
  802d65:	50                   	push   %eax
  802d66:	57                   	push   %edi
  802d67:	e8 18 df ff ff       	call   800c84 <memmove>
		sys_cputs(buf, m);
  802d6c:	83 c4 08             	add    $0x8,%esp
  802d6f:	53                   	push   %ebx
  802d70:	57                   	push   %edi
  802d71:	e8 b6 e0 ff ff       	call   800e2c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802d76:	01 de                	add    %ebx,%esi
  802d78:	83 c4 10             	add    $0x10,%esp
  802d7b:	eb ca                	jmp    802d47 <devcons_write+0x17>
}
  802d7d:	89 f0                	mov    %esi,%eax
  802d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d82:	5b                   	pop    %ebx
  802d83:	5e                   	pop    %esi
  802d84:	5f                   	pop    %edi
  802d85:	5d                   	pop    %ebp
  802d86:	c3                   	ret    

00802d87 <devcons_read>:
{
  802d87:	55                   	push   %ebp
  802d88:	89 e5                	mov    %esp,%ebp
  802d8a:	83 ec 08             	sub    $0x8,%esp
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802d92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d96:	74 21                	je     802db9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802d98:	e8 ad e0 ff ff       	call   800e4a <sys_cgetc>
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	75 07                	jne    802da8 <devcons_read+0x21>
		sys_yield();
  802da1:	e8 23 e1 ff ff       	call   800ec9 <sys_yield>
  802da6:	eb f0                	jmp    802d98 <devcons_read+0x11>
	if (c < 0)
  802da8:	78 0f                	js     802db9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802daa:	83 f8 04             	cmp    $0x4,%eax
  802dad:	74 0c                	je     802dbb <devcons_read+0x34>
	*(char*)vbuf = c;
  802daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db2:	88 02                	mov    %al,(%edx)
	return 1;
  802db4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802db9:	c9                   	leave  
  802dba:	c3                   	ret    
		return 0;
  802dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc0:	eb f7                	jmp    802db9 <devcons_read+0x32>

00802dc2 <cputchar>:
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
  802dc5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802dce:	6a 01                	push   $0x1
  802dd0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802dd3:	50                   	push   %eax
  802dd4:	e8 53 e0 ff ff       	call   800e2c <sys_cputs>
}
  802dd9:	83 c4 10             	add    $0x10,%esp
  802ddc:	c9                   	leave  
  802ddd:	c3                   	ret    

00802dde <getchar>:
{
  802dde:	55                   	push   %ebp
  802ddf:	89 e5                	mov    %esp,%ebp
  802de1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802de4:	6a 01                	push   $0x1
  802de6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802de9:	50                   	push   %eax
  802dea:	6a 00                	push   $0x0
  802dec:	e8 bc eb ff ff       	call   8019ad <read>
	if (r < 0)
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	85 c0                	test   %eax,%eax
  802df6:	78 06                	js     802dfe <getchar+0x20>
	if (r < 1)
  802df8:	74 06                	je     802e00 <getchar+0x22>
	return c;
  802dfa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802dfe:	c9                   	leave  
  802dff:	c3                   	ret    
		return -E_EOF;
  802e00:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802e05:	eb f7                	jmp    802dfe <getchar+0x20>

00802e07 <iscons>:
{
  802e07:	55                   	push   %ebp
  802e08:	89 e5                	mov    %esp,%ebp
  802e0a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e10:	50                   	push   %eax
  802e11:	ff 75 08             	pushl  0x8(%ebp)
  802e14:	e8 24 e9 ff ff       	call   80173d <fd_lookup>
  802e19:	83 c4 10             	add    $0x10,%esp
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	78 11                	js     802e31 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802e29:	39 10                	cmp    %edx,(%eax)
  802e2b:	0f 94 c0             	sete   %al
  802e2e:	0f b6 c0             	movzbl %al,%eax
}
  802e31:	c9                   	leave  
  802e32:	c3                   	ret    

00802e33 <opencons>:
{
  802e33:	55                   	push   %ebp
  802e34:	89 e5                	mov    %esp,%ebp
  802e36:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802e39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e3c:	50                   	push   %eax
  802e3d:	e8 a9 e8 ff ff       	call   8016eb <fd_alloc>
  802e42:	83 c4 10             	add    $0x10,%esp
  802e45:	85 c0                	test   %eax,%eax
  802e47:	78 3a                	js     802e83 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802e49:	83 ec 04             	sub    $0x4,%esp
  802e4c:	68 07 04 00 00       	push   $0x407
  802e51:	ff 75 f4             	pushl  -0xc(%ebp)
  802e54:	6a 00                	push   $0x0
  802e56:	e8 8d e0 ff ff       	call   800ee8 <sys_page_alloc>
  802e5b:	83 c4 10             	add    $0x10,%esp
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	78 21                	js     802e83 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802e6b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802e77:	83 ec 0c             	sub    $0xc,%esp
  802e7a:	50                   	push   %eax
  802e7b:	e8 44 e8 ff ff       	call   8016c4 <fd2num>
  802e80:	83 c4 10             	add    $0x10,%esp
}
  802e83:	c9                   	leave  
  802e84:	c3                   	ret    

00802e85 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e85:	55                   	push   %ebp
  802e86:	89 e5                	mov    %esp,%ebp
  802e88:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e8b:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802e92:	74 0a                	je     802e9e <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802e9c:	c9                   	leave  
  802e9d:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802e9e:	83 ec 04             	sub    $0x4,%esp
  802ea1:	6a 07                	push   $0x7
  802ea3:	68 00 f0 bf ee       	push   $0xeebff000
  802ea8:	6a 00                	push   $0x0
  802eaa:	e8 39 e0 ff ff       	call   800ee8 <sys_page_alloc>
		if(r < 0)
  802eaf:	83 c4 10             	add    $0x10,%esp
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	78 2a                	js     802ee0 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802eb6:	83 ec 08             	sub    $0x8,%esp
  802eb9:	68 f4 2e 80 00       	push   $0x802ef4
  802ebe:	6a 00                	push   $0x0
  802ec0:	e8 6e e1 ff ff       	call   801033 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802ec5:	83 c4 10             	add    $0x10,%esp
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	79 c8                	jns    802e94 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802ecc:	83 ec 04             	sub    $0x4,%esp
  802ecf:	68 f0 3a 80 00       	push   $0x803af0
  802ed4:	6a 25                	push   $0x25
  802ed6:	68 2c 3b 80 00       	push   $0x803b2c
  802edb:	e8 c1 d3 ff ff       	call   8002a1 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802ee0:	83 ec 04             	sub    $0x4,%esp
  802ee3:	68 c0 3a 80 00       	push   $0x803ac0
  802ee8:	6a 22                	push   $0x22
  802eea:	68 2c 3b 80 00       	push   $0x803b2c
  802eef:	e8 ad d3 ff ff       	call   8002a1 <_panic>

00802ef4 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ef4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ef5:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802efa:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802efc:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802eff:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802f03:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802f07:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802f0a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802f0c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802f10:	83 c4 08             	add    $0x8,%esp
	popal
  802f13:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802f14:	83 c4 04             	add    $0x4,%esp
	popfl
  802f17:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802f18:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802f19:	c3                   	ret    

00802f1a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802f1a:	55                   	push   %ebp
  802f1b:	89 e5                	mov    %esp,%ebp
  802f1d:	56                   	push   %esi
  802f1e:	53                   	push   %ebx
  802f1f:	8b 75 08             	mov    0x8(%ebp),%esi
  802f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f25:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802f28:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802f2a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802f2f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802f32:	83 ec 0c             	sub    $0xc,%esp
  802f35:	50                   	push   %eax
  802f36:	e8 5d e1 ff ff       	call   801098 <sys_ipc_recv>
	if(ret < 0){
  802f3b:	83 c4 10             	add    $0x10,%esp
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	78 2b                	js     802f6d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802f42:	85 f6                	test   %esi,%esi
  802f44:	74 0a                	je     802f50 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802f46:	a1 08 50 80 00       	mov    0x805008,%eax
  802f4b:	8b 40 74             	mov    0x74(%eax),%eax
  802f4e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802f50:	85 db                	test   %ebx,%ebx
  802f52:	74 0a                	je     802f5e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802f54:	a1 08 50 80 00       	mov    0x805008,%eax
  802f59:	8b 40 78             	mov    0x78(%eax),%eax
  802f5c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802f5e:	a1 08 50 80 00       	mov    0x805008,%eax
  802f63:	8b 40 70             	mov    0x70(%eax),%eax
}
  802f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f69:	5b                   	pop    %ebx
  802f6a:	5e                   	pop    %esi
  802f6b:	5d                   	pop    %ebp
  802f6c:	c3                   	ret    
		if(from_env_store)
  802f6d:	85 f6                	test   %esi,%esi
  802f6f:	74 06                	je     802f77 <ipc_recv+0x5d>
			*from_env_store = 0;
  802f71:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802f77:	85 db                	test   %ebx,%ebx
  802f79:	74 eb                	je     802f66 <ipc_recv+0x4c>
			*perm_store = 0;
  802f7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802f81:	eb e3                	jmp    802f66 <ipc_recv+0x4c>

00802f83 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802f83:	55                   	push   %ebp
  802f84:	89 e5                	mov    %esp,%ebp
  802f86:	57                   	push   %edi
  802f87:	56                   	push   %esi
  802f88:	53                   	push   %ebx
  802f89:	83 ec 0c             	sub    $0xc,%esp
  802f8c:	8b 7d 08             	mov    0x8(%ebp),%edi
  802f8f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802f95:	85 db                	test   %ebx,%ebx
  802f97:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802f9c:	0f 44 d8             	cmove  %eax,%ebx
  802f9f:	eb 05                	jmp    802fa6 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802fa1:	e8 23 df ff ff       	call   800ec9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802fa6:	ff 75 14             	pushl  0x14(%ebp)
  802fa9:	53                   	push   %ebx
  802faa:	56                   	push   %esi
  802fab:	57                   	push   %edi
  802fac:	e8 c4 e0 ff ff       	call   801075 <sys_ipc_try_send>
  802fb1:	83 c4 10             	add    $0x10,%esp
  802fb4:	85 c0                	test   %eax,%eax
  802fb6:	74 1b                	je     802fd3 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802fb8:	79 e7                	jns    802fa1 <ipc_send+0x1e>
  802fba:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802fbd:	74 e2                	je     802fa1 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802fbf:	83 ec 04             	sub    $0x4,%esp
  802fc2:	68 3a 3b 80 00       	push   $0x803b3a
  802fc7:	6a 46                	push   $0x46
  802fc9:	68 4f 3b 80 00       	push   $0x803b4f
  802fce:	e8 ce d2 ff ff       	call   8002a1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802fd6:	5b                   	pop    %ebx
  802fd7:	5e                   	pop    %esi
  802fd8:	5f                   	pop    %edi
  802fd9:	5d                   	pop    %ebp
  802fda:	c3                   	ret    

00802fdb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802fdb:	55                   	push   %ebp
  802fdc:	89 e5                	mov    %esp,%ebp
  802fde:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802fe1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802fe6:	89 c2                	mov    %eax,%edx
  802fe8:	c1 e2 07             	shl    $0x7,%edx
  802feb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ff1:	8b 52 50             	mov    0x50(%edx),%edx
  802ff4:	39 ca                	cmp    %ecx,%edx
  802ff6:	74 11                	je     803009 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802ff8:	83 c0 01             	add    $0x1,%eax
  802ffb:	3d 00 04 00 00       	cmp    $0x400,%eax
  803000:	75 e4                	jne    802fe6 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  803002:	b8 00 00 00 00       	mov    $0x0,%eax
  803007:	eb 0b                	jmp    803014 <ipc_find_env+0x39>
			return envs[i].env_id;
  803009:	c1 e0 07             	shl    $0x7,%eax
  80300c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803011:	8b 40 48             	mov    0x48(%eax),%eax
}
  803014:	5d                   	pop    %ebp
  803015:	c3                   	ret    

00803016 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803016:	55                   	push   %ebp
  803017:	89 e5                	mov    %esp,%ebp
  803019:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80301c:	89 d0                	mov    %edx,%eax
  80301e:	c1 e8 16             	shr    $0x16,%eax
  803021:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803028:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80302d:	f6 c1 01             	test   $0x1,%cl
  803030:	74 1d                	je     80304f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  803032:	c1 ea 0c             	shr    $0xc,%edx
  803035:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80303c:	f6 c2 01             	test   $0x1,%dl
  80303f:	74 0e                	je     80304f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803041:	c1 ea 0c             	shr    $0xc,%edx
  803044:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80304b:	ef 
  80304c:	0f b7 c0             	movzwl %ax,%eax
}
  80304f:	5d                   	pop    %ebp
  803050:	c3                   	ret    
  803051:	66 90                	xchg   %ax,%ax
  803053:	66 90                	xchg   %ax,%ax
  803055:	66 90                	xchg   %ax,%ax
  803057:	66 90                	xchg   %ax,%ax
  803059:	66 90                	xchg   %ax,%ax
  80305b:	66 90                	xchg   %ax,%ax
  80305d:	66 90                	xchg   %ax,%ax
  80305f:	90                   	nop

00803060 <__udivdi3>:
  803060:	55                   	push   %ebp
  803061:	57                   	push   %edi
  803062:	56                   	push   %esi
  803063:	53                   	push   %ebx
  803064:	83 ec 1c             	sub    $0x1c,%esp
  803067:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80306b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80306f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803073:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803077:	85 d2                	test   %edx,%edx
  803079:	75 4d                	jne    8030c8 <__udivdi3+0x68>
  80307b:	39 f3                	cmp    %esi,%ebx
  80307d:	76 19                	jbe    803098 <__udivdi3+0x38>
  80307f:	31 ff                	xor    %edi,%edi
  803081:	89 e8                	mov    %ebp,%eax
  803083:	89 f2                	mov    %esi,%edx
  803085:	f7 f3                	div    %ebx
  803087:	89 fa                	mov    %edi,%edx
  803089:	83 c4 1c             	add    $0x1c,%esp
  80308c:	5b                   	pop    %ebx
  80308d:	5e                   	pop    %esi
  80308e:	5f                   	pop    %edi
  80308f:	5d                   	pop    %ebp
  803090:	c3                   	ret    
  803091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803098:	89 d9                	mov    %ebx,%ecx
  80309a:	85 db                	test   %ebx,%ebx
  80309c:	75 0b                	jne    8030a9 <__udivdi3+0x49>
  80309e:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a3:	31 d2                	xor    %edx,%edx
  8030a5:	f7 f3                	div    %ebx
  8030a7:	89 c1                	mov    %eax,%ecx
  8030a9:	31 d2                	xor    %edx,%edx
  8030ab:	89 f0                	mov    %esi,%eax
  8030ad:	f7 f1                	div    %ecx
  8030af:	89 c6                	mov    %eax,%esi
  8030b1:	89 e8                	mov    %ebp,%eax
  8030b3:	89 f7                	mov    %esi,%edi
  8030b5:	f7 f1                	div    %ecx
  8030b7:	89 fa                	mov    %edi,%edx
  8030b9:	83 c4 1c             	add    $0x1c,%esp
  8030bc:	5b                   	pop    %ebx
  8030bd:	5e                   	pop    %esi
  8030be:	5f                   	pop    %edi
  8030bf:	5d                   	pop    %ebp
  8030c0:	c3                   	ret    
  8030c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030c8:	39 f2                	cmp    %esi,%edx
  8030ca:	77 1c                	ja     8030e8 <__udivdi3+0x88>
  8030cc:	0f bd fa             	bsr    %edx,%edi
  8030cf:	83 f7 1f             	xor    $0x1f,%edi
  8030d2:	75 2c                	jne    803100 <__udivdi3+0xa0>
  8030d4:	39 f2                	cmp    %esi,%edx
  8030d6:	72 06                	jb     8030de <__udivdi3+0x7e>
  8030d8:	31 c0                	xor    %eax,%eax
  8030da:	39 eb                	cmp    %ebp,%ebx
  8030dc:	77 a9                	ja     803087 <__udivdi3+0x27>
  8030de:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e3:	eb a2                	jmp    803087 <__udivdi3+0x27>
  8030e5:	8d 76 00             	lea    0x0(%esi),%esi
  8030e8:	31 ff                	xor    %edi,%edi
  8030ea:	31 c0                	xor    %eax,%eax
  8030ec:	89 fa                	mov    %edi,%edx
  8030ee:	83 c4 1c             	add    $0x1c,%esp
  8030f1:	5b                   	pop    %ebx
  8030f2:	5e                   	pop    %esi
  8030f3:	5f                   	pop    %edi
  8030f4:	5d                   	pop    %ebp
  8030f5:	c3                   	ret    
  8030f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030fd:	8d 76 00             	lea    0x0(%esi),%esi
  803100:	89 f9                	mov    %edi,%ecx
  803102:	b8 20 00 00 00       	mov    $0x20,%eax
  803107:	29 f8                	sub    %edi,%eax
  803109:	d3 e2                	shl    %cl,%edx
  80310b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80310f:	89 c1                	mov    %eax,%ecx
  803111:	89 da                	mov    %ebx,%edx
  803113:	d3 ea                	shr    %cl,%edx
  803115:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803119:	09 d1                	or     %edx,%ecx
  80311b:	89 f2                	mov    %esi,%edx
  80311d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803121:	89 f9                	mov    %edi,%ecx
  803123:	d3 e3                	shl    %cl,%ebx
  803125:	89 c1                	mov    %eax,%ecx
  803127:	d3 ea                	shr    %cl,%edx
  803129:	89 f9                	mov    %edi,%ecx
  80312b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80312f:	89 eb                	mov    %ebp,%ebx
  803131:	d3 e6                	shl    %cl,%esi
  803133:	89 c1                	mov    %eax,%ecx
  803135:	d3 eb                	shr    %cl,%ebx
  803137:	09 de                	or     %ebx,%esi
  803139:	89 f0                	mov    %esi,%eax
  80313b:	f7 74 24 08          	divl   0x8(%esp)
  80313f:	89 d6                	mov    %edx,%esi
  803141:	89 c3                	mov    %eax,%ebx
  803143:	f7 64 24 0c          	mull   0xc(%esp)
  803147:	39 d6                	cmp    %edx,%esi
  803149:	72 15                	jb     803160 <__udivdi3+0x100>
  80314b:	89 f9                	mov    %edi,%ecx
  80314d:	d3 e5                	shl    %cl,%ebp
  80314f:	39 c5                	cmp    %eax,%ebp
  803151:	73 04                	jae    803157 <__udivdi3+0xf7>
  803153:	39 d6                	cmp    %edx,%esi
  803155:	74 09                	je     803160 <__udivdi3+0x100>
  803157:	89 d8                	mov    %ebx,%eax
  803159:	31 ff                	xor    %edi,%edi
  80315b:	e9 27 ff ff ff       	jmp    803087 <__udivdi3+0x27>
  803160:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803163:	31 ff                	xor    %edi,%edi
  803165:	e9 1d ff ff ff       	jmp    803087 <__udivdi3+0x27>
  80316a:	66 90                	xchg   %ax,%ax
  80316c:	66 90                	xchg   %ax,%ax
  80316e:	66 90                	xchg   %ax,%ax

00803170 <__umoddi3>:
  803170:	55                   	push   %ebp
  803171:	57                   	push   %edi
  803172:	56                   	push   %esi
  803173:	53                   	push   %ebx
  803174:	83 ec 1c             	sub    $0x1c,%esp
  803177:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80317b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80317f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803187:	89 da                	mov    %ebx,%edx
  803189:	85 c0                	test   %eax,%eax
  80318b:	75 43                	jne    8031d0 <__umoddi3+0x60>
  80318d:	39 df                	cmp    %ebx,%edi
  80318f:	76 17                	jbe    8031a8 <__umoddi3+0x38>
  803191:	89 f0                	mov    %esi,%eax
  803193:	f7 f7                	div    %edi
  803195:	89 d0                	mov    %edx,%eax
  803197:	31 d2                	xor    %edx,%edx
  803199:	83 c4 1c             	add    $0x1c,%esp
  80319c:	5b                   	pop    %ebx
  80319d:	5e                   	pop    %esi
  80319e:	5f                   	pop    %edi
  80319f:	5d                   	pop    %ebp
  8031a0:	c3                   	ret    
  8031a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031a8:	89 fd                	mov    %edi,%ebp
  8031aa:	85 ff                	test   %edi,%edi
  8031ac:	75 0b                	jne    8031b9 <__umoddi3+0x49>
  8031ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8031b3:	31 d2                	xor    %edx,%edx
  8031b5:	f7 f7                	div    %edi
  8031b7:	89 c5                	mov    %eax,%ebp
  8031b9:	89 d8                	mov    %ebx,%eax
  8031bb:	31 d2                	xor    %edx,%edx
  8031bd:	f7 f5                	div    %ebp
  8031bf:	89 f0                	mov    %esi,%eax
  8031c1:	f7 f5                	div    %ebp
  8031c3:	89 d0                	mov    %edx,%eax
  8031c5:	eb d0                	jmp    803197 <__umoddi3+0x27>
  8031c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031ce:	66 90                	xchg   %ax,%ax
  8031d0:	89 f1                	mov    %esi,%ecx
  8031d2:	39 d8                	cmp    %ebx,%eax
  8031d4:	76 0a                	jbe    8031e0 <__umoddi3+0x70>
  8031d6:	89 f0                	mov    %esi,%eax
  8031d8:	83 c4 1c             	add    $0x1c,%esp
  8031db:	5b                   	pop    %ebx
  8031dc:	5e                   	pop    %esi
  8031dd:	5f                   	pop    %edi
  8031de:	5d                   	pop    %ebp
  8031df:	c3                   	ret    
  8031e0:	0f bd e8             	bsr    %eax,%ebp
  8031e3:	83 f5 1f             	xor    $0x1f,%ebp
  8031e6:	75 20                	jne    803208 <__umoddi3+0x98>
  8031e8:	39 d8                	cmp    %ebx,%eax
  8031ea:	0f 82 b0 00 00 00    	jb     8032a0 <__umoddi3+0x130>
  8031f0:	39 f7                	cmp    %esi,%edi
  8031f2:	0f 86 a8 00 00 00    	jbe    8032a0 <__umoddi3+0x130>
  8031f8:	89 c8                	mov    %ecx,%eax
  8031fa:	83 c4 1c             	add    $0x1c,%esp
  8031fd:	5b                   	pop    %ebx
  8031fe:	5e                   	pop    %esi
  8031ff:	5f                   	pop    %edi
  803200:	5d                   	pop    %ebp
  803201:	c3                   	ret    
  803202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803208:	89 e9                	mov    %ebp,%ecx
  80320a:	ba 20 00 00 00       	mov    $0x20,%edx
  80320f:	29 ea                	sub    %ebp,%edx
  803211:	d3 e0                	shl    %cl,%eax
  803213:	89 44 24 08          	mov    %eax,0x8(%esp)
  803217:	89 d1                	mov    %edx,%ecx
  803219:	89 f8                	mov    %edi,%eax
  80321b:	d3 e8                	shr    %cl,%eax
  80321d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803221:	89 54 24 04          	mov    %edx,0x4(%esp)
  803225:	8b 54 24 04          	mov    0x4(%esp),%edx
  803229:	09 c1                	or     %eax,%ecx
  80322b:	89 d8                	mov    %ebx,%eax
  80322d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803231:	89 e9                	mov    %ebp,%ecx
  803233:	d3 e7                	shl    %cl,%edi
  803235:	89 d1                	mov    %edx,%ecx
  803237:	d3 e8                	shr    %cl,%eax
  803239:	89 e9                	mov    %ebp,%ecx
  80323b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80323f:	d3 e3                	shl    %cl,%ebx
  803241:	89 c7                	mov    %eax,%edi
  803243:	89 d1                	mov    %edx,%ecx
  803245:	89 f0                	mov    %esi,%eax
  803247:	d3 e8                	shr    %cl,%eax
  803249:	89 e9                	mov    %ebp,%ecx
  80324b:	89 fa                	mov    %edi,%edx
  80324d:	d3 e6                	shl    %cl,%esi
  80324f:	09 d8                	or     %ebx,%eax
  803251:	f7 74 24 08          	divl   0x8(%esp)
  803255:	89 d1                	mov    %edx,%ecx
  803257:	89 f3                	mov    %esi,%ebx
  803259:	f7 64 24 0c          	mull   0xc(%esp)
  80325d:	89 c6                	mov    %eax,%esi
  80325f:	89 d7                	mov    %edx,%edi
  803261:	39 d1                	cmp    %edx,%ecx
  803263:	72 06                	jb     80326b <__umoddi3+0xfb>
  803265:	75 10                	jne    803277 <__umoddi3+0x107>
  803267:	39 c3                	cmp    %eax,%ebx
  803269:	73 0c                	jae    803277 <__umoddi3+0x107>
  80326b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80326f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803273:	89 d7                	mov    %edx,%edi
  803275:	89 c6                	mov    %eax,%esi
  803277:	89 ca                	mov    %ecx,%edx
  803279:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80327e:	29 f3                	sub    %esi,%ebx
  803280:	19 fa                	sbb    %edi,%edx
  803282:	89 d0                	mov    %edx,%eax
  803284:	d3 e0                	shl    %cl,%eax
  803286:	89 e9                	mov    %ebp,%ecx
  803288:	d3 eb                	shr    %cl,%ebx
  80328a:	d3 ea                	shr    %cl,%edx
  80328c:	09 d8                	or     %ebx,%eax
  80328e:	83 c4 1c             	add    $0x1c,%esp
  803291:	5b                   	pop    %ebx
  803292:	5e                   	pop    %esi
  803293:	5f                   	pop    %edi
  803294:	5d                   	pop    %ebp
  803295:	c3                   	ret    
  803296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80329d:	8d 76 00             	lea    0x0(%esi),%esi
  8032a0:	89 da                	mov    %ebx,%edx
  8032a2:	29 fe                	sub    %edi,%esi
  8032a4:	19 c2                	sbb    %eax,%edx
  8032a6:	89 f1                	mov    %esi,%ecx
  8032a8:	89 c8                	mov    %ecx,%eax
  8032aa:	e9 4b ff ff ff       	jmp    8031fa <__umoddi3+0x8a>
