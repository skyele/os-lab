
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 c5 00 00 00       	call   8000f6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  80003a:	e8 ad 0f 00 00       	call   800fec <sys_time_msec>
	unsigned end = now + sec * 1000;
  80003f:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800046:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800048:	85 c0                	test   %eax,%eax
  80004a:	79 05                	jns    800051 <sleep+0x1e>
  80004c:	83 f8 ef             	cmp    $0xffffffef,%eax
  80004f:	7d 14                	jge    800065 <sleep+0x32>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800051:	39 d8                	cmp    %ebx,%eax
  800053:	77 22                	ja     800077 <sleep+0x44>
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  800055:	e8 92 0f 00 00       	call   800fec <sys_time_msec>
  80005a:	39 d8                	cmp    %ebx,%eax
  80005c:	73 2d                	jae    80008b <sleep+0x58>
		sys_yield();
  80005e:	e8 38 0d 00 00       	call   800d9b <sys_yield>
  800063:	eb f0                	jmp    800055 <sleep+0x22>
		panic("sys_time_msec: %e", (int)now);
  800065:	50                   	push   %eax
  800066:	68 a0 25 80 00       	push   $0x8025a0
  80006b:	6a 0b                	push   $0xb
  80006d:	68 b2 25 80 00       	push   $0x8025b2
  800072:	e8 fc 00 00 00       	call   800173 <_panic>
		panic("sleep: wrap");
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	68 c2 25 80 00       	push   $0x8025c2
  80007f:	6a 0d                	push   $0xd
  800081:	68 b2 25 80 00       	push   $0x8025b2
  800086:	e8 e8 00 00 00       	call   800173 <_panic>
}
  80008b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008e:	c9                   	leave  
  80008f:	c3                   	ret    

00800090 <umain>:

void
umain(int argc, char **argv)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	53                   	push   %ebx
  800094:	83 ec 04             	sub    $0x4,%esp
  800097:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  80009c:	e8 fa 0c 00 00       	call   800d9b <sys_yield>
	for (i = 0; i < 50; i++)
  8000a1:	83 eb 01             	sub    $0x1,%ebx
  8000a4:	75 f6                	jne    80009c <umain+0xc>

	cprintf("starting count down: ");
  8000a6:	83 ec 0c             	sub    $0xc,%esp
  8000a9:	68 ce 25 80 00       	push   $0x8025ce
  8000ae:	e8 b6 01 00 00       	call   800269 <cprintf>
  8000b3:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000b6:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	53                   	push   %ebx
  8000bf:	68 e4 25 80 00       	push   $0x8025e4
  8000c4:	e8 a0 01 00 00       	call   800269 <cprintf>
		sleep(1);
  8000c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d0:	e8 5e ff ff ff       	call   800033 <sleep>
	for (i = 5; i >= 0; i--) {
  8000d5:	83 eb 01             	sub    $0x1,%ebx
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	83 fb ff             	cmp    $0xffffffff,%ebx
  8000de:	75 db                	jne    8000bb <umain+0x2b>
	}
	cprintf("\n");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 32 2b 80 00       	push   $0x802b32
  8000e8:	e8 7c 01 00 00       	call   800269 <cprintf>
  : "c" (msr), "a" (val1), "d" (val2))

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8000ed:	cc                   	int3   
	breakpoint();
}
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

008000f6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	56                   	push   %esi
  8000fa:	53                   	push   %ebx
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800101:	e8 76 0c 00 00       	call   800d7c <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800106:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800111:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800116:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011b:	85 db                	test   %ebx,%ebx
  80011d:	7e 07                	jle    800126 <libmain+0x30>
		binaryname = argv[0];
  80011f:	8b 06                	mov    (%esi),%eax
  800121:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	56                   	push   %esi
  80012a:	53                   	push   %ebx
  80012b:	e8 60 ff ff ff       	call   800090 <umain>

	// exit gracefully
	exit();
  800130:	e8 0a 00 00 00       	call   80013f <exit>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013b:	5b                   	pop    %ebx
  80013c:	5e                   	pop    %esi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800145:	a1 08 40 80 00       	mov    0x804008,%eax
  80014a:	8b 40 48             	mov    0x48(%eax),%eax
  80014d:	68 00 26 80 00       	push   $0x802600
  800152:	50                   	push   %eax
  800153:	68 f2 25 80 00       	push   $0x8025f2
  800158:	e8 0c 01 00 00       	call   800269 <cprintf>
	close_all();
  80015d:	e8 25 11 00 00       	call   801287 <close_all>
	sys_env_destroy(0);
  800162:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800169:	e8 cd 0b 00 00       	call   800d3b <sys_env_destroy>
}
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	56                   	push   %esi
  800177:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800178:	a1 08 40 80 00       	mov    0x804008,%eax
  80017d:	8b 40 48             	mov    0x48(%eax),%eax
  800180:	83 ec 04             	sub    $0x4,%esp
  800183:	68 2c 26 80 00       	push   $0x80262c
  800188:	50                   	push   %eax
  800189:	68 f2 25 80 00       	push   $0x8025f2
  80018e:	e8 d6 00 00 00       	call   800269 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800193:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800196:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019c:	e8 db 0b 00 00       	call   800d7c <sys_getenvid>
  8001a1:	83 c4 04             	add    $0x4,%esp
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	56                   	push   %esi
  8001ab:	50                   	push   %eax
  8001ac:	68 08 26 80 00       	push   $0x802608
  8001b1:	e8 b3 00 00 00       	call   800269 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b6:	83 c4 18             	add    $0x18,%esp
  8001b9:	53                   	push   %ebx
  8001ba:	ff 75 10             	pushl  0x10(%ebp)
  8001bd:	e8 56 00 00 00       	call   800218 <vcprintf>
	cprintf("\n");
  8001c2:	c7 04 24 32 2b 80 00 	movl   $0x802b32,(%esp)
  8001c9:	e8 9b 00 00 00       	call   800269 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d1:	cc                   	int3   
  8001d2:	eb fd                	jmp    8001d1 <_panic+0x5e>

008001d4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	53                   	push   %ebx
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001de:	8b 13                	mov    (%ebx),%edx
  8001e0:	8d 42 01             	lea    0x1(%edx),%eax
  8001e3:	89 03                	mov    %eax,(%ebx)
  8001e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f1:	74 09                	je     8001fc <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	68 ff 00 00 00       	push   $0xff
  800204:	8d 43 08             	lea    0x8(%ebx),%eax
  800207:	50                   	push   %eax
  800208:	e8 f1 0a 00 00       	call   800cfe <sys_cputs>
		b->idx = 0;
  80020d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	eb db                	jmp    8001f3 <putch+0x1f>

00800218 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800221:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800228:	00 00 00 
	b.cnt = 0;
  80022b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800232:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800235:	ff 75 0c             	pushl  0xc(%ebp)
  800238:	ff 75 08             	pushl  0x8(%ebp)
  80023b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800241:	50                   	push   %eax
  800242:	68 d4 01 80 00       	push   $0x8001d4
  800247:	e8 4a 01 00 00       	call   800396 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024c:	83 c4 08             	add    $0x8,%esp
  80024f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800255:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025b:	50                   	push   %eax
  80025c:	e8 9d 0a 00 00       	call   800cfe <sys_cputs>

	return b.cnt;
}
  800261:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800272:	50                   	push   %eax
  800273:	ff 75 08             	pushl  0x8(%ebp)
  800276:	e8 9d ff ff ff       	call   800218 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	57                   	push   %edi
  800281:	56                   	push   %esi
  800282:	53                   	push   %ebx
  800283:	83 ec 1c             	sub    $0x1c,%esp
  800286:	89 c6                	mov    %eax,%esi
  800288:	89 d7                	mov    %edx,%edi
  80028a:	8b 45 08             	mov    0x8(%ebp),%eax
  80028d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800290:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800293:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800296:	8b 45 10             	mov    0x10(%ebp),%eax
  800299:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80029c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002a0:	74 2c                	je     8002ce <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002b2:	39 c2                	cmp    %eax,%edx
  8002b4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b7:	73 43                	jae    8002fc <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002b9:	83 eb 01             	sub    $0x1,%ebx
  8002bc:	85 db                	test   %ebx,%ebx
  8002be:	7e 6c                	jle    80032c <printnum+0xaf>
				putch(padc, putdat);
  8002c0:	83 ec 08             	sub    $0x8,%esp
  8002c3:	57                   	push   %edi
  8002c4:	ff 75 18             	pushl  0x18(%ebp)
  8002c7:	ff d6                	call   *%esi
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	eb eb                	jmp    8002b9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 20                	push   $0x20
  8002d3:	6a 00                	push   $0x0
  8002d5:	50                   	push   %eax
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002dc:	89 fa                	mov    %edi,%edx
  8002de:	89 f0                	mov    %esi,%eax
  8002e0:	e8 98 ff ff ff       	call   80027d <printnum>
		while (--width > 0)
  8002e5:	83 c4 20             	add    $0x20,%esp
  8002e8:	83 eb 01             	sub    $0x1,%ebx
  8002eb:	85 db                	test   %ebx,%ebx
  8002ed:	7e 65                	jle    800354 <printnum+0xd7>
			putch(padc, putdat);
  8002ef:	83 ec 08             	sub    $0x8,%esp
  8002f2:	57                   	push   %edi
  8002f3:	6a 20                	push   $0x20
  8002f5:	ff d6                	call   *%esi
  8002f7:	83 c4 10             	add    $0x10,%esp
  8002fa:	eb ec                	jmp    8002e8 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fc:	83 ec 0c             	sub    $0xc,%esp
  8002ff:	ff 75 18             	pushl  0x18(%ebp)
  800302:	83 eb 01             	sub    $0x1,%ebx
  800305:	53                   	push   %ebx
  800306:	50                   	push   %eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 dc             	pushl  -0x24(%ebp)
  80030d:	ff 75 d8             	pushl  -0x28(%ebp)
  800310:	ff 75 e4             	pushl  -0x1c(%ebp)
  800313:	ff 75 e0             	pushl  -0x20(%ebp)
  800316:	e8 25 20 00 00       	call   802340 <__udivdi3>
  80031b:	83 c4 18             	add    $0x18,%esp
  80031e:	52                   	push   %edx
  80031f:	50                   	push   %eax
  800320:	89 fa                	mov    %edi,%edx
  800322:	89 f0                	mov    %esi,%eax
  800324:	e8 54 ff ff ff       	call   80027d <printnum>
  800329:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	57                   	push   %edi
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	ff 75 dc             	pushl  -0x24(%ebp)
  800336:	ff 75 d8             	pushl  -0x28(%ebp)
  800339:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033c:	ff 75 e0             	pushl  -0x20(%ebp)
  80033f:	e8 0c 21 00 00       	call   802450 <__umoddi3>
  800344:	83 c4 14             	add    $0x14,%esp
  800347:	0f be 80 33 26 80 00 	movsbl 0x802633(%eax),%eax
  80034e:	50                   	push   %eax
  80034f:	ff d6                	call   *%esi
  800351:	83 c4 10             	add    $0x10,%esp
	}
}
  800354:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800357:	5b                   	pop    %ebx
  800358:	5e                   	pop    %esi
  800359:	5f                   	pop    %edi
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800362:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800366:	8b 10                	mov    (%eax),%edx
  800368:	3b 50 04             	cmp    0x4(%eax),%edx
  80036b:	73 0a                	jae    800377 <sprintputch+0x1b>
		*b->buf++ = ch;
  80036d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800370:	89 08                	mov    %ecx,(%eax)
  800372:	8b 45 08             	mov    0x8(%ebp),%eax
  800375:	88 02                	mov    %al,(%edx)
}
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    

00800379 <printfmt>:
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800382:	50                   	push   %eax
  800383:	ff 75 10             	pushl  0x10(%ebp)
  800386:	ff 75 0c             	pushl  0xc(%ebp)
  800389:	ff 75 08             	pushl  0x8(%ebp)
  80038c:	e8 05 00 00 00       	call   800396 <vprintfmt>
}
  800391:	83 c4 10             	add    $0x10,%esp
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <vprintfmt>:
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	57                   	push   %edi
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
  80039c:	83 ec 3c             	sub    $0x3c,%esp
  80039f:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a8:	e9 32 04 00 00       	jmp    8007df <vprintfmt+0x449>
		padc = ' ';
  8003ad:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003b1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003bf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003cd:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003d4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	8d 47 01             	lea    0x1(%edi),%eax
  8003dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003df:	0f b6 17             	movzbl (%edi),%edx
  8003e2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003e5:	3c 55                	cmp    $0x55,%al
  8003e7:	0f 87 12 05 00 00    	ja     8008ff <vprintfmt+0x569>
  8003ed:	0f b6 c0             	movzbl %al,%eax
  8003f0:	ff 24 85 20 28 80 00 	jmp    *0x802820(,%eax,4)
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003fa:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003fe:	eb d9                	jmp    8003d9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800403:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800407:	eb d0                	jmp    8003d9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800409:	0f b6 d2             	movzbl %dl,%edx
  80040c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80040f:	b8 00 00 00 00       	mov    $0x0,%eax
  800414:	89 75 08             	mov    %esi,0x8(%ebp)
  800417:	eb 03                	jmp    80041c <vprintfmt+0x86>
  800419:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80041c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80041f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800423:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800426:	8d 72 d0             	lea    -0x30(%edx),%esi
  800429:	83 fe 09             	cmp    $0x9,%esi
  80042c:	76 eb                	jbe    800419 <vprintfmt+0x83>
  80042e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800431:	8b 75 08             	mov    0x8(%ebp),%esi
  800434:	eb 14                	jmp    80044a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800436:	8b 45 14             	mov    0x14(%ebp),%eax
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043e:	8b 45 14             	mov    0x14(%ebp),%eax
  800441:	8d 40 04             	lea    0x4(%eax),%eax
  800444:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80044a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044e:	79 89                	jns    8003d9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800450:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800456:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80045d:	e9 77 ff ff ff       	jmp    8003d9 <vprintfmt+0x43>
  800462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800465:	85 c0                	test   %eax,%eax
  800467:	0f 48 c1             	cmovs  %ecx,%eax
  80046a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800470:	e9 64 ff ff ff       	jmp    8003d9 <vprintfmt+0x43>
  800475:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800478:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80047f:	e9 55 ff ff ff       	jmp    8003d9 <vprintfmt+0x43>
			lflag++;
  800484:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80048b:	e9 49 ff ff ff       	jmp    8003d9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	8d 78 04             	lea    0x4(%eax),%edi
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	53                   	push   %ebx
  80049a:	ff 30                	pushl  (%eax)
  80049c:	ff d6                	call   *%esi
			break;
  80049e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004a1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004a4:	e9 33 03 00 00       	jmp    8007dc <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ac:	8d 78 04             	lea    0x4(%eax),%edi
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	99                   	cltd   
  8004b2:	31 d0                	xor    %edx,%eax
  8004b4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b6:	83 f8 11             	cmp    $0x11,%eax
  8004b9:	7f 23                	jg     8004de <vprintfmt+0x148>
  8004bb:	8b 14 85 80 29 80 00 	mov    0x802980(,%eax,4),%edx
  8004c2:	85 d2                	test   %edx,%edx
  8004c4:	74 18                	je     8004de <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004c6:	52                   	push   %edx
  8004c7:	68 a1 2a 80 00       	push   $0x802aa1
  8004cc:	53                   	push   %ebx
  8004cd:	56                   	push   %esi
  8004ce:	e8 a6 fe ff ff       	call   800379 <printfmt>
  8004d3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004d9:	e9 fe 02 00 00       	jmp    8007dc <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004de:	50                   	push   %eax
  8004df:	68 4b 26 80 00       	push   $0x80264b
  8004e4:	53                   	push   %ebx
  8004e5:	56                   	push   %esi
  8004e6:	e8 8e fe ff ff       	call   800379 <printfmt>
  8004eb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ee:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004f1:	e9 e6 02 00 00       	jmp    8007dc <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	83 c0 04             	add    $0x4,%eax
  8004fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800504:	85 c9                	test   %ecx,%ecx
  800506:	b8 44 26 80 00       	mov    $0x802644,%eax
  80050b:	0f 45 c1             	cmovne %ecx,%eax
  80050e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800511:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800515:	7e 06                	jle    80051d <vprintfmt+0x187>
  800517:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80051b:	75 0d                	jne    80052a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 c7                	mov    %eax,%edi
  800522:	03 45 e0             	add    -0x20(%ebp),%eax
  800525:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800528:	eb 53                	jmp    80057d <vprintfmt+0x1e7>
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 d8             	pushl  -0x28(%ebp)
  800530:	50                   	push   %eax
  800531:	e8 71 04 00 00       	call   8009a7 <strnlen>
  800536:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800539:	29 c1                	sub    %eax,%ecx
  80053b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800543:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800547:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80054a:	eb 0f                	jmp    80055b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	53                   	push   %ebx
  800550:	ff 75 e0             	pushl  -0x20(%ebp)
  800553:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800555:	83 ef 01             	sub    $0x1,%edi
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	85 ff                	test   %edi,%edi
  80055d:	7f ed                	jg     80054c <vprintfmt+0x1b6>
  80055f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800562:	85 c9                	test   %ecx,%ecx
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	0f 49 c1             	cmovns %ecx,%eax
  80056c:	29 c1                	sub    %eax,%ecx
  80056e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800571:	eb aa                	jmp    80051d <vprintfmt+0x187>
					putch(ch, putdat);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	53                   	push   %ebx
  800577:	52                   	push   %edx
  800578:	ff d6                	call   *%esi
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800580:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800582:	83 c7 01             	add    $0x1,%edi
  800585:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800589:	0f be d0             	movsbl %al,%edx
  80058c:	85 d2                	test   %edx,%edx
  80058e:	74 4b                	je     8005db <vprintfmt+0x245>
  800590:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800594:	78 06                	js     80059c <vprintfmt+0x206>
  800596:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80059a:	78 1e                	js     8005ba <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80059c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005a0:	74 d1                	je     800573 <vprintfmt+0x1dd>
  8005a2:	0f be c0             	movsbl %al,%eax
  8005a5:	83 e8 20             	sub    $0x20,%eax
  8005a8:	83 f8 5e             	cmp    $0x5e,%eax
  8005ab:	76 c6                	jbe    800573 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005ad:	83 ec 08             	sub    $0x8,%esp
  8005b0:	53                   	push   %ebx
  8005b1:	6a 3f                	push   $0x3f
  8005b3:	ff d6                	call   *%esi
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	eb c3                	jmp    80057d <vprintfmt+0x1e7>
  8005ba:	89 cf                	mov    %ecx,%edi
  8005bc:	eb 0e                	jmp    8005cc <vprintfmt+0x236>
				putch(' ', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 20                	push   $0x20
  8005c4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005c6:	83 ef 01             	sub    $0x1,%edi
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	85 ff                	test   %edi,%edi
  8005ce:	7f ee                	jg     8005be <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d6:	e9 01 02 00 00       	jmp    8007dc <vprintfmt+0x446>
  8005db:	89 cf                	mov    %ecx,%edi
  8005dd:	eb ed                	jmp    8005cc <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005e2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005e9:	e9 eb fd ff ff       	jmp    8003d9 <vprintfmt+0x43>
	if (lflag >= 2)
  8005ee:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005f2:	7f 21                	jg     800615 <vprintfmt+0x27f>
	else if (lflag)
  8005f4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f8:	74 68                	je     800662 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800602:	89 c1                	mov    %eax,%ecx
  800604:	c1 f9 1f             	sar    $0x1f,%ecx
  800607:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8d 40 04             	lea    0x4(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	eb 17                	jmp    80062c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 50 04             	mov    0x4(%eax),%edx
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800620:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8d 40 08             	lea    0x8(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80062c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80062f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800632:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800635:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800638:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80063c:	78 3f                	js     80067d <vprintfmt+0x2e7>
			base = 10;
  80063e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800643:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800647:	0f 84 71 01 00 00    	je     8007be <vprintfmt+0x428>
				putch('+', putdat);
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	53                   	push   %ebx
  800651:	6a 2b                	push   $0x2b
  800653:	ff d6                	call   *%esi
  800655:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800658:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065d:	e9 5c 01 00 00       	jmp    8007be <vprintfmt+0x428>
		return va_arg(*ap, int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066a:	89 c1                	mov    %eax,%ecx
  80066c:	c1 f9 1f             	sar    $0x1f,%ecx
  80066f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
  80067b:	eb af                	jmp    80062c <vprintfmt+0x296>
				putch('-', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 2d                	push   $0x2d
  800683:	ff d6                	call   *%esi
				num = -(long long) num;
  800685:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800688:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80068b:	f7 d8                	neg    %eax
  80068d:	83 d2 00             	adc    $0x0,%edx
  800690:	f7 da                	neg    %edx
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800695:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800698:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80069b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a0:	e9 19 01 00 00       	jmp    8007be <vprintfmt+0x428>
	if (lflag >= 2)
  8006a5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a9:	7f 29                	jg     8006d4 <vprintfmt+0x33e>
	else if (lflag)
  8006ab:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006af:	74 44                	je     8006f5 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cf:	e9 ea 00 00 00       	jmp    8007be <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 50 04             	mov    0x4(%eax),%edx
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 40 08             	lea    0x8(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f0:	e9 c9 00 00 00       	jmp    8007be <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800702:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8d 40 04             	lea    0x4(%eax),%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800713:	e9 a6 00 00 00       	jmp    8007be <vprintfmt+0x428>
			putch('0', putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	6a 30                	push   $0x30
  80071e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800727:	7f 26                	jg     80074f <vprintfmt+0x3b9>
	else if (lflag)
  800729:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80072d:	74 3e                	je     80076d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	ba 00 00 00 00       	mov    $0x0,%edx
  800739:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 40 04             	lea    0x4(%eax),%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800748:	b8 08 00 00 00       	mov    $0x8,%eax
  80074d:	eb 6f                	jmp    8007be <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8b 50 04             	mov    0x4(%eax),%edx
  800755:	8b 00                	mov    (%eax),%eax
  800757:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8d 40 08             	lea    0x8(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800766:	b8 08 00 00 00       	mov    $0x8,%eax
  80076b:	eb 51                	jmp    8007be <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 04             	lea    0x4(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800786:	b8 08 00 00 00       	mov    $0x8,%eax
  80078b:	eb 31                	jmp    8007be <vprintfmt+0x428>
			putch('0', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	53                   	push   %ebx
  800791:	6a 30                	push   $0x30
  800793:	ff d6                	call   *%esi
			putch('x', putdat);
  800795:	83 c4 08             	add    $0x8,%esp
  800798:	53                   	push   %ebx
  800799:	6a 78                	push   $0x78
  80079b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007ad:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8d 40 04             	lea    0x4(%eax),%eax
  8007b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007be:	83 ec 0c             	sub    $0xc,%esp
  8007c1:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007c5:	52                   	push   %edx
  8007c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c9:	50                   	push   %eax
  8007ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8007cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8007d0:	89 da                	mov    %ebx,%edx
  8007d2:	89 f0                	mov    %esi,%eax
  8007d4:	e8 a4 fa ff ff       	call   80027d <printnum>
			break;
  8007d9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007df:	83 c7 01             	add    $0x1,%edi
  8007e2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e6:	83 f8 25             	cmp    $0x25,%eax
  8007e9:	0f 84 be fb ff ff    	je     8003ad <vprintfmt+0x17>
			if (ch == '\0')
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	0f 84 28 01 00 00    	je     80091f <vprintfmt+0x589>
			putch(ch, putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	50                   	push   %eax
  8007fc:	ff d6                	call   *%esi
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	eb dc                	jmp    8007df <vprintfmt+0x449>
	if (lflag >= 2)
  800803:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800807:	7f 26                	jg     80082f <vprintfmt+0x499>
	else if (lflag)
  800809:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80080d:	74 41                	je     800850 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	ba 00 00 00 00       	mov    $0x0,%edx
  800819:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8d 40 04             	lea    0x4(%eax),%eax
  800825:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800828:	b8 10 00 00 00       	mov    $0x10,%eax
  80082d:	eb 8f                	jmp    8007be <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 50 04             	mov    0x4(%eax),%edx
  800835:	8b 00                	mov    (%eax),%eax
  800837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 40 08             	lea    0x8(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800846:	b8 10 00 00 00       	mov    $0x10,%eax
  80084b:	e9 6e ff ff ff       	jmp    8007be <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	ba 00 00 00 00       	mov    $0x0,%edx
  80085a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8d 40 04             	lea    0x4(%eax),%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800869:	b8 10 00 00 00       	mov    $0x10,%eax
  80086e:	e9 4b ff ff ff       	jmp    8007be <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	85 c0                	test   %eax,%eax
  800883:	74 14                	je     800899 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800885:	8b 13                	mov    (%ebx),%edx
  800887:	83 fa 7f             	cmp    $0x7f,%edx
  80088a:	7f 37                	jg     8008c3 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80088c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80088e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	e9 43 ff ff ff       	jmp    8007dc <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800899:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089e:	bf 69 27 80 00       	mov    $0x802769,%edi
							putch(ch, putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	53                   	push   %ebx
  8008a7:	50                   	push   %eax
  8008a8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008aa:	83 c7 01             	add    $0x1,%edi
  8008ad:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	85 c0                	test   %eax,%eax
  8008b6:	75 eb                	jne    8008a3 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008be:	e9 19 ff ff ff       	jmp    8007dc <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008c3:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ca:	bf a1 27 80 00       	mov    $0x8027a1,%edi
							putch(ch, putdat);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	53                   	push   %ebx
  8008d3:	50                   	push   %eax
  8008d4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008d6:	83 c7 01             	add    $0x1,%edi
  8008d9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	85 c0                	test   %eax,%eax
  8008e2:	75 eb                	jne    8008cf <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ea:	e9 ed fe ff ff       	jmp    8007dc <vprintfmt+0x446>
			putch(ch, putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	6a 25                	push   $0x25
  8008f5:	ff d6                	call   *%esi
			break;
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	e9 dd fe ff ff       	jmp    8007dc <vprintfmt+0x446>
			putch('%', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	53                   	push   %ebx
  800903:	6a 25                	push   $0x25
  800905:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	89 f8                	mov    %edi,%eax
  80090c:	eb 03                	jmp    800911 <vprintfmt+0x57b>
  80090e:	83 e8 01             	sub    $0x1,%eax
  800911:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800915:	75 f7                	jne    80090e <vprintfmt+0x578>
  800917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80091a:	e9 bd fe ff ff       	jmp    8007dc <vprintfmt+0x446>
}
  80091f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800922:	5b                   	pop    %ebx
  800923:	5e                   	pop    %esi
  800924:	5f                   	pop    %edi
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 18             	sub    $0x18,%esp
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800933:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800936:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80093a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80093d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800944:	85 c0                	test   %eax,%eax
  800946:	74 26                	je     80096e <vsnprintf+0x47>
  800948:	85 d2                	test   %edx,%edx
  80094a:	7e 22                	jle    80096e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094c:	ff 75 14             	pushl  0x14(%ebp)
  80094f:	ff 75 10             	pushl  0x10(%ebp)
  800952:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800955:	50                   	push   %eax
  800956:	68 5c 03 80 00       	push   $0x80035c
  80095b:	e8 36 fa ff ff       	call   800396 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800963:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800969:	83 c4 10             	add    $0x10,%esp
}
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    
		return -E_INVAL;
  80096e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800973:	eb f7                	jmp    80096c <vsnprintf+0x45>

00800975 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80097b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80097e:	50                   	push   %eax
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	ff 75 08             	pushl  0x8(%ebp)
  800988:	e8 9a ff ff ff       	call   800927 <vsnprintf>
	va_end(ap);

	return rc;
}
  80098d:	c9                   	leave  
  80098e:	c3                   	ret    

0080098f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800995:	b8 00 00 00 00       	mov    $0x0,%eax
  80099a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80099e:	74 05                	je     8009a5 <strlen+0x16>
		n++;
  8009a0:	83 c0 01             	add    $0x1,%eax
  8009a3:	eb f5                	jmp    80099a <strlen+0xb>
	return n;
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ad:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b5:	39 c2                	cmp    %eax,%edx
  8009b7:	74 0d                	je     8009c6 <strnlen+0x1f>
  8009b9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009bd:	74 05                	je     8009c4 <strnlen+0x1d>
		n++;
  8009bf:	83 c2 01             	add    $0x1,%edx
  8009c2:	eb f1                	jmp    8009b5 <strnlen+0xe>
  8009c4:	89 d0                	mov    %edx,%eax
	return n;
}
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	53                   	push   %ebx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009db:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009de:	83 c2 01             	add    $0x1,%edx
  8009e1:	84 c9                	test   %cl,%cl
  8009e3:	75 f2                	jne    8009d7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009e5:	5b                   	pop    %ebx
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	53                   	push   %ebx
  8009ec:	83 ec 10             	sub    $0x10,%esp
  8009ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009f2:	53                   	push   %ebx
  8009f3:	e8 97 ff ff ff       	call   80098f <strlen>
  8009f8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	01 d8                	add    %ebx,%eax
  800a00:	50                   	push   %eax
  800a01:	e8 c2 ff ff ff       	call   8009c8 <strcpy>
	return dst;
}
  800a06:	89 d8                	mov    %ebx,%eax
  800a08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a18:	89 c6                	mov    %eax,%esi
  800a1a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1d:	89 c2                	mov    %eax,%edx
  800a1f:	39 f2                	cmp    %esi,%edx
  800a21:	74 11                	je     800a34 <strncpy+0x27>
		*dst++ = *src;
  800a23:	83 c2 01             	add    $0x1,%edx
  800a26:	0f b6 19             	movzbl (%ecx),%ebx
  800a29:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a2c:	80 fb 01             	cmp    $0x1,%bl
  800a2f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a32:	eb eb                	jmp    800a1f <strncpy+0x12>
	}
	return ret;
}
  800a34:	5b                   	pop    %ebx
  800a35:	5e                   	pop    %esi
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a43:	8b 55 10             	mov    0x10(%ebp),%edx
  800a46:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a48:	85 d2                	test   %edx,%edx
  800a4a:	74 21                	je     800a6d <strlcpy+0x35>
  800a4c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a50:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 14                	je     800a6a <strlcpy+0x32>
  800a56:	0f b6 19             	movzbl (%ecx),%ebx
  800a59:	84 db                	test   %bl,%bl
  800a5b:	74 0b                	je     800a68 <strlcpy+0x30>
			*dst++ = *src++;
  800a5d:	83 c1 01             	add    $0x1,%ecx
  800a60:	83 c2 01             	add    $0x1,%edx
  800a63:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a66:	eb ea                	jmp    800a52 <strlcpy+0x1a>
  800a68:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a6a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a6d:	29 f0                	sub    %esi,%eax
}
  800a6f:	5b                   	pop    %ebx
  800a70:	5e                   	pop    %esi
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a7c:	0f b6 01             	movzbl (%ecx),%eax
  800a7f:	84 c0                	test   %al,%al
  800a81:	74 0c                	je     800a8f <strcmp+0x1c>
  800a83:	3a 02                	cmp    (%edx),%al
  800a85:	75 08                	jne    800a8f <strcmp+0x1c>
		p++, q++;
  800a87:	83 c1 01             	add    $0x1,%ecx
  800a8a:	83 c2 01             	add    $0x1,%edx
  800a8d:	eb ed                	jmp    800a7c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8f:	0f b6 c0             	movzbl %al,%eax
  800a92:	0f b6 12             	movzbl (%edx),%edx
  800a95:	29 d0                	sub    %edx,%eax
}
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	53                   	push   %ebx
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa3:	89 c3                	mov    %eax,%ebx
  800aa5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa8:	eb 06                	jmp    800ab0 <strncmp+0x17>
		n--, p++, q++;
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ab0:	39 d8                	cmp    %ebx,%eax
  800ab2:	74 16                	je     800aca <strncmp+0x31>
  800ab4:	0f b6 08             	movzbl (%eax),%ecx
  800ab7:	84 c9                	test   %cl,%cl
  800ab9:	74 04                	je     800abf <strncmp+0x26>
  800abb:	3a 0a                	cmp    (%edx),%cl
  800abd:	74 eb                	je     800aaa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800abf:	0f b6 00             	movzbl (%eax),%eax
  800ac2:	0f b6 12             	movzbl (%edx),%edx
  800ac5:	29 d0                	sub    %edx,%eax
}
  800ac7:	5b                   	pop    %ebx
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    
		return 0;
  800aca:	b8 00 00 00 00       	mov    $0x0,%eax
  800acf:	eb f6                	jmp    800ac7 <strncmp+0x2e>

00800ad1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800adb:	0f b6 10             	movzbl (%eax),%edx
  800ade:	84 d2                	test   %dl,%dl
  800ae0:	74 09                	je     800aeb <strchr+0x1a>
		if (*s == c)
  800ae2:	38 ca                	cmp    %cl,%dl
  800ae4:	74 0a                	je     800af0 <strchr+0x1f>
	for (; *s; s++)
  800ae6:	83 c0 01             	add    $0x1,%eax
  800ae9:	eb f0                	jmp    800adb <strchr+0xa>
			return (char *) s;
	return 0;
  800aeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800afc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aff:	38 ca                	cmp    %cl,%dl
  800b01:	74 09                	je     800b0c <strfind+0x1a>
  800b03:	84 d2                	test   %dl,%dl
  800b05:	74 05                	je     800b0c <strfind+0x1a>
	for (; *s; s++)
  800b07:	83 c0 01             	add    $0x1,%eax
  800b0a:	eb f0                	jmp    800afc <strfind+0xa>
			break;
	return (char *) s;
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	57                   	push   %edi
  800b12:	56                   	push   %esi
  800b13:	53                   	push   %ebx
  800b14:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b17:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b1a:	85 c9                	test   %ecx,%ecx
  800b1c:	74 31                	je     800b4f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b1e:	89 f8                	mov    %edi,%eax
  800b20:	09 c8                	or     %ecx,%eax
  800b22:	a8 03                	test   $0x3,%al
  800b24:	75 23                	jne    800b49 <memset+0x3b>
		c &= 0xFF;
  800b26:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b2a:	89 d3                	mov    %edx,%ebx
  800b2c:	c1 e3 08             	shl    $0x8,%ebx
  800b2f:	89 d0                	mov    %edx,%eax
  800b31:	c1 e0 18             	shl    $0x18,%eax
  800b34:	89 d6                	mov    %edx,%esi
  800b36:	c1 e6 10             	shl    $0x10,%esi
  800b39:	09 f0                	or     %esi,%eax
  800b3b:	09 c2                	or     %eax,%edx
  800b3d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b3f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b42:	89 d0                	mov    %edx,%eax
  800b44:	fc                   	cld    
  800b45:	f3 ab                	rep stos %eax,%es:(%edi)
  800b47:	eb 06                	jmp    800b4f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	fc                   	cld    
  800b4d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b4f:	89 f8                	mov    %edi,%eax
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b61:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b64:	39 c6                	cmp    %eax,%esi
  800b66:	73 32                	jae    800b9a <memmove+0x44>
  800b68:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b6b:	39 c2                	cmp    %eax,%edx
  800b6d:	76 2b                	jbe    800b9a <memmove+0x44>
		s += n;
		d += n;
  800b6f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b72:	89 fe                	mov    %edi,%esi
  800b74:	09 ce                	or     %ecx,%esi
  800b76:	09 d6                	or     %edx,%esi
  800b78:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b7e:	75 0e                	jne    800b8e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b80:	83 ef 04             	sub    $0x4,%edi
  800b83:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b86:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b89:	fd                   	std    
  800b8a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b8c:	eb 09                	jmp    800b97 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b8e:	83 ef 01             	sub    $0x1,%edi
  800b91:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b94:	fd                   	std    
  800b95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b97:	fc                   	cld    
  800b98:	eb 1a                	jmp    800bb4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b9a:	89 c2                	mov    %eax,%edx
  800b9c:	09 ca                	or     %ecx,%edx
  800b9e:	09 f2                	or     %esi,%edx
  800ba0:	f6 c2 03             	test   $0x3,%dl
  800ba3:	75 0a                	jne    800baf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ba5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ba8:	89 c7                	mov    %eax,%edi
  800baa:	fc                   	cld    
  800bab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bad:	eb 05                	jmp    800bb4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800baf:	89 c7                	mov    %eax,%edi
  800bb1:	fc                   	cld    
  800bb2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bbe:	ff 75 10             	pushl  0x10(%ebp)
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 8a ff ff ff       	call   800b56 <memmove>
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd9:	89 c6                	mov    %eax,%esi
  800bdb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bde:	39 f0                	cmp    %esi,%eax
  800be0:	74 1c                	je     800bfe <memcmp+0x30>
		if (*s1 != *s2)
  800be2:	0f b6 08             	movzbl (%eax),%ecx
  800be5:	0f b6 1a             	movzbl (%edx),%ebx
  800be8:	38 d9                	cmp    %bl,%cl
  800bea:	75 08                	jne    800bf4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bec:	83 c0 01             	add    $0x1,%eax
  800bef:	83 c2 01             	add    $0x1,%edx
  800bf2:	eb ea                	jmp    800bde <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bf4:	0f b6 c1             	movzbl %cl,%eax
  800bf7:	0f b6 db             	movzbl %bl,%ebx
  800bfa:	29 d8                	sub    %ebx,%eax
  800bfc:	eb 05                	jmp    800c03 <memcmp+0x35>
	}

	return 0;
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c10:	89 c2                	mov    %eax,%edx
  800c12:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c15:	39 d0                	cmp    %edx,%eax
  800c17:	73 09                	jae    800c22 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c19:	38 08                	cmp    %cl,(%eax)
  800c1b:	74 05                	je     800c22 <memfind+0x1b>
	for (; s < ends; s++)
  800c1d:	83 c0 01             	add    $0x1,%eax
  800c20:	eb f3                	jmp    800c15 <memfind+0xe>
			break;
	return (void *) s;
}
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c30:	eb 03                	jmp    800c35 <strtol+0x11>
		s++;
  800c32:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c35:	0f b6 01             	movzbl (%ecx),%eax
  800c38:	3c 20                	cmp    $0x20,%al
  800c3a:	74 f6                	je     800c32 <strtol+0xe>
  800c3c:	3c 09                	cmp    $0x9,%al
  800c3e:	74 f2                	je     800c32 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c40:	3c 2b                	cmp    $0x2b,%al
  800c42:	74 2a                	je     800c6e <strtol+0x4a>
	int neg = 0;
  800c44:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c49:	3c 2d                	cmp    $0x2d,%al
  800c4b:	74 2b                	je     800c78 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c53:	75 0f                	jne    800c64 <strtol+0x40>
  800c55:	80 39 30             	cmpb   $0x30,(%ecx)
  800c58:	74 28                	je     800c82 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c5a:	85 db                	test   %ebx,%ebx
  800c5c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c61:	0f 44 d8             	cmove  %eax,%ebx
  800c64:	b8 00 00 00 00       	mov    $0x0,%eax
  800c69:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c6c:	eb 50                	jmp    800cbe <strtol+0x9a>
		s++;
  800c6e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c71:	bf 00 00 00 00       	mov    $0x0,%edi
  800c76:	eb d5                	jmp    800c4d <strtol+0x29>
		s++, neg = 1;
  800c78:	83 c1 01             	add    $0x1,%ecx
  800c7b:	bf 01 00 00 00       	mov    $0x1,%edi
  800c80:	eb cb                	jmp    800c4d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c82:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c86:	74 0e                	je     800c96 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c88:	85 db                	test   %ebx,%ebx
  800c8a:	75 d8                	jne    800c64 <strtol+0x40>
		s++, base = 8;
  800c8c:	83 c1 01             	add    $0x1,%ecx
  800c8f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c94:	eb ce                	jmp    800c64 <strtol+0x40>
		s += 2, base = 16;
  800c96:	83 c1 02             	add    $0x2,%ecx
  800c99:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c9e:	eb c4                	jmp    800c64 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ca0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ca3:	89 f3                	mov    %esi,%ebx
  800ca5:	80 fb 19             	cmp    $0x19,%bl
  800ca8:	77 29                	ja     800cd3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800caa:	0f be d2             	movsbl %dl,%edx
  800cad:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cb0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cb3:	7d 30                	jge    800ce5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cb5:	83 c1 01             	add    $0x1,%ecx
  800cb8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cbc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cbe:	0f b6 11             	movzbl (%ecx),%edx
  800cc1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cc4:	89 f3                	mov    %esi,%ebx
  800cc6:	80 fb 09             	cmp    $0x9,%bl
  800cc9:	77 d5                	ja     800ca0 <strtol+0x7c>
			dig = *s - '0';
  800ccb:	0f be d2             	movsbl %dl,%edx
  800cce:	83 ea 30             	sub    $0x30,%edx
  800cd1:	eb dd                	jmp    800cb0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cd3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cd6:	89 f3                	mov    %esi,%ebx
  800cd8:	80 fb 19             	cmp    $0x19,%bl
  800cdb:	77 08                	ja     800ce5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cdd:	0f be d2             	movsbl %dl,%edx
  800ce0:	83 ea 37             	sub    $0x37,%edx
  800ce3:	eb cb                	jmp    800cb0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce9:	74 05                	je     800cf0 <strtol+0xcc>
		*endptr = (char *) s;
  800ceb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cee:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cf0:	89 c2                	mov    %eax,%edx
  800cf2:	f7 da                	neg    %edx
  800cf4:	85 ff                	test   %edi,%edi
  800cf6:	0f 45 c2             	cmovne %edx,%eax
}
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d04:	b8 00 00 00 00       	mov    $0x0,%eax
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0f:	89 c3                	mov    %eax,%ebx
  800d11:	89 c7                	mov    %eax,%edi
  800d13:	89 c6                	mov    %eax,%esi
  800d15:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <sys_cgetc>:

int
sys_cgetc(void)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d22:	ba 00 00 00 00       	mov    $0x0,%edx
  800d27:	b8 01 00 00 00       	mov    $0x1,%eax
  800d2c:	89 d1                	mov    %edx,%ecx
  800d2e:	89 d3                	mov    %edx,%ebx
  800d30:	89 d7                	mov    %edx,%edi
  800d32:	89 d6                	mov    %edx,%esi
  800d34:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d44:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d51:	89 cb                	mov    %ecx,%ebx
  800d53:	89 cf                	mov    %ecx,%edi
  800d55:	89 ce                	mov    %ecx,%esi
  800d57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	7f 08                	jg     800d65 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5f                   	pop    %edi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d65:	83 ec 0c             	sub    $0xc,%esp
  800d68:	50                   	push   %eax
  800d69:	6a 03                	push   $0x3
  800d6b:	68 c8 29 80 00       	push   $0x8029c8
  800d70:	6a 43                	push   $0x43
  800d72:	68 e5 29 80 00       	push   $0x8029e5
  800d77:	e8 f7 f3 ff ff       	call   800173 <_panic>

00800d7c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	57                   	push   %edi
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d82:	ba 00 00 00 00       	mov    $0x0,%edx
  800d87:	b8 02 00 00 00       	mov    $0x2,%eax
  800d8c:	89 d1                	mov    %edx,%ecx
  800d8e:	89 d3                	mov    %edx,%ebx
  800d90:	89 d7                	mov    %edx,%edi
  800d92:	89 d6                	mov    %edx,%esi
  800d94:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <sys_yield>:

void
sys_yield(void)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da1:	ba 00 00 00 00       	mov    $0x0,%edx
  800da6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dab:	89 d1                	mov    %edx,%ecx
  800dad:	89 d3                	mov    %edx,%ebx
  800daf:	89 d7                	mov    %edx,%edi
  800db1:	89 d6                	mov    %edx,%esi
  800db3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	be 00 00 00 00       	mov    $0x0,%esi
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dce:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd6:	89 f7                	mov    %esi,%edi
  800dd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7f 08                	jg     800de6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	50                   	push   %eax
  800dea:	6a 04                	push   $0x4
  800dec:	68 c8 29 80 00       	push   $0x8029c8
  800df1:	6a 43                	push   $0x43
  800df3:	68 e5 29 80 00       	push   $0x8029e5
  800df8:	e8 76 f3 ff ff       	call   800173 <_panic>

00800dfd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	57                   	push   %edi
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0c:	b8 05 00 00 00       	mov    $0x5,%eax
  800e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e14:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e17:	8b 75 18             	mov    0x18(%ebp),%esi
  800e1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	7f 08                	jg     800e28 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e28:	83 ec 0c             	sub    $0xc,%esp
  800e2b:	50                   	push   %eax
  800e2c:	6a 05                	push   $0x5
  800e2e:	68 c8 29 80 00       	push   $0x8029c8
  800e33:	6a 43                	push   $0x43
  800e35:	68 e5 29 80 00       	push   $0x8029e5
  800e3a:	e8 34 f3 ff ff       	call   800173 <_panic>

00800e3f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
  800e45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e53:	b8 06 00 00 00       	mov    $0x6,%eax
  800e58:	89 df                	mov    %ebx,%edi
  800e5a:	89 de                	mov    %ebx,%esi
  800e5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	7f 08                	jg     800e6a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6a:	83 ec 0c             	sub    $0xc,%esp
  800e6d:	50                   	push   %eax
  800e6e:	6a 06                	push   $0x6
  800e70:	68 c8 29 80 00       	push   $0x8029c8
  800e75:	6a 43                	push   $0x43
  800e77:	68 e5 29 80 00       	push   $0x8029e5
  800e7c:	e8 f2 f2 ff ff       	call   800173 <_panic>

00800e81 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	57                   	push   %edi
  800e85:	56                   	push   %esi
  800e86:	53                   	push   %ebx
  800e87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e95:	b8 08 00 00 00       	mov    $0x8,%eax
  800e9a:	89 df                	mov    %ebx,%edi
  800e9c:	89 de                	mov    %ebx,%esi
  800e9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	7f 08                	jg     800eac <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eac:	83 ec 0c             	sub    $0xc,%esp
  800eaf:	50                   	push   %eax
  800eb0:	6a 08                	push   $0x8
  800eb2:	68 c8 29 80 00       	push   $0x8029c8
  800eb7:	6a 43                	push   $0x43
  800eb9:	68 e5 29 80 00       	push   $0x8029e5
  800ebe:	e8 b0 f2 ff ff       	call   800173 <_panic>

00800ec3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
  800ec9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ecc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed7:	b8 09 00 00 00       	mov    $0x9,%eax
  800edc:	89 df                	mov    %ebx,%edi
  800ede:	89 de                	mov    %ebx,%esi
  800ee0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	7f 08                	jg     800eee <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eee:	83 ec 0c             	sub    $0xc,%esp
  800ef1:	50                   	push   %eax
  800ef2:	6a 09                	push   $0x9
  800ef4:	68 c8 29 80 00       	push   $0x8029c8
  800ef9:	6a 43                	push   $0x43
  800efb:	68 e5 29 80 00       	push   $0x8029e5
  800f00:	e8 6e f2 ff ff       	call   800173 <_panic>

00800f05 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	57                   	push   %edi
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
  800f0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f1e:	89 df                	mov    %ebx,%edi
  800f20:	89 de                	mov    %ebx,%esi
  800f22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	7f 08                	jg     800f30 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	50                   	push   %eax
  800f34:	6a 0a                	push   $0xa
  800f36:	68 c8 29 80 00       	push   $0x8029c8
  800f3b:	6a 43                	push   $0x43
  800f3d:	68 e5 29 80 00       	push   $0x8029e5
  800f42:	e8 2c f2 ff ff       	call   800173 <_panic>

00800f47 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	57                   	push   %edi
  800f4b:	56                   	push   %esi
  800f4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f53:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f58:	be 00 00 00 00       	mov    $0x0,%esi
  800f5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f60:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f63:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f78:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f80:	89 cb                	mov    %ecx,%ebx
  800f82:	89 cf                	mov    %ecx,%edi
  800f84:	89 ce                	mov    %ecx,%esi
  800f86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	7f 08                	jg     800f94 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	50                   	push   %eax
  800f98:	6a 0d                	push   $0xd
  800f9a:	68 c8 29 80 00       	push   $0x8029c8
  800f9f:	6a 43                	push   $0x43
  800fa1:	68 e5 29 80 00       	push   $0x8029e5
  800fa6:	e8 c8 f1 ff ff       	call   800173 <_panic>

00800fab <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	57                   	push   %edi
  800faf:	56                   	push   %esi
  800fb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbc:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fc1:	89 df                	mov    %ebx,%edi
  800fc3:	89 de                	mov    %ebx,%esi
  800fc5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fda:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fdf:	89 cb                	mov    %ecx,%ebx
  800fe1:	89 cf                	mov    %ecx,%edi
  800fe3:	89 ce                	mov    %ecx,%esi
  800fe5:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff7:	b8 10 00 00 00       	mov    $0x10,%eax
  800ffc:	89 d1                	mov    %edx,%ecx
  800ffe:	89 d3                	mov    %edx,%ebx
  801000:	89 d7                	mov    %edx,%edi
  801002:	89 d6                	mov    %edx,%esi
  801004:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	57                   	push   %edi
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
	asm volatile("int %1\n"
  801011:	bb 00 00 00 00       	mov    $0x0,%ebx
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101c:	b8 11 00 00 00       	mov    $0x11,%eax
  801021:	89 df                	mov    %ebx,%edi
  801023:	89 de                	mov    %ebx,%esi
  801025:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5f                   	pop    %edi
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    

0080102c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
	asm volatile("int %1\n"
  801032:	bb 00 00 00 00       	mov    $0x0,%ebx
  801037:	8b 55 08             	mov    0x8(%ebp),%edx
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	b8 12 00 00 00       	mov    $0x12,%eax
  801042:	89 df                	mov    %ebx,%edi
  801044:	89 de                	mov    %ebx,%esi
  801046:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801056:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801061:	b8 13 00 00 00       	mov    $0x13,%eax
  801066:	89 df                	mov    %ebx,%edi
  801068:	89 de                	mov    %ebx,%esi
  80106a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106c:	85 c0                	test   %eax,%eax
  80106e:	7f 08                	jg     801078 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801073:	5b                   	pop    %ebx
  801074:	5e                   	pop    %esi
  801075:	5f                   	pop    %edi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801078:	83 ec 0c             	sub    $0xc,%esp
  80107b:	50                   	push   %eax
  80107c:	6a 13                	push   $0x13
  80107e:	68 c8 29 80 00       	push   $0x8029c8
  801083:	6a 43                	push   $0x43
  801085:	68 e5 29 80 00       	push   $0x8029e5
  80108a:	e8 e4 f0 ff ff       	call   800173 <_panic>

0080108f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	57                   	push   %edi
  801093:	56                   	push   %esi
  801094:	53                   	push   %ebx
	asm volatile("int %1\n"
  801095:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109a:	8b 55 08             	mov    0x8(%ebp),%edx
  80109d:	b8 14 00 00 00       	mov    $0x14,%eax
  8010a2:	89 cb                	mov    %ecx,%ebx
  8010a4:	89 cf                	mov    %ecx,%edi
  8010a6:	89 ce                	mov    %ecx,%esi
  8010a8:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010aa:	5b                   	pop    %ebx
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ba:	c1 e8 0c             	shr    $0xc,%eax
}
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010cf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010de:	89 c2                	mov    %eax,%edx
  8010e0:	c1 ea 16             	shr    $0x16,%edx
  8010e3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ea:	f6 c2 01             	test   $0x1,%dl
  8010ed:	74 2d                	je     80111c <fd_alloc+0x46>
  8010ef:	89 c2                	mov    %eax,%edx
  8010f1:	c1 ea 0c             	shr    $0xc,%edx
  8010f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010fb:	f6 c2 01             	test   $0x1,%dl
  8010fe:	74 1c                	je     80111c <fd_alloc+0x46>
  801100:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801105:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80110a:	75 d2                	jne    8010de <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801115:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80111a:	eb 0a                	jmp    801126 <fd_alloc+0x50>
			*fd_store = fd;
  80111c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80112e:	83 f8 1f             	cmp    $0x1f,%eax
  801131:	77 30                	ja     801163 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801133:	c1 e0 0c             	shl    $0xc,%eax
  801136:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80113b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801141:	f6 c2 01             	test   $0x1,%dl
  801144:	74 24                	je     80116a <fd_lookup+0x42>
  801146:	89 c2                	mov    %eax,%edx
  801148:	c1 ea 0c             	shr    $0xc,%edx
  80114b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801152:	f6 c2 01             	test   $0x1,%dl
  801155:	74 1a                	je     801171 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	89 02                	mov    %eax,(%edx)
	return 0;
  80115c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    
		return -E_INVAL;
  801163:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801168:	eb f7                	jmp    801161 <fd_lookup+0x39>
		return -E_INVAL;
  80116a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116f:	eb f0                	jmp    801161 <fd_lookup+0x39>
  801171:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801176:	eb e9                	jmp    801161 <fd_lookup+0x39>

00801178 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801181:	ba 00 00 00 00       	mov    $0x0,%edx
  801186:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80118b:	39 08                	cmp    %ecx,(%eax)
  80118d:	74 38                	je     8011c7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80118f:	83 c2 01             	add    $0x1,%edx
  801192:	8b 04 95 74 2a 80 00 	mov    0x802a74(,%edx,4),%eax
  801199:	85 c0                	test   %eax,%eax
  80119b:	75 ee                	jne    80118b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80119d:	a1 08 40 80 00       	mov    0x804008,%eax
  8011a2:	8b 40 48             	mov    0x48(%eax),%eax
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	51                   	push   %ecx
  8011a9:	50                   	push   %eax
  8011aa:	68 f4 29 80 00       	push   $0x8029f4
  8011af:	e8 b5 f0 ff ff       	call   800269 <cprintf>
	*dev = 0;
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    
			*dev = devtab[i];
  8011c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ca:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d1:	eb f2                	jmp    8011c5 <dev_lookup+0x4d>

008011d3 <fd_close>:
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	57                   	push   %edi
  8011d7:	56                   	push   %esi
  8011d8:	53                   	push   %ebx
  8011d9:	83 ec 24             	sub    $0x24,%esp
  8011dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8011df:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011ec:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ef:	50                   	push   %eax
  8011f0:	e8 33 ff ff ff       	call   801128 <fd_lookup>
  8011f5:	89 c3                	mov    %eax,%ebx
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	78 05                	js     801203 <fd_close+0x30>
	    || fd != fd2)
  8011fe:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801201:	74 16                	je     801219 <fd_close+0x46>
		return (must_exist ? r : 0);
  801203:	89 f8                	mov    %edi,%eax
  801205:	84 c0                	test   %al,%al
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
  80120c:	0f 44 d8             	cmove  %eax,%ebx
}
  80120f:	89 d8                	mov    %ebx,%eax
  801211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801214:	5b                   	pop    %ebx
  801215:	5e                   	pop    %esi
  801216:	5f                   	pop    %edi
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80121f:	50                   	push   %eax
  801220:	ff 36                	pushl  (%esi)
  801222:	e8 51 ff ff ff       	call   801178 <dev_lookup>
  801227:	89 c3                	mov    %eax,%ebx
  801229:	83 c4 10             	add    $0x10,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	78 1a                	js     80124a <fd_close+0x77>
		if (dev->dev_close)
  801230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801233:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801236:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80123b:	85 c0                	test   %eax,%eax
  80123d:	74 0b                	je     80124a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	56                   	push   %esi
  801243:	ff d0                	call   *%eax
  801245:	89 c3                	mov    %eax,%ebx
  801247:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	56                   	push   %esi
  80124e:	6a 00                	push   $0x0
  801250:	e8 ea fb ff ff       	call   800e3f <sys_page_unmap>
	return r;
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	eb b5                	jmp    80120f <fd_close+0x3c>

0080125a <close>:

int
close(int fdnum)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801260:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801263:	50                   	push   %eax
  801264:	ff 75 08             	pushl  0x8(%ebp)
  801267:	e8 bc fe ff ff       	call   801128 <fd_lookup>
  80126c:	83 c4 10             	add    $0x10,%esp
  80126f:	85 c0                	test   %eax,%eax
  801271:	79 02                	jns    801275 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    
		return fd_close(fd, 1);
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	6a 01                	push   $0x1
  80127a:	ff 75 f4             	pushl  -0xc(%ebp)
  80127d:	e8 51 ff ff ff       	call   8011d3 <fd_close>
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	eb ec                	jmp    801273 <close+0x19>

00801287 <close_all>:

void
close_all(void)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	53                   	push   %ebx
  80128b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80128e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	53                   	push   %ebx
  801297:	e8 be ff ff ff       	call   80125a <close>
	for (i = 0; i < MAXFD; i++)
  80129c:	83 c3 01             	add    $0x1,%ebx
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	83 fb 20             	cmp    $0x20,%ebx
  8012a5:	75 ec                	jne    801293 <close_all+0xc>
}
  8012a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b8:	50                   	push   %eax
  8012b9:	ff 75 08             	pushl  0x8(%ebp)
  8012bc:	e8 67 fe ff ff       	call   801128 <fd_lookup>
  8012c1:	89 c3                	mov    %eax,%ebx
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	0f 88 81 00 00 00    	js     80134f <dup+0xa3>
		return r;
	close(newfdnum);
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	e8 81 ff ff ff       	call   80125a <close>

	newfd = INDEX2FD(newfdnum);
  8012d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012dc:	c1 e6 0c             	shl    $0xc,%esi
  8012df:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012e5:	83 c4 04             	add    $0x4,%esp
  8012e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012eb:	e8 cf fd ff ff       	call   8010bf <fd2data>
  8012f0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012f2:	89 34 24             	mov    %esi,(%esp)
  8012f5:	e8 c5 fd ff ff       	call   8010bf <fd2data>
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ff:	89 d8                	mov    %ebx,%eax
  801301:	c1 e8 16             	shr    $0x16,%eax
  801304:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80130b:	a8 01                	test   $0x1,%al
  80130d:	74 11                	je     801320 <dup+0x74>
  80130f:	89 d8                	mov    %ebx,%eax
  801311:	c1 e8 0c             	shr    $0xc,%eax
  801314:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80131b:	f6 c2 01             	test   $0x1,%dl
  80131e:	75 39                	jne    801359 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801320:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801323:	89 d0                	mov    %edx,%eax
  801325:	c1 e8 0c             	shr    $0xc,%eax
  801328:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80132f:	83 ec 0c             	sub    $0xc,%esp
  801332:	25 07 0e 00 00       	and    $0xe07,%eax
  801337:	50                   	push   %eax
  801338:	56                   	push   %esi
  801339:	6a 00                	push   $0x0
  80133b:	52                   	push   %edx
  80133c:	6a 00                	push   $0x0
  80133e:	e8 ba fa ff ff       	call   800dfd <sys_page_map>
  801343:	89 c3                	mov    %eax,%ebx
  801345:	83 c4 20             	add    $0x20,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	78 31                	js     80137d <dup+0xd1>
		goto err;

	return newfdnum;
  80134c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80134f:	89 d8                	mov    %ebx,%eax
  801351:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801354:	5b                   	pop    %ebx
  801355:	5e                   	pop    %esi
  801356:	5f                   	pop    %edi
  801357:	5d                   	pop    %ebp
  801358:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801359:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	25 07 0e 00 00       	and    $0xe07,%eax
  801368:	50                   	push   %eax
  801369:	57                   	push   %edi
  80136a:	6a 00                	push   $0x0
  80136c:	53                   	push   %ebx
  80136d:	6a 00                	push   $0x0
  80136f:	e8 89 fa ff ff       	call   800dfd <sys_page_map>
  801374:	89 c3                	mov    %eax,%ebx
  801376:	83 c4 20             	add    $0x20,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	79 a3                	jns    801320 <dup+0x74>
	sys_page_unmap(0, newfd);
  80137d:	83 ec 08             	sub    $0x8,%esp
  801380:	56                   	push   %esi
  801381:	6a 00                	push   $0x0
  801383:	e8 b7 fa ff ff       	call   800e3f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801388:	83 c4 08             	add    $0x8,%esp
  80138b:	57                   	push   %edi
  80138c:	6a 00                	push   $0x0
  80138e:	e8 ac fa ff ff       	call   800e3f <sys_page_unmap>
	return r;
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	eb b7                	jmp    80134f <dup+0xa3>

00801398 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	53                   	push   %ebx
  80139c:	83 ec 1c             	sub    $0x1c,%esp
  80139f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a5:	50                   	push   %eax
  8013a6:	53                   	push   %ebx
  8013a7:	e8 7c fd ff ff       	call   801128 <fd_lookup>
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 3f                	js     8013f2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bd:	ff 30                	pushl  (%eax)
  8013bf:	e8 b4 fd ff ff       	call   801178 <dev_lookup>
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 27                	js     8013f2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ce:	8b 42 08             	mov    0x8(%edx),%eax
  8013d1:	83 e0 03             	and    $0x3,%eax
  8013d4:	83 f8 01             	cmp    $0x1,%eax
  8013d7:	74 1e                	je     8013f7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	8b 40 08             	mov    0x8(%eax),%eax
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	74 35                	je     801418 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	ff 75 10             	pushl  0x10(%ebp)
  8013e9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ec:	52                   	push   %edx
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
}
  8013f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8013fc:	8b 40 48             	mov    0x48(%eax),%eax
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	53                   	push   %ebx
  801403:	50                   	push   %eax
  801404:	68 38 2a 80 00       	push   $0x802a38
  801409:	e8 5b ee ff ff       	call   800269 <cprintf>
		return -E_INVAL;
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801416:	eb da                	jmp    8013f2 <read+0x5a>
		return -E_NOT_SUPP;
  801418:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141d:	eb d3                	jmp    8013f2 <read+0x5a>

0080141f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	57                   	push   %edi
  801423:	56                   	push   %esi
  801424:	53                   	push   %ebx
  801425:	83 ec 0c             	sub    $0xc,%esp
  801428:	8b 7d 08             	mov    0x8(%ebp),%edi
  80142b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80142e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801433:	39 f3                	cmp    %esi,%ebx
  801435:	73 23                	jae    80145a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	89 f0                	mov    %esi,%eax
  80143c:	29 d8                	sub    %ebx,%eax
  80143e:	50                   	push   %eax
  80143f:	89 d8                	mov    %ebx,%eax
  801441:	03 45 0c             	add    0xc(%ebp),%eax
  801444:	50                   	push   %eax
  801445:	57                   	push   %edi
  801446:	e8 4d ff ff ff       	call   801398 <read>
		if (m < 0)
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 06                	js     801458 <readn+0x39>
			return m;
		if (m == 0)
  801452:	74 06                	je     80145a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801454:	01 c3                	add    %eax,%ebx
  801456:	eb db                	jmp    801433 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801458:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80145a:	89 d8                	mov    %ebx,%eax
  80145c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80145f:	5b                   	pop    %ebx
  801460:	5e                   	pop    %esi
  801461:	5f                   	pop    %edi
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    

00801464 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	53                   	push   %ebx
  801468:	83 ec 1c             	sub    $0x1c,%esp
  80146b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801471:	50                   	push   %eax
  801472:	53                   	push   %ebx
  801473:	e8 b0 fc ff ff       	call   801128 <fd_lookup>
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 3a                	js     8014b9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801489:	ff 30                	pushl  (%eax)
  80148b:	e8 e8 fc ff ff       	call   801178 <dev_lookup>
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	85 c0                	test   %eax,%eax
  801495:	78 22                	js     8014b9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149e:	74 1e                	je     8014be <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a6:	85 d2                	test   %edx,%edx
  8014a8:	74 35                	je     8014df <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	ff 75 10             	pushl  0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	50                   	push   %eax
  8014b4:	ff d2                	call   *%edx
  8014b6:	83 c4 10             	add    $0x10,%esp
}
  8014b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014be:	a1 08 40 80 00       	mov    0x804008,%eax
  8014c3:	8b 40 48             	mov    0x48(%eax),%eax
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	53                   	push   %ebx
  8014ca:	50                   	push   %eax
  8014cb:	68 54 2a 80 00       	push   $0x802a54
  8014d0:	e8 94 ed ff ff       	call   800269 <cprintf>
		return -E_INVAL;
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014dd:	eb da                	jmp    8014b9 <write+0x55>
		return -E_NOT_SUPP;
  8014df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e4:	eb d3                	jmp    8014b9 <write+0x55>

008014e6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ef:	50                   	push   %eax
  8014f0:	ff 75 08             	pushl  0x8(%ebp)
  8014f3:	e8 30 fc ff ff       	call   801128 <fd_lookup>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 0e                	js     80150d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801505:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	53                   	push   %ebx
  801513:	83 ec 1c             	sub    $0x1c,%esp
  801516:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801519:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	53                   	push   %ebx
  80151e:	e8 05 fc ff ff       	call   801128 <fd_lookup>
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 37                	js     801561 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801530:	50                   	push   %eax
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	ff 30                	pushl  (%eax)
  801536:	e8 3d fc ff ff       	call   801178 <dev_lookup>
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 1f                	js     801561 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801545:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801549:	74 1b                	je     801566 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80154b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154e:	8b 52 18             	mov    0x18(%edx),%edx
  801551:	85 d2                	test   %edx,%edx
  801553:	74 32                	je     801587 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	ff 75 0c             	pushl  0xc(%ebp)
  80155b:	50                   	push   %eax
  80155c:	ff d2                	call   *%edx
  80155e:	83 c4 10             	add    $0x10,%esp
}
  801561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801564:	c9                   	leave  
  801565:	c3                   	ret    
			thisenv->env_id, fdnum);
  801566:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80156b:	8b 40 48             	mov    0x48(%eax),%eax
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	53                   	push   %ebx
  801572:	50                   	push   %eax
  801573:	68 14 2a 80 00       	push   $0x802a14
  801578:	e8 ec ec ff ff       	call   800269 <cprintf>
		return -E_INVAL;
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801585:	eb da                	jmp    801561 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801587:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158c:	eb d3                	jmp    801561 <ftruncate+0x52>

0080158e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	53                   	push   %ebx
  801592:	83 ec 1c             	sub    $0x1c,%esp
  801595:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801598:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	ff 75 08             	pushl  0x8(%ebp)
  80159f:	e8 84 fb ff ff       	call   801128 <fd_lookup>
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 4b                	js     8015f6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b1:	50                   	push   %eax
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	ff 30                	pushl  (%eax)
  8015b7:	e8 bc fb ff ff       	call   801178 <dev_lookup>
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 33                	js     8015f6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015ca:	74 2f                	je     8015fb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015cc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015cf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015d6:	00 00 00 
	stat->st_isdir = 0;
  8015d9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015e0:	00 00 00 
	stat->st_dev = dev;
  8015e3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	53                   	push   %ebx
  8015ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f0:	ff 50 14             	call   *0x14(%eax)
  8015f3:	83 c4 10             	add    $0x10,%esp
}
  8015f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    
		return -E_NOT_SUPP;
  8015fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801600:	eb f4                	jmp    8015f6 <fstat+0x68>

00801602 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	6a 00                	push   $0x0
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	e8 22 02 00 00       	call   801836 <open>
  801614:	89 c3                	mov    %eax,%ebx
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	78 1b                	js     801638 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80161d:	83 ec 08             	sub    $0x8,%esp
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	50                   	push   %eax
  801624:	e8 65 ff ff ff       	call   80158e <fstat>
  801629:	89 c6                	mov    %eax,%esi
	close(fd);
  80162b:	89 1c 24             	mov    %ebx,(%esp)
  80162e:	e8 27 fc ff ff       	call   80125a <close>
	return r;
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	89 f3                	mov    %esi,%ebx
}
  801638:	89 d8                	mov    %ebx,%eax
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	56                   	push   %esi
  801645:	53                   	push   %ebx
  801646:	89 c6                	mov    %eax,%esi
  801648:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80164a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801651:	74 27                	je     80167a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801653:	6a 07                	push   $0x7
  801655:	68 00 50 80 00       	push   $0x805000
  80165a:	56                   	push   %esi
  80165b:	ff 35 00 40 80 00    	pushl  0x804000
  801661:	e8 08 0c 00 00       	call   80226e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801666:	83 c4 0c             	add    $0xc,%esp
  801669:	6a 00                	push   $0x0
  80166b:	53                   	push   %ebx
  80166c:	6a 00                	push   $0x0
  80166e:	e8 92 0b 00 00       	call   802205 <ipc_recv>
}
  801673:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	6a 01                	push   $0x1
  80167f:	e8 42 0c 00 00       	call   8022c6 <ipc_find_env>
  801684:	a3 00 40 80 00       	mov    %eax,0x804000
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	eb c5                	jmp    801653 <fsipc+0x12>

0080168e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	8b 40 0c             	mov    0xc(%eax),%eax
  80169a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	b8 02 00 00 00       	mov    $0x2,%eax
  8016b1:	e8 8b ff ff ff       	call   801641 <fsipc>
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <devfile_flush>:
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8016d3:	e8 69 ff ff ff       	call   801641 <fsipc>
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <devfile_stat>:
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ea:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f9:	e8 43 ff ff ff       	call   801641 <fsipc>
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 2c                	js     80172e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	68 00 50 80 00       	push   $0x805000
  80170a:	53                   	push   %ebx
  80170b:	e8 b8 f2 ff ff       	call   8009c8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801710:	a1 80 50 80 00       	mov    0x805080,%eax
  801715:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80171b:	a1 84 50 80 00       	mov    0x805084,%eax
  801720:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <devfile_write>:
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	53                   	push   %ebx
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8b 40 0c             	mov    0xc(%eax),%eax
  801743:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801748:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80174e:	53                   	push   %ebx
  80174f:	ff 75 0c             	pushl  0xc(%ebp)
  801752:	68 08 50 80 00       	push   $0x805008
  801757:	e8 5c f4 ff ff       	call   800bb8 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80175c:	ba 00 00 00 00       	mov    $0x0,%edx
  801761:	b8 04 00 00 00       	mov    $0x4,%eax
  801766:	e8 d6 fe ff ff       	call   801641 <fsipc>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 0b                	js     80177d <devfile_write+0x4a>
	assert(r <= n);
  801772:	39 d8                	cmp    %ebx,%eax
  801774:	77 0c                	ja     801782 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801776:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80177b:	7f 1e                	jg     80179b <devfile_write+0x68>
}
  80177d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801780:	c9                   	leave  
  801781:	c3                   	ret    
	assert(r <= n);
  801782:	68 88 2a 80 00       	push   $0x802a88
  801787:	68 8f 2a 80 00       	push   $0x802a8f
  80178c:	68 98 00 00 00       	push   $0x98
  801791:	68 a4 2a 80 00       	push   $0x802aa4
  801796:	e8 d8 e9 ff ff       	call   800173 <_panic>
	assert(r <= PGSIZE);
  80179b:	68 af 2a 80 00       	push   $0x802aaf
  8017a0:	68 8f 2a 80 00       	push   $0x802a8f
  8017a5:	68 99 00 00 00       	push   $0x99
  8017aa:	68 a4 2a 80 00       	push   $0x802aa4
  8017af:	e8 bf e9 ff ff       	call   800173 <_panic>

008017b4 <devfile_read>:
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
  8017b9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017c7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d2:	b8 03 00 00 00       	mov    $0x3,%eax
  8017d7:	e8 65 fe ff ff       	call   801641 <fsipc>
  8017dc:	89 c3                	mov    %eax,%ebx
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 1f                	js     801801 <devfile_read+0x4d>
	assert(r <= n);
  8017e2:	39 f0                	cmp    %esi,%eax
  8017e4:	77 24                	ja     80180a <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017e6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017eb:	7f 33                	jg     801820 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	50                   	push   %eax
  8017f1:	68 00 50 80 00       	push   $0x805000
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	e8 58 f3 ff ff       	call   800b56 <memmove>
	return r;
  8017fe:	83 c4 10             	add    $0x10,%esp
}
  801801:	89 d8                	mov    %ebx,%eax
  801803:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801806:	5b                   	pop    %ebx
  801807:	5e                   	pop    %esi
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    
	assert(r <= n);
  80180a:	68 88 2a 80 00       	push   $0x802a88
  80180f:	68 8f 2a 80 00       	push   $0x802a8f
  801814:	6a 7c                	push   $0x7c
  801816:	68 a4 2a 80 00       	push   $0x802aa4
  80181b:	e8 53 e9 ff ff       	call   800173 <_panic>
	assert(r <= PGSIZE);
  801820:	68 af 2a 80 00       	push   $0x802aaf
  801825:	68 8f 2a 80 00       	push   $0x802a8f
  80182a:	6a 7d                	push   $0x7d
  80182c:	68 a4 2a 80 00       	push   $0x802aa4
  801831:	e8 3d e9 ff ff       	call   800173 <_panic>

00801836 <open>:
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 1c             	sub    $0x1c,%esp
  80183e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801841:	56                   	push   %esi
  801842:	e8 48 f1 ff ff       	call   80098f <strlen>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80184f:	7f 6c                	jg     8018bd <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801857:	50                   	push   %eax
  801858:	e8 79 f8 ff ff       	call   8010d6 <fd_alloc>
  80185d:	89 c3                	mov    %eax,%ebx
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	85 c0                	test   %eax,%eax
  801864:	78 3c                	js     8018a2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801866:	83 ec 08             	sub    $0x8,%esp
  801869:	56                   	push   %esi
  80186a:	68 00 50 80 00       	push   $0x805000
  80186f:	e8 54 f1 ff ff       	call   8009c8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80187c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187f:	b8 01 00 00 00       	mov    $0x1,%eax
  801884:	e8 b8 fd ff ff       	call   801641 <fsipc>
  801889:	89 c3                	mov    %eax,%ebx
  80188b:	83 c4 10             	add    $0x10,%esp
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 19                	js     8018ab <open+0x75>
	return fd2num(fd);
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	ff 75 f4             	pushl  -0xc(%ebp)
  801898:	e8 12 f8 ff ff       	call   8010af <fd2num>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	83 c4 10             	add    $0x10,%esp
}
  8018a2:	89 d8                	mov    %ebx,%eax
  8018a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a7:	5b                   	pop    %ebx
  8018a8:	5e                   	pop    %esi
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    
		fd_close(fd, 0);
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	6a 00                	push   $0x0
  8018b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b3:	e8 1b f9 ff ff       	call   8011d3 <fd_close>
		return r;
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	eb e5                	jmp    8018a2 <open+0x6c>
		return -E_BAD_PATH;
  8018bd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018c2:	eb de                	jmp    8018a2 <open+0x6c>

008018c4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cf:	b8 08 00 00 00       	mov    $0x8,%eax
  8018d4:	e8 68 fd ff ff       	call   801641 <fsipc>
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018e1:	68 bb 2a 80 00       	push   $0x802abb
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	e8 da f0 ff ff       	call   8009c8 <strcpy>
	return 0;
}
  8018ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <devsock_close>:
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	53                   	push   %ebx
  8018f9:	83 ec 10             	sub    $0x10,%esp
  8018fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018ff:	53                   	push   %ebx
  801900:	e8 00 0a 00 00       	call   802305 <pageref>
  801905:	83 c4 10             	add    $0x10,%esp
		return 0;
  801908:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80190d:	83 f8 01             	cmp    $0x1,%eax
  801910:	74 07                	je     801919 <devsock_close+0x24>
}
  801912:	89 d0                	mov    %edx,%eax
  801914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801917:	c9                   	leave  
  801918:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801919:	83 ec 0c             	sub    $0xc,%esp
  80191c:	ff 73 0c             	pushl  0xc(%ebx)
  80191f:	e8 b9 02 00 00       	call   801bdd <nsipc_close>
  801924:	89 c2                	mov    %eax,%edx
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	eb e7                	jmp    801912 <devsock_close+0x1d>

0080192b <devsock_write>:
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801931:	6a 00                	push   $0x0
  801933:	ff 75 10             	pushl  0x10(%ebp)
  801936:	ff 75 0c             	pushl  0xc(%ebp)
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	ff 70 0c             	pushl  0xc(%eax)
  80193f:	e8 76 03 00 00       	call   801cba <nsipc_send>
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <devsock_read>:
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	ff 75 10             	pushl  0x10(%ebp)
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	ff 70 0c             	pushl  0xc(%eax)
  80195a:	e8 ef 02 00 00       	call   801c4e <nsipc_recv>
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <fd2sockid>:
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801967:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	e8 b7 f7 ff ff       	call   801128 <fd_lookup>
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	85 c0                	test   %eax,%eax
  801976:	78 10                	js     801988 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197b:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801981:	39 08                	cmp    %ecx,(%eax)
  801983:	75 05                	jne    80198a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801985:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    
		return -E_NOT_SUPP;
  80198a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80198f:	eb f7                	jmp    801988 <fd2sockid+0x27>

00801991 <alloc_sockfd>:
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	56                   	push   %esi
  801995:	53                   	push   %ebx
  801996:	83 ec 1c             	sub    $0x1c,%esp
  801999:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80199b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199e:	50                   	push   %eax
  80199f:	e8 32 f7 ff ff       	call   8010d6 <fd_alloc>
  8019a4:	89 c3                	mov    %eax,%ebx
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	78 43                	js     8019f0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	68 07 04 00 00       	push   $0x407
  8019b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b8:	6a 00                	push   $0x0
  8019ba:	e8 fb f3 ff ff       	call   800dba <sys_page_alloc>
  8019bf:	89 c3                	mov    %eax,%ebx
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 28                	js     8019f0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019d1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019dd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019e0:	83 ec 0c             	sub    $0xc,%esp
  8019e3:	50                   	push   %eax
  8019e4:	e8 c6 f6 ff ff       	call   8010af <fd2num>
  8019e9:	89 c3                	mov    %eax,%ebx
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	eb 0c                	jmp    8019fc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019f0:	83 ec 0c             	sub    $0xc,%esp
  8019f3:	56                   	push   %esi
  8019f4:	e8 e4 01 00 00       	call   801bdd <nsipc_close>
		return r;
  8019f9:	83 c4 10             	add    $0x10,%esp
}
  8019fc:	89 d8                	mov    %ebx,%eax
  8019fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a01:	5b                   	pop    %ebx
  801a02:	5e                   	pop    %esi
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    

00801a05 <accept>:
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	e8 4e ff ff ff       	call   801961 <fd2sockid>
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 1b                	js     801a32 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	ff 75 10             	pushl  0x10(%ebp)
  801a1d:	ff 75 0c             	pushl  0xc(%ebp)
  801a20:	50                   	push   %eax
  801a21:	e8 0e 01 00 00       	call   801b34 <nsipc_accept>
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	78 05                	js     801a32 <accept+0x2d>
	return alloc_sockfd(r);
  801a2d:	e8 5f ff ff ff       	call   801991 <alloc_sockfd>
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <bind>:
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	e8 1f ff ff ff       	call   801961 <fd2sockid>
  801a42:	85 c0                	test   %eax,%eax
  801a44:	78 12                	js     801a58 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	ff 75 10             	pushl  0x10(%ebp)
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	50                   	push   %eax
  801a50:	e8 31 01 00 00       	call   801b86 <nsipc_bind>
  801a55:	83 c4 10             	add    $0x10,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <shutdown>:
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	e8 f9 fe ff ff       	call   801961 <fd2sockid>
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	78 0f                	js     801a7b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	50                   	push   %eax
  801a73:	e8 43 01 00 00       	call   801bbb <nsipc_shutdown>
  801a78:	83 c4 10             	add    $0x10,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <connect>:
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	e8 d6 fe ff ff       	call   801961 <fd2sockid>
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	78 12                	js     801aa1 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a8f:	83 ec 04             	sub    $0x4,%esp
  801a92:	ff 75 10             	pushl  0x10(%ebp)
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	50                   	push   %eax
  801a99:	e8 59 01 00 00       	call   801bf7 <nsipc_connect>
  801a9e:	83 c4 10             	add    $0x10,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <listen>:
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	e8 b0 fe ff ff       	call   801961 <fd2sockid>
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 0f                	js     801ac4 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ab5:	83 ec 08             	sub    $0x8,%esp
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	50                   	push   %eax
  801abc:	e8 6b 01 00 00       	call   801c2c <nsipc_listen>
  801ac1:	83 c4 10             	add    $0x10,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801acc:	ff 75 10             	pushl  0x10(%ebp)
  801acf:	ff 75 0c             	pushl  0xc(%ebp)
  801ad2:	ff 75 08             	pushl  0x8(%ebp)
  801ad5:	e8 3e 02 00 00       	call   801d18 <nsipc_socket>
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 05                	js     801ae6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ae1:	e8 ab fe ff ff       	call   801991 <alloc_sockfd>
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 04             	sub    $0x4,%esp
  801aef:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801af1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801af8:	74 26                	je     801b20 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801afa:	6a 07                	push   $0x7
  801afc:	68 00 60 80 00       	push   $0x806000
  801b01:	53                   	push   %ebx
  801b02:	ff 35 04 40 80 00    	pushl  0x804004
  801b08:	e8 61 07 00 00       	call   80226e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b0d:	83 c4 0c             	add    $0xc,%esp
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	e8 ea 06 00 00       	call   802205 <ipc_recv>
}
  801b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b20:	83 ec 0c             	sub    $0xc,%esp
  801b23:	6a 02                	push   $0x2
  801b25:	e8 9c 07 00 00       	call   8022c6 <ipc_find_env>
  801b2a:	a3 04 40 80 00       	mov    %eax,0x804004
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	eb c6                	jmp    801afa <nsipc+0x12>

00801b34 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	56                   	push   %esi
  801b38:	53                   	push   %ebx
  801b39:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b44:	8b 06                	mov    (%esi),%eax
  801b46:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b50:	e8 93 ff ff ff       	call   801ae8 <nsipc>
  801b55:	89 c3                	mov    %eax,%ebx
  801b57:	85 c0                	test   %eax,%eax
  801b59:	79 09                	jns    801b64 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b5b:	89 d8                	mov    %ebx,%eax
  801b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b60:	5b                   	pop    %ebx
  801b61:	5e                   	pop    %esi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	ff 35 10 60 80 00    	pushl  0x806010
  801b6d:	68 00 60 80 00       	push   $0x806000
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	e8 dc ef ff ff       	call   800b56 <memmove>
		*addrlen = ret->ret_addrlen;
  801b7a:	a1 10 60 80 00       	mov    0x806010,%eax
  801b7f:	89 06                	mov    %eax,(%esi)
  801b81:	83 c4 10             	add    $0x10,%esp
	return r;
  801b84:	eb d5                	jmp    801b5b <nsipc_accept+0x27>

00801b86 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	53                   	push   %ebx
  801b8a:	83 ec 08             	sub    $0x8,%esp
  801b8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b98:	53                   	push   %ebx
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	68 04 60 80 00       	push   $0x806004
  801ba1:	e8 b0 ef ff ff       	call   800b56 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ba6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bac:	b8 02 00 00 00       	mov    $0x2,%eax
  801bb1:	e8 32 ff ff ff       	call   801ae8 <nsipc>
}
  801bb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcc:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bd1:	b8 03 00 00 00       	mov    $0x3,%eax
  801bd6:	e8 0d ff ff ff       	call   801ae8 <nsipc>
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <nsipc_close>:

int
nsipc_close(int s)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801beb:	b8 04 00 00 00       	mov    $0x4,%eax
  801bf0:	e8 f3 fe ff ff       	call   801ae8 <nsipc>
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	53                   	push   %ebx
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c09:	53                   	push   %ebx
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	68 04 60 80 00       	push   $0x806004
  801c12:	e8 3f ef ff ff       	call   800b56 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c17:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c1d:	b8 05 00 00 00       	mov    $0x5,%eax
  801c22:	e8 c1 fe ff ff       	call   801ae8 <nsipc>
}
  801c27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c42:	b8 06 00 00 00       	mov    $0x6,%eax
  801c47:	e8 9c fe ff ff       	call   801ae8 <nsipc>
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	56                   	push   %esi
  801c52:	53                   	push   %ebx
  801c53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c6c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c71:	e8 72 fe ff ff       	call   801ae8 <nsipc>
  801c76:	89 c3                	mov    %eax,%ebx
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 1f                	js     801c9b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c7c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c81:	7f 21                	jg     801ca4 <nsipc_recv+0x56>
  801c83:	39 c6                	cmp    %eax,%esi
  801c85:	7c 1d                	jl     801ca4 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	50                   	push   %eax
  801c8b:	68 00 60 80 00       	push   $0x806000
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	e8 be ee ff ff       	call   800b56 <memmove>
  801c98:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c9b:	89 d8                	mov    %ebx,%eax
  801c9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca0:	5b                   	pop    %ebx
  801ca1:	5e                   	pop    %esi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ca4:	68 c7 2a 80 00       	push   $0x802ac7
  801ca9:	68 8f 2a 80 00       	push   $0x802a8f
  801cae:	6a 62                	push   $0x62
  801cb0:	68 dc 2a 80 00       	push   $0x802adc
  801cb5:	e8 b9 e4 ff ff       	call   800173 <_panic>

00801cba <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ccc:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cd2:	7f 2e                	jg     801d02 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	53                   	push   %ebx
  801cd8:	ff 75 0c             	pushl  0xc(%ebp)
  801cdb:	68 0c 60 80 00       	push   $0x80600c
  801ce0:	e8 71 ee ff ff       	call   800b56 <memmove>
	nsipcbuf.send.req_size = size;
  801ce5:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cee:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cf3:	b8 08 00 00 00       	mov    $0x8,%eax
  801cf8:	e8 eb fd ff ff       	call   801ae8 <nsipc>
}
  801cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    
	assert(size < 1600);
  801d02:	68 e8 2a 80 00       	push   $0x802ae8
  801d07:	68 8f 2a 80 00       	push   $0x802a8f
  801d0c:	6a 6d                	push   $0x6d
  801d0e:	68 dc 2a 80 00       	push   $0x802adc
  801d13:	e8 5b e4 ff ff       	call   800173 <_panic>

00801d18 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d29:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d31:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d36:	b8 09 00 00 00       	mov    $0x9,%eax
  801d3b:	e8 a8 fd ff ff       	call   801ae8 <nsipc>
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	ff 75 08             	pushl  0x8(%ebp)
  801d50:	e8 6a f3 ff ff       	call   8010bf <fd2data>
  801d55:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d57:	83 c4 08             	add    $0x8,%esp
  801d5a:	68 f4 2a 80 00       	push   $0x802af4
  801d5f:	53                   	push   %ebx
  801d60:	e8 63 ec ff ff       	call   8009c8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d65:	8b 46 04             	mov    0x4(%esi),%eax
  801d68:	2b 06                	sub    (%esi),%eax
  801d6a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d70:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d77:	00 00 00 
	stat->st_dev = &devpipe;
  801d7a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d81:	30 80 00 
	return 0;
}
  801d84:	b8 00 00 00 00       	mov    $0x0,%eax
  801d89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8c:	5b                   	pop    %ebx
  801d8d:	5e                   	pop    %esi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    

00801d90 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	53                   	push   %ebx
  801d94:	83 ec 0c             	sub    $0xc,%esp
  801d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d9a:	53                   	push   %ebx
  801d9b:	6a 00                	push   $0x0
  801d9d:	e8 9d f0 ff ff       	call   800e3f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801da2:	89 1c 24             	mov    %ebx,(%esp)
  801da5:	e8 15 f3 ff ff       	call   8010bf <fd2data>
  801daa:	83 c4 08             	add    $0x8,%esp
  801dad:	50                   	push   %eax
  801dae:	6a 00                	push   $0x0
  801db0:	e8 8a f0 ff ff       	call   800e3f <sys_page_unmap>
}
  801db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <_pipeisclosed>:
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	57                   	push   %edi
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
  801dc0:	83 ec 1c             	sub    $0x1c,%esp
  801dc3:	89 c7                	mov    %eax,%edi
  801dc5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dc7:	a1 08 40 80 00       	mov    0x804008,%eax
  801dcc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	57                   	push   %edi
  801dd3:	e8 2d 05 00 00       	call   802305 <pageref>
  801dd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ddb:	89 34 24             	mov    %esi,(%esp)
  801dde:	e8 22 05 00 00       	call   802305 <pageref>
		nn = thisenv->env_runs;
  801de3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801de9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	39 cb                	cmp    %ecx,%ebx
  801df1:	74 1b                	je     801e0e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801df3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801df6:	75 cf                	jne    801dc7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801df8:	8b 42 58             	mov    0x58(%edx),%eax
  801dfb:	6a 01                	push   $0x1
  801dfd:	50                   	push   %eax
  801dfe:	53                   	push   %ebx
  801dff:	68 fb 2a 80 00       	push   $0x802afb
  801e04:	e8 60 e4 ff ff       	call   800269 <cprintf>
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	eb b9                	jmp    801dc7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e0e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e11:	0f 94 c0             	sete   %al
  801e14:	0f b6 c0             	movzbl %al,%eax
}
  801e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5f                   	pop    %edi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <devpipe_write>:
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	57                   	push   %edi
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
  801e25:	83 ec 28             	sub    $0x28,%esp
  801e28:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e2b:	56                   	push   %esi
  801e2c:	e8 8e f2 ff ff       	call   8010bf <fd2data>
  801e31:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e3e:	74 4f                	je     801e8f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e40:	8b 43 04             	mov    0x4(%ebx),%eax
  801e43:	8b 0b                	mov    (%ebx),%ecx
  801e45:	8d 51 20             	lea    0x20(%ecx),%edx
  801e48:	39 d0                	cmp    %edx,%eax
  801e4a:	72 14                	jb     801e60 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e4c:	89 da                	mov    %ebx,%edx
  801e4e:	89 f0                	mov    %esi,%eax
  801e50:	e8 65 ff ff ff       	call   801dba <_pipeisclosed>
  801e55:	85 c0                	test   %eax,%eax
  801e57:	75 3b                	jne    801e94 <devpipe_write+0x75>
			sys_yield();
  801e59:	e8 3d ef ff ff       	call   800d9b <sys_yield>
  801e5e:	eb e0                	jmp    801e40 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e63:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e67:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e6a:	89 c2                	mov    %eax,%edx
  801e6c:	c1 fa 1f             	sar    $0x1f,%edx
  801e6f:	89 d1                	mov    %edx,%ecx
  801e71:	c1 e9 1b             	shr    $0x1b,%ecx
  801e74:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e77:	83 e2 1f             	and    $0x1f,%edx
  801e7a:	29 ca                	sub    %ecx,%edx
  801e7c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e80:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e84:	83 c0 01             	add    $0x1,%eax
  801e87:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e8a:	83 c7 01             	add    $0x1,%edi
  801e8d:	eb ac                	jmp    801e3b <devpipe_write+0x1c>
	return i;
  801e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e92:	eb 05                	jmp    801e99 <devpipe_write+0x7a>
				return 0;
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e9c:	5b                   	pop    %ebx
  801e9d:	5e                   	pop    %esi
  801e9e:	5f                   	pop    %edi
  801e9f:	5d                   	pop    %ebp
  801ea0:	c3                   	ret    

00801ea1 <devpipe_read>:
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	57                   	push   %edi
  801ea5:	56                   	push   %esi
  801ea6:	53                   	push   %ebx
  801ea7:	83 ec 18             	sub    $0x18,%esp
  801eaa:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ead:	57                   	push   %edi
  801eae:	e8 0c f2 ff ff       	call   8010bf <fd2data>
  801eb3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eb5:	83 c4 10             	add    $0x10,%esp
  801eb8:	be 00 00 00 00       	mov    $0x0,%esi
  801ebd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ec0:	75 14                	jne    801ed6 <devpipe_read+0x35>
	return i;
  801ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec5:	eb 02                	jmp    801ec9 <devpipe_read+0x28>
				return i;
  801ec7:	89 f0                	mov    %esi,%eax
}
  801ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ecc:	5b                   	pop    %ebx
  801ecd:	5e                   	pop    %esi
  801ece:	5f                   	pop    %edi
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    
			sys_yield();
  801ed1:	e8 c5 ee ff ff       	call   800d9b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ed6:	8b 03                	mov    (%ebx),%eax
  801ed8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801edb:	75 18                	jne    801ef5 <devpipe_read+0x54>
			if (i > 0)
  801edd:	85 f6                	test   %esi,%esi
  801edf:	75 e6                	jne    801ec7 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ee1:	89 da                	mov    %ebx,%edx
  801ee3:	89 f8                	mov    %edi,%eax
  801ee5:	e8 d0 fe ff ff       	call   801dba <_pipeisclosed>
  801eea:	85 c0                	test   %eax,%eax
  801eec:	74 e3                	je     801ed1 <devpipe_read+0x30>
				return 0;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef3:	eb d4                	jmp    801ec9 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ef5:	99                   	cltd   
  801ef6:	c1 ea 1b             	shr    $0x1b,%edx
  801ef9:	01 d0                	add    %edx,%eax
  801efb:	83 e0 1f             	and    $0x1f,%eax
  801efe:	29 d0                	sub    %edx,%eax
  801f00:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f08:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f0b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f0e:	83 c6 01             	add    $0x1,%esi
  801f11:	eb aa                	jmp    801ebd <devpipe_read+0x1c>

00801f13 <pipe>:
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	56                   	push   %esi
  801f17:	53                   	push   %ebx
  801f18:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1e:	50                   	push   %eax
  801f1f:	e8 b2 f1 ff ff       	call   8010d6 <fd_alloc>
  801f24:	89 c3                	mov    %eax,%ebx
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	0f 88 23 01 00 00    	js     802054 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f31:	83 ec 04             	sub    $0x4,%esp
  801f34:	68 07 04 00 00       	push   $0x407
  801f39:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3c:	6a 00                	push   $0x0
  801f3e:	e8 77 ee ff ff       	call   800dba <sys_page_alloc>
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	0f 88 04 01 00 00    	js     802054 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f56:	50                   	push   %eax
  801f57:	e8 7a f1 ff ff       	call   8010d6 <fd_alloc>
  801f5c:	89 c3                	mov    %eax,%ebx
  801f5e:	83 c4 10             	add    $0x10,%esp
  801f61:	85 c0                	test   %eax,%eax
  801f63:	0f 88 db 00 00 00    	js     802044 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	68 07 04 00 00       	push   $0x407
  801f71:	ff 75 f0             	pushl  -0x10(%ebp)
  801f74:	6a 00                	push   $0x0
  801f76:	e8 3f ee ff ff       	call   800dba <sys_page_alloc>
  801f7b:	89 c3                	mov    %eax,%ebx
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	85 c0                	test   %eax,%eax
  801f82:	0f 88 bc 00 00 00    	js     802044 <pipe+0x131>
	va = fd2data(fd0);
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8e:	e8 2c f1 ff ff       	call   8010bf <fd2data>
  801f93:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f95:	83 c4 0c             	add    $0xc,%esp
  801f98:	68 07 04 00 00       	push   $0x407
  801f9d:	50                   	push   %eax
  801f9e:	6a 00                	push   $0x0
  801fa0:	e8 15 ee ff ff       	call   800dba <sys_page_alloc>
  801fa5:	89 c3                	mov    %eax,%ebx
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	85 c0                	test   %eax,%eax
  801fac:	0f 88 82 00 00 00    	js     802034 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb2:	83 ec 0c             	sub    $0xc,%esp
  801fb5:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb8:	e8 02 f1 ff ff       	call   8010bf <fd2data>
  801fbd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fc4:	50                   	push   %eax
  801fc5:	6a 00                	push   $0x0
  801fc7:	56                   	push   %esi
  801fc8:	6a 00                	push   $0x0
  801fca:	e8 2e ee ff ff       	call   800dfd <sys_page_map>
  801fcf:	89 c3                	mov    %eax,%ebx
  801fd1:	83 c4 20             	add    $0x20,%esp
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	78 4e                	js     802026 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fd8:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fef:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	ff 75 f4             	pushl  -0xc(%ebp)
  802001:	e8 a9 f0 ff ff       	call   8010af <fd2num>
  802006:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802009:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80200b:	83 c4 04             	add    $0x4,%esp
  80200e:	ff 75 f0             	pushl  -0x10(%ebp)
  802011:	e8 99 f0 ff ff       	call   8010af <fd2num>
  802016:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802019:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802024:	eb 2e                	jmp    802054 <pipe+0x141>
	sys_page_unmap(0, va);
  802026:	83 ec 08             	sub    $0x8,%esp
  802029:	56                   	push   %esi
  80202a:	6a 00                	push   $0x0
  80202c:	e8 0e ee ff ff       	call   800e3f <sys_page_unmap>
  802031:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802034:	83 ec 08             	sub    $0x8,%esp
  802037:	ff 75 f0             	pushl  -0x10(%ebp)
  80203a:	6a 00                	push   $0x0
  80203c:	e8 fe ed ff ff       	call   800e3f <sys_page_unmap>
  802041:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802044:	83 ec 08             	sub    $0x8,%esp
  802047:	ff 75 f4             	pushl  -0xc(%ebp)
  80204a:	6a 00                	push   $0x0
  80204c:	e8 ee ed ff ff       	call   800e3f <sys_page_unmap>
  802051:	83 c4 10             	add    $0x10,%esp
}
  802054:	89 d8                	mov    %ebx,%eax
  802056:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802059:	5b                   	pop    %ebx
  80205a:	5e                   	pop    %esi
  80205b:	5d                   	pop    %ebp
  80205c:	c3                   	ret    

0080205d <pipeisclosed>:
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802063:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802066:	50                   	push   %eax
  802067:	ff 75 08             	pushl  0x8(%ebp)
  80206a:	e8 b9 f0 ff ff       	call   801128 <fd_lookup>
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	85 c0                	test   %eax,%eax
  802074:	78 18                	js     80208e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802076:	83 ec 0c             	sub    $0xc,%esp
  802079:	ff 75 f4             	pushl  -0xc(%ebp)
  80207c:	e8 3e f0 ff ff       	call   8010bf <fd2data>
	return _pipeisclosed(fd, p);
  802081:	89 c2                	mov    %eax,%edx
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	e8 2f fd ff ff       	call   801dba <_pipeisclosed>
  80208b:	83 c4 10             	add    $0x10,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
  802095:	c3                   	ret    

00802096 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80209c:	68 13 2b 80 00       	push   $0x802b13
  8020a1:	ff 75 0c             	pushl  0xc(%ebp)
  8020a4:	e8 1f e9 ff ff       	call   8009c8 <strcpy>
	return 0;
}
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <devcons_write>:
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	57                   	push   %edi
  8020b4:	56                   	push   %esi
  8020b5:	53                   	push   %ebx
  8020b6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020bc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020c1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020c7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020ca:	73 31                	jae    8020fd <devcons_write+0x4d>
		m = n - tot;
  8020cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020cf:	29 f3                	sub    %esi,%ebx
  8020d1:	83 fb 7f             	cmp    $0x7f,%ebx
  8020d4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020d9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	53                   	push   %ebx
  8020e0:	89 f0                	mov    %esi,%eax
  8020e2:	03 45 0c             	add    0xc(%ebp),%eax
  8020e5:	50                   	push   %eax
  8020e6:	57                   	push   %edi
  8020e7:	e8 6a ea ff ff       	call   800b56 <memmove>
		sys_cputs(buf, m);
  8020ec:	83 c4 08             	add    $0x8,%esp
  8020ef:	53                   	push   %ebx
  8020f0:	57                   	push   %edi
  8020f1:	e8 08 ec ff ff       	call   800cfe <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020f6:	01 de                	add    %ebx,%esi
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	eb ca                	jmp    8020c7 <devcons_write+0x17>
}
  8020fd:	89 f0                	mov    %esi,%eax
  8020ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802102:	5b                   	pop    %ebx
  802103:	5e                   	pop    %esi
  802104:	5f                   	pop    %edi
  802105:	5d                   	pop    %ebp
  802106:	c3                   	ret    

00802107 <devcons_read>:
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 08             	sub    $0x8,%esp
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802112:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802116:	74 21                	je     802139 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802118:	e8 ff eb ff ff       	call   800d1c <sys_cgetc>
  80211d:	85 c0                	test   %eax,%eax
  80211f:	75 07                	jne    802128 <devcons_read+0x21>
		sys_yield();
  802121:	e8 75 ec ff ff       	call   800d9b <sys_yield>
  802126:	eb f0                	jmp    802118 <devcons_read+0x11>
	if (c < 0)
  802128:	78 0f                	js     802139 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80212a:	83 f8 04             	cmp    $0x4,%eax
  80212d:	74 0c                	je     80213b <devcons_read+0x34>
	*(char*)vbuf = c;
  80212f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802132:	88 02                	mov    %al,(%edx)
	return 1;
  802134:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    
		return 0;
  80213b:	b8 00 00 00 00       	mov    $0x0,%eax
  802140:	eb f7                	jmp    802139 <devcons_read+0x32>

00802142 <cputchar>:
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80214e:	6a 01                	push   $0x1
  802150:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802153:	50                   	push   %eax
  802154:	e8 a5 eb ff ff       	call   800cfe <sys_cputs>
}
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <getchar>:
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802164:	6a 01                	push   $0x1
  802166:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802169:	50                   	push   %eax
  80216a:	6a 00                	push   $0x0
  80216c:	e8 27 f2 ff ff       	call   801398 <read>
	if (r < 0)
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	85 c0                	test   %eax,%eax
  802176:	78 06                	js     80217e <getchar+0x20>
	if (r < 1)
  802178:	74 06                	je     802180 <getchar+0x22>
	return c;
  80217a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    
		return -E_EOF;
  802180:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802185:	eb f7                	jmp    80217e <getchar+0x20>

00802187 <iscons>:
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80218d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802190:	50                   	push   %eax
  802191:	ff 75 08             	pushl  0x8(%ebp)
  802194:	e8 8f ef ff ff       	call   801128 <fd_lookup>
  802199:	83 c4 10             	add    $0x10,%esp
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 11                	js     8021b1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021a9:	39 10                	cmp    %edx,(%eax)
  8021ab:	0f 94 c0             	sete   %al
  8021ae:	0f b6 c0             	movzbl %al,%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <opencons>:
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021bc:	50                   	push   %eax
  8021bd:	e8 14 ef ff ff       	call   8010d6 <fd_alloc>
  8021c2:	83 c4 10             	add    $0x10,%esp
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	78 3a                	js     802203 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	68 07 04 00 00       	push   $0x407
  8021d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d4:	6a 00                	push   $0x0
  8021d6:	e8 df eb ff ff       	call   800dba <sys_page_alloc>
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 21                	js     802203 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021eb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021f7:	83 ec 0c             	sub    $0xc,%esp
  8021fa:	50                   	push   %eax
  8021fb:	e8 af ee ff ff       	call   8010af <fd2num>
  802200:	83 c4 10             	add    $0x10,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	56                   	push   %esi
  802209:	53                   	push   %ebx
  80220a:	8b 75 08             	mov    0x8(%ebp),%esi
  80220d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802210:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802213:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802215:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80221a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80221d:	83 ec 0c             	sub    $0xc,%esp
  802220:	50                   	push   %eax
  802221:	e8 44 ed ff ff       	call   800f6a <sys_ipc_recv>
	if(ret < 0){
  802226:	83 c4 10             	add    $0x10,%esp
  802229:	85 c0                	test   %eax,%eax
  80222b:	78 2b                	js     802258 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80222d:	85 f6                	test   %esi,%esi
  80222f:	74 0a                	je     80223b <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802231:	a1 08 40 80 00       	mov    0x804008,%eax
  802236:	8b 40 78             	mov    0x78(%eax),%eax
  802239:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80223b:	85 db                	test   %ebx,%ebx
  80223d:	74 0a                	je     802249 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80223f:	a1 08 40 80 00       	mov    0x804008,%eax
  802244:	8b 40 7c             	mov    0x7c(%eax),%eax
  802247:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802249:	a1 08 40 80 00       	mov    0x804008,%eax
  80224e:	8b 40 74             	mov    0x74(%eax),%eax
}
  802251:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802254:	5b                   	pop    %ebx
  802255:	5e                   	pop    %esi
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    
		if(from_env_store)
  802258:	85 f6                	test   %esi,%esi
  80225a:	74 06                	je     802262 <ipc_recv+0x5d>
			*from_env_store = 0;
  80225c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802262:	85 db                	test   %ebx,%ebx
  802264:	74 eb                	je     802251 <ipc_recv+0x4c>
			*perm_store = 0;
  802266:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80226c:	eb e3                	jmp    802251 <ipc_recv+0x4c>

0080226e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	57                   	push   %edi
  802272:	56                   	push   %esi
  802273:	53                   	push   %ebx
  802274:	83 ec 0c             	sub    $0xc,%esp
  802277:	8b 7d 08             	mov    0x8(%ebp),%edi
  80227a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80227d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802280:	85 db                	test   %ebx,%ebx
  802282:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802287:	0f 44 d8             	cmove  %eax,%ebx
  80228a:	eb 05                	jmp    802291 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80228c:	e8 0a eb ff ff       	call   800d9b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802291:	ff 75 14             	pushl  0x14(%ebp)
  802294:	53                   	push   %ebx
  802295:	56                   	push   %esi
  802296:	57                   	push   %edi
  802297:	e8 ab ec ff ff       	call   800f47 <sys_ipc_try_send>
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	74 1b                	je     8022be <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022a3:	79 e7                	jns    80228c <ipc_send+0x1e>
  8022a5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022a8:	74 e2                	je     80228c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022aa:	83 ec 04             	sub    $0x4,%esp
  8022ad:	68 1f 2b 80 00       	push   $0x802b1f
  8022b2:	6a 46                	push   $0x46
  8022b4:	68 34 2b 80 00       	push   $0x802b34
  8022b9:	e8 b5 de ff ff       	call   800173 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	5f                   	pop    %edi
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    

008022c6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022d1:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022d7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022dd:	8b 52 50             	mov    0x50(%edx),%edx
  8022e0:	39 ca                	cmp    %ecx,%edx
  8022e2:	74 11                	je     8022f5 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022e4:	83 c0 01             	add    $0x1,%eax
  8022e7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022ec:	75 e3                	jne    8022d1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f3:	eb 0e                	jmp    802303 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022f5:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802300:	8b 40 48             	mov    0x48(%eax),%eax
}
  802303:	5d                   	pop    %ebp
  802304:	c3                   	ret    

00802305 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80230b:	89 d0                	mov    %edx,%eax
  80230d:	c1 e8 16             	shr    $0x16,%eax
  802310:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802317:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80231c:	f6 c1 01             	test   $0x1,%cl
  80231f:	74 1d                	je     80233e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802321:	c1 ea 0c             	shr    $0xc,%edx
  802324:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80232b:	f6 c2 01             	test   $0x1,%dl
  80232e:	74 0e                	je     80233e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802330:	c1 ea 0c             	shr    $0xc,%edx
  802333:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80233a:	ef 
  80233b:	0f b7 c0             	movzwl %ax,%eax
}
  80233e:	5d                   	pop    %ebp
  80233f:	c3                   	ret    

00802340 <__udivdi3>:
  802340:	55                   	push   %ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	83 ec 1c             	sub    $0x1c,%esp
  802347:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80234b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80234f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802353:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802357:	85 d2                	test   %edx,%edx
  802359:	75 4d                	jne    8023a8 <__udivdi3+0x68>
  80235b:	39 f3                	cmp    %esi,%ebx
  80235d:	76 19                	jbe    802378 <__udivdi3+0x38>
  80235f:	31 ff                	xor    %edi,%edi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f2                	mov    %esi,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	89 d9                	mov    %ebx,%ecx
  80237a:	85 db                	test   %ebx,%ebx
  80237c:	75 0b                	jne    802389 <__udivdi3+0x49>
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	31 d2                	xor    %edx,%edx
  802385:	f7 f3                	div    %ebx
  802387:	89 c1                	mov    %eax,%ecx
  802389:	31 d2                	xor    %edx,%edx
  80238b:	89 f0                	mov    %esi,%eax
  80238d:	f7 f1                	div    %ecx
  80238f:	89 c6                	mov    %eax,%esi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f7                	mov    %esi,%edi
  802395:	f7 f1                	div    %ecx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	39 f2                	cmp    %esi,%edx
  8023aa:	77 1c                	ja     8023c8 <__udivdi3+0x88>
  8023ac:	0f bd fa             	bsr    %edx,%edi
  8023af:	83 f7 1f             	xor    $0x1f,%edi
  8023b2:	75 2c                	jne    8023e0 <__udivdi3+0xa0>
  8023b4:	39 f2                	cmp    %esi,%edx
  8023b6:	72 06                	jb     8023be <__udivdi3+0x7e>
  8023b8:	31 c0                	xor    %eax,%eax
  8023ba:	39 eb                	cmp    %ebp,%ebx
  8023bc:	77 a9                	ja     802367 <__udivdi3+0x27>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	eb a2                	jmp    802367 <__udivdi3+0x27>
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	31 ff                	xor    %edi,%edi
  8023ca:	31 c0                	xor    %eax,%eax
  8023cc:	89 fa                	mov    %edi,%edx
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	89 f9                	mov    %edi,%ecx
  8023e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023e7:	29 f8                	sub    %edi,%eax
  8023e9:	d3 e2                	shl    %cl,%edx
  8023eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ef:	89 c1                	mov    %eax,%ecx
  8023f1:	89 da                	mov    %ebx,%edx
  8023f3:	d3 ea                	shr    %cl,%edx
  8023f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f9:	09 d1                	or     %edx,%ecx
  8023fb:	89 f2                	mov    %esi,%edx
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 f9                	mov    %edi,%ecx
  802403:	d3 e3                	shl    %cl,%ebx
  802405:	89 c1                	mov    %eax,%ecx
  802407:	d3 ea                	shr    %cl,%edx
  802409:	89 f9                	mov    %edi,%ecx
  80240b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80240f:	89 eb                	mov    %ebp,%ebx
  802411:	d3 e6                	shl    %cl,%esi
  802413:	89 c1                	mov    %eax,%ecx
  802415:	d3 eb                	shr    %cl,%ebx
  802417:	09 de                	or     %ebx,%esi
  802419:	89 f0                	mov    %esi,%eax
  80241b:	f7 74 24 08          	divl   0x8(%esp)
  80241f:	89 d6                	mov    %edx,%esi
  802421:	89 c3                	mov    %eax,%ebx
  802423:	f7 64 24 0c          	mull   0xc(%esp)
  802427:	39 d6                	cmp    %edx,%esi
  802429:	72 15                	jb     802440 <__udivdi3+0x100>
  80242b:	89 f9                	mov    %edi,%ecx
  80242d:	d3 e5                	shl    %cl,%ebp
  80242f:	39 c5                	cmp    %eax,%ebp
  802431:	73 04                	jae    802437 <__udivdi3+0xf7>
  802433:	39 d6                	cmp    %edx,%esi
  802435:	74 09                	je     802440 <__udivdi3+0x100>
  802437:	89 d8                	mov    %ebx,%eax
  802439:	31 ff                	xor    %edi,%edi
  80243b:	e9 27 ff ff ff       	jmp    802367 <__udivdi3+0x27>
  802440:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802443:	31 ff                	xor    %edi,%edi
  802445:	e9 1d ff ff ff       	jmp    802367 <__udivdi3+0x27>
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__umoddi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	83 ec 1c             	sub    $0x1c,%esp
  802457:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80245b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80245f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802467:	89 da                	mov    %ebx,%edx
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 43                	jne    8024b0 <__umoddi3+0x60>
  80246d:	39 df                	cmp    %ebx,%edi
  80246f:	76 17                	jbe    802488 <__umoddi3+0x38>
  802471:	89 f0                	mov    %esi,%eax
  802473:	f7 f7                	div    %edi
  802475:	89 d0                	mov    %edx,%eax
  802477:	31 d2                	xor    %edx,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 fd                	mov    %edi,%ebp
  80248a:	85 ff                	test   %edi,%edi
  80248c:	75 0b                	jne    802499 <__umoddi3+0x49>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f7                	div    %edi
  802497:	89 c5                	mov    %eax,%ebp
  802499:	89 d8                	mov    %ebx,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f5                	div    %ebp
  80249f:	89 f0                	mov    %esi,%eax
  8024a1:	f7 f5                	div    %ebp
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	eb d0                	jmp    802477 <__umoddi3+0x27>
  8024a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	89 f1                	mov    %esi,%ecx
  8024b2:	39 d8                	cmp    %ebx,%eax
  8024b4:	76 0a                	jbe    8024c0 <__umoddi3+0x70>
  8024b6:	89 f0                	mov    %esi,%eax
  8024b8:	83 c4 1c             	add    $0x1c,%esp
  8024bb:	5b                   	pop    %ebx
  8024bc:	5e                   	pop    %esi
  8024bd:	5f                   	pop    %edi
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    
  8024c0:	0f bd e8             	bsr    %eax,%ebp
  8024c3:	83 f5 1f             	xor    $0x1f,%ebp
  8024c6:	75 20                	jne    8024e8 <__umoddi3+0x98>
  8024c8:	39 d8                	cmp    %ebx,%eax
  8024ca:	0f 82 b0 00 00 00    	jb     802580 <__umoddi3+0x130>
  8024d0:	39 f7                	cmp    %esi,%edi
  8024d2:	0f 86 a8 00 00 00    	jbe    802580 <__umoddi3+0x130>
  8024d8:	89 c8                	mov    %ecx,%eax
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
  8024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ef:	29 ea                	sub    %ebp,%edx
  8024f1:	d3 e0                	shl    %cl,%eax
  8024f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f7:	89 d1                	mov    %edx,%ecx
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	d3 e8                	shr    %cl,%eax
  8024fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802501:	89 54 24 04          	mov    %edx,0x4(%esp)
  802505:	8b 54 24 04          	mov    0x4(%esp),%edx
  802509:	09 c1                	or     %eax,%ecx
  80250b:	89 d8                	mov    %ebx,%eax
  80250d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802511:	89 e9                	mov    %ebp,%ecx
  802513:	d3 e7                	shl    %cl,%edi
  802515:	89 d1                	mov    %edx,%ecx
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80251f:	d3 e3                	shl    %cl,%ebx
  802521:	89 c7                	mov    %eax,%edi
  802523:	89 d1                	mov    %edx,%ecx
  802525:	89 f0                	mov    %esi,%eax
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	d3 e6                	shl    %cl,%esi
  80252f:	09 d8                	or     %ebx,%eax
  802531:	f7 74 24 08          	divl   0x8(%esp)
  802535:	89 d1                	mov    %edx,%ecx
  802537:	89 f3                	mov    %esi,%ebx
  802539:	f7 64 24 0c          	mull   0xc(%esp)
  80253d:	89 c6                	mov    %eax,%esi
  80253f:	89 d7                	mov    %edx,%edi
  802541:	39 d1                	cmp    %edx,%ecx
  802543:	72 06                	jb     80254b <__umoddi3+0xfb>
  802545:	75 10                	jne    802557 <__umoddi3+0x107>
  802547:	39 c3                	cmp    %eax,%ebx
  802549:	73 0c                	jae    802557 <__umoddi3+0x107>
  80254b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80254f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802553:	89 d7                	mov    %edx,%edi
  802555:	89 c6                	mov    %eax,%esi
  802557:	89 ca                	mov    %ecx,%edx
  802559:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80255e:	29 f3                	sub    %esi,%ebx
  802560:	19 fa                	sbb    %edi,%edx
  802562:	89 d0                	mov    %edx,%eax
  802564:	d3 e0                	shl    %cl,%eax
  802566:	89 e9                	mov    %ebp,%ecx
  802568:	d3 eb                	shr    %cl,%ebx
  80256a:	d3 ea                	shr    %cl,%edx
  80256c:	09 d8                	or     %ebx,%eax
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	89 da                	mov    %ebx,%edx
  802582:	29 fe                	sub    %edi,%esi
  802584:	19 c2                	sbb    %eax,%edx
  802586:	89 f1                	mov    %esi,%ecx
  802588:	89 c8                	mov    %ecx,%eax
  80258a:	e9 4b ff ff ff       	jmp    8024da <__umoddi3+0x8a>
