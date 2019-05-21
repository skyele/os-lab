
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
  80002c:	e8 b4 00 00 00       	call   8000e5 <libmain>
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
  800038:	e8 58 0d 00 00       	call   800d95 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 c8 11 00 00       	call   801211 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 5a 0d 00 00       	call   800db4 <sys_yield>
		return;
  80005a:	eb 6b                	jmp    8000c7 <umain+0x94>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800062:	89 f2                	mov    %esi,%edx
  800064:	c1 e2 07             	shl    $0x7,%edx
  800067:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80006d:	eb 02                	jmp    800071 <umain+0x3e>
		asm volatile("pause");
  80006f:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800071:	8b 42 54             	mov    0x54(%edx),%eax
  800074:	85 c0                	test   %eax,%eax
  800076:	75 f7                	jne    80006f <umain+0x3c>
  800078:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007d:	e8 32 0d 00 00       	call   800db4 <sys_yield>
  800082:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800087:	a1 04 20 80 00       	mov    0x802004,%eax
  80008c:	83 c0 01             	add    $0x1,%eax
  80008f:	a3 04 20 80 00       	mov    %eax,0x802004
		for (j = 0; j < 10000; j++)
  800094:	83 ea 01             	sub    $0x1,%edx
  800097:	75 ee                	jne    800087 <umain+0x54>
	for (i = 0; i < 10; i++) {
  800099:	83 eb 01             	sub    $0x1,%ebx
  80009c:	75 df                	jne    80007d <umain+0x4a>
	}

	if (counter != 10*10000)
  80009e:	a1 04 20 80 00       	mov    0x802004,%eax
  8000a3:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000a8:	75 24                	jne    8000ce <umain+0x9b>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000aa:	a1 08 20 80 00       	mov    0x802008,%eax
  8000af:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b2:	8b 40 48             	mov    0x48(%eax),%eax
  8000b5:	83 ec 04             	sub    $0x4,%esp
  8000b8:	52                   	push   %edx
  8000b9:	50                   	push   %eax
  8000ba:	68 fb 17 80 00       	push   $0x8017fb
  8000bf:	e8 be 01 00 00       	call   800282 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp

}
  8000c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ca:	5b                   	pop    %ebx
  8000cb:	5e                   	pop    %esi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000ce:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d3:	50                   	push   %eax
  8000d4:	68 c0 17 80 00       	push   $0x8017c0
  8000d9:	6a 21                	push   $0x21
  8000db:	68 e8 17 80 00       	push   $0x8017e8
  8000e0:	e8 a7 00 00 00       	call   80018c <_panic>

008000e5 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	57                   	push   %edi
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000ee:	c7 05 08 20 80 00 00 	movl   $0x0,0x802008
  8000f5:	00 00 00 
	envid_t find = sys_getenvid();
  8000f8:	e8 98 0c 00 00       	call   800d95 <sys_getenvid>
  8000fd:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  800103:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800108:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80010d:	bf 01 00 00 00       	mov    $0x1,%edi
  800112:	eb 0b                	jmp    80011f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800114:	83 c2 01             	add    $0x1,%edx
  800117:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80011d:	74 21                	je     800140 <libmain+0x5b>
		if(envs[i].env_id == find)
  80011f:	89 d1                	mov    %edx,%ecx
  800121:	c1 e1 07             	shl    $0x7,%ecx
  800124:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80012a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80012d:	39 c1                	cmp    %eax,%ecx
  80012f:	75 e3                	jne    800114 <libmain+0x2f>
  800131:	89 d3                	mov    %edx,%ebx
  800133:	c1 e3 07             	shl    $0x7,%ebx
  800136:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80013c:	89 fe                	mov    %edi,%esi
  80013e:	eb d4                	jmp    800114 <libmain+0x2f>
  800140:	89 f0                	mov    %esi,%eax
  800142:	84 c0                	test   %al,%al
  800144:	74 06                	je     80014c <libmain+0x67>
  800146:	89 1d 08 20 80 00    	mov    %ebx,0x802008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800150:	7e 0a                	jle    80015c <libmain+0x77>
		binaryname = argv[0];
  800152:	8b 45 0c             	mov    0xc(%ebp),%eax
  800155:	8b 00                	mov    (%eax),%eax
  800157:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	ff 75 0c             	pushl  0xc(%ebp)
  800162:	ff 75 08             	pushl  0x8(%ebp)
  800165:	e8 c9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016a:	e8 0b 00 00 00       	call   80017a <exit>
}
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5f                   	pop    %edi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800180:	6a 00                	push   $0x0
  800182:	e8 cd 0b 00 00       	call   800d54 <sys_env_destroy>
}
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	c9                   	leave  
  80018b:	c3                   	ret    

0080018c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800191:	a1 08 20 80 00       	mov    0x802008,%eax
  800196:	8b 40 48             	mov    0x48(%eax),%eax
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 54 18 80 00       	push   $0x801854
  8001a1:	50                   	push   %eax
  8001a2:	68 23 18 80 00       	push   $0x801823
  8001a7:	e8 d6 00 00 00       	call   800282 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001ac:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001af:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8001b5:	e8 db 0b 00 00       	call   800d95 <sys_getenvid>
  8001ba:	83 c4 04             	add    $0x4,%esp
  8001bd:	ff 75 0c             	pushl  0xc(%ebp)
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	56                   	push   %esi
  8001c4:	50                   	push   %eax
  8001c5:	68 30 18 80 00       	push   $0x801830
  8001ca:	e8 b3 00 00 00       	call   800282 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cf:	83 c4 18             	add    $0x18,%esp
  8001d2:	53                   	push   %ebx
  8001d3:	ff 75 10             	pushl  0x10(%ebp)
  8001d6:	e8 56 00 00 00       	call   800231 <vcprintf>
	cprintf("\n");
  8001db:	c7 04 24 59 1c 80 00 	movl   $0x801c59,(%esp)
  8001e2:	e8 9b 00 00 00       	call   800282 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ea:	cc                   	int3   
  8001eb:	eb fd                	jmp    8001ea <_panic+0x5e>

008001ed <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	53                   	push   %ebx
  8001f1:	83 ec 04             	sub    $0x4,%esp
  8001f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f7:	8b 13                	mov    (%ebx),%edx
  8001f9:	8d 42 01             	lea    0x1(%edx),%eax
  8001fc:	89 03                	mov    %eax,(%ebx)
  8001fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800201:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800205:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020a:	74 09                	je     800215 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800210:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800213:	c9                   	leave  
  800214:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	68 ff 00 00 00       	push   $0xff
  80021d:	8d 43 08             	lea    0x8(%ebx),%eax
  800220:	50                   	push   %eax
  800221:	e8 f1 0a 00 00       	call   800d17 <sys_cputs>
		b->idx = 0;
  800226:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	eb db                	jmp    80020c <putch+0x1f>

00800231 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800241:	00 00 00 
	b.cnt = 0;
  800244:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80024b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80024e:	ff 75 0c             	pushl  0xc(%ebp)
  800251:	ff 75 08             	pushl  0x8(%ebp)
  800254:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025a:	50                   	push   %eax
  80025b:	68 ed 01 80 00       	push   $0x8001ed
  800260:	e8 4a 01 00 00       	call   8003af <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800265:	83 c4 08             	add    $0x8,%esp
  800268:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80026e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800274:	50                   	push   %eax
  800275:	e8 9d 0a 00 00       	call   800d17 <sys_cputs>

	return b.cnt;
}
  80027a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800288:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80028b:	50                   	push   %eax
  80028c:	ff 75 08             	pushl  0x8(%ebp)
  80028f:	e8 9d ff ff ff       	call   800231 <vcprintf>
	va_end(ap);

	return cnt;
}
  800294:	c9                   	leave  
  800295:	c3                   	ret    

00800296 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	57                   	push   %edi
  80029a:	56                   	push   %esi
  80029b:	53                   	push   %ebx
  80029c:	83 ec 1c             	sub    $0x1c,%esp
  80029f:	89 c6                	mov    %eax,%esi
  8002a1:	89 d7                	mov    %edx,%edi
  8002a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002af:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002b5:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002b9:	74 2c                	je     8002e7 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002be:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002cb:	39 c2                	cmp    %eax,%edx
  8002cd:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002d0:	73 43                	jae    800315 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002d2:	83 eb 01             	sub    $0x1,%ebx
  8002d5:	85 db                	test   %ebx,%ebx
  8002d7:	7e 6c                	jle    800345 <printnum+0xaf>
				putch(padc, putdat);
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	57                   	push   %edi
  8002dd:	ff 75 18             	pushl  0x18(%ebp)
  8002e0:	ff d6                	call   *%esi
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	eb eb                	jmp    8002d2 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	6a 20                	push   $0x20
  8002ec:	6a 00                	push   $0x0
  8002ee:	50                   	push   %eax
  8002ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f5:	89 fa                	mov    %edi,%edx
  8002f7:	89 f0                	mov    %esi,%eax
  8002f9:	e8 98 ff ff ff       	call   800296 <printnum>
		while (--width > 0)
  8002fe:	83 c4 20             	add    $0x20,%esp
  800301:	83 eb 01             	sub    $0x1,%ebx
  800304:	85 db                	test   %ebx,%ebx
  800306:	7e 65                	jle    80036d <printnum+0xd7>
			putch(padc, putdat);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	57                   	push   %edi
  80030c:	6a 20                	push   $0x20
  80030e:	ff d6                	call   *%esi
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	eb ec                	jmp    800301 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	ff 75 18             	pushl  0x18(%ebp)
  80031b:	83 eb 01             	sub    $0x1,%ebx
  80031e:	53                   	push   %ebx
  80031f:	50                   	push   %eax
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 dc             	pushl  -0x24(%ebp)
  800326:	ff 75 d8             	pushl  -0x28(%ebp)
  800329:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032c:	ff 75 e0             	pushl  -0x20(%ebp)
  80032f:	e8 2c 12 00 00       	call   801560 <__udivdi3>
  800334:	83 c4 18             	add    $0x18,%esp
  800337:	52                   	push   %edx
  800338:	50                   	push   %eax
  800339:	89 fa                	mov    %edi,%edx
  80033b:	89 f0                	mov    %esi,%eax
  80033d:	e8 54 ff ff ff       	call   800296 <printnum>
  800342:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	57                   	push   %edi
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	ff 75 dc             	pushl  -0x24(%ebp)
  80034f:	ff 75 d8             	pushl  -0x28(%ebp)
  800352:	ff 75 e4             	pushl  -0x1c(%ebp)
  800355:	ff 75 e0             	pushl  -0x20(%ebp)
  800358:	e8 13 13 00 00       	call   801670 <__umoddi3>
  80035d:	83 c4 14             	add    $0x14,%esp
  800360:	0f be 80 5b 18 80 00 	movsbl 0x80185b(%eax),%eax
  800367:	50                   	push   %eax
  800368:	ff d6                	call   *%esi
  80036a:	83 c4 10             	add    $0x10,%esp
	}
}
  80036d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800370:	5b                   	pop    %ebx
  800371:	5e                   	pop    %esi
  800372:	5f                   	pop    %edi
  800373:	5d                   	pop    %ebp
  800374:	c3                   	ret    

00800375 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80037b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80037f:	8b 10                	mov    (%eax),%edx
  800381:	3b 50 04             	cmp    0x4(%eax),%edx
  800384:	73 0a                	jae    800390 <sprintputch+0x1b>
		*b->buf++ = ch;
  800386:	8d 4a 01             	lea    0x1(%edx),%ecx
  800389:	89 08                	mov    %ecx,(%eax)
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	88 02                	mov    %al,(%edx)
}
  800390:	5d                   	pop    %ebp
  800391:	c3                   	ret    

00800392 <printfmt>:
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800398:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80039b:	50                   	push   %eax
  80039c:	ff 75 10             	pushl  0x10(%ebp)
  80039f:	ff 75 0c             	pushl  0xc(%ebp)
  8003a2:	ff 75 08             	pushl  0x8(%ebp)
  8003a5:	e8 05 00 00 00       	call   8003af <vprintfmt>
}
  8003aa:	83 c4 10             	add    $0x10,%esp
  8003ad:	c9                   	leave  
  8003ae:	c3                   	ret    

008003af <vprintfmt>:
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	57                   	push   %edi
  8003b3:	56                   	push   %esi
  8003b4:	53                   	push   %ebx
  8003b5:	83 ec 3c             	sub    $0x3c,%esp
  8003b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003be:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c1:	e9 32 04 00 00       	jmp    8007f8 <vprintfmt+0x449>
		padc = ' ';
  8003c6:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003ca:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003d1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003ed:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	8d 47 01             	lea    0x1(%edi),%eax
  8003f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f8:	0f b6 17             	movzbl (%edi),%edx
  8003fb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003fe:	3c 55                	cmp    $0x55,%al
  800400:	0f 87 12 05 00 00    	ja     800918 <vprintfmt+0x569>
  800406:	0f b6 c0             	movzbl %al,%eax
  800409:	ff 24 85 40 1a 80 00 	jmp    *0x801a40(,%eax,4)
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800413:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800417:	eb d9                	jmp    8003f2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800419:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80041c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800420:	eb d0                	jmp    8003f2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800422:	0f b6 d2             	movzbl %dl,%edx
  800425:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800428:	b8 00 00 00 00       	mov    $0x0,%eax
  80042d:	89 75 08             	mov    %esi,0x8(%ebp)
  800430:	eb 03                	jmp    800435 <vprintfmt+0x86>
  800432:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800435:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800438:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80043c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80043f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800442:	83 fe 09             	cmp    $0x9,%esi
  800445:	76 eb                	jbe    800432 <vprintfmt+0x83>
  800447:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044a:	8b 75 08             	mov    0x8(%ebp),%esi
  80044d:	eb 14                	jmp    800463 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80044f:	8b 45 14             	mov    0x14(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800457:	8b 45 14             	mov    0x14(%ebp),%eax
  80045a:	8d 40 04             	lea    0x4(%eax),%eax
  80045d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800463:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800467:	79 89                	jns    8003f2 <vprintfmt+0x43>
				width = precision, precision = -1;
  800469:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80046c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800476:	e9 77 ff ff ff       	jmp    8003f2 <vprintfmt+0x43>
  80047b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047e:	85 c0                	test   %eax,%eax
  800480:	0f 48 c1             	cmovs  %ecx,%eax
  800483:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800489:	e9 64 ff ff ff       	jmp    8003f2 <vprintfmt+0x43>
  80048e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800491:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800498:	e9 55 ff ff ff       	jmp    8003f2 <vprintfmt+0x43>
			lflag++;
  80049d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a4:	e9 49 ff ff ff       	jmp    8003f2 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ac:	8d 78 04             	lea    0x4(%eax),%edi
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	53                   	push   %ebx
  8004b3:	ff 30                	pushl  (%eax)
  8004b5:	ff d6                	call   *%esi
			break;
  8004b7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ba:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004bd:	e9 33 03 00 00       	jmp    8007f5 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	8d 78 04             	lea    0x4(%eax),%edi
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	99                   	cltd   
  8004cb:	31 d0                	xor    %edx,%eax
  8004cd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004cf:	83 f8 0f             	cmp    $0xf,%eax
  8004d2:	7f 23                	jg     8004f7 <vprintfmt+0x148>
  8004d4:	8b 14 85 a0 1b 80 00 	mov    0x801ba0(,%eax,4),%edx
  8004db:	85 d2                	test   %edx,%edx
  8004dd:	74 18                	je     8004f7 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004df:	52                   	push   %edx
  8004e0:	68 7c 18 80 00       	push   $0x80187c
  8004e5:	53                   	push   %ebx
  8004e6:	56                   	push   %esi
  8004e7:	e8 a6 fe ff ff       	call   800392 <printfmt>
  8004ec:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ef:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f2:	e9 fe 02 00 00       	jmp    8007f5 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004f7:	50                   	push   %eax
  8004f8:	68 73 18 80 00       	push   $0x801873
  8004fd:	53                   	push   %ebx
  8004fe:	56                   	push   %esi
  8004ff:	e8 8e fe ff ff       	call   800392 <printfmt>
  800504:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800507:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80050a:	e9 e6 02 00 00       	jmp    8007f5 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	83 c0 04             	add    $0x4,%eax
  800515:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80051d:	85 c9                	test   %ecx,%ecx
  80051f:	b8 6c 18 80 00       	mov    $0x80186c,%eax
  800524:	0f 45 c1             	cmovne %ecx,%eax
  800527:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80052a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052e:	7e 06                	jle    800536 <vprintfmt+0x187>
  800530:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800534:	75 0d                	jne    800543 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800536:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800539:	89 c7                	mov    %eax,%edi
  80053b:	03 45 e0             	add    -0x20(%ebp),%eax
  80053e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800541:	eb 53                	jmp    800596 <vprintfmt+0x1e7>
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	ff 75 d8             	pushl  -0x28(%ebp)
  800549:	50                   	push   %eax
  80054a:	e8 71 04 00 00       	call   8009c0 <strnlen>
  80054f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800552:	29 c1                	sub    %eax,%ecx
  800554:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800557:	83 c4 10             	add    $0x10,%esp
  80055a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80055c:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800560:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800563:	eb 0f                	jmp    800574 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800565:	83 ec 08             	sub    $0x8,%esp
  800568:	53                   	push   %ebx
  800569:	ff 75 e0             	pushl  -0x20(%ebp)
  80056c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80056e:	83 ef 01             	sub    $0x1,%edi
  800571:	83 c4 10             	add    $0x10,%esp
  800574:	85 ff                	test   %edi,%edi
  800576:	7f ed                	jg     800565 <vprintfmt+0x1b6>
  800578:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80057b:	85 c9                	test   %ecx,%ecx
  80057d:	b8 00 00 00 00       	mov    $0x0,%eax
  800582:	0f 49 c1             	cmovns %ecx,%eax
  800585:	29 c1                	sub    %eax,%ecx
  800587:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80058a:	eb aa                	jmp    800536 <vprintfmt+0x187>
					putch(ch, putdat);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	53                   	push   %ebx
  800590:	52                   	push   %edx
  800591:	ff d6                	call   *%esi
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800599:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80059b:	83 c7 01             	add    $0x1,%edi
  80059e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a2:	0f be d0             	movsbl %al,%edx
  8005a5:	85 d2                	test   %edx,%edx
  8005a7:	74 4b                	je     8005f4 <vprintfmt+0x245>
  8005a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ad:	78 06                	js     8005b5 <vprintfmt+0x206>
  8005af:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005b3:	78 1e                	js     8005d3 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005b9:	74 d1                	je     80058c <vprintfmt+0x1dd>
  8005bb:	0f be c0             	movsbl %al,%eax
  8005be:	83 e8 20             	sub    $0x20,%eax
  8005c1:	83 f8 5e             	cmp    $0x5e,%eax
  8005c4:	76 c6                	jbe    80058c <vprintfmt+0x1dd>
					putch('?', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 3f                	push   $0x3f
  8005cc:	ff d6                	call   *%esi
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	eb c3                	jmp    800596 <vprintfmt+0x1e7>
  8005d3:	89 cf                	mov    %ecx,%edi
  8005d5:	eb 0e                	jmp    8005e5 <vprintfmt+0x236>
				putch(' ', putdat);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	53                   	push   %ebx
  8005db:	6a 20                	push   $0x20
  8005dd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005df:	83 ef 01             	sub    $0x1,%edi
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	85 ff                	test   %edi,%edi
  8005e7:	7f ee                	jg     8005d7 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ef:	e9 01 02 00 00       	jmp    8007f5 <vprintfmt+0x446>
  8005f4:	89 cf                	mov    %ecx,%edi
  8005f6:	eb ed                	jmp    8005e5 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005fb:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800602:	e9 eb fd ff ff       	jmp    8003f2 <vprintfmt+0x43>
	if (lflag >= 2)
  800607:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80060b:	7f 21                	jg     80062e <vprintfmt+0x27f>
	else if (lflag)
  80060d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800611:	74 68                	je     80067b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80061b:	89 c1                	mov    %eax,%ecx
  80061d:	c1 f9 1f             	sar    $0x1f,%ecx
  800620:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8d 40 04             	lea    0x4(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
  80062c:	eb 17                	jmp    800645 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 50 04             	mov    0x4(%eax),%edx
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800639:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8d 40 08             	lea    0x8(%eax),%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800645:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800648:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800651:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800655:	78 3f                	js     800696 <vprintfmt+0x2e7>
			base = 10;
  800657:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80065c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800660:	0f 84 71 01 00 00    	je     8007d7 <vprintfmt+0x428>
				putch('+', putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 2b                	push   $0x2b
  80066c:	ff d6                	call   *%esi
  80066e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800671:	b8 0a 00 00 00       	mov    $0xa,%eax
  800676:	e9 5c 01 00 00       	jmp    8007d7 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800683:	89 c1                	mov    %eax,%ecx
  800685:	c1 f9 1f             	sar    $0x1f,%ecx
  800688:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8d 40 04             	lea    0x4(%eax),%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
  800694:	eb af                	jmp    800645 <vprintfmt+0x296>
				putch('-', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 2d                	push   $0x2d
  80069c:	ff d6                	call   *%esi
				num = -(long long) num;
  80069e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a4:	f7 d8                	neg    %eax
  8006a6:	83 d2 00             	adc    $0x0,%edx
  8006a9:	f7 da                	neg    %edx
  8006ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b9:	e9 19 01 00 00       	jmp    8007d7 <vprintfmt+0x428>
	if (lflag >= 2)
  8006be:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c2:	7f 29                	jg     8006ed <vprintfmt+0x33e>
	else if (lflag)
  8006c4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c8:	74 44                	je     80070e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e8:	e9 ea 00 00 00       	jmp    8007d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 50 04             	mov    0x4(%eax),%edx
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8d 40 08             	lea    0x8(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800704:	b8 0a 00 00 00       	mov    $0xa,%eax
  800709:	e9 c9 00 00 00       	jmp    8007d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 40 04             	lea    0x4(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800727:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072c:	e9 a6 00 00 00       	jmp    8007d7 <vprintfmt+0x428>
			putch('0', putdat);
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	53                   	push   %ebx
  800735:	6a 30                	push   $0x30
  800737:	ff d6                	call   *%esi
	if (lflag >= 2)
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800740:	7f 26                	jg     800768 <vprintfmt+0x3b9>
	else if (lflag)
  800742:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800746:	74 3e                	je     800786 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	ba 00 00 00 00       	mov    $0x0,%edx
  800752:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800755:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8d 40 04             	lea    0x4(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800761:	b8 08 00 00 00       	mov    $0x8,%eax
  800766:	eb 6f                	jmp    8007d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 50 04             	mov    0x4(%eax),%edx
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800773:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 08             	lea    0x8(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077f:	b8 08 00 00 00       	mov    $0x8,%eax
  800784:	eb 51                	jmp    8007d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800793:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80079f:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a4:	eb 31                	jmp    8007d7 <vprintfmt+0x428>
			putch('0', putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	53                   	push   %ebx
  8007aa:	6a 30                	push   $0x30
  8007ac:	ff d6                	call   *%esi
			putch('x', putdat);
  8007ae:	83 c4 08             	add    $0x8,%esp
  8007b1:	53                   	push   %ebx
  8007b2:	6a 78                	push   $0x78
  8007b4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007c6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 40 04             	lea    0x4(%eax),%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007de:	52                   	push   %edx
  8007df:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e2:	50                   	push   %eax
  8007e3:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e6:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e9:	89 da                	mov    %ebx,%edx
  8007eb:	89 f0                	mov    %esi,%eax
  8007ed:	e8 a4 fa ff ff       	call   800296 <printnum>
			break;
  8007f2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f8:	83 c7 01             	add    $0x1,%edi
  8007fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ff:	83 f8 25             	cmp    $0x25,%eax
  800802:	0f 84 be fb ff ff    	je     8003c6 <vprintfmt+0x17>
			if (ch == '\0')
  800808:	85 c0                	test   %eax,%eax
  80080a:	0f 84 28 01 00 00    	je     800938 <vprintfmt+0x589>
			putch(ch, putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	50                   	push   %eax
  800815:	ff d6                	call   *%esi
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	eb dc                	jmp    8007f8 <vprintfmt+0x449>
	if (lflag >= 2)
  80081c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800820:	7f 26                	jg     800848 <vprintfmt+0x499>
	else if (lflag)
  800822:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800826:	74 41                	je     800869 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	ba 00 00 00 00       	mov    $0x0,%edx
  800832:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800835:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8d 40 04             	lea    0x4(%eax),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800841:	b8 10 00 00 00       	mov    $0x10,%eax
  800846:	eb 8f                	jmp    8007d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8b 50 04             	mov    0x4(%eax),%edx
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800853:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8d 40 08             	lea    0x8(%eax),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085f:	b8 10 00 00 00       	mov    $0x10,%eax
  800864:	e9 6e ff ff ff       	jmp    8007d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	ba 00 00 00 00       	mov    $0x0,%edx
  800873:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800876:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8d 40 04             	lea    0x4(%eax),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800882:	b8 10 00 00 00       	mov    $0x10,%eax
  800887:	e9 4b ff ff ff       	jmp    8007d7 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	83 c0 04             	add    $0x4,%eax
  800892:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	85 c0                	test   %eax,%eax
  80089c:	74 14                	je     8008b2 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80089e:	8b 13                	mov    (%ebx),%edx
  8008a0:	83 fa 7f             	cmp    $0x7f,%edx
  8008a3:	7f 37                	jg     8008dc <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008a5:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ad:	e9 43 ff ff ff       	jmp    8007f5 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b7:	bf 95 19 80 00       	mov    $0x801995,%edi
							putch(ch, putdat);
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	53                   	push   %ebx
  8008c0:	50                   	push   %eax
  8008c1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008c3:	83 c7 01             	add    $0x1,%edi
  8008c6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	75 eb                	jne    8008bc <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	e9 19 ff ff ff       	jmp    8007f5 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008dc:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e3:	bf cd 19 80 00       	mov    $0x8019cd,%edi
							putch(ch, putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	53                   	push   %ebx
  8008ec:	50                   	push   %eax
  8008ed:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008ef:	83 c7 01             	add    $0x1,%edi
  8008f2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	85 c0                	test   %eax,%eax
  8008fb:	75 eb                	jne    8008e8 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
  800903:	e9 ed fe ff ff       	jmp    8007f5 <vprintfmt+0x446>
			putch(ch, putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	53                   	push   %ebx
  80090c:	6a 25                	push   $0x25
  80090e:	ff d6                	call   *%esi
			break;
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	e9 dd fe ff ff       	jmp    8007f5 <vprintfmt+0x446>
			putch('%', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	53                   	push   %ebx
  80091c:	6a 25                	push   $0x25
  80091e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	89 f8                	mov    %edi,%eax
  800925:	eb 03                	jmp    80092a <vprintfmt+0x57b>
  800927:	83 e8 01             	sub    $0x1,%eax
  80092a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80092e:	75 f7                	jne    800927 <vprintfmt+0x578>
  800930:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800933:	e9 bd fe ff ff       	jmp    8007f5 <vprintfmt+0x446>
}
  800938:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5f                   	pop    %edi
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	83 ec 18             	sub    $0x18,%esp
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800953:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800956:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80095d:	85 c0                	test   %eax,%eax
  80095f:	74 26                	je     800987 <vsnprintf+0x47>
  800961:	85 d2                	test   %edx,%edx
  800963:	7e 22                	jle    800987 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800965:	ff 75 14             	pushl  0x14(%ebp)
  800968:	ff 75 10             	pushl  0x10(%ebp)
  80096b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80096e:	50                   	push   %eax
  80096f:	68 75 03 80 00       	push   $0x800375
  800974:	e8 36 fa ff ff       	call   8003af <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800979:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80097c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80097f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800982:	83 c4 10             	add    $0x10,%esp
}
  800985:	c9                   	leave  
  800986:	c3                   	ret    
		return -E_INVAL;
  800987:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80098c:	eb f7                	jmp    800985 <vsnprintf+0x45>

0080098e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800994:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800997:	50                   	push   %eax
  800998:	ff 75 10             	pushl  0x10(%ebp)
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	ff 75 08             	pushl  0x8(%ebp)
  8009a1:	e8 9a ff ff ff       	call   800940 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a6:	c9                   	leave  
  8009a7:	c3                   	ret    

008009a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b7:	74 05                	je     8009be <strlen+0x16>
		n++;
  8009b9:	83 c0 01             	add    $0x1,%eax
  8009bc:	eb f5                	jmp    8009b3 <strlen+0xb>
	return n;
}
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    

008009c0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ce:	39 c2                	cmp    %eax,%edx
  8009d0:	74 0d                	je     8009df <strnlen+0x1f>
  8009d2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009d6:	74 05                	je     8009dd <strnlen+0x1d>
		n++;
  8009d8:	83 c2 01             	add    $0x1,%edx
  8009db:	eb f1                	jmp    8009ce <strnlen+0xe>
  8009dd:	89 d0                	mov    %edx,%eax
	return n;
}
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	53                   	push   %ebx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	84 c9                	test   %cl,%cl
  8009fc:	75 f2                	jne    8009f0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009fe:	5b                   	pop    %ebx
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	53                   	push   %ebx
  800a05:	83 ec 10             	sub    $0x10,%esp
  800a08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a0b:	53                   	push   %ebx
  800a0c:	e8 97 ff ff ff       	call   8009a8 <strlen>
  800a11:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	01 d8                	add    %ebx,%eax
  800a19:	50                   	push   %eax
  800a1a:	e8 c2 ff ff ff       	call   8009e1 <strcpy>
	return dst;
}
  800a1f:	89 d8                	mov    %ebx,%eax
  800a21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a31:	89 c6                	mov    %eax,%esi
  800a33:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a36:	89 c2                	mov    %eax,%edx
  800a38:	39 f2                	cmp    %esi,%edx
  800a3a:	74 11                	je     800a4d <strncpy+0x27>
		*dst++ = *src;
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	0f b6 19             	movzbl (%ecx),%ebx
  800a42:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a45:	80 fb 01             	cmp    $0x1,%bl
  800a48:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a4b:	eb eb                	jmp    800a38 <strncpy+0x12>
	}
	return ret;
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5e                   	pop    %esi
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	8b 75 08             	mov    0x8(%ebp),%esi
  800a59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a5c:	8b 55 10             	mov    0x10(%ebp),%edx
  800a5f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a61:	85 d2                	test   %edx,%edx
  800a63:	74 21                	je     800a86 <strlcpy+0x35>
  800a65:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a69:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a6b:	39 c2                	cmp    %eax,%edx
  800a6d:	74 14                	je     800a83 <strlcpy+0x32>
  800a6f:	0f b6 19             	movzbl (%ecx),%ebx
  800a72:	84 db                	test   %bl,%bl
  800a74:	74 0b                	je     800a81 <strlcpy+0x30>
			*dst++ = *src++;
  800a76:	83 c1 01             	add    $0x1,%ecx
  800a79:	83 c2 01             	add    $0x1,%edx
  800a7c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a7f:	eb ea                	jmp    800a6b <strlcpy+0x1a>
  800a81:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a86:	29 f0                	sub    %esi,%eax
}
  800a88:	5b                   	pop    %ebx
  800a89:	5e                   	pop    %esi
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a92:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a95:	0f b6 01             	movzbl (%ecx),%eax
  800a98:	84 c0                	test   %al,%al
  800a9a:	74 0c                	je     800aa8 <strcmp+0x1c>
  800a9c:	3a 02                	cmp    (%edx),%al
  800a9e:	75 08                	jne    800aa8 <strcmp+0x1c>
		p++, q++;
  800aa0:	83 c1 01             	add    $0x1,%ecx
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	eb ed                	jmp    800a95 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa8:	0f b6 c0             	movzbl %al,%eax
  800aab:	0f b6 12             	movzbl (%edx),%edx
  800aae:	29 d0                	sub    %edx,%eax
}
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	53                   	push   %ebx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abc:	89 c3                	mov    %eax,%ebx
  800abe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac1:	eb 06                	jmp    800ac9 <strncmp+0x17>
		n--, p++, q++;
  800ac3:	83 c0 01             	add    $0x1,%eax
  800ac6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac9:	39 d8                	cmp    %ebx,%eax
  800acb:	74 16                	je     800ae3 <strncmp+0x31>
  800acd:	0f b6 08             	movzbl (%eax),%ecx
  800ad0:	84 c9                	test   %cl,%cl
  800ad2:	74 04                	je     800ad8 <strncmp+0x26>
  800ad4:	3a 0a                	cmp    (%edx),%cl
  800ad6:	74 eb                	je     800ac3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad8:	0f b6 00             	movzbl (%eax),%eax
  800adb:	0f b6 12             	movzbl (%edx),%edx
  800ade:	29 d0                	sub    %edx,%eax
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    
		return 0;
  800ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae8:	eb f6                	jmp    800ae0 <strncmp+0x2e>

00800aea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af4:	0f b6 10             	movzbl (%eax),%edx
  800af7:	84 d2                	test   %dl,%dl
  800af9:	74 09                	je     800b04 <strchr+0x1a>
		if (*s == c)
  800afb:	38 ca                	cmp    %cl,%dl
  800afd:	74 0a                	je     800b09 <strchr+0x1f>
	for (; *s; s++)
  800aff:	83 c0 01             	add    $0x1,%eax
  800b02:	eb f0                	jmp    800af4 <strchr+0xa>
			return (char *) s;
	return 0;
  800b04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b15:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b18:	38 ca                	cmp    %cl,%dl
  800b1a:	74 09                	je     800b25 <strfind+0x1a>
  800b1c:	84 d2                	test   %dl,%dl
  800b1e:	74 05                	je     800b25 <strfind+0x1a>
	for (; *s; s++)
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	eb f0                	jmp    800b15 <strfind+0xa>
			break;
	return (char *) s;
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b33:	85 c9                	test   %ecx,%ecx
  800b35:	74 31                	je     800b68 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b37:	89 f8                	mov    %edi,%eax
  800b39:	09 c8                	or     %ecx,%eax
  800b3b:	a8 03                	test   $0x3,%al
  800b3d:	75 23                	jne    800b62 <memset+0x3b>
		c &= 0xFF;
  800b3f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b43:	89 d3                	mov    %edx,%ebx
  800b45:	c1 e3 08             	shl    $0x8,%ebx
  800b48:	89 d0                	mov    %edx,%eax
  800b4a:	c1 e0 18             	shl    $0x18,%eax
  800b4d:	89 d6                	mov    %edx,%esi
  800b4f:	c1 e6 10             	shl    $0x10,%esi
  800b52:	09 f0                	or     %esi,%eax
  800b54:	09 c2                	or     %eax,%edx
  800b56:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b58:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b5b:	89 d0                	mov    %edx,%eax
  800b5d:	fc                   	cld    
  800b5e:	f3 ab                	rep stos %eax,%es:(%edi)
  800b60:	eb 06                	jmp    800b68 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	fc                   	cld    
  800b66:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b68:	89 f8                	mov    %edi,%eax
  800b6a:	5b                   	pop    %ebx
  800b6b:	5e                   	pop    %esi
  800b6c:	5f                   	pop    %edi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	57                   	push   %edi
  800b73:	56                   	push   %esi
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b7d:	39 c6                	cmp    %eax,%esi
  800b7f:	73 32                	jae    800bb3 <memmove+0x44>
  800b81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	76 2b                	jbe    800bb3 <memmove+0x44>
		s += n;
		d += n;
  800b88:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8b:	89 fe                	mov    %edi,%esi
  800b8d:	09 ce                	or     %ecx,%esi
  800b8f:	09 d6                	or     %edx,%esi
  800b91:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b97:	75 0e                	jne    800ba7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b99:	83 ef 04             	sub    $0x4,%edi
  800b9c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b9f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ba2:	fd                   	std    
  800ba3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba5:	eb 09                	jmp    800bb0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ba7:	83 ef 01             	sub    $0x1,%edi
  800baa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bad:	fd                   	std    
  800bae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb0:	fc                   	cld    
  800bb1:	eb 1a                	jmp    800bcd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb3:	89 c2                	mov    %eax,%edx
  800bb5:	09 ca                	or     %ecx,%edx
  800bb7:	09 f2                	or     %esi,%edx
  800bb9:	f6 c2 03             	test   $0x3,%dl
  800bbc:	75 0a                	jne    800bc8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bbe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bc1:	89 c7                	mov    %eax,%edi
  800bc3:	fc                   	cld    
  800bc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc6:	eb 05                	jmp    800bcd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bc8:	89 c7                	mov    %eax,%edi
  800bca:	fc                   	cld    
  800bcb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bcd:	5e                   	pop    %esi
  800bce:	5f                   	pop    %edi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bd7:	ff 75 10             	pushl  0x10(%ebp)
  800bda:	ff 75 0c             	pushl  0xc(%ebp)
  800bdd:	ff 75 08             	pushl  0x8(%ebp)
  800be0:	e8 8a ff ff ff       	call   800b6f <memmove>
}
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    

00800be7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf2:	89 c6                	mov    %eax,%esi
  800bf4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf7:	39 f0                	cmp    %esi,%eax
  800bf9:	74 1c                	je     800c17 <memcmp+0x30>
		if (*s1 != *s2)
  800bfb:	0f b6 08             	movzbl (%eax),%ecx
  800bfe:	0f b6 1a             	movzbl (%edx),%ebx
  800c01:	38 d9                	cmp    %bl,%cl
  800c03:	75 08                	jne    800c0d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c05:	83 c0 01             	add    $0x1,%eax
  800c08:	83 c2 01             	add    $0x1,%edx
  800c0b:	eb ea                	jmp    800bf7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c0d:	0f b6 c1             	movzbl %cl,%eax
  800c10:	0f b6 db             	movzbl %bl,%ebx
  800c13:	29 d8                	sub    %ebx,%eax
  800c15:	eb 05                	jmp    800c1c <memcmp+0x35>
	}

	return 0;
  800c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1c:	5b                   	pop    %ebx
  800c1d:	5e                   	pop    %esi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c29:	89 c2                	mov    %eax,%edx
  800c2b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c2e:	39 d0                	cmp    %edx,%eax
  800c30:	73 09                	jae    800c3b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c32:	38 08                	cmp    %cl,(%eax)
  800c34:	74 05                	je     800c3b <memfind+0x1b>
	for (; s < ends; s++)
  800c36:	83 c0 01             	add    $0x1,%eax
  800c39:	eb f3                	jmp    800c2e <memfind+0xe>
			break;
	return (void *) s;
}
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    

00800c3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	57                   	push   %edi
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
  800c43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c49:	eb 03                	jmp    800c4e <strtol+0x11>
		s++;
  800c4b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c4e:	0f b6 01             	movzbl (%ecx),%eax
  800c51:	3c 20                	cmp    $0x20,%al
  800c53:	74 f6                	je     800c4b <strtol+0xe>
  800c55:	3c 09                	cmp    $0x9,%al
  800c57:	74 f2                	je     800c4b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c59:	3c 2b                	cmp    $0x2b,%al
  800c5b:	74 2a                	je     800c87 <strtol+0x4a>
	int neg = 0;
  800c5d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c62:	3c 2d                	cmp    $0x2d,%al
  800c64:	74 2b                	je     800c91 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c66:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c6c:	75 0f                	jne    800c7d <strtol+0x40>
  800c6e:	80 39 30             	cmpb   $0x30,(%ecx)
  800c71:	74 28                	je     800c9b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c73:	85 db                	test   %ebx,%ebx
  800c75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c7a:	0f 44 d8             	cmove  %eax,%ebx
  800c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c82:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c85:	eb 50                	jmp    800cd7 <strtol+0x9a>
		s++;
  800c87:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8f:	eb d5                	jmp    800c66 <strtol+0x29>
		s++, neg = 1;
  800c91:	83 c1 01             	add    $0x1,%ecx
  800c94:	bf 01 00 00 00       	mov    $0x1,%edi
  800c99:	eb cb                	jmp    800c66 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c9f:	74 0e                	je     800caf <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ca1:	85 db                	test   %ebx,%ebx
  800ca3:	75 d8                	jne    800c7d <strtol+0x40>
		s++, base = 8;
  800ca5:	83 c1 01             	add    $0x1,%ecx
  800ca8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cad:	eb ce                	jmp    800c7d <strtol+0x40>
		s += 2, base = 16;
  800caf:	83 c1 02             	add    $0x2,%ecx
  800cb2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb7:	eb c4                	jmp    800c7d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cbc:	89 f3                	mov    %esi,%ebx
  800cbe:	80 fb 19             	cmp    $0x19,%bl
  800cc1:	77 29                	ja     800cec <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cc3:	0f be d2             	movsbl %dl,%edx
  800cc6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ccc:	7d 30                	jge    800cfe <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cce:	83 c1 01             	add    $0x1,%ecx
  800cd1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cd5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cd7:	0f b6 11             	movzbl (%ecx),%edx
  800cda:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cdd:	89 f3                	mov    %esi,%ebx
  800cdf:	80 fb 09             	cmp    $0x9,%bl
  800ce2:	77 d5                	ja     800cb9 <strtol+0x7c>
			dig = *s - '0';
  800ce4:	0f be d2             	movsbl %dl,%edx
  800ce7:	83 ea 30             	sub    $0x30,%edx
  800cea:	eb dd                	jmp    800cc9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cec:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cef:	89 f3                	mov    %esi,%ebx
  800cf1:	80 fb 19             	cmp    $0x19,%bl
  800cf4:	77 08                	ja     800cfe <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cf6:	0f be d2             	movsbl %dl,%edx
  800cf9:	83 ea 37             	sub    $0x37,%edx
  800cfc:	eb cb                	jmp    800cc9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d02:	74 05                	je     800d09 <strtol+0xcc>
		*endptr = (char *) s;
  800d04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d07:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d09:	89 c2                	mov    %eax,%edx
  800d0b:	f7 da                	neg    %edx
  800d0d:	85 ff                	test   %edi,%edi
  800d0f:	0f 45 c2             	cmovne %edx,%eax
}
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	89 c3                	mov    %eax,%ebx
  800d2a:	89 c7                	mov    %eax,%edi
  800d2c:	89 c6                	mov    %eax,%esi
  800d2e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d40:	b8 01 00 00 00       	mov    $0x1,%eax
  800d45:	89 d1                	mov    %edx,%ecx
  800d47:	89 d3                	mov    %edx,%ebx
  800d49:	89 d7                	mov    %edx,%edi
  800d4b:	89 d6                	mov    %edx,%esi
  800d4d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6a:	89 cb                	mov    %ecx,%ebx
  800d6c:	89 cf                	mov    %ecx,%edi
  800d6e:	89 ce                	mov    %ecx,%esi
  800d70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7f 08                	jg     800d7e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	50                   	push   %eax
  800d82:	6a 03                	push   $0x3
  800d84:	68 e0 1b 80 00       	push   $0x801be0
  800d89:	6a 43                	push   $0x43
  800d8b:	68 fd 1b 80 00       	push   $0x801bfd
  800d90:	e8 f7 f3 ff ff       	call   80018c <_panic>

00800d95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800da0:	b8 02 00 00 00       	mov    $0x2,%eax
  800da5:	89 d1                	mov    %edx,%ecx
  800da7:	89 d3                	mov    %edx,%ebx
  800da9:	89 d7                	mov    %edx,%edi
  800dab:	89 d6                	mov    %edx,%esi
  800dad:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <sys_yield>:

void
sys_yield(void)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dba:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc4:	89 d1                	mov    %edx,%ecx
  800dc6:	89 d3                	mov    %edx,%ebx
  800dc8:	89 d7                	mov    %edx,%edi
  800dca:	89 d6                	mov    %edx,%esi
  800dcc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddc:	be 00 00 00 00       	mov    $0x0,%esi
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de7:	b8 04 00 00 00       	mov    $0x4,%eax
  800dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800def:	89 f7                	mov    %esi,%edi
  800df1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df3:	85 c0                	test   %eax,%eax
  800df5:	7f 08                	jg     800dff <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dff:	83 ec 0c             	sub    $0xc,%esp
  800e02:	50                   	push   %eax
  800e03:	6a 04                	push   $0x4
  800e05:	68 e0 1b 80 00       	push   $0x801be0
  800e0a:	6a 43                	push   $0x43
  800e0c:	68 fd 1b 80 00       	push   $0x801bfd
  800e11:	e8 76 f3 ff ff       	call   80018c <_panic>

00800e16 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e25:	b8 05 00 00 00       	mov    $0x5,%eax
  800e2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e30:	8b 75 18             	mov    0x18(%ebp),%esi
  800e33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e35:	85 c0                	test   %eax,%eax
  800e37:	7f 08                	jg     800e41 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	50                   	push   %eax
  800e45:	6a 05                	push   $0x5
  800e47:	68 e0 1b 80 00       	push   $0x801be0
  800e4c:	6a 43                	push   $0x43
  800e4e:	68 fd 1b 80 00       	push   $0x801bfd
  800e53:	e8 34 f3 ff ff       	call   80018c <_panic>

00800e58 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
  800e5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6c:	b8 06 00 00 00       	mov    $0x6,%eax
  800e71:	89 df                	mov    %ebx,%edi
  800e73:	89 de                	mov    %ebx,%esi
  800e75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	7f 08                	jg     800e83 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	50                   	push   %eax
  800e87:	6a 06                	push   $0x6
  800e89:	68 e0 1b 80 00       	push   $0x801be0
  800e8e:	6a 43                	push   $0x43
  800e90:	68 fd 1b 80 00       	push   $0x801bfd
  800e95:	e8 f2 f2 ff ff       	call   80018c <_panic>

00800e9a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eae:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	89 de                	mov    %ebx,%esi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 08                	push   $0x8
  800ecb:	68 e0 1b 80 00       	push   $0x801be0
  800ed0:	6a 43                	push   $0x43
  800ed2:	68 fd 1b 80 00       	push   $0x801bfd
  800ed7:	e8 b0 f2 ff ff       	call   80018c <_panic>

00800edc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
  800ee2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef5:	89 df                	mov    %ebx,%edi
  800ef7:	89 de                	mov    %ebx,%esi
  800ef9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7f 08                	jg     800f07 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	50                   	push   %eax
  800f0b:	6a 09                	push   $0x9
  800f0d:	68 e0 1b 80 00       	push   $0x801be0
  800f12:	6a 43                	push   $0x43
  800f14:	68 fd 1b 80 00       	push   $0x801bfd
  800f19:	e8 6e f2 ff ff       	call   80018c <_panic>

00800f1e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f37:	89 df                	mov    %ebx,%edi
  800f39:	89 de                	mov    %ebx,%esi
  800f3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7f 08                	jg     800f49 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	50                   	push   %eax
  800f4d:	6a 0a                	push   $0xa
  800f4f:	68 e0 1b 80 00       	push   $0x801be0
  800f54:	6a 43                	push   $0x43
  800f56:	68 fd 1b 80 00       	push   $0x801bfd
  800f5b:	e8 2c f2 ff ff       	call   80018c <_panic>

00800f60 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f71:	be 00 00 00 00       	mov    $0x0,%esi
  800f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f79:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	57                   	push   %edi
  800f87:	56                   	push   %esi
  800f88:	53                   	push   %ebx
  800f89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f99:	89 cb                	mov    %ecx,%ebx
  800f9b:	89 cf                	mov    %ecx,%edi
  800f9d:	89 ce                	mov    %ecx,%esi
  800f9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa1:	85 c0                	test   %eax,%eax
  800fa3:	7f 08                	jg     800fad <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	83 ec 0c             	sub    $0xc,%esp
  800fb0:	50                   	push   %eax
  800fb1:	6a 0d                	push   $0xd
  800fb3:	68 e0 1b 80 00       	push   $0x801be0
  800fb8:	6a 43                	push   $0x43
  800fba:	68 fd 1b 80 00       	push   $0x801bfd
  800fbf:	e8 c8 f1 ff ff       	call   80018c <_panic>

00800fc4 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	57                   	push   %edi
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fca:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fda:	89 df                	mov    %ebx,%edi
  800fdc:	89 de                	mov    %ebx,%esi
  800fde:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800feb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ff8:	89 cb                	mov    %ecx,%ebx
  800ffa:	89 cf                	mov    %ecx,%edi
  800ffc:	89 ce                	mov    %ecx,%esi
  800ffe:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801000:	5b                   	pop    %ebx
  801001:	5e                   	pop    %esi
  801002:	5f                   	pop    %edi
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    

00801005 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	53                   	push   %ebx
  801009:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80100c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801013:	83 e1 07             	and    $0x7,%ecx
  801016:	83 f9 07             	cmp    $0x7,%ecx
  801019:	74 32                	je     80104d <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80101b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801022:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801028:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80102e:	74 7d                	je     8010ad <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801030:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801037:	83 e1 05             	and    $0x5,%ecx
  80103a:	83 f9 05             	cmp    $0x5,%ecx
  80103d:	0f 84 9e 00 00 00    	je     8010e1 <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
  801048:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80104d:	89 d3                	mov    %edx,%ebx
  80104f:	c1 e3 0c             	shl    $0xc,%ebx
  801052:	83 ec 0c             	sub    $0xc,%esp
  801055:	68 05 08 00 00       	push   $0x805
  80105a:	53                   	push   %ebx
  80105b:	50                   	push   %eax
  80105c:	53                   	push   %ebx
  80105d:	6a 00                	push   $0x0
  80105f:	e8 b2 fd ff ff       	call   800e16 <sys_page_map>
		if(r < 0)
  801064:	83 c4 20             	add    $0x20,%esp
  801067:	85 c0                	test   %eax,%eax
  801069:	78 2e                	js     801099 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80106b:	83 ec 0c             	sub    $0xc,%esp
  80106e:	68 05 08 00 00       	push   $0x805
  801073:	53                   	push   %ebx
  801074:	6a 00                	push   $0x0
  801076:	53                   	push   %ebx
  801077:	6a 00                	push   $0x0
  801079:	e8 98 fd ff ff       	call   800e16 <sys_page_map>
		if(r < 0)
  80107e:	83 c4 20             	add    $0x20,%esp
  801081:	85 c0                	test   %eax,%eax
  801083:	79 be                	jns    801043 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	68 0b 1c 80 00       	push   $0x801c0b
  80108d:	6a 57                	push   $0x57
  80108f:	68 21 1c 80 00       	push   $0x801c21
  801094:	e8 f3 f0 ff ff       	call   80018c <_panic>
			panic("sys_page_map() panic\n");
  801099:	83 ec 04             	sub    $0x4,%esp
  80109c:	68 0b 1c 80 00       	push   $0x801c0b
  8010a1:	6a 53                	push   $0x53
  8010a3:	68 21 1c 80 00       	push   $0x801c21
  8010a8:	e8 df f0 ff ff       	call   80018c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010ad:	c1 e2 0c             	shl    $0xc,%edx
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 05 08 00 00       	push   $0x805
  8010b8:	52                   	push   %edx
  8010b9:	50                   	push   %eax
  8010ba:	52                   	push   %edx
  8010bb:	6a 00                	push   $0x0
  8010bd:	e8 54 fd ff ff       	call   800e16 <sys_page_map>
		if(r < 0)
  8010c2:	83 c4 20             	add    $0x20,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	0f 89 76 ff ff ff    	jns    801043 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8010cd:	83 ec 04             	sub    $0x4,%esp
  8010d0:	68 0b 1c 80 00       	push   $0x801c0b
  8010d5:	6a 5e                	push   $0x5e
  8010d7:	68 21 1c 80 00       	push   $0x801c21
  8010dc:	e8 ab f0 ff ff       	call   80018c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010e1:	c1 e2 0c             	shl    $0xc,%edx
  8010e4:	83 ec 0c             	sub    $0xc,%esp
  8010e7:	6a 05                	push   $0x5
  8010e9:	52                   	push   %edx
  8010ea:	50                   	push   %eax
  8010eb:	52                   	push   %edx
  8010ec:	6a 00                	push   $0x0
  8010ee:	e8 23 fd ff ff       	call   800e16 <sys_page_map>
		if(r < 0)
  8010f3:	83 c4 20             	add    $0x20,%esp
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	0f 89 45 ff ff ff    	jns    801043 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8010fe:	83 ec 04             	sub    $0x4,%esp
  801101:	68 0b 1c 80 00       	push   $0x801c0b
  801106:	6a 65                	push   $0x65
  801108:	68 21 1c 80 00       	push   $0x801c21
  80110d:	e8 7a f0 ff ff       	call   80018c <_panic>

00801112 <pgfault>:
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	53                   	push   %ebx
  801116:	83 ec 04             	sub    $0x4,%esp
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80111c:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80111e:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801122:	0f 84 99 00 00 00    	je     8011c1 <pgfault+0xaf>
  801128:	89 c2                	mov    %eax,%edx
  80112a:	c1 ea 16             	shr    $0x16,%edx
  80112d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801134:	f6 c2 01             	test   $0x1,%dl
  801137:	0f 84 84 00 00 00    	je     8011c1 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80113d:	89 c2                	mov    %eax,%edx
  80113f:	c1 ea 0c             	shr    $0xc,%edx
  801142:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801149:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80114f:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801155:	75 6a                	jne    8011c1 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801157:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115c:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80115e:	83 ec 04             	sub    $0x4,%esp
  801161:	6a 07                	push   $0x7
  801163:	68 00 f0 7f 00       	push   $0x7ff000
  801168:	6a 00                	push   $0x0
  80116a:	e8 64 fc ff ff       	call   800dd3 <sys_page_alloc>
	if(ret < 0)
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	85 c0                	test   %eax,%eax
  801174:	78 5f                	js     8011d5 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801176:	83 ec 04             	sub    $0x4,%esp
  801179:	68 00 10 00 00       	push   $0x1000
  80117e:	53                   	push   %ebx
  80117f:	68 00 f0 7f 00       	push   $0x7ff000
  801184:	e8 48 fa ff ff       	call   800bd1 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801189:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801190:	53                   	push   %ebx
  801191:	6a 00                	push   $0x0
  801193:	68 00 f0 7f 00       	push   $0x7ff000
  801198:	6a 00                	push   $0x0
  80119a:	e8 77 fc ff ff       	call   800e16 <sys_page_map>
	if(ret < 0)
  80119f:	83 c4 20             	add    $0x20,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	78 43                	js     8011e9 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	68 00 f0 7f 00       	push   $0x7ff000
  8011ae:	6a 00                	push   $0x0
  8011b0:	e8 a3 fc ff ff       	call   800e58 <sys_page_unmap>
	if(ret < 0)
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	78 41                	js     8011fd <pgfault+0xeb>
}
  8011bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    
		panic("panic at pgfault()\n");
  8011c1:	83 ec 04             	sub    $0x4,%esp
  8011c4:	68 2c 1c 80 00       	push   $0x801c2c
  8011c9:	6a 26                	push   $0x26
  8011cb:	68 21 1c 80 00       	push   $0x801c21
  8011d0:	e8 b7 ef ff ff       	call   80018c <_panic>
		panic("panic in sys_page_alloc()\n");
  8011d5:	83 ec 04             	sub    $0x4,%esp
  8011d8:	68 40 1c 80 00       	push   $0x801c40
  8011dd:	6a 31                	push   $0x31
  8011df:	68 21 1c 80 00       	push   $0x801c21
  8011e4:	e8 a3 ef ff ff       	call   80018c <_panic>
		panic("panic in sys_page_map()\n");
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	68 5b 1c 80 00       	push   $0x801c5b
  8011f1:	6a 36                	push   $0x36
  8011f3:	68 21 1c 80 00       	push   $0x801c21
  8011f8:	e8 8f ef ff ff       	call   80018c <_panic>
		panic("panic in sys_page_unmap()\n");
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	68 74 1c 80 00       	push   $0x801c74
  801205:	6a 39                	push   $0x39
  801207:	68 21 1c 80 00       	push   $0x801c21
  80120c:	e8 7b ef ff ff       	call   80018c <_panic>

00801211 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
  801217:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  80121a:	68 12 11 80 00       	push   $0x801112
  80121f:	e8 99 02 00 00       	call   8014bd <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801224:	b8 07 00 00 00       	mov    $0x7,%eax
  801229:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80122b:	83 c4 10             	add    $0x10,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 27                	js     801259 <fork+0x48>
  801232:	89 c6                	mov    %eax,%esi
  801234:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801236:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80123b:	75 48                	jne    801285 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80123d:	e8 53 fb ff ff       	call   800d95 <sys_getenvid>
  801242:	25 ff 03 00 00       	and    $0x3ff,%eax
  801247:	c1 e0 07             	shl    $0x7,%eax
  80124a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80124f:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  801254:	e9 90 00 00 00       	jmp    8012e9 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801259:	83 ec 04             	sub    $0x4,%esp
  80125c:	68 90 1c 80 00       	push   $0x801c90
  801261:	68 85 00 00 00       	push   $0x85
  801266:	68 21 1c 80 00       	push   $0x801c21
  80126b:	e8 1c ef ff ff       	call   80018c <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801270:	89 f8                	mov    %edi,%eax
  801272:	e8 8e fd ff ff       	call   801005 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801277:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80127d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801283:	74 26                	je     8012ab <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801285:	89 d8                	mov    %ebx,%eax
  801287:	c1 e8 16             	shr    $0x16,%eax
  80128a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801291:	a8 01                	test   $0x1,%al
  801293:	74 e2                	je     801277 <fork+0x66>
  801295:	89 da                	mov    %ebx,%edx
  801297:	c1 ea 0c             	shr    $0xc,%edx
  80129a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012a1:	83 e0 05             	and    $0x5,%eax
  8012a4:	83 f8 05             	cmp    $0x5,%eax
  8012a7:	75 ce                	jne    801277 <fork+0x66>
  8012a9:	eb c5                	jmp    801270 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012ab:	83 ec 04             	sub    $0x4,%esp
  8012ae:	6a 07                	push   $0x7
  8012b0:	68 00 f0 bf ee       	push   $0xeebff000
  8012b5:	56                   	push   %esi
  8012b6:	e8 18 fb ff ff       	call   800dd3 <sys_page_alloc>
	if(ret < 0)
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 31                	js     8012f3 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8012c2:	83 ec 08             	sub    $0x8,%esp
  8012c5:	68 2c 15 80 00       	push   $0x80152c
  8012ca:	56                   	push   %esi
  8012cb:	e8 4e fc ff ff       	call   800f1e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 33                	js     80130a <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	6a 02                	push   $0x2
  8012dc:	56                   	push   %esi
  8012dd:	e8 b8 fb ff ff       	call   800e9a <sys_env_set_status>
	if(ret < 0)
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	78 38                	js     801321 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8012e9:	89 f0                	mov    %esi,%eax
  8012eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ee:	5b                   	pop    %ebx
  8012ef:	5e                   	pop    %esi
  8012f0:	5f                   	pop    %edi
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8012f3:	83 ec 04             	sub    $0x4,%esp
  8012f6:	68 40 1c 80 00       	push   $0x801c40
  8012fb:	68 91 00 00 00       	push   $0x91
  801300:	68 21 1c 80 00       	push   $0x801c21
  801305:	e8 82 ee ff ff       	call   80018c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80130a:	83 ec 04             	sub    $0x4,%esp
  80130d:	68 b4 1c 80 00       	push   $0x801cb4
  801312:	68 94 00 00 00       	push   $0x94
  801317:	68 21 1c 80 00       	push   $0x801c21
  80131c:	e8 6b ee ff ff       	call   80018c <_panic>
		panic("panic in sys_env_set_status()\n");
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	68 dc 1c 80 00       	push   $0x801cdc
  801329:	68 97 00 00 00       	push   $0x97
  80132e:	68 21 1c 80 00       	push   $0x801c21
  801333:	e8 54 ee ff ff       	call   80018c <_panic>

00801338 <sfork>:

// Challenge!
int
sfork(void)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	57                   	push   %edi
  80133c:	56                   	push   %esi
  80133d:	53                   	push   %ebx
  80133e:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801341:	a1 08 20 80 00       	mov    0x802008,%eax
  801346:	8b 40 48             	mov    0x48(%eax),%eax
  801349:	68 fc 1c 80 00       	push   $0x801cfc
  80134e:	50                   	push   %eax
  80134f:	68 23 18 80 00       	push   $0x801823
  801354:	e8 29 ef ff ff       	call   800282 <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801359:	c7 04 24 12 11 80 00 	movl   $0x801112,(%esp)
  801360:	e8 58 01 00 00       	call   8014bd <set_pgfault_handler>
  801365:	b8 07 00 00 00       	mov    $0x7,%eax
  80136a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80136c:	83 c4 10             	add    $0x10,%esp
  80136f:	85 c0                	test   %eax,%eax
  801371:	78 27                	js     80139a <sfork+0x62>
  801373:	89 c7                	mov    %eax,%edi
  801375:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801377:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80137c:	75 55                	jne    8013d3 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  80137e:	e8 12 fa ff ff       	call   800d95 <sys_getenvid>
  801383:	25 ff 03 00 00       	and    $0x3ff,%eax
  801388:	c1 e0 07             	shl    $0x7,%eax
  80138b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801390:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  801395:	e9 d4 00 00 00       	jmp    80146e <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	68 90 1c 80 00       	push   $0x801c90
  8013a2:	68 a9 00 00 00       	push   $0xa9
  8013a7:	68 21 1c 80 00       	push   $0x801c21
  8013ac:	e8 db ed ff ff       	call   80018c <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8013b1:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8013b6:	89 f0                	mov    %esi,%eax
  8013b8:	e8 48 fc ff ff       	call   801005 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013bd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013c3:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8013c9:	77 65                	ja     801430 <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  8013cb:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8013d1:	74 de                	je     8013b1 <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8013d3:	89 d8                	mov    %ebx,%eax
  8013d5:	c1 e8 16             	shr    $0x16,%eax
  8013d8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013df:	a8 01                	test   $0x1,%al
  8013e1:	74 da                	je     8013bd <sfork+0x85>
  8013e3:	89 da                	mov    %ebx,%edx
  8013e5:	c1 ea 0c             	shr    $0xc,%edx
  8013e8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013ef:	83 e0 05             	and    $0x5,%eax
  8013f2:	83 f8 05             	cmp    $0x5,%eax
  8013f5:	75 c6                	jne    8013bd <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8013f7:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8013fe:	c1 e2 0c             	shl    $0xc,%edx
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	83 e0 07             	and    $0x7,%eax
  801407:	50                   	push   %eax
  801408:	52                   	push   %edx
  801409:	56                   	push   %esi
  80140a:	52                   	push   %edx
  80140b:	6a 00                	push   $0x0
  80140d:	e8 04 fa ff ff       	call   800e16 <sys_page_map>
  801412:	83 c4 20             	add    $0x20,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	74 a4                	je     8013bd <sfork+0x85>
				panic("sys_page_map() panic\n");
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	68 0b 1c 80 00       	push   $0x801c0b
  801421:	68 b4 00 00 00       	push   $0xb4
  801426:	68 21 1c 80 00       	push   $0x801c21
  80142b:	e8 5c ed ff ff       	call   80018c <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	6a 07                	push   $0x7
  801435:	68 00 f0 bf ee       	push   $0xeebff000
  80143a:	57                   	push   %edi
  80143b:	e8 93 f9 ff ff       	call   800dd3 <sys_page_alloc>
	if(ret < 0)
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	78 31                	js     801478 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801447:	83 ec 08             	sub    $0x8,%esp
  80144a:	68 2c 15 80 00       	push   $0x80152c
  80144f:	57                   	push   %edi
  801450:	e8 c9 fa ff ff       	call   800f1e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	85 c0                	test   %eax,%eax
  80145a:	78 33                	js     80148f <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80145c:	83 ec 08             	sub    $0x8,%esp
  80145f:	6a 02                	push   $0x2
  801461:	57                   	push   %edi
  801462:	e8 33 fa ff ff       	call   800e9a <sys_env_set_status>
	if(ret < 0)
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 38                	js     8014a6 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80146e:	89 f8                	mov    %edi,%eax
  801470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801473:	5b                   	pop    %ebx
  801474:	5e                   	pop    %esi
  801475:	5f                   	pop    %edi
  801476:	5d                   	pop    %ebp
  801477:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	68 40 1c 80 00       	push   $0x801c40
  801480:	68 ba 00 00 00       	push   $0xba
  801485:	68 21 1c 80 00       	push   $0x801c21
  80148a:	e8 fd ec ff ff       	call   80018c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	68 b4 1c 80 00       	push   $0x801cb4
  801497:	68 bd 00 00 00       	push   $0xbd
  80149c:	68 21 1c 80 00       	push   $0x801c21
  8014a1:	e8 e6 ec ff ff       	call   80018c <_panic>
		panic("panic in sys_env_set_status()\n");
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	68 dc 1c 80 00       	push   $0x801cdc
  8014ae:	68 c0 00 00 00       	push   $0xc0
  8014b3:	68 21 1c 80 00       	push   $0x801c21
  8014b8:	e8 cf ec ff ff       	call   80018c <_panic>

008014bd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8014c3:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  8014ca:	74 0a                	je     8014d6 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	6a 07                	push   $0x7
  8014db:	68 00 f0 bf ee       	push   $0xeebff000
  8014e0:	6a 00                	push   $0x0
  8014e2:	e8 ec f8 ff ff       	call   800dd3 <sys_page_alloc>
		if(r < 0)
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 2a                	js     801518 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	68 2c 15 80 00       	push   $0x80152c
  8014f6:	6a 00                	push   $0x0
  8014f8:	e8 21 fa ff ff       	call   800f1e <sys_env_set_pgfault_upcall>
		if(r < 0)
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	79 c8                	jns    8014cc <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	68 34 1d 80 00       	push   $0x801d34
  80150c:	6a 25                	push   $0x25
  80150e:	68 70 1d 80 00       	push   $0x801d70
  801513:	e8 74 ec ff ff       	call   80018c <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	68 04 1d 80 00       	push   $0x801d04
  801520:	6a 22                	push   $0x22
  801522:	68 70 1d 80 00       	push   $0x801d70
  801527:	e8 60 ec ff ff       	call   80018c <_panic>

0080152c <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80152c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80152d:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax
  801532:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801534:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801537:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80153b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80153f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801542:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801544:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801548:	83 c4 08             	add    $0x8,%esp
	popal
  80154b:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80154c:	83 c4 04             	add    $0x4,%esp
	popfl
  80154f:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801550:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801551:	c3                   	ret    
  801552:	66 90                	xchg   %ax,%ax
  801554:	66 90                	xchg   %ax,%ax
  801556:	66 90                	xchg   %ax,%ax
  801558:	66 90                	xchg   %ax,%ax
  80155a:	66 90                	xchg   %ax,%ax
  80155c:	66 90                	xchg   %ax,%ax
  80155e:	66 90                	xchg   %ax,%ax

00801560 <__udivdi3>:
  801560:	55                   	push   %ebp
  801561:	57                   	push   %edi
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	83 ec 1c             	sub    $0x1c,%esp
  801567:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80156b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80156f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801573:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801577:	85 d2                	test   %edx,%edx
  801579:	75 4d                	jne    8015c8 <__udivdi3+0x68>
  80157b:	39 f3                	cmp    %esi,%ebx
  80157d:	76 19                	jbe    801598 <__udivdi3+0x38>
  80157f:	31 ff                	xor    %edi,%edi
  801581:	89 e8                	mov    %ebp,%eax
  801583:	89 f2                	mov    %esi,%edx
  801585:	f7 f3                	div    %ebx
  801587:	89 fa                	mov    %edi,%edx
  801589:	83 c4 1c             	add    $0x1c,%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5f                   	pop    %edi
  80158f:	5d                   	pop    %ebp
  801590:	c3                   	ret    
  801591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801598:	89 d9                	mov    %ebx,%ecx
  80159a:	85 db                	test   %ebx,%ebx
  80159c:	75 0b                	jne    8015a9 <__udivdi3+0x49>
  80159e:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a3:	31 d2                	xor    %edx,%edx
  8015a5:	f7 f3                	div    %ebx
  8015a7:	89 c1                	mov    %eax,%ecx
  8015a9:	31 d2                	xor    %edx,%edx
  8015ab:	89 f0                	mov    %esi,%eax
  8015ad:	f7 f1                	div    %ecx
  8015af:	89 c6                	mov    %eax,%esi
  8015b1:	89 e8                	mov    %ebp,%eax
  8015b3:	89 f7                	mov    %esi,%edi
  8015b5:	f7 f1                	div    %ecx
  8015b7:	89 fa                	mov    %edi,%edx
  8015b9:	83 c4 1c             	add    $0x1c,%esp
  8015bc:	5b                   	pop    %ebx
  8015bd:	5e                   	pop    %esi
  8015be:	5f                   	pop    %edi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    
  8015c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015c8:	39 f2                	cmp    %esi,%edx
  8015ca:	77 1c                	ja     8015e8 <__udivdi3+0x88>
  8015cc:	0f bd fa             	bsr    %edx,%edi
  8015cf:	83 f7 1f             	xor    $0x1f,%edi
  8015d2:	75 2c                	jne    801600 <__udivdi3+0xa0>
  8015d4:	39 f2                	cmp    %esi,%edx
  8015d6:	72 06                	jb     8015de <__udivdi3+0x7e>
  8015d8:	31 c0                	xor    %eax,%eax
  8015da:	39 eb                	cmp    %ebp,%ebx
  8015dc:	77 a9                	ja     801587 <__udivdi3+0x27>
  8015de:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e3:	eb a2                	jmp    801587 <__udivdi3+0x27>
  8015e5:	8d 76 00             	lea    0x0(%esi),%esi
  8015e8:	31 ff                	xor    %edi,%edi
  8015ea:	31 c0                	xor    %eax,%eax
  8015ec:	89 fa                	mov    %edi,%edx
  8015ee:	83 c4 1c             	add    $0x1c,%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5e                   	pop    %esi
  8015f3:	5f                   	pop    %edi
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    
  8015f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8015fd:	8d 76 00             	lea    0x0(%esi),%esi
  801600:	89 f9                	mov    %edi,%ecx
  801602:	b8 20 00 00 00       	mov    $0x20,%eax
  801607:	29 f8                	sub    %edi,%eax
  801609:	d3 e2                	shl    %cl,%edx
  80160b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80160f:	89 c1                	mov    %eax,%ecx
  801611:	89 da                	mov    %ebx,%edx
  801613:	d3 ea                	shr    %cl,%edx
  801615:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801619:	09 d1                	or     %edx,%ecx
  80161b:	89 f2                	mov    %esi,%edx
  80161d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801621:	89 f9                	mov    %edi,%ecx
  801623:	d3 e3                	shl    %cl,%ebx
  801625:	89 c1                	mov    %eax,%ecx
  801627:	d3 ea                	shr    %cl,%edx
  801629:	89 f9                	mov    %edi,%ecx
  80162b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80162f:	89 eb                	mov    %ebp,%ebx
  801631:	d3 e6                	shl    %cl,%esi
  801633:	89 c1                	mov    %eax,%ecx
  801635:	d3 eb                	shr    %cl,%ebx
  801637:	09 de                	or     %ebx,%esi
  801639:	89 f0                	mov    %esi,%eax
  80163b:	f7 74 24 08          	divl   0x8(%esp)
  80163f:	89 d6                	mov    %edx,%esi
  801641:	89 c3                	mov    %eax,%ebx
  801643:	f7 64 24 0c          	mull   0xc(%esp)
  801647:	39 d6                	cmp    %edx,%esi
  801649:	72 15                	jb     801660 <__udivdi3+0x100>
  80164b:	89 f9                	mov    %edi,%ecx
  80164d:	d3 e5                	shl    %cl,%ebp
  80164f:	39 c5                	cmp    %eax,%ebp
  801651:	73 04                	jae    801657 <__udivdi3+0xf7>
  801653:	39 d6                	cmp    %edx,%esi
  801655:	74 09                	je     801660 <__udivdi3+0x100>
  801657:	89 d8                	mov    %ebx,%eax
  801659:	31 ff                	xor    %edi,%edi
  80165b:	e9 27 ff ff ff       	jmp    801587 <__udivdi3+0x27>
  801660:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801663:	31 ff                	xor    %edi,%edi
  801665:	e9 1d ff ff ff       	jmp    801587 <__udivdi3+0x27>
  80166a:	66 90                	xchg   %ax,%ax
  80166c:	66 90                	xchg   %ax,%ax
  80166e:	66 90                	xchg   %ax,%ax

00801670 <__umoddi3>:
  801670:	55                   	push   %ebp
  801671:	57                   	push   %edi
  801672:	56                   	push   %esi
  801673:	53                   	push   %ebx
  801674:	83 ec 1c             	sub    $0x1c,%esp
  801677:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80167b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80167f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801683:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801687:	89 da                	mov    %ebx,%edx
  801689:	85 c0                	test   %eax,%eax
  80168b:	75 43                	jne    8016d0 <__umoddi3+0x60>
  80168d:	39 df                	cmp    %ebx,%edi
  80168f:	76 17                	jbe    8016a8 <__umoddi3+0x38>
  801691:	89 f0                	mov    %esi,%eax
  801693:	f7 f7                	div    %edi
  801695:	89 d0                	mov    %edx,%eax
  801697:	31 d2                	xor    %edx,%edx
  801699:	83 c4 1c             	add    $0x1c,%esp
  80169c:	5b                   	pop    %ebx
  80169d:	5e                   	pop    %esi
  80169e:	5f                   	pop    %edi
  80169f:	5d                   	pop    %ebp
  8016a0:	c3                   	ret    
  8016a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8016a8:	89 fd                	mov    %edi,%ebp
  8016aa:	85 ff                	test   %edi,%edi
  8016ac:	75 0b                	jne    8016b9 <__umoddi3+0x49>
  8016ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b3:	31 d2                	xor    %edx,%edx
  8016b5:	f7 f7                	div    %edi
  8016b7:	89 c5                	mov    %eax,%ebp
  8016b9:	89 d8                	mov    %ebx,%eax
  8016bb:	31 d2                	xor    %edx,%edx
  8016bd:	f7 f5                	div    %ebp
  8016bf:	89 f0                	mov    %esi,%eax
  8016c1:	f7 f5                	div    %ebp
  8016c3:	89 d0                	mov    %edx,%eax
  8016c5:	eb d0                	jmp    801697 <__umoddi3+0x27>
  8016c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8016ce:	66 90                	xchg   %ax,%ax
  8016d0:	89 f1                	mov    %esi,%ecx
  8016d2:	39 d8                	cmp    %ebx,%eax
  8016d4:	76 0a                	jbe    8016e0 <__umoddi3+0x70>
  8016d6:	89 f0                	mov    %esi,%eax
  8016d8:	83 c4 1c             	add    $0x1c,%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5e                   	pop    %esi
  8016dd:	5f                   	pop    %edi
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    
  8016e0:	0f bd e8             	bsr    %eax,%ebp
  8016e3:	83 f5 1f             	xor    $0x1f,%ebp
  8016e6:	75 20                	jne    801708 <__umoddi3+0x98>
  8016e8:	39 d8                	cmp    %ebx,%eax
  8016ea:	0f 82 b0 00 00 00    	jb     8017a0 <__umoddi3+0x130>
  8016f0:	39 f7                	cmp    %esi,%edi
  8016f2:	0f 86 a8 00 00 00    	jbe    8017a0 <__umoddi3+0x130>
  8016f8:	89 c8                	mov    %ecx,%eax
  8016fa:	83 c4 1c             	add    $0x1c,%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5e                   	pop    %esi
  8016ff:	5f                   	pop    %edi
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    
  801702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801708:	89 e9                	mov    %ebp,%ecx
  80170a:	ba 20 00 00 00       	mov    $0x20,%edx
  80170f:	29 ea                	sub    %ebp,%edx
  801711:	d3 e0                	shl    %cl,%eax
  801713:	89 44 24 08          	mov    %eax,0x8(%esp)
  801717:	89 d1                	mov    %edx,%ecx
  801719:	89 f8                	mov    %edi,%eax
  80171b:	d3 e8                	shr    %cl,%eax
  80171d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801721:	89 54 24 04          	mov    %edx,0x4(%esp)
  801725:	8b 54 24 04          	mov    0x4(%esp),%edx
  801729:	09 c1                	or     %eax,%ecx
  80172b:	89 d8                	mov    %ebx,%eax
  80172d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801731:	89 e9                	mov    %ebp,%ecx
  801733:	d3 e7                	shl    %cl,%edi
  801735:	89 d1                	mov    %edx,%ecx
  801737:	d3 e8                	shr    %cl,%eax
  801739:	89 e9                	mov    %ebp,%ecx
  80173b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80173f:	d3 e3                	shl    %cl,%ebx
  801741:	89 c7                	mov    %eax,%edi
  801743:	89 d1                	mov    %edx,%ecx
  801745:	89 f0                	mov    %esi,%eax
  801747:	d3 e8                	shr    %cl,%eax
  801749:	89 e9                	mov    %ebp,%ecx
  80174b:	89 fa                	mov    %edi,%edx
  80174d:	d3 e6                	shl    %cl,%esi
  80174f:	09 d8                	or     %ebx,%eax
  801751:	f7 74 24 08          	divl   0x8(%esp)
  801755:	89 d1                	mov    %edx,%ecx
  801757:	89 f3                	mov    %esi,%ebx
  801759:	f7 64 24 0c          	mull   0xc(%esp)
  80175d:	89 c6                	mov    %eax,%esi
  80175f:	89 d7                	mov    %edx,%edi
  801761:	39 d1                	cmp    %edx,%ecx
  801763:	72 06                	jb     80176b <__umoddi3+0xfb>
  801765:	75 10                	jne    801777 <__umoddi3+0x107>
  801767:	39 c3                	cmp    %eax,%ebx
  801769:	73 0c                	jae    801777 <__umoddi3+0x107>
  80176b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80176f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801773:	89 d7                	mov    %edx,%edi
  801775:	89 c6                	mov    %eax,%esi
  801777:	89 ca                	mov    %ecx,%edx
  801779:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80177e:	29 f3                	sub    %esi,%ebx
  801780:	19 fa                	sbb    %edi,%edx
  801782:	89 d0                	mov    %edx,%eax
  801784:	d3 e0                	shl    %cl,%eax
  801786:	89 e9                	mov    %ebp,%ecx
  801788:	d3 eb                	shr    %cl,%ebx
  80178a:	d3 ea                	shr    %cl,%edx
  80178c:	09 d8                	or     %ebx,%eax
  80178e:	83 c4 1c             	add    $0x1c,%esp
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5f                   	pop    %edi
  801794:	5d                   	pop    %ebp
  801795:	c3                   	ret    
  801796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80179d:	8d 76 00             	lea    0x0(%esi),%esi
  8017a0:	89 da                	mov    %ebx,%edx
  8017a2:	29 fe                	sub    %edi,%esi
  8017a4:	19 c2                	sbb    %eax,%edx
  8017a6:	89 f1                	mov    %esi,%ecx
  8017a8:	89 c8                	mov    %ecx,%eax
  8017aa:	e9 4b ff ff ff       	jmp    8016fa <__umoddi3+0x8a>
