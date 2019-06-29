
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b5 00 00 00       	call   8000e6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 2f 0d 00 00       	call   800d6c <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 ab 12 00 00       	call   8012f4 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 31 0d 00 00       	call   800d8b <sys_yield>
		return;
  80005a:	eb 6c                	jmp    8000c8 <umain+0x95>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800062:	69 d6 84 00 00 00    	imul   $0x84,%esi,%edx
  800068:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80006e:	eb 02                	jmp    800072 <umain+0x3f>
		asm volatile("pause");
  800070:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800072:	8b 42 54             	mov    0x54(%edx),%eax
  800075:	85 c0                	test   %eax,%eax
  800077:	75 f7                	jne    800070 <umain+0x3d>
  800079:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007e:	e8 08 0d 00 00       	call   800d8b <sys_yield>
  800083:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800088:	a1 08 50 80 00       	mov    0x805008,%eax
  80008d:	83 c0 01             	add    $0x1,%eax
  800090:	a3 08 50 80 00       	mov    %eax,0x805008
		for (j = 0; j < 10000; j++)
  800095:	83 ea 01             	sub    $0x1,%edx
  800098:	75 ee                	jne    800088 <umain+0x55>
	for (i = 0; i < 10; i++) {
  80009a:	83 eb 01             	sub    $0x1,%ebx
  80009d:	75 df                	jne    80007e <umain+0x4b>
	}

	if (counter != 10*10000)
  80009f:	a1 08 50 80 00       	mov    0x805008,%eax
  8000a4:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000a9:	75 24                	jne    8000cf <umain+0x9c>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ab:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8000b0:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b3:	8b 40 48             	mov    0x48(%eax),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	52                   	push   %edx
  8000ba:	50                   	push   %eax
  8000bb:	68 5b 2b 80 00       	push   $0x802b5b
  8000c0:	e8 94 01 00 00       	call   800259 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

}
  8000c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cb:	5b                   	pop    %ebx
  8000cc:	5e                   	pop    %esi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d4:	50                   	push   %eax
  8000d5:	68 20 2b 80 00       	push   $0x802b20
  8000da:	6a 21                	push   $0x21
  8000dc:	68 48 2b 80 00       	push   $0x802b48
  8000e1:	e8 7d 00 00 00       	call   800163 <_panic>

008000e6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ee:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000f1:	e8 76 0c 00 00       	call   800d6c <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fb:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800101:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800106:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010b:	85 db                	test   %ebx,%ebx
  80010d:	7e 07                	jle    800116 <libmain+0x30>
		binaryname = argv[0];
  80010f:	8b 06                	mov    (%esi),%eax
  800111:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	e8 13 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800120:	e8 0a 00 00 00       	call   80012f <exit>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012b:	5b                   	pop    %ebx
  80012c:	5e                   	pop    %esi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800135:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80013a:	8b 40 48             	mov    0x48(%eax),%eax
  80013d:	68 90 2b 80 00       	push   $0x802b90
  800142:	50                   	push   %eax
  800143:	68 83 2b 80 00       	push   $0x802b83
  800148:	e8 0c 01 00 00       	call   800259 <cprintf>
	close_all();
  80014d:	e8 12 16 00 00       	call   801764 <close_all>
	sys_env_destroy(0);
  800152:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800159:	e8 cd 0b 00 00       	call   800d2b <sys_env_destroy>
}
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800168:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80016d:	8b 40 48             	mov    0x48(%eax),%eax
  800170:	83 ec 04             	sub    $0x4,%esp
  800173:	68 bc 2b 80 00       	push   $0x802bbc
  800178:	50                   	push   %eax
  800179:	68 83 2b 80 00       	push   $0x802b83
  80017e:	e8 d6 00 00 00       	call   800259 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800183:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800186:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80018c:	e8 db 0b 00 00       	call   800d6c <sys_getenvid>
  800191:	83 c4 04             	add    $0x4,%esp
  800194:	ff 75 0c             	pushl  0xc(%ebp)
  800197:	ff 75 08             	pushl  0x8(%ebp)
  80019a:	56                   	push   %esi
  80019b:	50                   	push   %eax
  80019c:	68 98 2b 80 00       	push   $0x802b98
  8001a1:	e8 b3 00 00 00       	call   800259 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001a6:	83 c4 18             	add    $0x18,%esp
  8001a9:	53                   	push   %ebx
  8001aa:	ff 75 10             	pushl  0x10(%ebp)
  8001ad:	e8 56 00 00 00       	call   800208 <vcprintf>
	cprintf("\n");
  8001b2:	c7 04 24 c1 2f 80 00 	movl   $0x802fc1,(%esp)
  8001b9:	e8 9b 00 00 00       	call   800259 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c1:	cc                   	int3   
  8001c2:	eb fd                	jmp    8001c1 <_panic+0x5e>

008001c4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ce:	8b 13                	mov    (%ebx),%edx
  8001d0:	8d 42 01             	lea    0x1(%edx),%eax
  8001d3:	89 03                	mov    %eax,(%ebx)
  8001d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e1:	74 09                	je     8001ec <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001e3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	68 ff 00 00 00       	push   $0xff
  8001f4:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f7:	50                   	push   %eax
  8001f8:	e8 f1 0a 00 00       	call   800cee <sys_cputs>
		b->idx = 0;
  8001fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	eb db                	jmp    8001e3 <putch+0x1f>

00800208 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800211:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800218:	00 00 00 
	b.cnt = 0;
  80021b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800222:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800225:	ff 75 0c             	pushl  0xc(%ebp)
  800228:	ff 75 08             	pushl  0x8(%ebp)
  80022b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800231:	50                   	push   %eax
  800232:	68 c4 01 80 00       	push   $0x8001c4
  800237:	e8 4a 01 00 00       	call   800386 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80023c:	83 c4 08             	add    $0x8,%esp
  80023f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800245:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 9d 0a 00 00       	call   800cee <sys_cputs>

	return b.cnt;
}
  800251:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80025f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800262:	50                   	push   %eax
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	e8 9d ff ff ff       	call   800208 <vcprintf>
	va_end(ap);

	return cnt;
}
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    

0080026d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	57                   	push   %edi
  800271:	56                   	push   %esi
  800272:	53                   	push   %ebx
  800273:	83 ec 1c             	sub    $0x1c,%esp
  800276:	89 c6                	mov    %eax,%esi
  800278:	89 d7                	mov    %edx,%edi
  80027a:	8b 45 08             	mov    0x8(%ebp),%eax
  80027d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800280:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800283:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800286:	8b 45 10             	mov    0x10(%ebp),%eax
  800289:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80028c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800290:	74 2c                	je     8002be <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800292:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800295:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80029c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80029f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002a2:	39 c2                	cmp    %eax,%edx
  8002a4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002a7:	73 43                	jae    8002ec <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002a9:	83 eb 01             	sub    $0x1,%ebx
  8002ac:	85 db                	test   %ebx,%ebx
  8002ae:	7e 6c                	jle    80031c <printnum+0xaf>
				putch(padc, putdat);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	57                   	push   %edi
  8002b4:	ff 75 18             	pushl  0x18(%ebp)
  8002b7:	ff d6                	call   *%esi
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	eb eb                	jmp    8002a9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	6a 20                	push   $0x20
  8002c3:	6a 00                	push   $0x0
  8002c5:	50                   	push   %eax
  8002c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cc:	89 fa                	mov    %edi,%edx
  8002ce:	89 f0                	mov    %esi,%eax
  8002d0:	e8 98 ff ff ff       	call   80026d <printnum>
		while (--width > 0)
  8002d5:	83 c4 20             	add    $0x20,%esp
  8002d8:	83 eb 01             	sub    $0x1,%ebx
  8002db:	85 db                	test   %ebx,%ebx
  8002dd:	7e 65                	jle    800344 <printnum+0xd7>
			putch(padc, putdat);
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	57                   	push   %edi
  8002e3:	6a 20                	push   $0x20
  8002e5:	ff d6                	call   *%esi
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	eb ec                	jmp    8002d8 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ec:	83 ec 0c             	sub    $0xc,%esp
  8002ef:	ff 75 18             	pushl  0x18(%ebp)
  8002f2:	83 eb 01             	sub    $0x1,%ebx
  8002f5:	53                   	push   %ebx
  8002f6:	50                   	push   %eax
  8002f7:	83 ec 08             	sub    $0x8,%esp
  8002fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8002fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800300:	ff 75 e4             	pushl  -0x1c(%ebp)
  800303:	ff 75 e0             	pushl  -0x20(%ebp)
  800306:	e8 b5 25 00 00       	call   8028c0 <__udivdi3>
  80030b:	83 c4 18             	add    $0x18,%esp
  80030e:	52                   	push   %edx
  80030f:	50                   	push   %eax
  800310:	89 fa                	mov    %edi,%edx
  800312:	89 f0                	mov    %esi,%eax
  800314:	e8 54 ff ff ff       	call   80026d <printnum>
  800319:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80031c:	83 ec 08             	sub    $0x8,%esp
  80031f:	57                   	push   %edi
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	ff 75 dc             	pushl  -0x24(%ebp)
  800326:	ff 75 d8             	pushl  -0x28(%ebp)
  800329:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032c:	ff 75 e0             	pushl  -0x20(%ebp)
  80032f:	e8 9c 26 00 00       	call   8029d0 <__umoddi3>
  800334:	83 c4 14             	add    $0x14,%esp
  800337:	0f be 80 c3 2b 80 00 	movsbl 0x802bc3(%eax),%eax
  80033e:	50                   	push   %eax
  80033f:	ff d6                	call   *%esi
  800341:	83 c4 10             	add    $0x10,%esp
	}
}
  800344:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800347:	5b                   	pop    %ebx
  800348:	5e                   	pop    %esi
  800349:	5f                   	pop    %edi
  80034a:	5d                   	pop    %ebp
  80034b:	c3                   	ret    

0080034c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800352:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800356:	8b 10                	mov    (%eax),%edx
  800358:	3b 50 04             	cmp    0x4(%eax),%edx
  80035b:	73 0a                	jae    800367 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800360:	89 08                	mov    %ecx,(%eax)
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	88 02                	mov    %al,(%edx)
}
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    

00800369 <printfmt>:
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80036f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800372:	50                   	push   %eax
  800373:	ff 75 10             	pushl  0x10(%ebp)
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 05 00 00 00       	call   800386 <vprintfmt>
}
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <vprintfmt>:
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	57                   	push   %edi
  80038a:	56                   	push   %esi
  80038b:	53                   	push   %ebx
  80038c:	83 ec 3c             	sub    $0x3c,%esp
  80038f:	8b 75 08             	mov    0x8(%ebp),%esi
  800392:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800395:	8b 7d 10             	mov    0x10(%ebp),%edi
  800398:	e9 32 04 00 00       	jmp    8007cf <vprintfmt+0x449>
		padc = ' ';
  80039d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003a1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003a8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003af:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003bd:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003c4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8d 47 01             	lea    0x1(%edi),%eax
  8003cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cf:	0f b6 17             	movzbl (%edi),%edx
  8003d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d5:	3c 55                	cmp    $0x55,%al
  8003d7:	0f 87 12 05 00 00    	ja     8008ef <vprintfmt+0x569>
  8003dd:	0f b6 c0             	movzbl %al,%eax
  8003e0:	ff 24 85 a0 2d 80 00 	jmp    *0x802da0(,%eax,4)
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ea:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003ee:	eb d9                	jmp    8003c9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f3:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003f7:	eb d0                	jmp    8003c9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	0f b6 d2             	movzbl %dl,%edx
  8003fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800404:	89 75 08             	mov    %esi,0x8(%ebp)
  800407:	eb 03                	jmp    80040c <vprintfmt+0x86>
  800409:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80040c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80040f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800413:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800416:	8d 72 d0             	lea    -0x30(%edx),%esi
  800419:	83 fe 09             	cmp    $0x9,%esi
  80041c:	76 eb                	jbe    800409 <vprintfmt+0x83>
  80041e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800421:	8b 75 08             	mov    0x8(%ebp),%esi
  800424:	eb 14                	jmp    80043a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	8d 40 04             	lea    0x4(%eax),%eax
  800434:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800437:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80043a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043e:	79 89                	jns    8003c9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800440:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800443:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800446:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80044d:	e9 77 ff ff ff       	jmp    8003c9 <vprintfmt+0x43>
  800452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800455:	85 c0                	test   %eax,%eax
  800457:	0f 48 c1             	cmovs  %ecx,%eax
  80045a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800460:	e9 64 ff ff ff       	jmp    8003c9 <vprintfmt+0x43>
  800465:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800468:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80046f:	e9 55 ff ff ff       	jmp    8003c9 <vprintfmt+0x43>
			lflag++;
  800474:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80047b:	e9 49 ff ff ff       	jmp    8003c9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800480:	8b 45 14             	mov    0x14(%ebp),%eax
  800483:	8d 78 04             	lea    0x4(%eax),%edi
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	53                   	push   %ebx
  80048a:	ff 30                	pushl  (%eax)
  80048c:	ff d6                	call   *%esi
			break;
  80048e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800491:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800494:	e9 33 03 00 00       	jmp    8007cc <vprintfmt+0x446>
			err = va_arg(ap, int);
  800499:	8b 45 14             	mov    0x14(%ebp),%eax
  80049c:	8d 78 04             	lea    0x4(%eax),%edi
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	99                   	cltd   
  8004a2:	31 d0                	xor    %edx,%eax
  8004a4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a6:	83 f8 11             	cmp    $0x11,%eax
  8004a9:	7f 23                	jg     8004ce <vprintfmt+0x148>
  8004ab:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  8004b2:	85 d2                	test   %edx,%edx
  8004b4:	74 18                	je     8004ce <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004b6:	52                   	push   %edx
  8004b7:	68 0d 31 80 00       	push   $0x80310d
  8004bc:	53                   	push   %ebx
  8004bd:	56                   	push   %esi
  8004be:	e8 a6 fe ff ff       	call   800369 <printfmt>
  8004c3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c9:	e9 fe 02 00 00       	jmp    8007cc <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004ce:	50                   	push   %eax
  8004cf:	68 db 2b 80 00       	push   $0x802bdb
  8004d4:	53                   	push   %ebx
  8004d5:	56                   	push   %esi
  8004d6:	e8 8e fe ff ff       	call   800369 <printfmt>
  8004db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004de:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004e1:	e9 e6 02 00 00       	jmp    8007cc <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e9:	83 c0 04             	add    $0x4,%eax
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004f4:	85 c9                	test   %ecx,%ecx
  8004f6:	b8 d4 2b 80 00       	mov    $0x802bd4,%eax
  8004fb:	0f 45 c1             	cmovne %ecx,%eax
  8004fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800501:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800505:	7e 06                	jle    80050d <vprintfmt+0x187>
  800507:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80050b:	75 0d                	jne    80051a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80050d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800510:	89 c7                	mov    %eax,%edi
  800512:	03 45 e0             	add    -0x20(%ebp),%eax
  800515:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800518:	eb 53                	jmp    80056d <vprintfmt+0x1e7>
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	ff 75 d8             	pushl  -0x28(%ebp)
  800520:	50                   	push   %eax
  800521:	e8 71 04 00 00       	call   800997 <strnlen>
  800526:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800529:	29 c1                	sub    %eax,%ecx
  80052b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800533:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80053a:	eb 0f                	jmp    80054b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 75 e0             	pushl  -0x20(%ebp)
  800543:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800545:	83 ef 01             	sub    $0x1,%edi
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	85 ff                	test   %edi,%edi
  80054d:	7f ed                	jg     80053c <vprintfmt+0x1b6>
  80054f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800552:	85 c9                	test   %ecx,%ecx
  800554:	b8 00 00 00 00       	mov    $0x0,%eax
  800559:	0f 49 c1             	cmovns %ecx,%eax
  80055c:	29 c1                	sub    %eax,%ecx
  80055e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800561:	eb aa                	jmp    80050d <vprintfmt+0x187>
					putch(ch, putdat);
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	53                   	push   %ebx
  800567:	52                   	push   %edx
  800568:	ff d6                	call   *%esi
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800570:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800572:	83 c7 01             	add    $0x1,%edi
  800575:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800579:	0f be d0             	movsbl %al,%edx
  80057c:	85 d2                	test   %edx,%edx
  80057e:	74 4b                	je     8005cb <vprintfmt+0x245>
  800580:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800584:	78 06                	js     80058c <vprintfmt+0x206>
  800586:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80058a:	78 1e                	js     8005aa <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80058c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800590:	74 d1                	je     800563 <vprintfmt+0x1dd>
  800592:	0f be c0             	movsbl %al,%eax
  800595:	83 e8 20             	sub    $0x20,%eax
  800598:	83 f8 5e             	cmp    $0x5e,%eax
  80059b:	76 c6                	jbe    800563 <vprintfmt+0x1dd>
					putch('?', putdat);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	53                   	push   %ebx
  8005a1:	6a 3f                	push   $0x3f
  8005a3:	ff d6                	call   *%esi
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	eb c3                	jmp    80056d <vprintfmt+0x1e7>
  8005aa:	89 cf                	mov    %ecx,%edi
  8005ac:	eb 0e                	jmp    8005bc <vprintfmt+0x236>
				putch(' ', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	6a 20                	push   $0x20
  8005b4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b6:	83 ef 01             	sub    $0x1,%edi
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	85 ff                	test   %edi,%edi
  8005be:	7f ee                	jg     8005ae <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c6:	e9 01 02 00 00       	jmp    8007cc <vprintfmt+0x446>
  8005cb:	89 cf                	mov    %ecx,%edi
  8005cd:	eb ed                	jmp    8005bc <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005d2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005d9:	e9 eb fd ff ff       	jmp    8003c9 <vprintfmt+0x43>
	if (lflag >= 2)
  8005de:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005e2:	7f 21                	jg     800605 <vprintfmt+0x27f>
	else if (lflag)
  8005e4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005e8:	74 68                	je     800652 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f2:	89 c1                	mov    %eax,%ecx
  8005f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
  800603:	eb 17                	jmp    80061c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8b 50 04             	mov    0x4(%eax),%edx
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800610:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8d 40 08             	lea    0x8(%eax),%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80061c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800622:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800625:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800628:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80062c:	78 3f                	js     80066d <vprintfmt+0x2e7>
			base = 10;
  80062e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800633:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800637:	0f 84 71 01 00 00    	je     8007ae <vprintfmt+0x428>
				putch('+', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 2b                	push   $0x2b
  800643:	ff d6                	call   *%esi
  800645:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800648:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064d:	e9 5c 01 00 00       	jmp    8007ae <vprintfmt+0x428>
		return va_arg(*ap, int);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 00                	mov    (%eax),%eax
  800657:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80065a:	89 c1                	mov    %eax,%ecx
  80065c:	c1 f9 1f             	sar    $0x1f,%ecx
  80065f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8d 40 04             	lea    0x4(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
  80066b:	eb af                	jmp    80061c <vprintfmt+0x296>
				putch('-', putdat);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	53                   	push   %ebx
  800671:	6a 2d                	push   $0x2d
  800673:	ff d6                	call   *%esi
				num = -(long long) num;
  800675:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800678:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80067b:	f7 d8                	neg    %eax
  80067d:	83 d2 00             	adc    $0x0,%edx
  800680:	f7 da                	neg    %edx
  800682:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800685:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800688:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800690:	e9 19 01 00 00       	jmp    8007ae <vprintfmt+0x428>
	if (lflag >= 2)
  800695:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800699:	7f 29                	jg     8006c4 <vprintfmt+0x33e>
	else if (lflag)
  80069b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80069f:	74 44                	je     8006e5 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bf:	e9 ea 00 00 00       	jmp    8007ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 08             	lea    0x8(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e0:	e9 c9 00 00 00       	jmp    8007ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8d 40 04             	lea    0x4(%eax),%eax
  8006fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800703:	e9 a6 00 00 00       	jmp    8007ae <vprintfmt+0x428>
			putch('0', putdat);
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	53                   	push   %ebx
  80070c:	6a 30                	push   $0x30
  80070e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800717:	7f 26                	jg     80073f <vprintfmt+0x3b9>
	else if (lflag)
  800719:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80071d:	74 3e                	je     80075d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	ba 00 00 00 00       	mov    $0x0,%edx
  800729:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8d 40 04             	lea    0x4(%eax),%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800738:	b8 08 00 00 00       	mov    $0x8,%eax
  80073d:	eb 6f                	jmp    8007ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 50 04             	mov    0x4(%eax),%edx
  800745:	8b 00                	mov    (%eax),%eax
  800747:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8d 40 08             	lea    0x8(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800756:	b8 08 00 00 00       	mov    $0x8,%eax
  80075b:	eb 51                	jmp    8007ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	ba 00 00 00 00       	mov    $0x0,%edx
  800767:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8d 40 04             	lea    0x4(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800776:	b8 08 00 00 00       	mov    $0x8,%eax
  80077b:	eb 31                	jmp    8007ae <vprintfmt+0x428>
			putch('0', putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	53                   	push   %ebx
  800781:	6a 30                	push   $0x30
  800783:	ff d6                	call   *%esi
			putch('x', putdat);
  800785:	83 c4 08             	add    $0x8,%esp
  800788:	53                   	push   %ebx
  800789:	6a 78                	push   $0x78
  80078b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
  800797:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80079d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ae:	83 ec 0c             	sub    $0xc,%esp
  8007b1:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007b5:	52                   	push   %edx
  8007b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	ff 75 dc             	pushl  -0x24(%ebp)
  8007bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8007c0:	89 da                	mov    %ebx,%edx
  8007c2:	89 f0                	mov    %esi,%eax
  8007c4:	e8 a4 fa ff ff       	call   80026d <printnum>
			break;
  8007c9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cf:	83 c7 01             	add    $0x1,%edi
  8007d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d6:	83 f8 25             	cmp    $0x25,%eax
  8007d9:	0f 84 be fb ff ff    	je     80039d <vprintfmt+0x17>
			if (ch == '\0')
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	0f 84 28 01 00 00    	je     80090f <vprintfmt+0x589>
			putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	53                   	push   %ebx
  8007eb:	50                   	push   %eax
  8007ec:	ff d6                	call   *%esi
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	eb dc                	jmp    8007cf <vprintfmt+0x449>
	if (lflag >= 2)
  8007f3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007f7:	7f 26                	jg     80081f <vprintfmt+0x499>
	else if (lflag)
  8007f9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007fd:	74 41                	je     800840 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800818:	b8 10 00 00 00       	mov    $0x10,%eax
  80081d:	eb 8f                	jmp    8007ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 50 04             	mov    0x4(%eax),%edx
  800825:	8b 00                	mov    (%eax),%eax
  800827:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8d 40 08             	lea    0x8(%eax),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800836:	b8 10 00 00 00       	mov    $0x10,%eax
  80083b:	e9 6e ff ff ff       	jmp    8007ae <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	ba 00 00 00 00       	mov    $0x0,%edx
  80084a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8d 40 04             	lea    0x4(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800859:	b8 10 00 00 00       	mov    $0x10,%eax
  80085e:	e9 4b ff ff ff       	jmp    8007ae <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	83 c0 04             	add    $0x4,%eax
  800869:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	85 c0                	test   %eax,%eax
  800873:	74 14                	je     800889 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800875:	8b 13                	mov    (%ebx),%edx
  800877:	83 fa 7f             	cmp    $0x7f,%edx
  80087a:	7f 37                	jg     8008b3 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80087c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80087e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
  800884:	e9 43 ff ff ff       	jmp    8007cc <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800889:	b8 0a 00 00 00       	mov    $0xa,%eax
  80088e:	bf f9 2c 80 00       	mov    $0x802cf9,%edi
							putch(ch, putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	53                   	push   %ebx
  800897:	50                   	push   %eax
  800898:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80089a:	83 c7 01             	add    $0x1,%edi
  80089d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	85 c0                	test   %eax,%eax
  8008a6:	75 eb                	jne    800893 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	e9 19 ff ff ff       	jmp    8007cc <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008b3:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ba:	bf 31 2d 80 00       	mov    $0x802d31,%edi
							putch(ch, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	53                   	push   %ebx
  8008c3:	50                   	push   %eax
  8008c4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008c6:	83 c7 01             	add    $0x1,%edi
  8008c9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	75 eb                	jne    8008bf <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	e9 ed fe ff ff       	jmp    8007cc <vprintfmt+0x446>
			putch(ch, putdat);
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	53                   	push   %ebx
  8008e3:	6a 25                	push   $0x25
  8008e5:	ff d6                	call   *%esi
			break;
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	e9 dd fe ff ff       	jmp    8007cc <vprintfmt+0x446>
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	6a 25                	push   $0x25
  8008f5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	89 f8                	mov    %edi,%eax
  8008fc:	eb 03                	jmp    800901 <vprintfmt+0x57b>
  8008fe:	83 e8 01             	sub    $0x1,%eax
  800901:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800905:	75 f7                	jne    8008fe <vprintfmt+0x578>
  800907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090a:	e9 bd fe ff ff       	jmp    8007cc <vprintfmt+0x446>
}
  80090f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5f                   	pop    %edi
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	83 ec 18             	sub    $0x18,%esp
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800923:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800926:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80092a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80092d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800934:	85 c0                	test   %eax,%eax
  800936:	74 26                	je     80095e <vsnprintf+0x47>
  800938:	85 d2                	test   %edx,%edx
  80093a:	7e 22                	jle    80095e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093c:	ff 75 14             	pushl  0x14(%ebp)
  80093f:	ff 75 10             	pushl  0x10(%ebp)
  800942:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800945:	50                   	push   %eax
  800946:	68 4c 03 80 00       	push   $0x80034c
  80094b:	e8 36 fa ff ff       	call   800386 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800953:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800959:	83 c4 10             	add    $0x10,%esp
}
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    
		return -E_INVAL;
  80095e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800963:	eb f7                	jmp    80095c <vsnprintf+0x45>

00800965 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80096b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80096e:	50                   	push   %eax
  80096f:	ff 75 10             	pushl  0x10(%ebp)
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	ff 75 08             	pushl  0x8(%ebp)
  800978:	e8 9a ff ff ff       	call   800917 <vsnprintf>
	va_end(ap);

	return rc;
}
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800985:	b8 00 00 00 00       	mov    $0x0,%eax
  80098a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80098e:	74 05                	je     800995 <strlen+0x16>
		n++;
  800990:	83 c0 01             	add    $0x1,%eax
  800993:	eb f5                	jmp    80098a <strlen+0xb>
	return n;
}
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a5:	39 c2                	cmp    %eax,%edx
  8009a7:	74 0d                	je     8009b6 <strnlen+0x1f>
  8009a9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009ad:	74 05                	je     8009b4 <strnlen+0x1d>
		n++;
  8009af:	83 c2 01             	add    $0x1,%edx
  8009b2:	eb f1                	jmp    8009a5 <strnlen+0xe>
  8009b4:	89 d0                	mov    %edx,%eax
	return n;
}
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	53                   	push   %ebx
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009cb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009ce:	83 c2 01             	add    $0x1,%edx
  8009d1:	84 c9                	test   %cl,%cl
  8009d3:	75 f2                	jne    8009c7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009d5:	5b                   	pop    %ebx
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	53                   	push   %ebx
  8009dc:	83 ec 10             	sub    $0x10,%esp
  8009df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009e2:	53                   	push   %ebx
  8009e3:	e8 97 ff ff ff       	call   80097f <strlen>
  8009e8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	01 d8                	add    %ebx,%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 c2 ff ff ff       	call   8009b8 <strcpy>
	return dst;
}
  8009f6:	89 d8                	mov    %ebx,%eax
  8009f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a08:	89 c6                	mov    %eax,%esi
  800a0a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a0d:	89 c2                	mov    %eax,%edx
  800a0f:	39 f2                	cmp    %esi,%edx
  800a11:	74 11                	je     800a24 <strncpy+0x27>
		*dst++ = *src;
  800a13:	83 c2 01             	add    $0x1,%edx
  800a16:	0f b6 19             	movzbl (%ecx),%ebx
  800a19:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a1c:	80 fb 01             	cmp    $0x1,%bl
  800a1f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a22:	eb eb                	jmp    800a0f <strncpy+0x12>
	}
	return ret;
}
  800a24:	5b                   	pop    %ebx
  800a25:	5e                   	pop    %esi
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a33:	8b 55 10             	mov    0x10(%ebp),%edx
  800a36:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a38:	85 d2                	test   %edx,%edx
  800a3a:	74 21                	je     800a5d <strlcpy+0x35>
  800a3c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a40:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	74 14                	je     800a5a <strlcpy+0x32>
  800a46:	0f b6 19             	movzbl (%ecx),%ebx
  800a49:	84 db                	test   %bl,%bl
  800a4b:	74 0b                	je     800a58 <strlcpy+0x30>
			*dst++ = *src++;
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	83 c2 01             	add    $0x1,%edx
  800a53:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a56:	eb ea                	jmp    800a42 <strlcpy+0x1a>
  800a58:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a5a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a5d:	29 f0                	sub    %esi,%eax
}
  800a5f:	5b                   	pop    %ebx
  800a60:	5e                   	pop    %esi
  800a61:	5d                   	pop    %ebp
  800a62:	c3                   	ret    

00800a63 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a69:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a6c:	0f b6 01             	movzbl (%ecx),%eax
  800a6f:	84 c0                	test   %al,%al
  800a71:	74 0c                	je     800a7f <strcmp+0x1c>
  800a73:	3a 02                	cmp    (%edx),%al
  800a75:	75 08                	jne    800a7f <strcmp+0x1c>
		p++, q++;
  800a77:	83 c1 01             	add    $0x1,%ecx
  800a7a:	83 c2 01             	add    $0x1,%edx
  800a7d:	eb ed                	jmp    800a6c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7f:	0f b6 c0             	movzbl %al,%eax
  800a82:	0f b6 12             	movzbl (%edx),%edx
  800a85:	29 d0                	sub    %edx,%eax
}
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	53                   	push   %ebx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a93:	89 c3                	mov    %eax,%ebx
  800a95:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a98:	eb 06                	jmp    800aa0 <strncmp+0x17>
		n--, p++, q++;
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aa0:	39 d8                	cmp    %ebx,%eax
  800aa2:	74 16                	je     800aba <strncmp+0x31>
  800aa4:	0f b6 08             	movzbl (%eax),%ecx
  800aa7:	84 c9                	test   %cl,%cl
  800aa9:	74 04                	je     800aaf <strncmp+0x26>
  800aab:	3a 0a                	cmp    (%edx),%cl
  800aad:	74 eb                	je     800a9a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aaf:	0f b6 00             	movzbl (%eax),%eax
  800ab2:	0f b6 12             	movzbl (%edx),%edx
  800ab5:	29 d0                	sub    %edx,%eax
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    
		return 0;
  800aba:	b8 00 00 00 00       	mov    $0x0,%eax
  800abf:	eb f6                	jmp    800ab7 <strncmp+0x2e>

00800ac1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800acb:	0f b6 10             	movzbl (%eax),%edx
  800ace:	84 d2                	test   %dl,%dl
  800ad0:	74 09                	je     800adb <strchr+0x1a>
		if (*s == c)
  800ad2:	38 ca                	cmp    %cl,%dl
  800ad4:	74 0a                	je     800ae0 <strchr+0x1f>
	for (; *s; s++)
  800ad6:	83 c0 01             	add    $0x1,%eax
  800ad9:	eb f0                	jmp    800acb <strchr+0xa>
			return (char *) s;
	return 0;
  800adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aec:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aef:	38 ca                	cmp    %cl,%dl
  800af1:	74 09                	je     800afc <strfind+0x1a>
  800af3:	84 d2                	test   %dl,%dl
  800af5:	74 05                	je     800afc <strfind+0x1a>
	for (; *s; s++)
  800af7:	83 c0 01             	add    $0x1,%eax
  800afa:	eb f0                	jmp    800aec <strfind+0xa>
			break;
	return (char *) s;
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	57                   	push   %edi
  800b02:	56                   	push   %esi
  800b03:	53                   	push   %ebx
  800b04:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b0a:	85 c9                	test   %ecx,%ecx
  800b0c:	74 31                	je     800b3f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b0e:	89 f8                	mov    %edi,%eax
  800b10:	09 c8                	or     %ecx,%eax
  800b12:	a8 03                	test   $0x3,%al
  800b14:	75 23                	jne    800b39 <memset+0x3b>
		c &= 0xFF;
  800b16:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1a:	89 d3                	mov    %edx,%ebx
  800b1c:	c1 e3 08             	shl    $0x8,%ebx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	c1 e0 18             	shl    $0x18,%eax
  800b24:	89 d6                	mov    %edx,%esi
  800b26:	c1 e6 10             	shl    $0x10,%esi
  800b29:	09 f0                	or     %esi,%eax
  800b2b:	09 c2                	or     %eax,%edx
  800b2d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b2f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b32:	89 d0                	mov    %edx,%eax
  800b34:	fc                   	cld    
  800b35:	f3 ab                	rep stos %eax,%es:(%edi)
  800b37:	eb 06                	jmp    800b3f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	fc                   	cld    
  800b3d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b3f:	89 f8                	mov    %edi,%eax
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	57                   	push   %edi
  800b4a:	56                   	push   %esi
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b51:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b54:	39 c6                	cmp    %eax,%esi
  800b56:	73 32                	jae    800b8a <memmove+0x44>
  800b58:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b5b:	39 c2                	cmp    %eax,%edx
  800b5d:	76 2b                	jbe    800b8a <memmove+0x44>
		s += n;
		d += n;
  800b5f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b62:	89 fe                	mov    %edi,%esi
  800b64:	09 ce                	or     %ecx,%esi
  800b66:	09 d6                	or     %edx,%esi
  800b68:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b6e:	75 0e                	jne    800b7e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b70:	83 ef 04             	sub    $0x4,%edi
  800b73:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b76:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b79:	fd                   	std    
  800b7a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7c:	eb 09                	jmp    800b87 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b7e:	83 ef 01             	sub    $0x1,%edi
  800b81:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b84:	fd                   	std    
  800b85:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b87:	fc                   	cld    
  800b88:	eb 1a                	jmp    800ba4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8a:	89 c2                	mov    %eax,%edx
  800b8c:	09 ca                	or     %ecx,%edx
  800b8e:	09 f2                	or     %esi,%edx
  800b90:	f6 c2 03             	test   $0x3,%dl
  800b93:	75 0a                	jne    800b9f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b95:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b98:	89 c7                	mov    %eax,%edi
  800b9a:	fc                   	cld    
  800b9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9d:	eb 05                	jmp    800ba4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b9f:	89 c7                	mov    %eax,%edi
  800ba1:	fc                   	cld    
  800ba2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ba4:	5e                   	pop    %esi
  800ba5:	5f                   	pop    %edi
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bae:	ff 75 10             	pushl  0x10(%ebp)
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	ff 75 08             	pushl  0x8(%ebp)
  800bb7:	e8 8a ff ff ff       	call   800b46 <memmove>
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	56                   	push   %esi
  800bc2:	53                   	push   %ebx
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc9:	89 c6                	mov    %eax,%esi
  800bcb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bce:	39 f0                	cmp    %esi,%eax
  800bd0:	74 1c                	je     800bee <memcmp+0x30>
		if (*s1 != *s2)
  800bd2:	0f b6 08             	movzbl (%eax),%ecx
  800bd5:	0f b6 1a             	movzbl (%edx),%ebx
  800bd8:	38 d9                	cmp    %bl,%cl
  800bda:	75 08                	jne    800be4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bdc:	83 c0 01             	add    $0x1,%eax
  800bdf:	83 c2 01             	add    $0x1,%edx
  800be2:	eb ea                	jmp    800bce <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800be4:	0f b6 c1             	movzbl %cl,%eax
  800be7:	0f b6 db             	movzbl %bl,%ebx
  800bea:	29 d8                	sub    %ebx,%eax
  800bec:	eb 05                	jmp    800bf3 <memcmp+0x35>
	}

	return 0;
  800bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf3:	5b                   	pop    %ebx
  800bf4:	5e                   	pop    %esi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c00:	89 c2                	mov    %eax,%edx
  800c02:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c05:	39 d0                	cmp    %edx,%eax
  800c07:	73 09                	jae    800c12 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c09:	38 08                	cmp    %cl,(%eax)
  800c0b:	74 05                	je     800c12 <memfind+0x1b>
	for (; s < ends; s++)
  800c0d:	83 c0 01             	add    $0x1,%eax
  800c10:	eb f3                	jmp    800c05 <memfind+0xe>
			break;
	return (void *) s;
}
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
  800c1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c20:	eb 03                	jmp    800c25 <strtol+0x11>
		s++;
  800c22:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c25:	0f b6 01             	movzbl (%ecx),%eax
  800c28:	3c 20                	cmp    $0x20,%al
  800c2a:	74 f6                	je     800c22 <strtol+0xe>
  800c2c:	3c 09                	cmp    $0x9,%al
  800c2e:	74 f2                	je     800c22 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c30:	3c 2b                	cmp    $0x2b,%al
  800c32:	74 2a                	je     800c5e <strtol+0x4a>
	int neg = 0;
  800c34:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c39:	3c 2d                	cmp    $0x2d,%al
  800c3b:	74 2b                	je     800c68 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c43:	75 0f                	jne    800c54 <strtol+0x40>
  800c45:	80 39 30             	cmpb   $0x30,(%ecx)
  800c48:	74 28                	je     800c72 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c4a:	85 db                	test   %ebx,%ebx
  800c4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c51:	0f 44 d8             	cmove  %eax,%ebx
  800c54:	b8 00 00 00 00       	mov    $0x0,%eax
  800c59:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c5c:	eb 50                	jmp    800cae <strtol+0x9a>
		s++;
  800c5e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c61:	bf 00 00 00 00       	mov    $0x0,%edi
  800c66:	eb d5                	jmp    800c3d <strtol+0x29>
		s++, neg = 1;
  800c68:	83 c1 01             	add    $0x1,%ecx
  800c6b:	bf 01 00 00 00       	mov    $0x1,%edi
  800c70:	eb cb                	jmp    800c3d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c72:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c76:	74 0e                	je     800c86 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c78:	85 db                	test   %ebx,%ebx
  800c7a:	75 d8                	jne    800c54 <strtol+0x40>
		s++, base = 8;
  800c7c:	83 c1 01             	add    $0x1,%ecx
  800c7f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c84:	eb ce                	jmp    800c54 <strtol+0x40>
		s += 2, base = 16;
  800c86:	83 c1 02             	add    $0x2,%ecx
  800c89:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c8e:	eb c4                	jmp    800c54 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c90:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c93:	89 f3                	mov    %esi,%ebx
  800c95:	80 fb 19             	cmp    $0x19,%bl
  800c98:	77 29                	ja     800cc3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c9a:	0f be d2             	movsbl %dl,%edx
  800c9d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ca3:	7d 30                	jge    800cd5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ca5:	83 c1 01             	add    $0x1,%ecx
  800ca8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cac:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cae:	0f b6 11             	movzbl (%ecx),%edx
  800cb1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cb4:	89 f3                	mov    %esi,%ebx
  800cb6:	80 fb 09             	cmp    $0x9,%bl
  800cb9:	77 d5                	ja     800c90 <strtol+0x7c>
			dig = *s - '0';
  800cbb:	0f be d2             	movsbl %dl,%edx
  800cbe:	83 ea 30             	sub    $0x30,%edx
  800cc1:	eb dd                	jmp    800ca0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cc3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cc6:	89 f3                	mov    %esi,%ebx
  800cc8:	80 fb 19             	cmp    $0x19,%bl
  800ccb:	77 08                	ja     800cd5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ccd:	0f be d2             	movsbl %dl,%edx
  800cd0:	83 ea 37             	sub    $0x37,%edx
  800cd3:	eb cb                	jmp    800ca0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd9:	74 05                	je     800ce0 <strtol+0xcc>
		*endptr = (char *) s;
  800cdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cde:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ce0:	89 c2                	mov    %eax,%edx
  800ce2:	f7 da                	neg    %edx
  800ce4:	85 ff                	test   %edi,%edi
  800ce6:	0f 45 c2             	cmovne %edx,%eax
}
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cff:	89 c3                	mov    %eax,%ebx
  800d01:	89 c7                	mov    %eax,%edi
  800d03:	89 c6                	mov    %eax,%esi
  800d05:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <sys_cgetc>:

int
sys_cgetc(void)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d12:	ba 00 00 00 00       	mov    $0x0,%edx
  800d17:	b8 01 00 00 00       	mov    $0x1,%eax
  800d1c:	89 d1                	mov    %edx,%ecx
  800d1e:	89 d3                	mov    %edx,%ebx
  800d20:	89 d7                	mov    %edx,%edi
  800d22:	89 d6                	mov    %edx,%esi
  800d24:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5f                   	pop    %edi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	57                   	push   %edi
  800d2f:	56                   	push   %esi
  800d30:	53                   	push   %ebx
  800d31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d34:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d41:	89 cb                	mov    %ecx,%ebx
  800d43:	89 cf                	mov    %ecx,%edi
  800d45:	89 ce                	mov    %ecx,%esi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7f 08                	jg     800d55 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	50                   	push   %eax
  800d59:	6a 03                	push   $0x3
  800d5b:	68 48 2f 80 00       	push   $0x802f48
  800d60:	6a 43                	push   $0x43
  800d62:	68 65 2f 80 00       	push   $0x802f65
  800d67:	e8 f7 f3 ff ff       	call   800163 <_panic>

00800d6c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	57                   	push   %edi
  800d70:	56                   	push   %esi
  800d71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d72:	ba 00 00 00 00       	mov    $0x0,%edx
  800d77:	b8 02 00 00 00       	mov    $0x2,%eax
  800d7c:	89 d1                	mov    %edx,%ecx
  800d7e:	89 d3                	mov    %edx,%ebx
  800d80:	89 d7                	mov    %edx,%edi
  800d82:	89 d6                	mov    %edx,%esi
  800d84:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <sys_yield>:

void
sys_yield(void)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d91:	ba 00 00 00 00       	mov    $0x0,%edx
  800d96:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d9b:	89 d1                	mov    %edx,%ecx
  800d9d:	89 d3                	mov    %edx,%ebx
  800d9f:	89 d7                	mov    %edx,%edi
  800da1:	89 d6                	mov    %edx,%esi
  800da3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	be 00 00 00 00       	mov    $0x0,%esi
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc6:	89 f7                	mov    %esi,%edi
  800dc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	7f 08                	jg     800dd6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd6:	83 ec 0c             	sub    $0xc,%esp
  800dd9:	50                   	push   %eax
  800dda:	6a 04                	push   $0x4
  800ddc:	68 48 2f 80 00       	push   $0x802f48
  800de1:	6a 43                	push   $0x43
  800de3:	68 65 2f 80 00       	push   $0x802f65
  800de8:	e8 76 f3 ff ff       	call   800163 <_panic>

00800ded <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	b8 05 00 00 00       	mov    $0x5,%eax
  800e01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e04:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e07:	8b 75 18             	mov    0x18(%ebp),%esi
  800e0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7f 08                	jg     800e18 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	50                   	push   %eax
  800e1c:	6a 05                	push   $0x5
  800e1e:	68 48 2f 80 00       	push   $0x802f48
  800e23:	6a 43                	push   $0x43
  800e25:	68 65 2f 80 00       	push   $0x802f65
  800e2a:	e8 34 f3 ff ff       	call   800163 <_panic>

00800e2f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e43:	b8 06 00 00 00       	mov    $0x6,%eax
  800e48:	89 df                	mov    %ebx,%edi
  800e4a:	89 de                	mov    %ebx,%esi
  800e4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	7f 08                	jg     800e5a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e55:	5b                   	pop    %ebx
  800e56:	5e                   	pop    %esi
  800e57:	5f                   	pop    %edi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5a:	83 ec 0c             	sub    $0xc,%esp
  800e5d:	50                   	push   %eax
  800e5e:	6a 06                	push   $0x6
  800e60:	68 48 2f 80 00       	push   $0x802f48
  800e65:	6a 43                	push   $0x43
  800e67:	68 65 2f 80 00       	push   $0x802f65
  800e6c:	e8 f2 f2 ff ff       	call   800163 <_panic>

00800e71 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	57                   	push   %edi
  800e75:	56                   	push   %esi
  800e76:	53                   	push   %ebx
  800e77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	b8 08 00 00 00       	mov    $0x8,%eax
  800e8a:	89 df                	mov    %ebx,%edi
  800e8c:	89 de                	mov    %ebx,%esi
  800e8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	7f 08                	jg     800e9c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9c:	83 ec 0c             	sub    $0xc,%esp
  800e9f:	50                   	push   %eax
  800ea0:	6a 08                	push   $0x8
  800ea2:	68 48 2f 80 00       	push   $0x802f48
  800ea7:	6a 43                	push   $0x43
  800ea9:	68 65 2f 80 00       	push   $0x802f65
  800eae:	e8 b0 f2 ff ff       	call   800163 <_panic>

00800eb3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec7:	b8 09 00 00 00       	mov    $0x9,%eax
  800ecc:	89 df                	mov    %ebx,%edi
  800ece:	89 de                	mov    %ebx,%esi
  800ed0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	7f 08                	jg     800ede <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed9:	5b                   	pop    %ebx
  800eda:	5e                   	pop    %esi
  800edb:	5f                   	pop    %edi
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ede:	83 ec 0c             	sub    $0xc,%esp
  800ee1:	50                   	push   %eax
  800ee2:	6a 09                	push   $0x9
  800ee4:	68 48 2f 80 00       	push   $0x802f48
  800ee9:	6a 43                	push   $0x43
  800eeb:	68 65 2f 80 00       	push   $0x802f65
  800ef0:	e8 6e f2 ff ff       	call   800163 <_panic>

00800ef5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	57                   	push   %edi
  800ef9:	56                   	push   %esi
  800efa:	53                   	push   %ebx
  800efb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f0e:	89 df                	mov    %ebx,%edi
  800f10:	89 de                	mov    %ebx,%esi
  800f12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f14:	85 c0                	test   %eax,%eax
  800f16:	7f 08                	jg     800f20 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f20:	83 ec 0c             	sub    $0xc,%esp
  800f23:	50                   	push   %eax
  800f24:	6a 0a                	push   $0xa
  800f26:	68 48 2f 80 00       	push   $0x802f48
  800f2b:	6a 43                	push   $0x43
  800f2d:	68 65 2f 80 00       	push   $0x802f65
  800f32:	e8 2c f2 ff ff       	call   800163 <_panic>

00800f37 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f43:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f48:	be 00 00 00 00       	mov    $0x0,%esi
  800f4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f50:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f53:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
  800f60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f63:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f68:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f70:	89 cb                	mov    %ecx,%ebx
  800f72:	89 cf                	mov    %ecx,%edi
  800f74:	89 ce                	mov    %ecx,%esi
  800f76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	7f 08                	jg     800f84 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7f:	5b                   	pop    %ebx
  800f80:	5e                   	pop    %esi
  800f81:	5f                   	pop    %edi
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f84:	83 ec 0c             	sub    $0xc,%esp
  800f87:	50                   	push   %eax
  800f88:	6a 0d                	push   $0xd
  800f8a:	68 48 2f 80 00       	push   $0x802f48
  800f8f:	6a 43                	push   $0x43
  800f91:	68 65 2f 80 00       	push   $0x802f65
  800f96:	e8 c8 f1 ff ff       	call   800163 <_panic>

00800f9b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	57                   	push   %edi
  800f9f:	56                   	push   %esi
  800fa0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fac:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fb1:	89 df                	mov    %ebx,%edi
  800fb3:	89 de                	mov    %ebx,%esi
  800fb5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fca:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fcf:	89 cb                	mov    %ecx,%ebx
  800fd1:	89 cf                	mov    %ecx,%edi
  800fd3:	89 ce                	mov    %ecx,%esi
  800fd5:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe7:	b8 10 00 00 00       	mov    $0x10,%eax
  800fec:	89 d1                	mov    %edx,%ecx
  800fee:	89 d3                	mov    %edx,%ebx
  800ff0:	89 d7                	mov    %edx,%edi
  800ff2:	89 d6                	mov    %edx,%esi
  800ff4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
	asm volatile("int %1\n"
  801001:	bb 00 00 00 00       	mov    $0x0,%ebx
  801006:	8b 55 08             	mov    0x8(%ebp),%edx
  801009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100c:	b8 11 00 00 00       	mov    $0x11,%eax
  801011:	89 df                	mov    %ebx,%edi
  801013:	89 de                	mov    %ebx,%esi
  801015:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
	asm volatile("int %1\n"
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102d:	b8 12 00 00 00       	mov    $0x12,%eax
  801032:	89 df                	mov    %ebx,%edi
  801034:	89 de                	mov    %ebx,%esi
  801036:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
  801043:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	8b 55 08             	mov    0x8(%ebp),%edx
  80104e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801051:	b8 13 00 00 00       	mov    $0x13,%eax
  801056:	89 df                	mov    %ebx,%edi
  801058:	89 de                	mov    %ebx,%esi
  80105a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	7f 08                	jg     801068 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801060:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801063:	5b                   	pop    %ebx
  801064:	5e                   	pop    %esi
  801065:	5f                   	pop    %edi
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801068:	83 ec 0c             	sub    $0xc,%esp
  80106b:	50                   	push   %eax
  80106c:	6a 13                	push   $0x13
  80106e:	68 48 2f 80 00       	push   $0x802f48
  801073:	6a 43                	push   $0x43
  801075:	68 65 2f 80 00       	push   $0x802f65
  80107a:	e8 e4 f0 ff ff       	call   800163 <_panic>

0080107f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
	asm volatile("int %1\n"
  801085:	b9 00 00 00 00       	mov    $0x0,%ecx
  80108a:	8b 55 08             	mov    0x8(%ebp),%edx
  80108d:	b8 14 00 00 00       	mov    $0x14,%eax
  801092:	89 cb                	mov    %ecx,%ebx
  801094:	89 cf                	mov    %ecx,%edi
  801096:	89 ce                	mov    %ecx,%esi
  801098:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80109a:	5b                   	pop    %ebx
  80109b:	5e                   	pop    %esi
  80109c:	5f                   	pop    %edi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010a6:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ad:	f6 c5 04             	test   $0x4,%ch
  8010b0:	75 45                	jne    8010f7 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010b2:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010b9:	83 e1 07             	and    $0x7,%ecx
  8010bc:	83 f9 07             	cmp    $0x7,%ecx
  8010bf:	74 6f                	je     801130 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010c1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010c8:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010ce:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010d4:	0f 84 b6 00 00 00    	je     801190 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010da:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010e1:	83 e1 05             	and    $0x5,%ecx
  8010e4:	83 f9 05             	cmp    $0x5,%ecx
  8010e7:	0f 84 d7 00 00 00    	je     8011c4 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8010f7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010fe:	c1 e2 0c             	shl    $0xc,%edx
  801101:	83 ec 0c             	sub    $0xc,%esp
  801104:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80110a:	51                   	push   %ecx
  80110b:	52                   	push   %edx
  80110c:	50                   	push   %eax
  80110d:	52                   	push   %edx
  80110e:	6a 00                	push   $0x0
  801110:	e8 d8 fc ff ff       	call   800ded <sys_page_map>
		if(r < 0)
  801115:	83 c4 20             	add    $0x20,%esp
  801118:	85 c0                	test   %eax,%eax
  80111a:	79 d1                	jns    8010ed <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80111c:	83 ec 04             	sub    $0x4,%esp
  80111f:	68 73 2f 80 00       	push   $0x802f73
  801124:	6a 54                	push   $0x54
  801126:	68 89 2f 80 00       	push   $0x802f89
  80112b:	e8 33 f0 ff ff       	call   800163 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801130:	89 d3                	mov    %edx,%ebx
  801132:	c1 e3 0c             	shl    $0xc,%ebx
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	68 05 08 00 00       	push   $0x805
  80113d:	53                   	push   %ebx
  80113e:	50                   	push   %eax
  80113f:	53                   	push   %ebx
  801140:	6a 00                	push   $0x0
  801142:	e8 a6 fc ff ff       	call   800ded <sys_page_map>
		if(r < 0)
  801147:	83 c4 20             	add    $0x20,%esp
  80114a:	85 c0                	test   %eax,%eax
  80114c:	78 2e                	js     80117c <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80114e:	83 ec 0c             	sub    $0xc,%esp
  801151:	68 05 08 00 00       	push   $0x805
  801156:	53                   	push   %ebx
  801157:	6a 00                	push   $0x0
  801159:	53                   	push   %ebx
  80115a:	6a 00                	push   $0x0
  80115c:	e8 8c fc ff ff       	call   800ded <sys_page_map>
		if(r < 0)
  801161:	83 c4 20             	add    $0x20,%esp
  801164:	85 c0                	test   %eax,%eax
  801166:	79 85                	jns    8010ed <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801168:	83 ec 04             	sub    $0x4,%esp
  80116b:	68 73 2f 80 00       	push   $0x802f73
  801170:	6a 5f                	push   $0x5f
  801172:	68 89 2f 80 00       	push   $0x802f89
  801177:	e8 e7 ef ff ff       	call   800163 <_panic>
			panic("sys_page_map() panic\n");
  80117c:	83 ec 04             	sub    $0x4,%esp
  80117f:	68 73 2f 80 00       	push   $0x802f73
  801184:	6a 5b                	push   $0x5b
  801186:	68 89 2f 80 00       	push   $0x802f89
  80118b:	e8 d3 ef ff ff       	call   800163 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801190:	c1 e2 0c             	shl    $0xc,%edx
  801193:	83 ec 0c             	sub    $0xc,%esp
  801196:	68 05 08 00 00       	push   $0x805
  80119b:	52                   	push   %edx
  80119c:	50                   	push   %eax
  80119d:	52                   	push   %edx
  80119e:	6a 00                	push   $0x0
  8011a0:	e8 48 fc ff ff       	call   800ded <sys_page_map>
		if(r < 0)
  8011a5:	83 c4 20             	add    $0x20,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	0f 89 3d ff ff ff    	jns    8010ed <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011b0:	83 ec 04             	sub    $0x4,%esp
  8011b3:	68 73 2f 80 00       	push   $0x802f73
  8011b8:	6a 66                	push   $0x66
  8011ba:	68 89 2f 80 00       	push   $0x802f89
  8011bf:	e8 9f ef ff ff       	call   800163 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011c4:	c1 e2 0c             	shl    $0xc,%edx
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	6a 05                	push   $0x5
  8011cc:	52                   	push   %edx
  8011cd:	50                   	push   %eax
  8011ce:	52                   	push   %edx
  8011cf:	6a 00                	push   $0x0
  8011d1:	e8 17 fc ff ff       	call   800ded <sys_page_map>
		if(r < 0)
  8011d6:	83 c4 20             	add    $0x20,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	0f 89 0c ff ff ff    	jns    8010ed <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011e1:	83 ec 04             	sub    $0x4,%esp
  8011e4:	68 73 2f 80 00       	push   $0x802f73
  8011e9:	6a 6d                	push   $0x6d
  8011eb:	68 89 2f 80 00       	push   $0x802f89
  8011f0:	e8 6e ef ff ff       	call   800163 <_panic>

008011f5 <pgfault>:
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 04             	sub    $0x4,%esp
  8011fc:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011ff:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801201:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801205:	0f 84 99 00 00 00    	je     8012a4 <pgfault+0xaf>
  80120b:	89 c2                	mov    %eax,%edx
  80120d:	c1 ea 16             	shr    $0x16,%edx
  801210:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801217:	f6 c2 01             	test   $0x1,%dl
  80121a:	0f 84 84 00 00 00    	je     8012a4 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801220:	89 c2                	mov    %eax,%edx
  801222:	c1 ea 0c             	shr    $0xc,%edx
  801225:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122c:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801232:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801238:	75 6a                	jne    8012a4 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80123a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80123f:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801241:	83 ec 04             	sub    $0x4,%esp
  801244:	6a 07                	push   $0x7
  801246:	68 00 f0 7f 00       	push   $0x7ff000
  80124b:	6a 00                	push   $0x0
  80124d:	e8 58 fb ff ff       	call   800daa <sys_page_alloc>
	if(ret < 0)
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	78 5f                	js     8012b8 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801259:	83 ec 04             	sub    $0x4,%esp
  80125c:	68 00 10 00 00       	push   $0x1000
  801261:	53                   	push   %ebx
  801262:	68 00 f0 7f 00       	push   $0x7ff000
  801267:	e8 3c f9 ff ff       	call   800ba8 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80126c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801273:	53                   	push   %ebx
  801274:	6a 00                	push   $0x0
  801276:	68 00 f0 7f 00       	push   $0x7ff000
  80127b:	6a 00                	push   $0x0
  80127d:	e8 6b fb ff ff       	call   800ded <sys_page_map>
	if(ret < 0)
  801282:	83 c4 20             	add    $0x20,%esp
  801285:	85 c0                	test   %eax,%eax
  801287:	78 43                	js     8012cc <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801289:	83 ec 08             	sub    $0x8,%esp
  80128c:	68 00 f0 7f 00       	push   $0x7ff000
  801291:	6a 00                	push   $0x0
  801293:	e8 97 fb ff ff       	call   800e2f <sys_page_unmap>
	if(ret < 0)
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	85 c0                	test   %eax,%eax
  80129d:	78 41                	js     8012e0 <pgfault+0xeb>
}
  80129f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012a4:	83 ec 04             	sub    $0x4,%esp
  8012a7:	68 94 2f 80 00       	push   $0x802f94
  8012ac:	6a 26                	push   $0x26
  8012ae:	68 89 2f 80 00       	push   $0x802f89
  8012b3:	e8 ab ee ff ff       	call   800163 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	68 a8 2f 80 00       	push   $0x802fa8
  8012c0:	6a 31                	push   $0x31
  8012c2:	68 89 2f 80 00       	push   $0x802f89
  8012c7:	e8 97 ee ff ff       	call   800163 <_panic>
		panic("panic in sys_page_map()\n");
  8012cc:	83 ec 04             	sub    $0x4,%esp
  8012cf:	68 c3 2f 80 00       	push   $0x802fc3
  8012d4:	6a 36                	push   $0x36
  8012d6:	68 89 2f 80 00       	push   $0x802f89
  8012db:	e8 83 ee ff ff       	call   800163 <_panic>
		panic("panic in sys_page_unmap()\n");
  8012e0:	83 ec 04             	sub    $0x4,%esp
  8012e3:	68 dc 2f 80 00       	push   $0x802fdc
  8012e8:	6a 39                	push   $0x39
  8012ea:	68 89 2f 80 00       	push   $0x802f89
  8012ef:	e8 6f ee ff ff       	call   800163 <_panic>

008012f4 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	57                   	push   %edi
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
  8012fa:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012fd:	68 f5 11 80 00       	push   $0x8011f5
  801302:	e8 db 13 00 00       	call   8026e2 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801307:	b8 07 00 00 00       	mov    $0x7,%eax
  80130c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	78 2a                	js     80133f <fork+0x4b>
  801315:	89 c6                	mov    %eax,%esi
  801317:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801319:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80131e:	75 4b                	jne    80136b <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801320:	e8 47 fa ff ff       	call   800d6c <sys_getenvid>
  801325:	25 ff 03 00 00       	and    $0x3ff,%eax
  80132a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801330:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801335:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80133a:	e9 90 00 00 00       	jmp    8013cf <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80133f:	83 ec 04             	sub    $0x4,%esp
  801342:	68 f8 2f 80 00       	push   $0x802ff8
  801347:	68 8c 00 00 00       	push   $0x8c
  80134c:	68 89 2f 80 00       	push   $0x802f89
  801351:	e8 0d ee ff ff       	call   800163 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801356:	89 f8                	mov    %edi,%eax
  801358:	e8 42 fd ff ff       	call   80109f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80135d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801363:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801369:	74 26                	je     801391 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80136b:	89 d8                	mov    %ebx,%eax
  80136d:	c1 e8 16             	shr    $0x16,%eax
  801370:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801377:	a8 01                	test   $0x1,%al
  801379:	74 e2                	je     80135d <fork+0x69>
  80137b:	89 da                	mov    %ebx,%edx
  80137d:	c1 ea 0c             	shr    $0xc,%edx
  801380:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801387:	83 e0 05             	and    $0x5,%eax
  80138a:	83 f8 05             	cmp    $0x5,%eax
  80138d:	75 ce                	jne    80135d <fork+0x69>
  80138f:	eb c5                	jmp    801356 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	6a 07                	push   $0x7
  801396:	68 00 f0 bf ee       	push   $0xeebff000
  80139b:	56                   	push   %esi
  80139c:	e8 09 fa ff ff       	call   800daa <sys_page_alloc>
	if(ret < 0)
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 31                	js     8013d9 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013a8:	83 ec 08             	sub    $0x8,%esp
  8013ab:	68 51 27 80 00       	push   $0x802751
  8013b0:	56                   	push   %esi
  8013b1:	e8 3f fb ff ff       	call   800ef5 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 33                	js     8013f0 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	6a 02                	push   $0x2
  8013c2:	56                   	push   %esi
  8013c3:	e8 a9 fa ff ff       	call   800e71 <sys_env_set_status>
	if(ret < 0)
  8013c8:	83 c4 10             	add    $0x10,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	78 38                	js     801407 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5f                   	pop    %edi
  8013d7:	5d                   	pop    %ebp
  8013d8:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	68 a8 2f 80 00       	push   $0x802fa8
  8013e1:	68 98 00 00 00       	push   $0x98
  8013e6:	68 89 2f 80 00       	push   $0x802f89
  8013eb:	e8 73 ed ff ff       	call   800163 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	68 1c 30 80 00       	push   $0x80301c
  8013f8:	68 9b 00 00 00       	push   $0x9b
  8013fd:	68 89 2f 80 00       	push   $0x802f89
  801402:	e8 5c ed ff ff       	call   800163 <_panic>
		panic("panic in sys_env_set_status()\n");
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	68 44 30 80 00       	push   $0x803044
  80140f:	68 9e 00 00 00       	push   $0x9e
  801414:	68 89 2f 80 00       	push   $0x802f89
  801419:	e8 45 ed ff ff       	call   800163 <_panic>

0080141e <sfork>:

// Challenge!
int
sfork(void)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	57                   	push   %edi
  801422:	56                   	push   %esi
  801423:	53                   	push   %ebx
  801424:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801427:	68 f5 11 80 00       	push   $0x8011f5
  80142c:	e8 b1 12 00 00       	call   8026e2 <set_pgfault_handler>
  801431:	b8 07 00 00 00       	mov    $0x7,%eax
  801436:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	85 c0                	test   %eax,%eax
  80143d:	78 2a                	js     801469 <sfork+0x4b>
  80143f:	89 c7                	mov    %eax,%edi
  801441:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801443:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801448:	75 58                	jne    8014a2 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  80144a:	e8 1d f9 ff ff       	call   800d6c <sys_getenvid>
  80144f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801454:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80145a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80145f:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801464:	e9 d4 00 00 00       	jmp    80153d <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	68 f8 2f 80 00       	push   $0x802ff8
  801471:	68 af 00 00 00       	push   $0xaf
  801476:	68 89 2f 80 00       	push   $0x802f89
  80147b:	e8 e3 ec ff ff       	call   800163 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801480:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801485:	89 f0                	mov    %esi,%eax
  801487:	e8 13 fc ff ff       	call   80109f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80148c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801492:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801498:	77 65                	ja     8014ff <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  80149a:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014a0:	74 de                	je     801480 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014a2:	89 d8                	mov    %ebx,%eax
  8014a4:	c1 e8 16             	shr    $0x16,%eax
  8014a7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ae:	a8 01                	test   $0x1,%al
  8014b0:	74 da                	je     80148c <sfork+0x6e>
  8014b2:	89 da                	mov    %ebx,%edx
  8014b4:	c1 ea 0c             	shr    $0xc,%edx
  8014b7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014be:	83 e0 05             	and    $0x5,%eax
  8014c1:	83 f8 05             	cmp    $0x5,%eax
  8014c4:	75 c6                	jne    80148c <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014c6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014cd:	c1 e2 0c             	shl    $0xc,%edx
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	83 e0 07             	and    $0x7,%eax
  8014d6:	50                   	push   %eax
  8014d7:	52                   	push   %edx
  8014d8:	56                   	push   %esi
  8014d9:	52                   	push   %edx
  8014da:	6a 00                	push   $0x0
  8014dc:	e8 0c f9 ff ff       	call   800ded <sys_page_map>
  8014e1:	83 c4 20             	add    $0x20,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	74 a4                	je     80148c <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	68 73 2f 80 00       	push   $0x802f73
  8014f0:	68 ba 00 00 00       	push   $0xba
  8014f5:	68 89 2f 80 00       	push   $0x802f89
  8014fa:	e8 64 ec ff ff       	call   800163 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	6a 07                	push   $0x7
  801504:	68 00 f0 bf ee       	push   $0xeebff000
  801509:	57                   	push   %edi
  80150a:	e8 9b f8 ff ff       	call   800daa <sys_page_alloc>
	if(ret < 0)
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	78 31                	js     801547 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	68 51 27 80 00       	push   $0x802751
  80151e:	57                   	push   %edi
  80151f:	e8 d1 f9 ff ff       	call   800ef5 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	78 33                	js     80155e <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	6a 02                	push   $0x2
  801530:	57                   	push   %edi
  801531:	e8 3b f9 ff ff       	call   800e71 <sys_env_set_status>
	if(ret < 0)
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	85 c0                	test   %eax,%eax
  80153b:	78 38                	js     801575 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80153d:	89 f8                	mov    %edi,%eax
  80153f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801542:	5b                   	pop    %ebx
  801543:	5e                   	pop    %esi
  801544:	5f                   	pop    %edi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	68 a8 2f 80 00       	push   $0x802fa8
  80154f:	68 c0 00 00 00       	push   $0xc0
  801554:	68 89 2f 80 00       	push   $0x802f89
  801559:	e8 05 ec ff ff       	call   800163 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80155e:	83 ec 04             	sub    $0x4,%esp
  801561:	68 1c 30 80 00       	push   $0x80301c
  801566:	68 c3 00 00 00       	push   $0xc3
  80156b:	68 89 2f 80 00       	push   $0x802f89
  801570:	e8 ee eb ff ff       	call   800163 <_panic>
		panic("panic in sys_env_set_status()\n");
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	68 44 30 80 00       	push   $0x803044
  80157d:	68 c6 00 00 00       	push   $0xc6
  801582:	68 89 2f 80 00       	push   $0x802f89
  801587:	e8 d7 eb ff ff       	call   800163 <_panic>

0080158c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	05 00 00 00 30       	add    $0x30000000,%eax
  801597:	c1 e8 0c             	shr    $0xc,%eax
}
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ac:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015b1:	5d                   	pop    %ebp
  8015b2:	c3                   	ret    

008015b3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	c1 ea 16             	shr    $0x16,%edx
  8015c0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015c7:	f6 c2 01             	test   $0x1,%dl
  8015ca:	74 2d                	je     8015f9 <fd_alloc+0x46>
  8015cc:	89 c2                	mov    %eax,%edx
  8015ce:	c1 ea 0c             	shr    $0xc,%edx
  8015d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015d8:	f6 c2 01             	test   $0x1,%dl
  8015db:	74 1c                	je     8015f9 <fd_alloc+0x46>
  8015dd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015e7:	75 d2                	jne    8015bb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015f2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015f7:	eb 0a                	jmp    801603 <fd_alloc+0x50>
			*fd_store = fd;
  8015f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    

00801605 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80160b:	83 f8 1f             	cmp    $0x1f,%eax
  80160e:	77 30                	ja     801640 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801610:	c1 e0 0c             	shl    $0xc,%eax
  801613:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801618:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80161e:	f6 c2 01             	test   $0x1,%dl
  801621:	74 24                	je     801647 <fd_lookup+0x42>
  801623:	89 c2                	mov    %eax,%edx
  801625:	c1 ea 0c             	shr    $0xc,%edx
  801628:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80162f:	f6 c2 01             	test   $0x1,%dl
  801632:	74 1a                	je     80164e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801634:	8b 55 0c             	mov    0xc(%ebp),%edx
  801637:	89 02                	mov    %eax,(%edx)
	return 0;
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    
		return -E_INVAL;
  801640:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801645:	eb f7                	jmp    80163e <fd_lookup+0x39>
		return -E_INVAL;
  801647:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164c:	eb f0                	jmp    80163e <fd_lookup+0x39>
  80164e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801653:	eb e9                	jmp    80163e <fd_lookup+0x39>

00801655 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80165e:	ba 00 00 00 00       	mov    $0x0,%edx
  801663:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801668:	39 08                	cmp    %ecx,(%eax)
  80166a:	74 38                	je     8016a4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80166c:	83 c2 01             	add    $0x1,%edx
  80166f:	8b 04 95 e0 30 80 00 	mov    0x8030e0(,%edx,4),%eax
  801676:	85 c0                	test   %eax,%eax
  801678:	75 ee                	jne    801668 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80167a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80167f:	8b 40 48             	mov    0x48(%eax),%eax
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	51                   	push   %ecx
  801686:	50                   	push   %eax
  801687:	68 64 30 80 00       	push   $0x803064
  80168c:	e8 c8 eb ff ff       	call   800259 <cprintf>
	*dev = 0;
  801691:	8b 45 0c             	mov    0xc(%ebp),%eax
  801694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    
			*dev = devtab[i];
  8016a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb f2                	jmp    8016a2 <dev_lookup+0x4d>

008016b0 <fd_close>:
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	57                   	push   %edi
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 24             	sub    $0x24,%esp
  8016b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8016bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016c2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016c9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016cc:	50                   	push   %eax
  8016cd:	e8 33 ff ff ff       	call   801605 <fd_lookup>
  8016d2:	89 c3                	mov    %eax,%ebx
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 05                	js     8016e0 <fd_close+0x30>
	    || fd != fd2)
  8016db:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016de:	74 16                	je     8016f6 <fd_close+0x46>
		return (must_exist ? r : 0);
  8016e0:	89 f8                	mov    %edi,%eax
  8016e2:	84 c0                	test   %al,%al
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	0f 44 d8             	cmove  %eax,%ebx
}
  8016ec:	89 d8                	mov    %ebx,%eax
  8016ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5f                   	pop    %edi
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016fc:	50                   	push   %eax
  8016fd:	ff 36                	pushl  (%esi)
  8016ff:	e8 51 ff ff ff       	call   801655 <dev_lookup>
  801704:	89 c3                	mov    %eax,%ebx
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 1a                	js     801727 <fd_close+0x77>
		if (dev->dev_close)
  80170d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801710:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801713:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 0b                	je     801727 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	56                   	push   %esi
  801720:	ff d0                	call   *%eax
  801722:	89 c3                	mov    %eax,%ebx
  801724:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	56                   	push   %esi
  80172b:	6a 00                	push   $0x0
  80172d:	e8 fd f6 ff ff       	call   800e2f <sys_page_unmap>
	return r;
  801732:	83 c4 10             	add    $0x10,%esp
  801735:	eb b5                	jmp    8016ec <fd_close+0x3c>

00801737 <close>:

int
close(int fdnum)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80173d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801740:	50                   	push   %eax
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	e8 bc fe ff ff       	call   801605 <fd_lookup>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	85 c0                	test   %eax,%eax
  80174e:	79 02                	jns    801752 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    
		return fd_close(fd, 1);
  801752:	83 ec 08             	sub    $0x8,%esp
  801755:	6a 01                	push   $0x1
  801757:	ff 75 f4             	pushl  -0xc(%ebp)
  80175a:	e8 51 ff ff ff       	call   8016b0 <fd_close>
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	eb ec                	jmp    801750 <close+0x19>

00801764 <close_all>:

void
close_all(void)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	53                   	push   %ebx
  801768:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80176b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	53                   	push   %ebx
  801774:	e8 be ff ff ff       	call   801737 <close>
	for (i = 0; i < MAXFD; i++)
  801779:	83 c3 01             	add    $0x1,%ebx
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	83 fb 20             	cmp    $0x20,%ebx
  801782:	75 ec                	jne    801770 <close_all+0xc>
}
  801784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	57                   	push   %edi
  80178d:	56                   	push   %esi
  80178e:	53                   	push   %ebx
  80178f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801792:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801795:	50                   	push   %eax
  801796:	ff 75 08             	pushl  0x8(%ebp)
  801799:	e8 67 fe ff ff       	call   801605 <fd_lookup>
  80179e:	89 c3                	mov    %eax,%ebx
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	0f 88 81 00 00 00    	js     80182c <dup+0xa3>
		return r;
	close(newfdnum);
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	ff 75 0c             	pushl  0xc(%ebp)
  8017b1:	e8 81 ff ff ff       	call   801737 <close>

	newfd = INDEX2FD(newfdnum);
  8017b6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b9:	c1 e6 0c             	shl    $0xc,%esi
  8017bc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017c2:	83 c4 04             	add    $0x4,%esp
  8017c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017c8:	e8 cf fd ff ff       	call   80159c <fd2data>
  8017cd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017cf:	89 34 24             	mov    %esi,(%esp)
  8017d2:	e8 c5 fd ff ff       	call   80159c <fd2data>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017dc:	89 d8                	mov    %ebx,%eax
  8017de:	c1 e8 16             	shr    $0x16,%eax
  8017e1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017e8:	a8 01                	test   $0x1,%al
  8017ea:	74 11                	je     8017fd <dup+0x74>
  8017ec:	89 d8                	mov    %ebx,%eax
  8017ee:	c1 e8 0c             	shr    $0xc,%eax
  8017f1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017f8:	f6 c2 01             	test   $0x1,%dl
  8017fb:	75 39                	jne    801836 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801800:	89 d0                	mov    %edx,%eax
  801802:	c1 e8 0c             	shr    $0xc,%eax
  801805:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80180c:	83 ec 0c             	sub    $0xc,%esp
  80180f:	25 07 0e 00 00       	and    $0xe07,%eax
  801814:	50                   	push   %eax
  801815:	56                   	push   %esi
  801816:	6a 00                	push   $0x0
  801818:	52                   	push   %edx
  801819:	6a 00                	push   $0x0
  80181b:	e8 cd f5 ff ff       	call   800ded <sys_page_map>
  801820:	89 c3                	mov    %eax,%ebx
  801822:	83 c4 20             	add    $0x20,%esp
  801825:	85 c0                	test   %eax,%eax
  801827:	78 31                	js     80185a <dup+0xd1>
		goto err;

	return newfdnum;
  801829:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80182c:	89 d8                	mov    %ebx,%eax
  80182e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801831:	5b                   	pop    %ebx
  801832:	5e                   	pop    %esi
  801833:	5f                   	pop    %edi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801836:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80183d:	83 ec 0c             	sub    $0xc,%esp
  801840:	25 07 0e 00 00       	and    $0xe07,%eax
  801845:	50                   	push   %eax
  801846:	57                   	push   %edi
  801847:	6a 00                	push   $0x0
  801849:	53                   	push   %ebx
  80184a:	6a 00                	push   $0x0
  80184c:	e8 9c f5 ff ff       	call   800ded <sys_page_map>
  801851:	89 c3                	mov    %eax,%ebx
  801853:	83 c4 20             	add    $0x20,%esp
  801856:	85 c0                	test   %eax,%eax
  801858:	79 a3                	jns    8017fd <dup+0x74>
	sys_page_unmap(0, newfd);
  80185a:	83 ec 08             	sub    $0x8,%esp
  80185d:	56                   	push   %esi
  80185e:	6a 00                	push   $0x0
  801860:	e8 ca f5 ff ff       	call   800e2f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801865:	83 c4 08             	add    $0x8,%esp
  801868:	57                   	push   %edi
  801869:	6a 00                	push   $0x0
  80186b:	e8 bf f5 ff ff       	call   800e2f <sys_page_unmap>
	return r;
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	eb b7                	jmp    80182c <dup+0xa3>

00801875 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	53                   	push   %ebx
  801879:	83 ec 1c             	sub    $0x1c,%esp
  80187c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801882:	50                   	push   %eax
  801883:	53                   	push   %ebx
  801884:	e8 7c fd ff ff       	call   801605 <fd_lookup>
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 3f                	js     8018cf <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801896:	50                   	push   %eax
  801897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189a:	ff 30                	pushl  (%eax)
  80189c:	e8 b4 fd ff ff       	call   801655 <dev_lookup>
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	78 27                	js     8018cf <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ab:	8b 42 08             	mov    0x8(%edx),%eax
  8018ae:	83 e0 03             	and    $0x3,%eax
  8018b1:	83 f8 01             	cmp    $0x1,%eax
  8018b4:	74 1e                	je     8018d4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b9:	8b 40 08             	mov    0x8(%eax),%eax
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	74 35                	je     8018f5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	ff 75 10             	pushl  0x10(%ebp)
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	52                   	push   %edx
  8018ca:	ff d0                	call   *%eax
  8018cc:	83 c4 10             	add    $0x10,%esp
}
  8018cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018d4:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8018d9:	8b 40 48             	mov    0x48(%eax),%eax
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	53                   	push   %ebx
  8018e0:	50                   	push   %eax
  8018e1:	68 a5 30 80 00       	push   $0x8030a5
  8018e6:	e8 6e e9 ff ff       	call   800259 <cprintf>
		return -E_INVAL;
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f3:	eb da                	jmp    8018cf <read+0x5a>
		return -E_NOT_SUPP;
  8018f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018fa:	eb d3                	jmp    8018cf <read+0x5a>

008018fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	57                   	push   %edi
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
  801902:	83 ec 0c             	sub    $0xc,%esp
  801905:	8b 7d 08             	mov    0x8(%ebp),%edi
  801908:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80190b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801910:	39 f3                	cmp    %esi,%ebx
  801912:	73 23                	jae    801937 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	89 f0                	mov    %esi,%eax
  801919:	29 d8                	sub    %ebx,%eax
  80191b:	50                   	push   %eax
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	03 45 0c             	add    0xc(%ebp),%eax
  801921:	50                   	push   %eax
  801922:	57                   	push   %edi
  801923:	e8 4d ff ff ff       	call   801875 <read>
		if (m < 0)
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 06                	js     801935 <readn+0x39>
			return m;
		if (m == 0)
  80192f:	74 06                	je     801937 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801931:	01 c3                	add    %eax,%ebx
  801933:	eb db                	jmp    801910 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801935:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801937:	89 d8                	mov    %ebx,%eax
  801939:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5f                   	pop    %edi
  80193f:	5d                   	pop    %ebp
  801940:	c3                   	ret    

00801941 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	53                   	push   %ebx
  801945:	83 ec 1c             	sub    $0x1c,%esp
  801948:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80194b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194e:	50                   	push   %eax
  80194f:	53                   	push   %ebx
  801950:	e8 b0 fc ff ff       	call   801605 <fd_lookup>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 3a                	js     801996 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801962:	50                   	push   %eax
  801963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801966:	ff 30                	pushl  (%eax)
  801968:	e8 e8 fc ff ff       	call   801655 <dev_lookup>
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	78 22                	js     801996 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801977:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80197b:	74 1e                	je     80199b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80197d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801980:	8b 52 0c             	mov    0xc(%edx),%edx
  801983:	85 d2                	test   %edx,%edx
  801985:	74 35                	je     8019bc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801987:	83 ec 04             	sub    $0x4,%esp
  80198a:	ff 75 10             	pushl  0x10(%ebp)
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	50                   	push   %eax
  801991:	ff d2                	call   *%edx
  801993:	83 c4 10             	add    $0x10,%esp
}
  801996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801999:	c9                   	leave  
  80199a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80199b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019a0:	8b 40 48             	mov    0x48(%eax),%eax
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	53                   	push   %ebx
  8019a7:	50                   	push   %eax
  8019a8:	68 c1 30 80 00       	push   $0x8030c1
  8019ad:	e8 a7 e8 ff ff       	call   800259 <cprintf>
		return -E_INVAL;
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ba:	eb da                	jmp    801996 <write+0x55>
		return -E_NOT_SUPP;
  8019bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c1:	eb d3                	jmp    801996 <write+0x55>

008019c3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cc:	50                   	push   %eax
  8019cd:	ff 75 08             	pushl  0x8(%ebp)
  8019d0:	e8 30 fc ff ff       	call   801605 <fd_lookup>
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 0e                	js     8019ea <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	53                   	push   %ebx
  8019f0:	83 ec 1c             	sub    $0x1c,%esp
  8019f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f9:	50                   	push   %eax
  8019fa:	53                   	push   %ebx
  8019fb:	e8 05 fc ff ff       	call   801605 <fd_lookup>
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 37                	js     801a3e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a07:	83 ec 08             	sub    $0x8,%esp
  801a0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0d:	50                   	push   %eax
  801a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a11:	ff 30                	pushl  (%eax)
  801a13:	e8 3d fc ff ff       	call   801655 <dev_lookup>
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 1f                	js     801a3e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a22:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a26:	74 1b                	je     801a43 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2b:	8b 52 18             	mov    0x18(%edx),%edx
  801a2e:	85 d2                	test   %edx,%edx
  801a30:	74 32                	je     801a64 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a32:	83 ec 08             	sub    $0x8,%esp
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	50                   	push   %eax
  801a39:	ff d2                	call   *%edx
  801a3b:	83 c4 10             	add    $0x10,%esp
}
  801a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a43:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a48:	8b 40 48             	mov    0x48(%eax),%eax
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	53                   	push   %ebx
  801a4f:	50                   	push   %eax
  801a50:	68 84 30 80 00       	push   $0x803084
  801a55:	e8 ff e7 ff ff       	call   800259 <cprintf>
		return -E_INVAL;
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a62:	eb da                	jmp    801a3e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a69:	eb d3                	jmp    801a3e <ftruncate+0x52>

00801a6b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 1c             	sub    $0x1c,%esp
  801a72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a75:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a78:	50                   	push   %eax
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	e8 84 fb ff ff       	call   801605 <fd_lookup>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 4b                	js     801ad3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a88:	83 ec 08             	sub    $0x8,%esp
  801a8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8e:	50                   	push   %eax
  801a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a92:	ff 30                	pushl  (%eax)
  801a94:	e8 bc fb ff ff       	call   801655 <dev_lookup>
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 33                	js     801ad3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801aa7:	74 2f                	je     801ad8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801aa9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801aac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ab3:	00 00 00 
	stat->st_isdir = 0;
  801ab6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801abd:	00 00 00 
	stat->st_dev = dev;
  801ac0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ac6:	83 ec 08             	sub    $0x8,%esp
  801ac9:	53                   	push   %ebx
  801aca:	ff 75 f0             	pushl  -0x10(%ebp)
  801acd:	ff 50 14             	call   *0x14(%eax)
  801ad0:	83 c4 10             	add    $0x10,%esp
}
  801ad3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    
		return -E_NOT_SUPP;
  801ad8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801add:	eb f4                	jmp    801ad3 <fstat+0x68>

00801adf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	e8 22 02 00 00       	call   801d13 <open>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 1b                	js     801b15 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	50                   	push   %eax
  801b01:	e8 65 ff ff ff       	call   801a6b <fstat>
  801b06:	89 c6                	mov    %eax,%esi
	close(fd);
  801b08:	89 1c 24             	mov    %ebx,(%esp)
  801b0b:	e8 27 fc ff ff       	call   801737 <close>
	return r;
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	89 f3                	mov    %esi,%ebx
}
  801b15:	89 d8                	mov    %ebx,%eax
  801b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1a:	5b                   	pop    %ebx
  801b1b:	5e                   	pop    %esi
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    

00801b1e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	56                   	push   %esi
  801b22:	53                   	push   %ebx
  801b23:	89 c6                	mov    %eax,%esi
  801b25:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b27:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b2e:	74 27                	je     801b57 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b30:	6a 07                	push   $0x7
  801b32:	68 00 60 80 00       	push   $0x806000
  801b37:	56                   	push   %esi
  801b38:	ff 35 00 50 80 00    	pushl  0x805000
  801b3e:	e8 9d 0c 00 00       	call   8027e0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b43:	83 c4 0c             	add    $0xc,%esp
  801b46:	6a 00                	push   $0x0
  801b48:	53                   	push   %ebx
  801b49:	6a 00                	push   $0x0
  801b4b:	e8 27 0c 00 00       	call   802777 <ipc_recv>
}
  801b50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	6a 01                	push   $0x1
  801b5c:	e8 d7 0c 00 00       	call   802838 <ipc_find_env>
  801b61:	a3 00 50 80 00       	mov    %eax,0x805000
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	eb c5                	jmp    801b30 <fsipc+0x12>

00801b6b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8b 40 0c             	mov    0xc(%eax),%eax
  801b77:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7f:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b84:	ba 00 00 00 00       	mov    $0x0,%edx
  801b89:	b8 02 00 00 00       	mov    $0x2,%eax
  801b8e:	e8 8b ff ff ff       	call   801b1e <fsipc>
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <devfile_flush>:
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba1:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ba6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bab:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb0:	e8 69 ff ff ff       	call   801b1e <fsipc>
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <devfile_stat>:
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	53                   	push   %ebx
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc7:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd1:	b8 05 00 00 00       	mov    $0x5,%eax
  801bd6:	e8 43 ff ff ff       	call   801b1e <fsipc>
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	78 2c                	js     801c0b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	68 00 60 80 00       	push   $0x806000
  801be7:	53                   	push   %ebx
  801be8:	e8 cb ed ff ff       	call   8009b8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bed:	a1 80 60 80 00       	mov    0x806080,%eax
  801bf2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bf8:	a1 84 60 80 00       	mov    0x806084,%eax
  801bfd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <devfile_write>:
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	53                   	push   %ebx
  801c14:	83 ec 08             	sub    $0x8,%esp
  801c17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c20:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c25:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c2b:	53                   	push   %ebx
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	68 08 60 80 00       	push   $0x806008
  801c34:	e8 6f ef ff ff       	call   800ba8 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c39:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c43:	e8 d6 fe ff ff       	call   801b1e <fsipc>
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 0b                	js     801c5a <devfile_write+0x4a>
	assert(r <= n);
  801c4f:	39 d8                	cmp    %ebx,%eax
  801c51:	77 0c                	ja     801c5f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c53:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c58:	7f 1e                	jg     801c78 <devfile_write+0x68>
}
  801c5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    
	assert(r <= n);
  801c5f:	68 f4 30 80 00       	push   $0x8030f4
  801c64:	68 fb 30 80 00       	push   $0x8030fb
  801c69:	68 98 00 00 00       	push   $0x98
  801c6e:	68 10 31 80 00       	push   $0x803110
  801c73:	e8 eb e4 ff ff       	call   800163 <_panic>
	assert(r <= PGSIZE);
  801c78:	68 1b 31 80 00       	push   $0x80311b
  801c7d:	68 fb 30 80 00       	push   $0x8030fb
  801c82:	68 99 00 00 00       	push   $0x99
  801c87:	68 10 31 80 00       	push   $0x803110
  801c8c:	e8 d2 e4 ff ff       	call   800163 <_panic>

00801c91 <devfile_read>:
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	56                   	push   %esi
  801c95:	53                   	push   %ebx
  801c96:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ca4:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801caa:	ba 00 00 00 00       	mov    $0x0,%edx
  801caf:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb4:	e8 65 fe ff ff       	call   801b1e <fsipc>
  801cb9:	89 c3                	mov    %eax,%ebx
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	78 1f                	js     801cde <devfile_read+0x4d>
	assert(r <= n);
  801cbf:	39 f0                	cmp    %esi,%eax
  801cc1:	77 24                	ja     801ce7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cc3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cc8:	7f 33                	jg     801cfd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	50                   	push   %eax
  801cce:	68 00 60 80 00       	push   $0x806000
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	e8 6b ee ff ff       	call   800b46 <memmove>
	return r;
  801cdb:	83 c4 10             	add    $0x10,%esp
}
  801cde:	89 d8                	mov    %ebx,%eax
  801ce0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    
	assert(r <= n);
  801ce7:	68 f4 30 80 00       	push   $0x8030f4
  801cec:	68 fb 30 80 00       	push   $0x8030fb
  801cf1:	6a 7c                	push   $0x7c
  801cf3:	68 10 31 80 00       	push   $0x803110
  801cf8:	e8 66 e4 ff ff       	call   800163 <_panic>
	assert(r <= PGSIZE);
  801cfd:	68 1b 31 80 00       	push   $0x80311b
  801d02:	68 fb 30 80 00       	push   $0x8030fb
  801d07:	6a 7d                	push   $0x7d
  801d09:	68 10 31 80 00       	push   $0x803110
  801d0e:	e8 50 e4 ff ff       	call   800163 <_panic>

00801d13 <open>:
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	56                   	push   %esi
  801d17:	53                   	push   %ebx
  801d18:	83 ec 1c             	sub    $0x1c,%esp
  801d1b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d1e:	56                   	push   %esi
  801d1f:	e8 5b ec ff ff       	call   80097f <strlen>
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d2c:	7f 6c                	jg     801d9a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d2e:	83 ec 0c             	sub    $0xc,%esp
  801d31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d34:	50                   	push   %eax
  801d35:	e8 79 f8 ff ff       	call   8015b3 <fd_alloc>
  801d3a:	89 c3                	mov    %eax,%ebx
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	78 3c                	js     801d7f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d43:	83 ec 08             	sub    $0x8,%esp
  801d46:	56                   	push   %esi
  801d47:	68 00 60 80 00       	push   $0x806000
  801d4c:	e8 67 ec ff ff       	call   8009b8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d61:	e8 b8 fd ff ff       	call   801b1e <fsipc>
  801d66:	89 c3                	mov    %eax,%ebx
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	78 19                	js     801d88 <open+0x75>
	return fd2num(fd);
  801d6f:	83 ec 0c             	sub    $0xc,%esp
  801d72:	ff 75 f4             	pushl  -0xc(%ebp)
  801d75:	e8 12 f8 ff ff       	call   80158c <fd2num>
  801d7a:	89 c3                	mov    %eax,%ebx
  801d7c:	83 c4 10             	add    $0x10,%esp
}
  801d7f:	89 d8                	mov    %ebx,%eax
  801d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
		fd_close(fd, 0);
  801d88:	83 ec 08             	sub    $0x8,%esp
  801d8b:	6a 00                	push   $0x0
  801d8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d90:	e8 1b f9 ff ff       	call   8016b0 <fd_close>
		return r;
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	eb e5                	jmp    801d7f <open+0x6c>
		return -E_BAD_PATH;
  801d9a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d9f:	eb de                	jmp    801d7f <open+0x6c>

00801da1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801da7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dac:	b8 08 00 00 00       	mov    $0x8,%eax
  801db1:	e8 68 fd ff ff       	call   801b1e <fsipc>
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dbe:	68 27 31 80 00       	push   $0x803127
  801dc3:	ff 75 0c             	pushl  0xc(%ebp)
  801dc6:	e8 ed eb ff ff       	call   8009b8 <strcpy>
	return 0;
}
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <devsock_close>:
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	53                   	push   %ebx
  801dd6:	83 ec 10             	sub    $0x10,%esp
  801dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ddc:	53                   	push   %ebx
  801ddd:	e8 95 0a 00 00       	call   802877 <pageref>
  801de2:	83 c4 10             	add    $0x10,%esp
		return 0;
  801de5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801dea:	83 f8 01             	cmp    $0x1,%eax
  801ded:	74 07                	je     801df6 <devsock_close+0x24>
}
  801def:	89 d0                	mov    %edx,%eax
  801df1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801df6:	83 ec 0c             	sub    $0xc,%esp
  801df9:	ff 73 0c             	pushl  0xc(%ebx)
  801dfc:	e8 b9 02 00 00       	call   8020ba <nsipc_close>
  801e01:	89 c2                	mov    %eax,%edx
  801e03:	83 c4 10             	add    $0x10,%esp
  801e06:	eb e7                	jmp    801def <devsock_close+0x1d>

00801e08 <devsock_write>:
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	ff 75 10             	pushl  0x10(%ebp)
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	ff 70 0c             	pushl  0xc(%eax)
  801e1c:	e8 76 03 00 00       	call   802197 <nsipc_send>
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <devsock_read>:
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	ff 75 10             	pushl  0x10(%ebp)
  801e2e:	ff 75 0c             	pushl  0xc(%ebp)
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	ff 70 0c             	pushl  0xc(%eax)
  801e37:	e8 ef 02 00 00       	call   80212b <nsipc_recv>
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <fd2sockid>:
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e44:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e47:	52                   	push   %edx
  801e48:	50                   	push   %eax
  801e49:	e8 b7 f7 ff ff       	call   801605 <fd_lookup>
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	85 c0                	test   %eax,%eax
  801e53:	78 10                	js     801e65 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e5e:	39 08                	cmp    %ecx,(%eax)
  801e60:	75 05                	jne    801e67 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e62:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    
		return -E_NOT_SUPP;
  801e67:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e6c:	eb f7                	jmp    801e65 <fd2sockid+0x27>

00801e6e <alloc_sockfd>:
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	56                   	push   %esi
  801e72:	53                   	push   %ebx
  801e73:	83 ec 1c             	sub    $0x1c,%esp
  801e76:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e7b:	50                   	push   %eax
  801e7c:	e8 32 f7 ff ff       	call   8015b3 <fd_alloc>
  801e81:	89 c3                	mov    %eax,%ebx
  801e83:	83 c4 10             	add    $0x10,%esp
  801e86:	85 c0                	test   %eax,%eax
  801e88:	78 43                	js     801ecd <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e8a:	83 ec 04             	sub    $0x4,%esp
  801e8d:	68 07 04 00 00       	push   $0x407
  801e92:	ff 75 f4             	pushl  -0xc(%ebp)
  801e95:	6a 00                	push   $0x0
  801e97:	e8 0e ef ff ff       	call   800daa <sys_page_alloc>
  801e9c:	89 c3                	mov    %eax,%ebx
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 28                	js     801ecd <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea8:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801eae:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801eba:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ebd:	83 ec 0c             	sub    $0xc,%esp
  801ec0:	50                   	push   %eax
  801ec1:	e8 c6 f6 ff ff       	call   80158c <fd2num>
  801ec6:	89 c3                	mov    %eax,%ebx
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	eb 0c                	jmp    801ed9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ecd:	83 ec 0c             	sub    $0xc,%esp
  801ed0:	56                   	push   %esi
  801ed1:	e8 e4 01 00 00       	call   8020ba <nsipc_close>
		return r;
  801ed6:	83 c4 10             	add    $0x10,%esp
}
  801ed9:	89 d8                	mov    %ebx,%eax
  801edb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ede:	5b                   	pop    %ebx
  801edf:	5e                   	pop    %esi
  801ee0:	5d                   	pop    %ebp
  801ee1:	c3                   	ret    

00801ee2 <accept>:
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	e8 4e ff ff ff       	call   801e3e <fd2sockid>
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	78 1b                	js     801f0f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	ff 75 10             	pushl  0x10(%ebp)
  801efa:	ff 75 0c             	pushl  0xc(%ebp)
  801efd:	50                   	push   %eax
  801efe:	e8 0e 01 00 00       	call   802011 <nsipc_accept>
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	85 c0                	test   %eax,%eax
  801f08:	78 05                	js     801f0f <accept+0x2d>
	return alloc_sockfd(r);
  801f0a:	e8 5f ff ff ff       	call   801e6e <alloc_sockfd>
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <bind>:
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	e8 1f ff ff ff       	call   801e3e <fd2sockid>
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	78 12                	js     801f35 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f23:	83 ec 04             	sub    $0x4,%esp
  801f26:	ff 75 10             	pushl  0x10(%ebp)
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	50                   	push   %eax
  801f2d:	e8 31 01 00 00       	call   802063 <nsipc_bind>
  801f32:	83 c4 10             	add    $0x10,%esp
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <shutdown>:
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	e8 f9 fe ff ff       	call   801e3e <fd2sockid>
  801f45:	85 c0                	test   %eax,%eax
  801f47:	78 0f                	js     801f58 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f49:	83 ec 08             	sub    $0x8,%esp
  801f4c:	ff 75 0c             	pushl  0xc(%ebp)
  801f4f:	50                   	push   %eax
  801f50:	e8 43 01 00 00       	call   802098 <nsipc_shutdown>
  801f55:	83 c4 10             	add    $0x10,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <connect>:
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	e8 d6 fe ff ff       	call   801e3e <fd2sockid>
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 12                	js     801f7e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f6c:	83 ec 04             	sub    $0x4,%esp
  801f6f:	ff 75 10             	pushl  0x10(%ebp)
  801f72:	ff 75 0c             	pushl  0xc(%ebp)
  801f75:	50                   	push   %eax
  801f76:	e8 59 01 00 00       	call   8020d4 <nsipc_connect>
  801f7b:	83 c4 10             	add    $0x10,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <listen>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	e8 b0 fe ff ff       	call   801e3e <fd2sockid>
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 0f                	js     801fa1 <listen+0x21>
	return nsipc_listen(r, backlog);
  801f92:	83 ec 08             	sub    $0x8,%esp
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	50                   	push   %eax
  801f99:	e8 6b 01 00 00       	call   802109 <nsipc_listen>
  801f9e:	83 c4 10             	add    $0x10,%esp
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <socket>:

int
socket(int domain, int type, int protocol)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fa9:	ff 75 10             	pushl  0x10(%ebp)
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	ff 75 08             	pushl  0x8(%ebp)
  801fb2:	e8 3e 02 00 00       	call   8021f5 <nsipc_socket>
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 05                	js     801fc3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fbe:	e8 ab fe ff ff       	call   801e6e <alloc_sockfd>
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	53                   	push   %ebx
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fce:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fd5:	74 26                	je     801ffd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fd7:	6a 07                	push   $0x7
  801fd9:	68 00 70 80 00       	push   $0x807000
  801fde:	53                   	push   %ebx
  801fdf:	ff 35 04 50 80 00    	pushl  0x805004
  801fe5:	e8 f6 07 00 00       	call   8027e0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fea:	83 c4 0c             	add    $0xc,%esp
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	e8 7f 07 00 00       	call   802777 <ipc_recv>
}
  801ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	6a 02                	push   $0x2
  802002:	e8 31 08 00 00       	call   802838 <ipc_find_env>
  802007:	a3 04 50 80 00       	mov    %eax,0x805004
  80200c:	83 c4 10             	add    $0x10,%esp
  80200f:	eb c6                	jmp    801fd7 <nsipc+0x12>

00802011 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	56                   	push   %esi
  802015:	53                   	push   %ebx
  802016:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802021:	8b 06                	mov    (%esi),%eax
  802023:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802028:	b8 01 00 00 00       	mov    $0x1,%eax
  80202d:	e8 93 ff ff ff       	call   801fc5 <nsipc>
  802032:	89 c3                	mov    %eax,%ebx
  802034:	85 c0                	test   %eax,%eax
  802036:	79 09                	jns    802041 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802038:	89 d8                	mov    %ebx,%eax
  80203a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203d:	5b                   	pop    %ebx
  80203e:	5e                   	pop    %esi
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	ff 35 10 70 80 00    	pushl  0x807010
  80204a:	68 00 70 80 00       	push   $0x807000
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	e8 ef ea ff ff       	call   800b46 <memmove>
		*addrlen = ret->ret_addrlen;
  802057:	a1 10 70 80 00       	mov    0x807010,%eax
  80205c:	89 06                	mov    %eax,(%esi)
  80205e:	83 c4 10             	add    $0x10,%esp
	return r;
  802061:	eb d5                	jmp    802038 <nsipc_accept+0x27>

00802063 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	53                   	push   %ebx
  802067:	83 ec 08             	sub    $0x8,%esp
  80206a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802075:	53                   	push   %ebx
  802076:	ff 75 0c             	pushl  0xc(%ebp)
  802079:	68 04 70 80 00       	push   $0x807004
  80207e:	e8 c3 ea ff ff       	call   800b46 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802083:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802089:	b8 02 00 00 00       	mov    $0x2,%eax
  80208e:	e8 32 ff ff ff       	call   801fc5 <nsipc>
}
  802093:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020ae:	b8 03 00 00 00       	mov    $0x3,%eax
  8020b3:	e8 0d ff ff ff       	call   801fc5 <nsipc>
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <nsipc_close>:

int
nsipc_close(int s)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020c8:	b8 04 00 00 00       	mov    $0x4,%eax
  8020cd:	e8 f3 fe ff ff       	call   801fc5 <nsipc>
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	53                   	push   %ebx
  8020d8:	83 ec 08             	sub    $0x8,%esp
  8020db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020e6:	53                   	push   %ebx
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	68 04 70 80 00       	push   $0x807004
  8020ef:	e8 52 ea ff ff       	call   800b46 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020f4:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020fa:	b8 05 00 00 00       	mov    $0x5,%eax
  8020ff:	e8 c1 fe ff ff       	call   801fc5 <nsipc>
}
  802104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80211f:	b8 06 00 00 00       	mov    $0x6,%eax
  802124:	e8 9c fe ff ff       	call   801fc5 <nsipc>
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80213b:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802141:	8b 45 14             	mov    0x14(%ebp),%eax
  802144:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802149:	b8 07 00 00 00       	mov    $0x7,%eax
  80214e:	e8 72 fe ff ff       	call   801fc5 <nsipc>
  802153:	89 c3                	mov    %eax,%ebx
  802155:	85 c0                	test   %eax,%eax
  802157:	78 1f                	js     802178 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802159:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80215e:	7f 21                	jg     802181 <nsipc_recv+0x56>
  802160:	39 c6                	cmp    %eax,%esi
  802162:	7c 1d                	jl     802181 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802164:	83 ec 04             	sub    $0x4,%esp
  802167:	50                   	push   %eax
  802168:	68 00 70 80 00       	push   $0x807000
  80216d:	ff 75 0c             	pushl  0xc(%ebp)
  802170:	e8 d1 e9 ff ff       	call   800b46 <memmove>
  802175:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802178:	89 d8                	mov    %ebx,%eax
  80217a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802181:	68 33 31 80 00       	push   $0x803133
  802186:	68 fb 30 80 00       	push   $0x8030fb
  80218b:	6a 62                	push   $0x62
  80218d:	68 48 31 80 00       	push   $0x803148
  802192:	e8 cc df ff ff       	call   800163 <_panic>

00802197 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	53                   	push   %ebx
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021a9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021af:	7f 2e                	jg     8021df <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	53                   	push   %ebx
  8021b5:	ff 75 0c             	pushl  0xc(%ebp)
  8021b8:	68 0c 70 80 00       	push   $0x80700c
  8021bd:	e8 84 e9 ff ff       	call   800b46 <memmove>
	nsipcbuf.send.req_size = size;
  8021c2:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021cb:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021d0:	b8 08 00 00 00       	mov    $0x8,%eax
  8021d5:	e8 eb fd ff ff       	call   801fc5 <nsipc>
}
  8021da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    
	assert(size < 1600);
  8021df:	68 54 31 80 00       	push   $0x803154
  8021e4:	68 fb 30 80 00       	push   $0x8030fb
  8021e9:	6a 6d                	push   $0x6d
  8021eb:	68 48 31 80 00       	push   $0x803148
  8021f0:	e8 6e df ff ff       	call   800163 <_panic>

008021f5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802203:	8b 45 0c             	mov    0xc(%ebp),%eax
  802206:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80220b:	8b 45 10             	mov    0x10(%ebp),%eax
  80220e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802213:	b8 09 00 00 00       	mov    $0x9,%eax
  802218:	e8 a8 fd ff ff       	call   801fc5 <nsipc>
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802227:	83 ec 0c             	sub    $0xc,%esp
  80222a:	ff 75 08             	pushl  0x8(%ebp)
  80222d:	e8 6a f3 ff ff       	call   80159c <fd2data>
  802232:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802234:	83 c4 08             	add    $0x8,%esp
  802237:	68 60 31 80 00       	push   $0x803160
  80223c:	53                   	push   %ebx
  80223d:	e8 76 e7 ff ff       	call   8009b8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802242:	8b 46 04             	mov    0x4(%esi),%eax
  802245:	2b 06                	sub    (%esi),%eax
  802247:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80224d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802254:	00 00 00 
	stat->st_dev = &devpipe;
  802257:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80225e:	40 80 00 
	return 0;
}
  802261:	b8 00 00 00 00       	mov    $0x0,%eax
  802266:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802269:	5b                   	pop    %ebx
  80226a:	5e                   	pop    %esi
  80226b:	5d                   	pop    %ebp
  80226c:	c3                   	ret    

0080226d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	53                   	push   %ebx
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802277:	53                   	push   %ebx
  802278:	6a 00                	push   $0x0
  80227a:	e8 b0 eb ff ff       	call   800e2f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80227f:	89 1c 24             	mov    %ebx,(%esp)
  802282:	e8 15 f3 ff ff       	call   80159c <fd2data>
  802287:	83 c4 08             	add    $0x8,%esp
  80228a:	50                   	push   %eax
  80228b:	6a 00                	push   $0x0
  80228d:	e8 9d eb ff ff       	call   800e2f <sys_page_unmap>
}
  802292:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <_pipeisclosed>:
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	57                   	push   %edi
  80229b:	56                   	push   %esi
  80229c:	53                   	push   %ebx
  80229d:	83 ec 1c             	sub    $0x1c,%esp
  8022a0:	89 c7                	mov    %eax,%edi
  8022a2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022a4:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8022a9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022ac:	83 ec 0c             	sub    $0xc,%esp
  8022af:	57                   	push   %edi
  8022b0:	e8 c2 05 00 00       	call   802877 <pageref>
  8022b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022b8:	89 34 24             	mov    %esi,(%esp)
  8022bb:	e8 b7 05 00 00       	call   802877 <pageref>
		nn = thisenv->env_runs;
  8022c0:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8022c6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022c9:	83 c4 10             	add    $0x10,%esp
  8022cc:	39 cb                	cmp    %ecx,%ebx
  8022ce:	74 1b                	je     8022eb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022d0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022d3:	75 cf                	jne    8022a4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022d5:	8b 42 58             	mov    0x58(%edx),%eax
  8022d8:	6a 01                	push   $0x1
  8022da:	50                   	push   %eax
  8022db:	53                   	push   %ebx
  8022dc:	68 67 31 80 00       	push   $0x803167
  8022e1:	e8 73 df ff ff       	call   800259 <cprintf>
  8022e6:	83 c4 10             	add    $0x10,%esp
  8022e9:	eb b9                	jmp    8022a4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022eb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022ee:	0f 94 c0             	sete   %al
  8022f1:	0f b6 c0             	movzbl %al,%eax
}
  8022f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5f                   	pop    %edi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    

008022fc <devpipe_write>:
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	57                   	push   %edi
  802300:	56                   	push   %esi
  802301:	53                   	push   %ebx
  802302:	83 ec 28             	sub    $0x28,%esp
  802305:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802308:	56                   	push   %esi
  802309:	e8 8e f2 ff ff       	call   80159c <fd2data>
  80230e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	bf 00 00 00 00       	mov    $0x0,%edi
  802318:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80231b:	74 4f                	je     80236c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80231d:	8b 43 04             	mov    0x4(%ebx),%eax
  802320:	8b 0b                	mov    (%ebx),%ecx
  802322:	8d 51 20             	lea    0x20(%ecx),%edx
  802325:	39 d0                	cmp    %edx,%eax
  802327:	72 14                	jb     80233d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802329:	89 da                	mov    %ebx,%edx
  80232b:	89 f0                	mov    %esi,%eax
  80232d:	e8 65 ff ff ff       	call   802297 <_pipeisclosed>
  802332:	85 c0                	test   %eax,%eax
  802334:	75 3b                	jne    802371 <devpipe_write+0x75>
			sys_yield();
  802336:	e8 50 ea ff ff       	call   800d8b <sys_yield>
  80233b:	eb e0                	jmp    80231d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80233d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802340:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802344:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802347:	89 c2                	mov    %eax,%edx
  802349:	c1 fa 1f             	sar    $0x1f,%edx
  80234c:	89 d1                	mov    %edx,%ecx
  80234e:	c1 e9 1b             	shr    $0x1b,%ecx
  802351:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802354:	83 e2 1f             	and    $0x1f,%edx
  802357:	29 ca                	sub    %ecx,%edx
  802359:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80235d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802361:	83 c0 01             	add    $0x1,%eax
  802364:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802367:	83 c7 01             	add    $0x1,%edi
  80236a:	eb ac                	jmp    802318 <devpipe_write+0x1c>
	return i;
  80236c:	8b 45 10             	mov    0x10(%ebp),%eax
  80236f:	eb 05                	jmp    802376 <devpipe_write+0x7a>
				return 0;
  802371:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802376:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802379:	5b                   	pop    %ebx
  80237a:	5e                   	pop    %esi
  80237b:	5f                   	pop    %edi
  80237c:	5d                   	pop    %ebp
  80237d:	c3                   	ret    

0080237e <devpipe_read>:
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	57                   	push   %edi
  802382:	56                   	push   %esi
  802383:	53                   	push   %ebx
  802384:	83 ec 18             	sub    $0x18,%esp
  802387:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80238a:	57                   	push   %edi
  80238b:	e8 0c f2 ff ff       	call   80159c <fd2data>
  802390:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802392:	83 c4 10             	add    $0x10,%esp
  802395:	be 00 00 00 00       	mov    $0x0,%esi
  80239a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80239d:	75 14                	jne    8023b3 <devpipe_read+0x35>
	return i;
  80239f:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a2:	eb 02                	jmp    8023a6 <devpipe_read+0x28>
				return i;
  8023a4:	89 f0                	mov    %esi,%eax
}
  8023a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a9:	5b                   	pop    %ebx
  8023aa:	5e                   	pop    %esi
  8023ab:	5f                   	pop    %edi
  8023ac:	5d                   	pop    %ebp
  8023ad:	c3                   	ret    
			sys_yield();
  8023ae:	e8 d8 e9 ff ff       	call   800d8b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023b3:	8b 03                	mov    (%ebx),%eax
  8023b5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023b8:	75 18                	jne    8023d2 <devpipe_read+0x54>
			if (i > 0)
  8023ba:	85 f6                	test   %esi,%esi
  8023bc:	75 e6                	jne    8023a4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023be:	89 da                	mov    %ebx,%edx
  8023c0:	89 f8                	mov    %edi,%eax
  8023c2:	e8 d0 fe ff ff       	call   802297 <_pipeisclosed>
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	74 e3                	je     8023ae <devpipe_read+0x30>
				return 0;
  8023cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d0:	eb d4                	jmp    8023a6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023d2:	99                   	cltd   
  8023d3:	c1 ea 1b             	shr    $0x1b,%edx
  8023d6:	01 d0                	add    %edx,%eax
  8023d8:	83 e0 1f             	and    $0x1f,%eax
  8023db:	29 d0                	sub    %edx,%eax
  8023dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023e8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023eb:	83 c6 01             	add    $0x1,%esi
  8023ee:	eb aa                	jmp    80239a <devpipe_read+0x1c>

008023f0 <pipe>:
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	56                   	push   %esi
  8023f4:	53                   	push   %ebx
  8023f5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023fb:	50                   	push   %eax
  8023fc:	e8 b2 f1 ff ff       	call   8015b3 <fd_alloc>
  802401:	89 c3                	mov    %eax,%ebx
  802403:	83 c4 10             	add    $0x10,%esp
  802406:	85 c0                	test   %eax,%eax
  802408:	0f 88 23 01 00 00    	js     802531 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240e:	83 ec 04             	sub    $0x4,%esp
  802411:	68 07 04 00 00       	push   $0x407
  802416:	ff 75 f4             	pushl  -0xc(%ebp)
  802419:	6a 00                	push   $0x0
  80241b:	e8 8a e9 ff ff       	call   800daa <sys_page_alloc>
  802420:	89 c3                	mov    %eax,%ebx
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	85 c0                	test   %eax,%eax
  802427:	0f 88 04 01 00 00    	js     802531 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80242d:	83 ec 0c             	sub    $0xc,%esp
  802430:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802433:	50                   	push   %eax
  802434:	e8 7a f1 ff ff       	call   8015b3 <fd_alloc>
  802439:	89 c3                	mov    %eax,%ebx
  80243b:	83 c4 10             	add    $0x10,%esp
  80243e:	85 c0                	test   %eax,%eax
  802440:	0f 88 db 00 00 00    	js     802521 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802446:	83 ec 04             	sub    $0x4,%esp
  802449:	68 07 04 00 00       	push   $0x407
  80244e:	ff 75 f0             	pushl  -0x10(%ebp)
  802451:	6a 00                	push   $0x0
  802453:	e8 52 e9 ff ff       	call   800daa <sys_page_alloc>
  802458:	89 c3                	mov    %eax,%ebx
  80245a:	83 c4 10             	add    $0x10,%esp
  80245d:	85 c0                	test   %eax,%eax
  80245f:	0f 88 bc 00 00 00    	js     802521 <pipe+0x131>
	va = fd2data(fd0);
  802465:	83 ec 0c             	sub    $0xc,%esp
  802468:	ff 75 f4             	pushl  -0xc(%ebp)
  80246b:	e8 2c f1 ff ff       	call   80159c <fd2data>
  802470:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802472:	83 c4 0c             	add    $0xc,%esp
  802475:	68 07 04 00 00       	push   $0x407
  80247a:	50                   	push   %eax
  80247b:	6a 00                	push   $0x0
  80247d:	e8 28 e9 ff ff       	call   800daa <sys_page_alloc>
  802482:	89 c3                	mov    %eax,%ebx
  802484:	83 c4 10             	add    $0x10,%esp
  802487:	85 c0                	test   %eax,%eax
  802489:	0f 88 82 00 00 00    	js     802511 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248f:	83 ec 0c             	sub    $0xc,%esp
  802492:	ff 75 f0             	pushl  -0x10(%ebp)
  802495:	e8 02 f1 ff ff       	call   80159c <fd2data>
  80249a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024a1:	50                   	push   %eax
  8024a2:	6a 00                	push   $0x0
  8024a4:	56                   	push   %esi
  8024a5:	6a 00                	push   $0x0
  8024a7:	e8 41 e9 ff ff       	call   800ded <sys_page_map>
  8024ac:	89 c3                	mov    %eax,%ebx
  8024ae:	83 c4 20             	add    $0x20,%esp
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	78 4e                	js     802503 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024b5:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024cc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024d8:	83 ec 0c             	sub    $0xc,%esp
  8024db:	ff 75 f4             	pushl  -0xc(%ebp)
  8024de:	e8 a9 f0 ff ff       	call   80158c <fd2num>
  8024e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024e6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024e8:	83 c4 04             	add    $0x4,%esp
  8024eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ee:	e8 99 f0 ff ff       	call   80158c <fd2num>
  8024f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024f6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024f9:	83 c4 10             	add    $0x10,%esp
  8024fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  802501:	eb 2e                	jmp    802531 <pipe+0x141>
	sys_page_unmap(0, va);
  802503:	83 ec 08             	sub    $0x8,%esp
  802506:	56                   	push   %esi
  802507:	6a 00                	push   $0x0
  802509:	e8 21 e9 ff ff       	call   800e2f <sys_page_unmap>
  80250e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802511:	83 ec 08             	sub    $0x8,%esp
  802514:	ff 75 f0             	pushl  -0x10(%ebp)
  802517:	6a 00                	push   $0x0
  802519:	e8 11 e9 ff ff       	call   800e2f <sys_page_unmap>
  80251e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802521:	83 ec 08             	sub    $0x8,%esp
  802524:	ff 75 f4             	pushl  -0xc(%ebp)
  802527:	6a 00                	push   $0x0
  802529:	e8 01 e9 ff ff       	call   800e2f <sys_page_unmap>
  80252e:	83 c4 10             	add    $0x10,%esp
}
  802531:	89 d8                	mov    %ebx,%eax
  802533:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802536:	5b                   	pop    %ebx
  802537:	5e                   	pop    %esi
  802538:	5d                   	pop    %ebp
  802539:	c3                   	ret    

0080253a <pipeisclosed>:
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802540:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802543:	50                   	push   %eax
  802544:	ff 75 08             	pushl  0x8(%ebp)
  802547:	e8 b9 f0 ff ff       	call   801605 <fd_lookup>
  80254c:	83 c4 10             	add    $0x10,%esp
  80254f:	85 c0                	test   %eax,%eax
  802551:	78 18                	js     80256b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802553:	83 ec 0c             	sub    $0xc,%esp
  802556:	ff 75 f4             	pushl  -0xc(%ebp)
  802559:	e8 3e f0 ff ff       	call   80159c <fd2data>
	return _pipeisclosed(fd, p);
  80255e:	89 c2                	mov    %eax,%edx
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	e8 2f fd ff ff       	call   802297 <_pipeisclosed>
  802568:	83 c4 10             	add    $0x10,%esp
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
  802572:	c3                   	ret    

00802573 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802579:	68 7f 31 80 00       	push   $0x80317f
  80257e:	ff 75 0c             	pushl  0xc(%ebp)
  802581:	e8 32 e4 ff ff       	call   8009b8 <strcpy>
	return 0;
}
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <devcons_write>:
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	57                   	push   %edi
  802591:	56                   	push   %esi
  802592:	53                   	push   %ebx
  802593:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802599:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80259e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025a4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025a7:	73 31                	jae    8025da <devcons_write+0x4d>
		m = n - tot;
  8025a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025ac:	29 f3                	sub    %esi,%ebx
  8025ae:	83 fb 7f             	cmp    $0x7f,%ebx
  8025b1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025b6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	53                   	push   %ebx
  8025bd:	89 f0                	mov    %esi,%eax
  8025bf:	03 45 0c             	add    0xc(%ebp),%eax
  8025c2:	50                   	push   %eax
  8025c3:	57                   	push   %edi
  8025c4:	e8 7d e5 ff ff       	call   800b46 <memmove>
		sys_cputs(buf, m);
  8025c9:	83 c4 08             	add    $0x8,%esp
  8025cc:	53                   	push   %ebx
  8025cd:	57                   	push   %edi
  8025ce:	e8 1b e7 ff ff       	call   800cee <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025d3:	01 de                	add    %ebx,%esi
  8025d5:	83 c4 10             	add    $0x10,%esp
  8025d8:	eb ca                	jmp    8025a4 <devcons_write+0x17>
}
  8025da:	89 f0                	mov    %esi,%eax
  8025dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025df:	5b                   	pop    %ebx
  8025e0:	5e                   	pop    %esi
  8025e1:	5f                   	pop    %edi
  8025e2:	5d                   	pop    %ebp
  8025e3:	c3                   	ret    

008025e4 <devcons_read>:
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 08             	sub    $0x8,%esp
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8025ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025f3:	74 21                	je     802616 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8025f5:	e8 12 e7 ff ff       	call   800d0c <sys_cgetc>
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	75 07                	jne    802605 <devcons_read+0x21>
		sys_yield();
  8025fe:	e8 88 e7 ff ff       	call   800d8b <sys_yield>
  802603:	eb f0                	jmp    8025f5 <devcons_read+0x11>
	if (c < 0)
  802605:	78 0f                	js     802616 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802607:	83 f8 04             	cmp    $0x4,%eax
  80260a:	74 0c                	je     802618 <devcons_read+0x34>
	*(char*)vbuf = c;
  80260c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260f:	88 02                	mov    %al,(%edx)
	return 1;
  802611:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802616:	c9                   	leave  
  802617:	c3                   	ret    
		return 0;
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	eb f7                	jmp    802616 <devcons_read+0x32>

0080261f <cputchar>:
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802625:	8b 45 08             	mov    0x8(%ebp),%eax
  802628:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80262b:	6a 01                	push   $0x1
  80262d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802630:	50                   	push   %eax
  802631:	e8 b8 e6 ff ff       	call   800cee <sys_cputs>
}
  802636:	83 c4 10             	add    $0x10,%esp
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <getchar>:
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802641:	6a 01                	push   $0x1
  802643:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802646:	50                   	push   %eax
  802647:	6a 00                	push   $0x0
  802649:	e8 27 f2 ff ff       	call   801875 <read>
	if (r < 0)
  80264e:	83 c4 10             	add    $0x10,%esp
  802651:	85 c0                	test   %eax,%eax
  802653:	78 06                	js     80265b <getchar+0x20>
	if (r < 1)
  802655:	74 06                	je     80265d <getchar+0x22>
	return c;
  802657:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    
		return -E_EOF;
  80265d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802662:	eb f7                	jmp    80265b <getchar+0x20>

00802664 <iscons>:
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80266a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80266d:	50                   	push   %eax
  80266e:	ff 75 08             	pushl  0x8(%ebp)
  802671:	e8 8f ef ff ff       	call   801605 <fd_lookup>
  802676:	83 c4 10             	add    $0x10,%esp
  802679:	85 c0                	test   %eax,%eax
  80267b:	78 11                	js     80268e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802686:	39 10                	cmp    %edx,(%eax)
  802688:	0f 94 c0             	sete   %al
  80268b:	0f b6 c0             	movzbl %al,%eax
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <opencons>:
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802699:	50                   	push   %eax
  80269a:	e8 14 ef ff ff       	call   8015b3 <fd_alloc>
  80269f:	83 c4 10             	add    $0x10,%esp
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	78 3a                	js     8026e0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	68 07 04 00 00       	push   $0x407
  8026ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b1:	6a 00                	push   $0x0
  8026b3:	e8 f2 e6 ff ff       	call   800daa <sys_page_alloc>
  8026b8:	83 c4 10             	add    $0x10,%esp
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	78 21                	js     8026e0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026c8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026d4:	83 ec 0c             	sub    $0xc,%esp
  8026d7:	50                   	push   %eax
  8026d8:	e8 af ee ff ff       	call   80158c <fd2num>
  8026dd:	83 c4 10             	add    $0x10,%esp
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026e8:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026ef:	74 0a                	je     8026fb <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8026fb:	83 ec 04             	sub    $0x4,%esp
  8026fe:	6a 07                	push   $0x7
  802700:	68 00 f0 bf ee       	push   $0xeebff000
  802705:	6a 00                	push   $0x0
  802707:	e8 9e e6 ff ff       	call   800daa <sys_page_alloc>
		if(r < 0)
  80270c:	83 c4 10             	add    $0x10,%esp
  80270f:	85 c0                	test   %eax,%eax
  802711:	78 2a                	js     80273d <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802713:	83 ec 08             	sub    $0x8,%esp
  802716:	68 51 27 80 00       	push   $0x802751
  80271b:	6a 00                	push   $0x0
  80271d:	e8 d3 e7 ff ff       	call   800ef5 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802722:	83 c4 10             	add    $0x10,%esp
  802725:	85 c0                	test   %eax,%eax
  802727:	79 c8                	jns    8026f1 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802729:	83 ec 04             	sub    $0x4,%esp
  80272c:	68 bc 31 80 00       	push   $0x8031bc
  802731:	6a 25                	push   $0x25
  802733:	68 f8 31 80 00       	push   $0x8031f8
  802738:	e8 26 da ff ff       	call   800163 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80273d:	83 ec 04             	sub    $0x4,%esp
  802740:	68 8c 31 80 00       	push   $0x80318c
  802745:	6a 22                	push   $0x22
  802747:	68 f8 31 80 00       	push   $0x8031f8
  80274c:	e8 12 da ff ff       	call   800163 <_panic>

00802751 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802751:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802752:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802757:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802759:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80275c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802760:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802764:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802767:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802769:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80276d:	83 c4 08             	add    $0x8,%esp
	popal
  802770:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802771:	83 c4 04             	add    $0x4,%esp
	popfl
  802774:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802775:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802776:	c3                   	ret    

00802777 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	56                   	push   %esi
  80277b:	53                   	push   %ebx
  80277c:	8b 75 08             	mov    0x8(%ebp),%esi
  80277f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802782:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802785:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802787:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80278c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	50                   	push   %eax
  802793:	e8 c2 e7 ff ff       	call   800f5a <sys_ipc_recv>
	if(ret < 0){
  802798:	83 c4 10             	add    $0x10,%esp
  80279b:	85 c0                	test   %eax,%eax
  80279d:	78 2b                	js     8027ca <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80279f:	85 f6                	test   %esi,%esi
  8027a1:	74 0a                	je     8027ad <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8027a3:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027a8:	8b 40 78             	mov    0x78(%eax),%eax
  8027ab:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027ad:	85 db                	test   %ebx,%ebx
  8027af:	74 0a                	je     8027bb <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8027b1:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027b6:	8b 40 7c             	mov    0x7c(%eax),%eax
  8027b9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8027bb:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027c0:	8b 40 74             	mov    0x74(%eax),%eax
}
  8027c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027c6:	5b                   	pop    %ebx
  8027c7:	5e                   	pop    %esi
  8027c8:	5d                   	pop    %ebp
  8027c9:	c3                   	ret    
		if(from_env_store)
  8027ca:	85 f6                	test   %esi,%esi
  8027cc:	74 06                	je     8027d4 <ipc_recv+0x5d>
			*from_env_store = 0;
  8027ce:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027d4:	85 db                	test   %ebx,%ebx
  8027d6:	74 eb                	je     8027c3 <ipc_recv+0x4c>
			*perm_store = 0;
  8027d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027de:	eb e3                	jmp    8027c3 <ipc_recv+0x4c>

008027e0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	57                   	push   %edi
  8027e4:	56                   	push   %esi
  8027e5:	53                   	push   %ebx
  8027e6:	83 ec 0c             	sub    $0xc,%esp
  8027e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8027f2:	85 db                	test   %ebx,%ebx
  8027f4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027f9:	0f 44 d8             	cmove  %eax,%ebx
  8027fc:	eb 05                	jmp    802803 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8027fe:	e8 88 e5 ff ff       	call   800d8b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802803:	ff 75 14             	pushl  0x14(%ebp)
  802806:	53                   	push   %ebx
  802807:	56                   	push   %esi
  802808:	57                   	push   %edi
  802809:	e8 29 e7 ff ff       	call   800f37 <sys_ipc_try_send>
  80280e:	83 c4 10             	add    $0x10,%esp
  802811:	85 c0                	test   %eax,%eax
  802813:	74 1b                	je     802830 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802815:	79 e7                	jns    8027fe <ipc_send+0x1e>
  802817:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80281a:	74 e2                	je     8027fe <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80281c:	83 ec 04             	sub    $0x4,%esp
  80281f:	68 06 32 80 00       	push   $0x803206
  802824:	6a 46                	push   $0x46
  802826:	68 1b 32 80 00       	push   $0x80321b
  80282b:	e8 33 d9 ff ff       	call   800163 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802830:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802833:	5b                   	pop    %ebx
  802834:	5e                   	pop    %esi
  802835:	5f                   	pop    %edi
  802836:	5d                   	pop    %ebp
  802837:	c3                   	ret    

00802838 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802843:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802849:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80284f:	8b 52 50             	mov    0x50(%edx),%edx
  802852:	39 ca                	cmp    %ecx,%edx
  802854:	74 11                	je     802867 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802856:	83 c0 01             	add    $0x1,%eax
  802859:	3d 00 04 00 00       	cmp    $0x400,%eax
  80285e:	75 e3                	jne    802843 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802860:	b8 00 00 00 00       	mov    $0x0,%eax
  802865:	eb 0e                	jmp    802875 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802867:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80286d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802872:	8b 40 48             	mov    0x48(%eax),%eax
}
  802875:	5d                   	pop    %ebp
  802876:	c3                   	ret    

00802877 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802877:	55                   	push   %ebp
  802878:	89 e5                	mov    %esp,%ebp
  80287a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80287d:	89 d0                	mov    %edx,%eax
  80287f:	c1 e8 16             	shr    $0x16,%eax
  802882:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80288e:	f6 c1 01             	test   $0x1,%cl
  802891:	74 1d                	je     8028b0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802893:	c1 ea 0c             	shr    $0xc,%edx
  802896:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80289d:	f6 c2 01             	test   $0x1,%dl
  8028a0:	74 0e                	je     8028b0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028a2:	c1 ea 0c             	shr    $0xc,%edx
  8028a5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028ac:	ef 
  8028ad:	0f b7 c0             	movzwl %ax,%eax
}
  8028b0:	5d                   	pop    %ebp
  8028b1:	c3                   	ret    
  8028b2:	66 90                	xchg   %ax,%ax
  8028b4:	66 90                	xchg   %ax,%ax
  8028b6:	66 90                	xchg   %ax,%ax
  8028b8:	66 90                	xchg   %ax,%ax
  8028ba:	66 90                	xchg   %ax,%ax
  8028bc:	66 90                	xchg   %ax,%ax
  8028be:	66 90                	xchg   %ax,%ax

008028c0 <__udivdi3>:
  8028c0:	55                   	push   %ebp
  8028c1:	57                   	push   %edi
  8028c2:	56                   	push   %esi
  8028c3:	53                   	push   %ebx
  8028c4:	83 ec 1c             	sub    $0x1c,%esp
  8028c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028d7:	85 d2                	test   %edx,%edx
  8028d9:	75 4d                	jne    802928 <__udivdi3+0x68>
  8028db:	39 f3                	cmp    %esi,%ebx
  8028dd:	76 19                	jbe    8028f8 <__udivdi3+0x38>
  8028df:	31 ff                	xor    %edi,%edi
  8028e1:	89 e8                	mov    %ebp,%eax
  8028e3:	89 f2                	mov    %esi,%edx
  8028e5:	f7 f3                	div    %ebx
  8028e7:	89 fa                	mov    %edi,%edx
  8028e9:	83 c4 1c             	add    $0x1c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	89 d9                	mov    %ebx,%ecx
  8028fa:	85 db                	test   %ebx,%ebx
  8028fc:	75 0b                	jne    802909 <__udivdi3+0x49>
  8028fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802903:	31 d2                	xor    %edx,%edx
  802905:	f7 f3                	div    %ebx
  802907:	89 c1                	mov    %eax,%ecx
  802909:	31 d2                	xor    %edx,%edx
  80290b:	89 f0                	mov    %esi,%eax
  80290d:	f7 f1                	div    %ecx
  80290f:	89 c6                	mov    %eax,%esi
  802911:	89 e8                	mov    %ebp,%eax
  802913:	89 f7                	mov    %esi,%edi
  802915:	f7 f1                	div    %ecx
  802917:	89 fa                	mov    %edi,%edx
  802919:	83 c4 1c             	add    $0x1c,%esp
  80291c:	5b                   	pop    %ebx
  80291d:	5e                   	pop    %esi
  80291e:	5f                   	pop    %edi
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	39 f2                	cmp    %esi,%edx
  80292a:	77 1c                	ja     802948 <__udivdi3+0x88>
  80292c:	0f bd fa             	bsr    %edx,%edi
  80292f:	83 f7 1f             	xor    $0x1f,%edi
  802932:	75 2c                	jne    802960 <__udivdi3+0xa0>
  802934:	39 f2                	cmp    %esi,%edx
  802936:	72 06                	jb     80293e <__udivdi3+0x7e>
  802938:	31 c0                	xor    %eax,%eax
  80293a:	39 eb                	cmp    %ebp,%ebx
  80293c:	77 a9                	ja     8028e7 <__udivdi3+0x27>
  80293e:	b8 01 00 00 00       	mov    $0x1,%eax
  802943:	eb a2                	jmp    8028e7 <__udivdi3+0x27>
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	31 ff                	xor    %edi,%edi
  80294a:	31 c0                	xor    %eax,%eax
  80294c:	89 fa                	mov    %edi,%edx
  80294e:	83 c4 1c             	add    $0x1c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
  802956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80295d:	8d 76 00             	lea    0x0(%esi),%esi
  802960:	89 f9                	mov    %edi,%ecx
  802962:	b8 20 00 00 00       	mov    $0x20,%eax
  802967:	29 f8                	sub    %edi,%eax
  802969:	d3 e2                	shl    %cl,%edx
  80296b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80296f:	89 c1                	mov    %eax,%ecx
  802971:	89 da                	mov    %ebx,%edx
  802973:	d3 ea                	shr    %cl,%edx
  802975:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802979:	09 d1                	or     %edx,%ecx
  80297b:	89 f2                	mov    %esi,%edx
  80297d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802981:	89 f9                	mov    %edi,%ecx
  802983:	d3 e3                	shl    %cl,%ebx
  802985:	89 c1                	mov    %eax,%ecx
  802987:	d3 ea                	shr    %cl,%edx
  802989:	89 f9                	mov    %edi,%ecx
  80298b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80298f:	89 eb                	mov    %ebp,%ebx
  802991:	d3 e6                	shl    %cl,%esi
  802993:	89 c1                	mov    %eax,%ecx
  802995:	d3 eb                	shr    %cl,%ebx
  802997:	09 de                	or     %ebx,%esi
  802999:	89 f0                	mov    %esi,%eax
  80299b:	f7 74 24 08          	divl   0x8(%esp)
  80299f:	89 d6                	mov    %edx,%esi
  8029a1:	89 c3                	mov    %eax,%ebx
  8029a3:	f7 64 24 0c          	mull   0xc(%esp)
  8029a7:	39 d6                	cmp    %edx,%esi
  8029a9:	72 15                	jb     8029c0 <__udivdi3+0x100>
  8029ab:	89 f9                	mov    %edi,%ecx
  8029ad:	d3 e5                	shl    %cl,%ebp
  8029af:	39 c5                	cmp    %eax,%ebp
  8029b1:	73 04                	jae    8029b7 <__udivdi3+0xf7>
  8029b3:	39 d6                	cmp    %edx,%esi
  8029b5:	74 09                	je     8029c0 <__udivdi3+0x100>
  8029b7:	89 d8                	mov    %ebx,%eax
  8029b9:	31 ff                	xor    %edi,%edi
  8029bb:	e9 27 ff ff ff       	jmp    8028e7 <__udivdi3+0x27>
  8029c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029c3:	31 ff                	xor    %edi,%edi
  8029c5:	e9 1d ff ff ff       	jmp    8028e7 <__udivdi3+0x27>
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

008029d0 <__umoddi3>:
  8029d0:	55                   	push   %ebp
  8029d1:	57                   	push   %edi
  8029d2:	56                   	push   %esi
  8029d3:	53                   	push   %ebx
  8029d4:	83 ec 1c             	sub    $0x1c,%esp
  8029d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029e7:	89 da                	mov    %ebx,%edx
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	75 43                	jne    802a30 <__umoddi3+0x60>
  8029ed:	39 df                	cmp    %ebx,%edi
  8029ef:	76 17                	jbe    802a08 <__umoddi3+0x38>
  8029f1:	89 f0                	mov    %esi,%eax
  8029f3:	f7 f7                	div    %edi
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	31 d2                	xor    %edx,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 fd                	mov    %edi,%ebp
  802a0a:	85 ff                	test   %edi,%edi
  802a0c:	75 0b                	jne    802a19 <__umoddi3+0x49>
  802a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a13:	31 d2                	xor    %edx,%edx
  802a15:	f7 f7                	div    %edi
  802a17:	89 c5                	mov    %eax,%ebp
  802a19:	89 d8                	mov    %ebx,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	f7 f5                	div    %ebp
  802a1f:	89 f0                	mov    %esi,%eax
  802a21:	f7 f5                	div    %ebp
  802a23:	89 d0                	mov    %edx,%eax
  802a25:	eb d0                	jmp    8029f7 <__umoddi3+0x27>
  802a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a2e:	66 90                	xchg   %ax,%ax
  802a30:	89 f1                	mov    %esi,%ecx
  802a32:	39 d8                	cmp    %ebx,%eax
  802a34:	76 0a                	jbe    802a40 <__umoddi3+0x70>
  802a36:	89 f0                	mov    %esi,%eax
  802a38:	83 c4 1c             	add    $0x1c,%esp
  802a3b:	5b                   	pop    %ebx
  802a3c:	5e                   	pop    %esi
  802a3d:	5f                   	pop    %edi
  802a3e:	5d                   	pop    %ebp
  802a3f:	c3                   	ret    
  802a40:	0f bd e8             	bsr    %eax,%ebp
  802a43:	83 f5 1f             	xor    $0x1f,%ebp
  802a46:	75 20                	jne    802a68 <__umoddi3+0x98>
  802a48:	39 d8                	cmp    %ebx,%eax
  802a4a:	0f 82 b0 00 00 00    	jb     802b00 <__umoddi3+0x130>
  802a50:	39 f7                	cmp    %esi,%edi
  802a52:	0f 86 a8 00 00 00    	jbe    802b00 <__umoddi3+0x130>
  802a58:	89 c8                	mov    %ecx,%eax
  802a5a:	83 c4 1c             	add    $0x1c,%esp
  802a5d:	5b                   	pop    %ebx
  802a5e:	5e                   	pop    %esi
  802a5f:	5f                   	pop    %edi
  802a60:	5d                   	pop    %ebp
  802a61:	c3                   	ret    
  802a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a68:	89 e9                	mov    %ebp,%ecx
  802a6a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a6f:	29 ea                	sub    %ebp,%edx
  802a71:	d3 e0                	shl    %cl,%eax
  802a73:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a77:	89 d1                	mov    %edx,%ecx
  802a79:	89 f8                	mov    %edi,%eax
  802a7b:	d3 e8                	shr    %cl,%eax
  802a7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a81:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a85:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a89:	09 c1                	or     %eax,%ecx
  802a8b:	89 d8                	mov    %ebx,%eax
  802a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a91:	89 e9                	mov    %ebp,%ecx
  802a93:	d3 e7                	shl    %cl,%edi
  802a95:	89 d1                	mov    %edx,%ecx
  802a97:	d3 e8                	shr    %cl,%eax
  802a99:	89 e9                	mov    %ebp,%ecx
  802a9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a9f:	d3 e3                	shl    %cl,%ebx
  802aa1:	89 c7                	mov    %eax,%edi
  802aa3:	89 d1                	mov    %edx,%ecx
  802aa5:	89 f0                	mov    %esi,%eax
  802aa7:	d3 e8                	shr    %cl,%eax
  802aa9:	89 e9                	mov    %ebp,%ecx
  802aab:	89 fa                	mov    %edi,%edx
  802aad:	d3 e6                	shl    %cl,%esi
  802aaf:	09 d8                	or     %ebx,%eax
  802ab1:	f7 74 24 08          	divl   0x8(%esp)
  802ab5:	89 d1                	mov    %edx,%ecx
  802ab7:	89 f3                	mov    %esi,%ebx
  802ab9:	f7 64 24 0c          	mull   0xc(%esp)
  802abd:	89 c6                	mov    %eax,%esi
  802abf:	89 d7                	mov    %edx,%edi
  802ac1:	39 d1                	cmp    %edx,%ecx
  802ac3:	72 06                	jb     802acb <__umoddi3+0xfb>
  802ac5:	75 10                	jne    802ad7 <__umoddi3+0x107>
  802ac7:	39 c3                	cmp    %eax,%ebx
  802ac9:	73 0c                	jae    802ad7 <__umoddi3+0x107>
  802acb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802acf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ad3:	89 d7                	mov    %edx,%edi
  802ad5:	89 c6                	mov    %eax,%esi
  802ad7:	89 ca                	mov    %ecx,%edx
  802ad9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802ade:	29 f3                	sub    %esi,%ebx
  802ae0:	19 fa                	sbb    %edi,%edx
  802ae2:	89 d0                	mov    %edx,%eax
  802ae4:	d3 e0                	shl    %cl,%eax
  802ae6:	89 e9                	mov    %ebp,%ecx
  802ae8:	d3 eb                	shr    %cl,%ebx
  802aea:	d3 ea                	shr    %cl,%edx
  802aec:	09 d8                	or     %ebx,%eax
  802aee:	83 c4 1c             	add    $0x1c,%esp
  802af1:	5b                   	pop    %ebx
  802af2:	5e                   	pop    %esi
  802af3:	5f                   	pop    %edi
  802af4:	5d                   	pop    %ebp
  802af5:	c3                   	ret    
  802af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802afd:	8d 76 00             	lea    0x0(%esi),%esi
  802b00:	89 da                	mov    %ebx,%edx
  802b02:	29 fe                	sub    %edi,%esi
  802b04:	19 c2                	sbb    %eax,%edx
  802b06:	89 f1                	mov    %esi,%ecx
  802b08:	89 c8                	mov    %ecx,%eax
  802b0a:	e9 4b ff ff ff       	jmp    802a5a <__umoddi3+0x8a>
