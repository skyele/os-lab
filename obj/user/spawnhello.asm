
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 50 80 00       	mov    0x805008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 60 2b 80 00       	push   $0x802b60
  800047:	e8 e1 01 00 00       	call   80022d <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 7e 2b 80 00       	push   $0x802b7e
  800056:	68 7e 2b 80 00       	push   $0x802b7e
  80005b:	e8 ac 1d 00 00       	call   801e0c <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(hello) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(hello) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 84 2b 80 00       	push   $0x802b84
  80006f:	6a 09                	push   $0x9
  800071:	68 9c 2b 80 00       	push   $0x802b9c
  800076:	e8 bc 00 00 00       	call   800137 <_panic>

0080007b <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	57                   	push   %edi
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800084:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80008b:	00 00 00 
	envid_t find = sys_getenvid();
  80008e:	e8 ad 0c 00 00       	call   800d40 <sys_getenvid>
  800093:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  800099:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80009e:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000a3:	bf 01 00 00 00       	mov    $0x1,%edi
  8000a8:	eb 0b                	jmp    8000b5 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000aa:	83 c2 01             	add    $0x1,%edx
  8000ad:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000b3:	74 21                	je     8000d6 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000b5:	89 d1                	mov    %edx,%ecx
  8000b7:	c1 e1 07             	shl    $0x7,%ecx
  8000ba:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000c0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000c3:	39 c1                	cmp    %eax,%ecx
  8000c5:	75 e3                	jne    8000aa <libmain+0x2f>
  8000c7:	89 d3                	mov    %edx,%ebx
  8000c9:	c1 e3 07             	shl    $0x7,%ebx
  8000cc:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000d2:	89 fe                	mov    %edi,%esi
  8000d4:	eb d4                	jmp    8000aa <libmain+0x2f>
  8000d6:	89 f0                	mov    %esi,%eax
  8000d8:	84 c0                	test   %al,%al
  8000da:	74 06                	je     8000e2 <libmain+0x67>
  8000dc:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e6:	7e 0a                	jle    8000f2 <libmain+0x77>
		binaryname = argv[0];
  8000e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("call umain!\n");
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	68 ae 2b 80 00       	push   $0x802bae
  8000fa:	e8 2e 01 00 00       	call   80022d <cprintf>
	// call user main routine
	umain(argc, argv);
  8000ff:	83 c4 08             	add    $0x8,%esp
  800102:	ff 75 0c             	pushl  0xc(%ebp)
  800105:	ff 75 08             	pushl  0x8(%ebp)
  800108:	e8 26 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80010d:	e8 0b 00 00 00       	call   80011d <exit>
}
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800118:	5b                   	pop    %ebx
  800119:	5e                   	pop    %esi
  80011a:	5f                   	pop    %edi
  80011b:	5d                   	pop    %ebp
  80011c:	c3                   	ret    

0080011d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800123:	e8 03 11 00 00       	call   80122b <close_all>
	sys_env_destroy(0);
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	6a 00                	push   $0x0
  80012d:	e8 cd 0b 00 00       	call   800cff <sys_env_destroy>
}
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	c9                   	leave  
  800136:	c3                   	ret    

00800137 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80013c:	a1 08 50 80 00       	mov    0x805008,%eax
  800141:	8b 40 48             	mov    0x48(%eax),%eax
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 f4 2b 80 00       	push   $0x802bf4
  80014c:	50                   	push   %eax
  80014d:	68 c5 2b 80 00       	push   $0x802bc5
  800152:	e8 d6 00 00 00       	call   80022d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800157:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015a:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800160:	e8 db 0b 00 00       	call   800d40 <sys_getenvid>
  800165:	83 c4 04             	add    $0x4,%esp
  800168:	ff 75 0c             	pushl  0xc(%ebp)
  80016b:	ff 75 08             	pushl  0x8(%ebp)
  80016e:	56                   	push   %esi
  80016f:	50                   	push   %eax
  800170:	68 d0 2b 80 00       	push   $0x802bd0
  800175:	e8 b3 00 00 00       	call   80022d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017a:	83 c4 18             	add    $0x18,%esp
  80017d:	53                   	push   %ebx
  80017e:	ff 75 10             	pushl  0x10(%ebp)
  800181:	e8 56 00 00 00       	call   8001dc <vcprintf>
	cprintf("\n");
  800186:	c7 04 24 b9 2b 80 00 	movl   $0x802bb9,(%esp)
  80018d:	e8 9b 00 00 00       	call   80022d <cprintf>
  800192:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800195:	cc                   	int3   
  800196:	eb fd                	jmp    800195 <_panic+0x5e>

00800198 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	53                   	push   %ebx
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a2:	8b 13                	mov    (%ebx),%edx
  8001a4:	8d 42 01             	lea    0x1(%edx),%eax
  8001a7:	89 03                	mov    %eax,(%ebx)
  8001a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b5:	74 09                	je     8001c0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001be:	c9                   	leave  
  8001bf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	68 ff 00 00 00       	push   $0xff
  8001c8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cb:	50                   	push   %eax
  8001cc:	e8 f1 0a 00 00       	call   800cc2 <sys_cputs>
		b->idx = 0;
  8001d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d7:	83 c4 10             	add    $0x10,%esp
  8001da:	eb db                	jmp    8001b7 <putch+0x1f>

008001dc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ec:	00 00 00 
	b.cnt = 0;
  8001ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f9:	ff 75 0c             	pushl  0xc(%ebp)
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800205:	50                   	push   %eax
  800206:	68 98 01 80 00       	push   $0x800198
  80020b:	e8 4a 01 00 00       	call   80035a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800210:	83 c4 08             	add    $0x8,%esp
  800213:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800219:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021f:	50                   	push   %eax
  800220:	e8 9d 0a 00 00       	call   800cc2 <sys_cputs>

	return b.cnt;
}
  800225:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022b:	c9                   	leave  
  80022c:	c3                   	ret    

0080022d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800233:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800236:	50                   	push   %eax
  800237:	ff 75 08             	pushl  0x8(%ebp)
  80023a:	e8 9d ff ff ff       	call   8001dc <vcprintf>
	va_end(ap);

	return cnt;
}
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	83 ec 1c             	sub    $0x1c,%esp
  80024a:	89 c6                	mov    %eax,%esi
  80024c:	89 d7                	mov    %edx,%edi
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	8b 55 0c             	mov    0xc(%ebp),%edx
  800254:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800257:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80025a:	8b 45 10             	mov    0x10(%ebp),%eax
  80025d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800260:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800264:	74 2c                	je     800292 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800266:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800269:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800270:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800273:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800276:	39 c2                	cmp    %eax,%edx
  800278:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80027b:	73 43                	jae    8002c0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80027d:	83 eb 01             	sub    $0x1,%ebx
  800280:	85 db                	test   %ebx,%ebx
  800282:	7e 6c                	jle    8002f0 <printnum+0xaf>
				putch(padc, putdat);
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	57                   	push   %edi
  800288:	ff 75 18             	pushl  0x18(%ebp)
  80028b:	ff d6                	call   *%esi
  80028d:	83 c4 10             	add    $0x10,%esp
  800290:	eb eb                	jmp    80027d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 20                	push   $0x20
  800297:	6a 00                	push   $0x0
  800299:	50                   	push   %eax
  80029a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029d:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a0:	89 fa                	mov    %edi,%edx
  8002a2:	89 f0                	mov    %esi,%eax
  8002a4:	e8 98 ff ff ff       	call   800241 <printnum>
		while (--width > 0)
  8002a9:	83 c4 20             	add    $0x20,%esp
  8002ac:	83 eb 01             	sub    $0x1,%ebx
  8002af:	85 db                	test   %ebx,%ebx
  8002b1:	7e 65                	jle    800318 <printnum+0xd7>
			putch(padc, putdat);
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	57                   	push   %edi
  8002b7:	6a 20                	push   $0x20
  8002b9:	ff d6                	call   *%esi
  8002bb:	83 c4 10             	add    $0x10,%esp
  8002be:	eb ec                	jmp    8002ac <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	ff 75 18             	pushl  0x18(%ebp)
  8002c6:	83 eb 01             	sub    $0x1,%ebx
  8002c9:	53                   	push   %ebx
  8002ca:	50                   	push   %eax
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002da:	e8 21 26 00 00       	call   802900 <__udivdi3>
  8002df:	83 c4 18             	add    $0x18,%esp
  8002e2:	52                   	push   %edx
  8002e3:	50                   	push   %eax
  8002e4:	89 fa                	mov    %edi,%edx
  8002e6:	89 f0                	mov    %esi,%eax
  8002e8:	e8 54 ff ff ff       	call   800241 <printnum>
  8002ed:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	57                   	push   %edi
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8002fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800300:	ff 75 e0             	pushl  -0x20(%ebp)
  800303:	e8 08 27 00 00       	call   802a10 <__umoddi3>
  800308:	83 c4 14             	add    $0x14,%esp
  80030b:	0f be 80 fb 2b 80 00 	movsbl 0x802bfb(%eax),%eax
  800312:	50                   	push   %eax
  800313:	ff d6                	call   *%esi
  800315:	83 c4 10             	add    $0x10,%esp
	}
}
  800318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800326:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80032a:	8b 10                	mov    (%eax),%edx
  80032c:	3b 50 04             	cmp    0x4(%eax),%edx
  80032f:	73 0a                	jae    80033b <sprintputch+0x1b>
		*b->buf++ = ch;
  800331:	8d 4a 01             	lea    0x1(%edx),%ecx
  800334:	89 08                	mov    %ecx,(%eax)
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	88 02                	mov    %al,(%edx)
}
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    

0080033d <printfmt>:
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800343:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800346:	50                   	push   %eax
  800347:	ff 75 10             	pushl  0x10(%ebp)
  80034a:	ff 75 0c             	pushl  0xc(%ebp)
  80034d:	ff 75 08             	pushl  0x8(%ebp)
  800350:	e8 05 00 00 00       	call   80035a <vprintfmt>
}
  800355:	83 c4 10             	add    $0x10,%esp
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <vprintfmt>:
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	57                   	push   %edi
  80035e:	56                   	push   %esi
  80035f:	53                   	push   %ebx
  800360:	83 ec 3c             	sub    $0x3c,%esp
  800363:	8b 75 08             	mov    0x8(%ebp),%esi
  800366:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800369:	8b 7d 10             	mov    0x10(%ebp),%edi
  80036c:	e9 32 04 00 00       	jmp    8007a3 <vprintfmt+0x449>
		padc = ' ';
  800371:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800375:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80037c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800383:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80038a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800391:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800398:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	8d 47 01             	lea    0x1(%edi),%eax
  8003a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a3:	0f b6 17             	movzbl (%edi),%edx
  8003a6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a9:	3c 55                	cmp    $0x55,%al
  8003ab:	0f 87 12 05 00 00    	ja     8008c3 <vprintfmt+0x569>
  8003b1:	0f b6 c0             	movzbl %al,%eax
  8003b4:	ff 24 85 e0 2d 80 00 	jmp    *0x802de0(,%eax,4)
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003be:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003c2:	eb d9                	jmp    80039d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003cb:	eb d0                	jmp    80039d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003cd:	0f b6 d2             	movzbl %dl,%edx
  8003d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	89 75 08             	mov    %esi,0x8(%ebp)
  8003db:	eb 03                	jmp    8003e0 <vprintfmt+0x86>
  8003dd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003e3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ea:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ed:	83 fe 09             	cmp    $0x9,%esi
  8003f0:	76 eb                	jbe    8003dd <vprintfmt+0x83>
  8003f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f8:	eb 14                	jmp    80040e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 40 04             	lea    0x4(%eax),%eax
  800408:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80040e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800412:	79 89                	jns    80039d <vprintfmt+0x43>
				width = precision, precision = -1;
  800414:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800417:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800421:	e9 77 ff ff ff       	jmp    80039d <vprintfmt+0x43>
  800426:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	0f 48 c1             	cmovs  %ecx,%eax
  80042e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800431:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800434:	e9 64 ff ff ff       	jmp    80039d <vprintfmt+0x43>
  800439:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80043c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800443:	e9 55 ff ff ff       	jmp    80039d <vprintfmt+0x43>
			lflag++;
  800448:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044f:	e9 49 ff ff ff       	jmp    80039d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 78 04             	lea    0x4(%eax),%edi
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	53                   	push   %ebx
  80045e:	ff 30                	pushl  (%eax)
  800460:	ff d6                	call   *%esi
			break;
  800462:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800468:	e9 33 03 00 00       	jmp    8007a0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8d 78 04             	lea    0x4(%eax),%edi
  800473:	8b 00                	mov    (%eax),%eax
  800475:	99                   	cltd   
  800476:	31 d0                	xor    %edx,%eax
  800478:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047a:	83 f8 10             	cmp    $0x10,%eax
  80047d:	7f 23                	jg     8004a2 <vprintfmt+0x148>
  80047f:	8b 14 85 40 2f 80 00 	mov    0x802f40(,%eax,4),%edx
  800486:	85 d2                	test   %edx,%edx
  800488:	74 18                	je     8004a2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80048a:	52                   	push   %edx
  80048b:	68 59 30 80 00       	push   $0x803059
  800490:	53                   	push   %ebx
  800491:	56                   	push   %esi
  800492:	e8 a6 fe ff ff       	call   80033d <printfmt>
  800497:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049d:	e9 fe 02 00 00       	jmp    8007a0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004a2:	50                   	push   %eax
  8004a3:	68 13 2c 80 00       	push   $0x802c13
  8004a8:	53                   	push   %ebx
  8004a9:	56                   	push   %esi
  8004aa:	e8 8e fe ff ff       	call   80033d <printfmt>
  8004af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b5:	e9 e6 02 00 00       	jmp    8007a0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	83 c0 04             	add    $0x4,%eax
  8004c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004c8:	85 c9                	test   %ecx,%ecx
  8004ca:	b8 0c 2c 80 00       	mov    $0x802c0c,%eax
  8004cf:	0f 45 c1             	cmovne %ecx,%eax
  8004d2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d9:	7e 06                	jle    8004e1 <vprintfmt+0x187>
  8004db:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004df:	75 0d                	jne    8004ee <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	03 45 e0             	add    -0x20(%ebp),%eax
  8004e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ec:	eb 53                	jmp    800541 <vprintfmt+0x1e7>
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	e8 71 04 00 00       	call   80096b <strnlen>
  8004fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004fd:	29 c1                	sub    %eax,%ecx
  8004ff:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800507:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80050b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80050e:	eb 0f                	jmp    80051f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	ff 75 e0             	pushl  -0x20(%ebp)
  800517:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800519:	83 ef 01             	sub    $0x1,%edi
  80051c:	83 c4 10             	add    $0x10,%esp
  80051f:	85 ff                	test   %edi,%edi
  800521:	7f ed                	jg     800510 <vprintfmt+0x1b6>
  800523:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800526:	85 c9                	test   %ecx,%ecx
  800528:	b8 00 00 00 00       	mov    $0x0,%eax
  80052d:	0f 49 c1             	cmovns %ecx,%eax
  800530:	29 c1                	sub    %eax,%ecx
  800532:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800535:	eb aa                	jmp    8004e1 <vprintfmt+0x187>
					putch(ch, putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	53                   	push   %ebx
  80053b:	52                   	push   %edx
  80053c:	ff d6                	call   *%esi
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800544:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800546:	83 c7 01             	add    $0x1,%edi
  800549:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80054d:	0f be d0             	movsbl %al,%edx
  800550:	85 d2                	test   %edx,%edx
  800552:	74 4b                	je     80059f <vprintfmt+0x245>
  800554:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800558:	78 06                	js     800560 <vprintfmt+0x206>
  80055a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80055e:	78 1e                	js     80057e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800560:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800564:	74 d1                	je     800537 <vprintfmt+0x1dd>
  800566:	0f be c0             	movsbl %al,%eax
  800569:	83 e8 20             	sub    $0x20,%eax
  80056c:	83 f8 5e             	cmp    $0x5e,%eax
  80056f:	76 c6                	jbe    800537 <vprintfmt+0x1dd>
					putch('?', putdat);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	53                   	push   %ebx
  800575:	6a 3f                	push   $0x3f
  800577:	ff d6                	call   *%esi
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	eb c3                	jmp    800541 <vprintfmt+0x1e7>
  80057e:	89 cf                	mov    %ecx,%edi
  800580:	eb 0e                	jmp    800590 <vprintfmt+0x236>
				putch(' ', putdat);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	53                   	push   %ebx
  800586:	6a 20                	push   $0x20
  800588:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80058a:	83 ef 01             	sub    $0x1,%edi
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	85 ff                	test   %edi,%edi
  800592:	7f ee                	jg     800582 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800594:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
  80059a:	e9 01 02 00 00       	jmp    8007a0 <vprintfmt+0x446>
  80059f:	89 cf                	mov    %ecx,%edi
  8005a1:	eb ed                	jmp    800590 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005a6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005ad:	e9 eb fd ff ff       	jmp    80039d <vprintfmt+0x43>
	if (lflag >= 2)
  8005b2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005b6:	7f 21                	jg     8005d9 <vprintfmt+0x27f>
	else if (lflag)
  8005b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005bc:	74 68                	je     800626 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c6:	89 c1                	mov    %eax,%ecx
  8005c8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005cb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8d 40 04             	lea    0x4(%eax),%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d7:	eb 17                	jmp    8005f0 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8b 50 04             	mov    0x4(%eax),%edx
  8005df:	8b 00                	mov    (%eax),%eax
  8005e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 08             	lea    0x8(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800600:	78 3f                	js     800641 <vprintfmt+0x2e7>
			base = 10;
  800602:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800607:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80060b:	0f 84 71 01 00 00    	je     800782 <vprintfmt+0x428>
				putch('+', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 2b                	push   $0x2b
  800617:	ff d6                	call   *%esi
  800619:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800621:	e9 5c 01 00 00       	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80062e:	89 c1                	mov    %eax,%ecx
  800630:	c1 f9 1f             	sar    $0x1f,%ecx
  800633:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
  80063f:	eb af                	jmp    8005f0 <vprintfmt+0x296>
				putch('-', putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	53                   	push   %ebx
  800645:	6a 2d                	push   $0x2d
  800647:	ff d6                	call   *%esi
				num = -(long long) num;
  800649:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80064c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064f:	f7 d8                	neg    %eax
  800651:	83 d2 00             	adc    $0x0,%edx
  800654:	f7 da                	neg    %edx
  800656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800659:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80065f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800664:	e9 19 01 00 00       	jmp    800782 <vprintfmt+0x428>
	if (lflag >= 2)
  800669:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066d:	7f 29                	jg     800698 <vprintfmt+0x33e>
	else if (lflag)
  80066f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800673:	74 44                	je     8006b9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	ba 00 00 00 00       	mov    $0x0,%edx
  80067f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800693:	e9 ea 00 00 00       	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 50 04             	mov    0x4(%eax),%edx
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8d 40 08             	lea    0x8(%eax),%eax
  8006ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b4:	e9 c9 00 00 00       	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8d 40 04             	lea    0x4(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d7:	e9 a6 00 00 00       	jmp    800782 <vprintfmt+0x428>
			putch('0', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	53                   	push   %ebx
  8006e0:	6a 30                	push   $0x30
  8006e2:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006eb:	7f 26                	jg     800713 <vprintfmt+0x3b9>
	else if (lflag)
  8006ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f1:	74 3e                	je     800731 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800700:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070c:	b8 08 00 00 00       	mov    $0x8,%eax
  800711:	eb 6f                	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 50 04             	mov    0x4(%eax),%edx
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 40 08             	lea    0x8(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072a:	b8 08 00 00 00       	mov    $0x8,%eax
  80072f:	eb 51                	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
  80073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8d 40 04             	lea    0x4(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074a:	b8 08 00 00 00       	mov    $0x8,%eax
  80074f:	eb 31                	jmp    800782 <vprintfmt+0x428>
			putch('0', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	53                   	push   %ebx
  800755:	6a 30                	push   $0x30
  800757:	ff d6                	call   *%esi
			putch('x', putdat);
  800759:	83 c4 08             	add    $0x8,%esp
  80075c:	53                   	push   %ebx
  80075d:	6a 78                	push   $0x78
  80075f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	ba 00 00 00 00       	mov    $0x0,%edx
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800771:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 40 04             	lea    0x4(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800782:	83 ec 0c             	sub    $0xc,%esp
  800785:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800789:	52                   	push   %edx
  80078a:	ff 75 e0             	pushl  -0x20(%ebp)
  80078d:	50                   	push   %eax
  80078e:	ff 75 dc             	pushl  -0x24(%ebp)
  800791:	ff 75 d8             	pushl  -0x28(%ebp)
  800794:	89 da                	mov    %ebx,%edx
  800796:	89 f0                	mov    %esi,%eax
  800798:	e8 a4 fa ff ff       	call   800241 <printnum>
			break;
  80079d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a3:	83 c7 01             	add    $0x1,%edi
  8007a6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007aa:	83 f8 25             	cmp    $0x25,%eax
  8007ad:	0f 84 be fb ff ff    	je     800371 <vprintfmt+0x17>
			if (ch == '\0')
  8007b3:	85 c0                	test   %eax,%eax
  8007b5:	0f 84 28 01 00 00    	je     8008e3 <vprintfmt+0x589>
			putch(ch, putdat);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	50                   	push   %eax
  8007c0:	ff d6                	call   *%esi
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	eb dc                	jmp    8007a3 <vprintfmt+0x449>
	if (lflag >= 2)
  8007c7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007cb:	7f 26                	jg     8007f3 <vprintfmt+0x499>
	else if (lflag)
  8007cd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007d1:	74 41                	je     800814 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ec:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f1:	eb 8f                	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 50 04             	mov    0x4(%eax),%edx
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8d 40 08             	lea    0x8(%eax),%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080a:	b8 10 00 00 00       	mov    $0x10,%eax
  80080f:	e9 6e ff ff ff       	jmp    800782 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800821:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8d 40 04             	lea    0x4(%eax),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082d:	b8 10 00 00 00       	mov    $0x10,%eax
  800832:	e9 4b ff ff ff       	jmp    800782 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	83 c0 04             	add    $0x4,%eax
  80083d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	85 c0                	test   %eax,%eax
  800847:	74 14                	je     80085d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800849:	8b 13                	mov    (%ebx),%edx
  80084b:	83 fa 7f             	cmp    $0x7f,%edx
  80084e:	7f 37                	jg     800887 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800850:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800852:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
  800858:	e9 43 ff ff ff       	jmp    8007a0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80085d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800862:	bf 31 2d 80 00       	mov    $0x802d31,%edi
							putch(ch, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	53                   	push   %ebx
  80086b:	50                   	push   %eax
  80086c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80086e:	83 c7 01             	add    $0x1,%edi
  800871:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	85 c0                	test   %eax,%eax
  80087a:	75 eb                	jne    800867 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80087c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
  800882:	e9 19 ff ff ff       	jmp    8007a0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800887:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800889:	b8 0a 00 00 00       	mov    $0xa,%eax
  80088e:	bf 69 2d 80 00       	mov    $0x802d69,%edi
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
  8008a6:	75 eb                	jne    800893 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ae:	e9 ed fe ff ff       	jmp    8007a0 <vprintfmt+0x446>
			putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	53                   	push   %ebx
  8008b7:	6a 25                	push   $0x25
  8008b9:	ff d6                	call   *%esi
			break;
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	e9 dd fe ff ff       	jmp    8007a0 <vprintfmt+0x446>
			putch('%', putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	53                   	push   %ebx
  8008c7:	6a 25                	push   $0x25
  8008c9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	89 f8                	mov    %edi,%eax
  8008d0:	eb 03                	jmp    8008d5 <vprintfmt+0x57b>
  8008d2:	83 e8 01             	sub    $0x1,%eax
  8008d5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008d9:	75 f7                	jne    8008d2 <vprintfmt+0x578>
  8008db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008de:	e9 bd fe ff ff       	jmp    8007a0 <vprintfmt+0x446>
}
  8008e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e6:	5b                   	pop    %ebx
  8008e7:	5e                   	pop    %esi
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008fa:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fe:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800901:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800908:	85 c0                	test   %eax,%eax
  80090a:	74 26                	je     800932 <vsnprintf+0x47>
  80090c:	85 d2                	test   %edx,%edx
  80090e:	7e 22                	jle    800932 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800910:	ff 75 14             	pushl  0x14(%ebp)
  800913:	ff 75 10             	pushl  0x10(%ebp)
  800916:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800919:	50                   	push   %eax
  80091a:	68 20 03 80 00       	push   $0x800320
  80091f:	e8 36 fa ff ff       	call   80035a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800927:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092d:	83 c4 10             	add    $0x10,%esp
}
  800930:	c9                   	leave  
  800931:	c3                   	ret    
		return -E_INVAL;
  800932:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800937:	eb f7                	jmp    800930 <vsnprintf+0x45>

00800939 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800942:	50                   	push   %eax
  800943:	ff 75 10             	pushl  0x10(%ebp)
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	ff 75 08             	pushl  0x8(%ebp)
  80094c:	e8 9a ff ff ff       	call   8008eb <vsnprintf>
	va_end(ap);

	return rc;
}
  800951:	c9                   	leave  
  800952:	c3                   	ret    

00800953 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
  80095e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800962:	74 05                	je     800969 <strlen+0x16>
		n++;
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	eb f5                	jmp    80095e <strlen+0xb>
	return n;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800971:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800974:	ba 00 00 00 00       	mov    $0x0,%edx
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	74 0d                	je     80098a <strnlen+0x1f>
  80097d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800981:	74 05                	je     800988 <strnlen+0x1d>
		n++;
  800983:	83 c2 01             	add    $0x1,%edx
  800986:	eb f1                	jmp    800979 <strnlen+0xe>
  800988:	89 d0                	mov    %edx,%eax
	return n;
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800996:	ba 00 00 00 00       	mov    $0x0,%edx
  80099b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80099f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009a2:	83 c2 01             	add    $0x1,%edx
  8009a5:	84 c9                	test   %cl,%cl
  8009a7:	75 f2                	jne    80099b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009a9:	5b                   	pop    %ebx
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	53                   	push   %ebx
  8009b0:	83 ec 10             	sub    $0x10,%esp
  8009b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009b6:	53                   	push   %ebx
  8009b7:	e8 97 ff ff ff       	call   800953 <strlen>
  8009bc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	01 d8                	add    %ebx,%eax
  8009c4:	50                   	push   %eax
  8009c5:	e8 c2 ff ff ff       	call   80098c <strcpy>
	return dst;
}
  8009ca:	89 d8                	mov    %ebx,%eax
  8009cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009dc:	89 c6                	mov    %eax,%esi
  8009de:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	39 f2                	cmp    %esi,%edx
  8009e5:	74 11                	je     8009f8 <strncpy+0x27>
		*dst++ = *src;
  8009e7:	83 c2 01             	add    $0x1,%edx
  8009ea:	0f b6 19             	movzbl (%ecx),%ebx
  8009ed:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009f0:	80 fb 01             	cmp    $0x1,%bl
  8009f3:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009f6:	eb eb                	jmp    8009e3 <strncpy+0x12>
	}
	return ret;
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	56                   	push   %esi
  800a00:	53                   	push   %ebx
  800a01:	8b 75 08             	mov    0x8(%ebp),%esi
  800a04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a07:	8b 55 10             	mov    0x10(%ebp),%edx
  800a0a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a0c:	85 d2                	test   %edx,%edx
  800a0e:	74 21                	je     800a31 <strlcpy+0x35>
  800a10:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a14:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a16:	39 c2                	cmp    %eax,%edx
  800a18:	74 14                	je     800a2e <strlcpy+0x32>
  800a1a:	0f b6 19             	movzbl (%ecx),%ebx
  800a1d:	84 db                	test   %bl,%bl
  800a1f:	74 0b                	je     800a2c <strlcpy+0x30>
			*dst++ = *src++;
  800a21:	83 c1 01             	add    $0x1,%ecx
  800a24:	83 c2 01             	add    $0x1,%edx
  800a27:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a2a:	eb ea                	jmp    800a16 <strlcpy+0x1a>
  800a2c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a2e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a31:	29 f0                	sub    %esi,%eax
}
  800a33:	5b                   	pop    %ebx
  800a34:	5e                   	pop    %esi
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a40:	0f b6 01             	movzbl (%ecx),%eax
  800a43:	84 c0                	test   %al,%al
  800a45:	74 0c                	je     800a53 <strcmp+0x1c>
  800a47:	3a 02                	cmp    (%edx),%al
  800a49:	75 08                	jne    800a53 <strcmp+0x1c>
		p++, q++;
  800a4b:	83 c1 01             	add    $0x1,%ecx
  800a4e:	83 c2 01             	add    $0x1,%edx
  800a51:	eb ed                	jmp    800a40 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a53:	0f b6 c0             	movzbl %al,%eax
  800a56:	0f b6 12             	movzbl (%edx),%edx
  800a59:	29 d0                	sub    %edx,%eax
}
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a67:	89 c3                	mov    %eax,%ebx
  800a69:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a6c:	eb 06                	jmp    800a74 <strncmp+0x17>
		n--, p++, q++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a74:	39 d8                	cmp    %ebx,%eax
  800a76:	74 16                	je     800a8e <strncmp+0x31>
  800a78:	0f b6 08             	movzbl (%eax),%ecx
  800a7b:	84 c9                	test   %cl,%cl
  800a7d:	74 04                	je     800a83 <strncmp+0x26>
  800a7f:	3a 0a                	cmp    (%edx),%cl
  800a81:	74 eb                	je     800a6e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a83:	0f b6 00             	movzbl (%eax),%eax
  800a86:	0f b6 12             	movzbl (%edx),%edx
  800a89:	29 d0                	sub    %edx,%eax
}
  800a8b:	5b                   	pop    %ebx
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    
		return 0;
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a93:	eb f6                	jmp    800a8b <strncmp+0x2e>

00800a95 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9f:	0f b6 10             	movzbl (%eax),%edx
  800aa2:	84 d2                	test   %dl,%dl
  800aa4:	74 09                	je     800aaf <strchr+0x1a>
		if (*s == c)
  800aa6:	38 ca                	cmp    %cl,%dl
  800aa8:	74 0a                	je     800ab4 <strchr+0x1f>
	for (; *s; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	eb f0                	jmp    800a9f <strchr+0xa>
			return (char *) s;
	return 0;
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ac3:	38 ca                	cmp    %cl,%dl
  800ac5:	74 09                	je     800ad0 <strfind+0x1a>
  800ac7:	84 d2                	test   %dl,%dl
  800ac9:	74 05                	je     800ad0 <strfind+0x1a>
	for (; *s; s++)
  800acb:	83 c0 01             	add    $0x1,%eax
  800ace:	eb f0                	jmp    800ac0 <strfind+0xa>
			break;
	return (char *) s;
}
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    

00800ad2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	57                   	push   %edi
  800ad6:	56                   	push   %esi
  800ad7:	53                   	push   %ebx
  800ad8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ade:	85 c9                	test   %ecx,%ecx
  800ae0:	74 31                	je     800b13 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae2:	89 f8                	mov    %edi,%eax
  800ae4:	09 c8                	or     %ecx,%eax
  800ae6:	a8 03                	test   $0x3,%al
  800ae8:	75 23                	jne    800b0d <memset+0x3b>
		c &= 0xFF;
  800aea:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aee:	89 d3                	mov    %edx,%ebx
  800af0:	c1 e3 08             	shl    $0x8,%ebx
  800af3:	89 d0                	mov    %edx,%eax
  800af5:	c1 e0 18             	shl    $0x18,%eax
  800af8:	89 d6                	mov    %edx,%esi
  800afa:	c1 e6 10             	shl    $0x10,%esi
  800afd:	09 f0                	or     %esi,%eax
  800aff:	09 c2                	or     %eax,%edx
  800b01:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b03:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b06:	89 d0                	mov    %edx,%eax
  800b08:	fc                   	cld    
  800b09:	f3 ab                	rep stos %eax,%es:(%edi)
  800b0b:	eb 06                	jmp    800b13 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b10:	fc                   	cld    
  800b11:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b13:	89 f8                	mov    %edi,%eax
  800b15:	5b                   	pop    %ebx
  800b16:	5e                   	pop    %esi
  800b17:	5f                   	pop    %edi
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	57                   	push   %edi
  800b1e:	56                   	push   %esi
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b25:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b28:	39 c6                	cmp    %eax,%esi
  800b2a:	73 32                	jae    800b5e <memmove+0x44>
  800b2c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2f:	39 c2                	cmp    %eax,%edx
  800b31:	76 2b                	jbe    800b5e <memmove+0x44>
		s += n;
		d += n;
  800b33:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b36:	89 fe                	mov    %edi,%esi
  800b38:	09 ce                	or     %ecx,%esi
  800b3a:	09 d6                	or     %edx,%esi
  800b3c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b42:	75 0e                	jne    800b52 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b44:	83 ef 04             	sub    $0x4,%edi
  800b47:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b4a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b4d:	fd                   	std    
  800b4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b50:	eb 09                	jmp    800b5b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b52:	83 ef 01             	sub    $0x1,%edi
  800b55:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b58:	fd                   	std    
  800b59:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b5b:	fc                   	cld    
  800b5c:	eb 1a                	jmp    800b78 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5e:	89 c2                	mov    %eax,%edx
  800b60:	09 ca                	or     %ecx,%edx
  800b62:	09 f2                	or     %esi,%edx
  800b64:	f6 c2 03             	test   $0x3,%dl
  800b67:	75 0a                	jne    800b73 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b69:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b6c:	89 c7                	mov    %eax,%edi
  800b6e:	fc                   	cld    
  800b6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b71:	eb 05                	jmp    800b78 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b73:	89 c7                	mov    %eax,%edi
  800b75:	fc                   	cld    
  800b76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b82:	ff 75 10             	pushl  0x10(%ebp)
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	ff 75 08             	pushl  0x8(%ebp)
  800b8b:	e8 8a ff ff ff       	call   800b1a <memmove>
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	89 c6                	mov    %eax,%esi
  800b9f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba2:	39 f0                	cmp    %esi,%eax
  800ba4:	74 1c                	je     800bc2 <memcmp+0x30>
		if (*s1 != *s2)
  800ba6:	0f b6 08             	movzbl (%eax),%ecx
  800ba9:	0f b6 1a             	movzbl (%edx),%ebx
  800bac:	38 d9                	cmp    %bl,%cl
  800bae:	75 08                	jne    800bb8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb0:	83 c0 01             	add    $0x1,%eax
  800bb3:	83 c2 01             	add    $0x1,%edx
  800bb6:	eb ea                	jmp    800ba2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bb8:	0f b6 c1             	movzbl %cl,%eax
  800bbb:	0f b6 db             	movzbl %bl,%ebx
  800bbe:	29 d8                	sub    %ebx,%eax
  800bc0:	eb 05                	jmp    800bc7 <memcmp+0x35>
	}

	return 0;
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd4:	89 c2                	mov    %eax,%edx
  800bd6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd9:	39 d0                	cmp    %edx,%eax
  800bdb:	73 09                	jae    800be6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bdd:	38 08                	cmp    %cl,(%eax)
  800bdf:	74 05                	je     800be6 <memfind+0x1b>
	for (; s < ends; s++)
  800be1:	83 c0 01             	add    $0x1,%eax
  800be4:	eb f3                	jmp    800bd9 <memfind+0xe>
			break;
	return (void *) s;
}
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf4:	eb 03                	jmp    800bf9 <strtol+0x11>
		s++;
  800bf6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf9:	0f b6 01             	movzbl (%ecx),%eax
  800bfc:	3c 20                	cmp    $0x20,%al
  800bfe:	74 f6                	je     800bf6 <strtol+0xe>
  800c00:	3c 09                	cmp    $0x9,%al
  800c02:	74 f2                	je     800bf6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c04:	3c 2b                	cmp    $0x2b,%al
  800c06:	74 2a                	je     800c32 <strtol+0x4a>
	int neg = 0;
  800c08:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c0d:	3c 2d                	cmp    $0x2d,%al
  800c0f:	74 2b                	je     800c3c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c11:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c17:	75 0f                	jne    800c28 <strtol+0x40>
  800c19:	80 39 30             	cmpb   $0x30,(%ecx)
  800c1c:	74 28                	je     800c46 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c1e:	85 db                	test   %ebx,%ebx
  800c20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c25:	0f 44 d8             	cmove  %eax,%ebx
  800c28:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c30:	eb 50                	jmp    800c82 <strtol+0x9a>
		s++;
  800c32:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c35:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3a:	eb d5                	jmp    800c11 <strtol+0x29>
		s++, neg = 1;
  800c3c:	83 c1 01             	add    $0x1,%ecx
  800c3f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c44:	eb cb                	jmp    800c11 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c46:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c4a:	74 0e                	je     800c5a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c4c:	85 db                	test   %ebx,%ebx
  800c4e:	75 d8                	jne    800c28 <strtol+0x40>
		s++, base = 8;
  800c50:	83 c1 01             	add    $0x1,%ecx
  800c53:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c58:	eb ce                	jmp    800c28 <strtol+0x40>
		s += 2, base = 16;
  800c5a:	83 c1 02             	add    $0x2,%ecx
  800c5d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c62:	eb c4                	jmp    800c28 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c64:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c67:	89 f3                	mov    %esi,%ebx
  800c69:	80 fb 19             	cmp    $0x19,%bl
  800c6c:	77 29                	ja     800c97 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c6e:	0f be d2             	movsbl %dl,%edx
  800c71:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c74:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c77:	7d 30                	jge    800ca9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c79:	83 c1 01             	add    $0x1,%ecx
  800c7c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c80:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c82:	0f b6 11             	movzbl (%ecx),%edx
  800c85:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c88:	89 f3                	mov    %esi,%ebx
  800c8a:	80 fb 09             	cmp    $0x9,%bl
  800c8d:	77 d5                	ja     800c64 <strtol+0x7c>
			dig = *s - '0';
  800c8f:	0f be d2             	movsbl %dl,%edx
  800c92:	83 ea 30             	sub    $0x30,%edx
  800c95:	eb dd                	jmp    800c74 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c97:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c9a:	89 f3                	mov    %esi,%ebx
  800c9c:	80 fb 19             	cmp    $0x19,%bl
  800c9f:	77 08                	ja     800ca9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ca1:	0f be d2             	movsbl %dl,%edx
  800ca4:	83 ea 37             	sub    $0x37,%edx
  800ca7:	eb cb                	jmp    800c74 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cad:	74 05                	je     800cb4 <strtol+0xcc>
		*endptr = (char *) s;
  800caf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	f7 da                	neg    %edx
  800cb8:	85 ff                	test   %edi,%edi
  800cba:	0f 45 c2             	cmovne %edx,%eax
}
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd3:	89 c3                	mov    %eax,%ebx
  800cd5:	89 c7                	mov    %eax,%edi
  800cd7:	89 c6                	mov    %eax,%esi
  800cd9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf0:	89 d1                	mov    %edx,%ecx
  800cf2:	89 d3                	mov    %edx,%ebx
  800cf4:	89 d7                	mov    %edx,%edi
  800cf6:	89 d6                	mov    %edx,%esi
  800cf8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
  800d05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d08:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d10:	b8 03 00 00 00       	mov    $0x3,%eax
  800d15:	89 cb                	mov    %ecx,%ebx
  800d17:	89 cf                	mov    %ecx,%edi
  800d19:	89 ce                	mov    %ecx,%esi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	50                   	push   %eax
  800d2d:	6a 03                	push   $0x3
  800d2f:	68 84 2f 80 00       	push   $0x802f84
  800d34:	6a 43                	push   $0x43
  800d36:	68 a1 2f 80 00       	push   $0x802fa1
  800d3b:	e8 f7 f3 ff ff       	call   800137 <_panic>

00800d40 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d46:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4b:	b8 02 00 00 00       	mov    $0x2,%eax
  800d50:	89 d1                	mov    %edx,%ecx
  800d52:	89 d3                	mov    %edx,%ebx
  800d54:	89 d7                	mov    %edx,%edi
  800d56:	89 d6                	mov    %edx,%esi
  800d58:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <sys_yield>:

void
sys_yield(void)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d65:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d6f:	89 d1                	mov    %edx,%ecx
  800d71:	89 d3                	mov    %edx,%ebx
  800d73:	89 d7                	mov    %edx,%edi
  800d75:	89 d6                	mov    %edx,%esi
  800d77:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d87:	be 00 00 00 00       	mov    $0x0,%esi
  800d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d92:	b8 04 00 00 00       	mov    $0x4,%eax
  800d97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9a:	89 f7                	mov    %esi,%edi
  800d9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	7f 08                	jg     800daa <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daa:	83 ec 0c             	sub    $0xc,%esp
  800dad:	50                   	push   %eax
  800dae:	6a 04                	push   $0x4
  800db0:	68 84 2f 80 00       	push   $0x802f84
  800db5:	6a 43                	push   $0x43
  800db7:	68 a1 2f 80 00       	push   $0x802fa1
  800dbc:	e8 76 f3 ff ff       	call   800137 <_panic>

00800dc1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	53                   	push   %ebx
  800dc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dca:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd0:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddb:	8b 75 18             	mov    0x18(%ebp),%esi
  800dde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de0:	85 c0                	test   %eax,%eax
  800de2:	7f 08                	jg     800dec <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	50                   	push   %eax
  800df0:	6a 05                	push   $0x5
  800df2:	68 84 2f 80 00       	push   $0x802f84
  800df7:	6a 43                	push   $0x43
  800df9:	68 a1 2f 80 00       	push   $0x802fa1
  800dfe:	e8 34 f3 ff ff       	call   800137 <_panic>

00800e03 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e17:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1c:	89 df                	mov    %ebx,%edi
  800e1e:	89 de                	mov    %ebx,%esi
  800e20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e22:	85 c0                	test   %eax,%eax
  800e24:	7f 08                	jg     800e2e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	6a 06                	push   $0x6
  800e34:	68 84 2f 80 00       	push   $0x802f84
  800e39:	6a 43                	push   $0x43
  800e3b:	68 a1 2f 80 00       	push   $0x802fa1
  800e40:	e8 f2 f2 ff ff       	call   800137 <_panic>

00800e45 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	b8 08 00 00 00       	mov    $0x8,%eax
  800e5e:	89 df                	mov    %ebx,%edi
  800e60:	89 de                	mov    %ebx,%esi
  800e62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7f 08                	jg     800e70 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	50                   	push   %eax
  800e74:	6a 08                	push   $0x8
  800e76:	68 84 2f 80 00       	push   $0x802f84
  800e7b:	6a 43                	push   $0x43
  800e7d:	68 a1 2f 80 00       	push   $0x802fa1
  800e82:	e8 b0 f2 ff ff       	call   800137 <_panic>

00800e87 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea0:	89 df                	mov    %ebx,%edi
  800ea2:	89 de                	mov    %ebx,%esi
  800ea4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	7f 08                	jg     800eb2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	50                   	push   %eax
  800eb6:	6a 09                	push   $0x9
  800eb8:	68 84 2f 80 00       	push   $0x802f84
  800ebd:	6a 43                	push   $0x43
  800ebf:	68 a1 2f 80 00       	push   $0x802fa1
  800ec4:	e8 6e f2 ff ff       	call   800137 <_panic>

00800ec9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee2:	89 df                	mov    %ebx,%edi
  800ee4:	89 de                	mov    %ebx,%esi
  800ee6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	7f 08                	jg     800ef4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef4:	83 ec 0c             	sub    $0xc,%esp
  800ef7:	50                   	push   %eax
  800ef8:	6a 0a                	push   $0xa
  800efa:	68 84 2f 80 00       	push   $0x802f84
  800eff:	6a 43                	push   $0x43
  800f01:	68 a1 2f 80 00       	push   $0x802fa1
  800f06:	e8 2c f2 ff ff       	call   800137 <_panic>

00800f0b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f17:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f1c:	be 00 00 00 00       	mov    $0x0,%esi
  800f21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f24:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f27:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f44:	89 cb                	mov    %ecx,%ebx
  800f46:	89 cf                	mov    %ecx,%edi
  800f48:	89 ce                	mov    %ecx,%esi
  800f4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7f 08                	jg     800f58 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	83 ec 0c             	sub    $0xc,%esp
  800f5b:	50                   	push   %eax
  800f5c:	6a 0d                	push   $0xd
  800f5e:	68 84 2f 80 00       	push   $0x802f84
  800f63:	6a 43                	push   $0x43
  800f65:	68 a1 2f 80 00       	push   $0x802fa1
  800f6a:	e8 c8 f1 ff ff       	call   800137 <_panic>

00800f6f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f85:	89 df                	mov    %ebx,%edi
  800f87:	89 de                	mov    %ebx,%esi
  800f89:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f8b:	5b                   	pop    %ebx
  800f8c:	5e                   	pop    %esi
  800f8d:	5f                   	pop    %edi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	57                   	push   %edi
  800f94:	56                   	push   %esi
  800f95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fa3:	89 cb                	mov    %ecx,%ebx
  800fa5:	89 cf                	mov    %ecx,%edi
  800fa7:	89 ce                	mov    %ecx,%esi
  800fa9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbb:	b8 10 00 00 00       	mov    $0x10,%eax
  800fc0:	89 d1                	mov    %edx,%ecx
  800fc2:	89 d3                	mov    %edx,%ebx
  800fc4:	89 d7                	mov    %edx,%edi
  800fc6:	89 d6                	mov    %edx,%esi
  800fc8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	b8 11 00 00 00       	mov    $0x11,%eax
  800fe5:	89 df                	mov    %ebx,%edi
  800fe7:	89 de                	mov    %ebx,%esi
  800fe9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800feb:	5b                   	pop    %ebx
  800fec:	5e                   	pop    %esi
  800fed:	5f                   	pop    %edi
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	57                   	push   %edi
  800ff4:	56                   	push   %esi
  800ff5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801001:	b8 12 00 00 00       	mov    $0x12,%eax
  801006:	89 df                	mov    %ebx,%edi
  801008:	89 de                	mov    %ebx,%esi
  80100a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
  801017:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80101a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801025:	b8 13 00 00 00       	mov    $0x13,%eax
  80102a:	89 df                	mov    %ebx,%edi
  80102c:	89 de                	mov    %ebx,%esi
  80102e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801030:	85 c0                	test   %eax,%eax
  801032:	7f 08                	jg     80103c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801034:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5f                   	pop    %edi
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103c:	83 ec 0c             	sub    $0xc,%esp
  80103f:	50                   	push   %eax
  801040:	6a 13                	push   $0x13
  801042:	68 84 2f 80 00       	push   $0x802f84
  801047:	6a 43                	push   $0x43
  801049:	68 a1 2f 80 00       	push   $0x802fa1
  80104e:	e8 e4 f0 ff ff       	call   800137 <_panic>

00801053 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	05 00 00 00 30       	add    $0x30000000,%eax
  80105e:	c1 e8 0c             	shr    $0xc,%eax
}
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80106e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801073:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    

0080107a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801082:	89 c2                	mov    %eax,%edx
  801084:	c1 ea 16             	shr    $0x16,%edx
  801087:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80108e:	f6 c2 01             	test   $0x1,%dl
  801091:	74 2d                	je     8010c0 <fd_alloc+0x46>
  801093:	89 c2                	mov    %eax,%edx
  801095:	c1 ea 0c             	shr    $0xc,%edx
  801098:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80109f:	f6 c2 01             	test   $0x1,%dl
  8010a2:	74 1c                	je     8010c0 <fd_alloc+0x46>
  8010a4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010a9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010ae:	75 d2                	jne    801082 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010b9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010be:	eb 0a                	jmp    8010ca <fd_alloc+0x50>
			*fd_store = fd;
  8010c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010d2:	83 f8 1f             	cmp    $0x1f,%eax
  8010d5:	77 30                	ja     801107 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010d7:	c1 e0 0c             	shl    $0xc,%eax
  8010da:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010df:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010e5:	f6 c2 01             	test   $0x1,%dl
  8010e8:	74 24                	je     80110e <fd_lookup+0x42>
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	c1 ea 0c             	shr    $0xc,%edx
  8010ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f6:	f6 c2 01             	test   $0x1,%dl
  8010f9:	74 1a                	je     801115 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    
		return -E_INVAL;
  801107:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110c:	eb f7                	jmp    801105 <fd_lookup+0x39>
		return -E_INVAL;
  80110e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801113:	eb f0                	jmp    801105 <fd_lookup+0x39>
  801115:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111a:	eb e9                	jmp    801105 <fd_lookup+0x39>

0080111c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801125:	ba 00 00 00 00       	mov    $0x0,%edx
  80112a:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80112f:	39 08                	cmp    %ecx,(%eax)
  801131:	74 38                	je     80116b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801133:	83 c2 01             	add    $0x1,%edx
  801136:	8b 04 95 2c 30 80 00 	mov    0x80302c(,%edx,4),%eax
  80113d:	85 c0                	test   %eax,%eax
  80113f:	75 ee                	jne    80112f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801141:	a1 08 50 80 00       	mov    0x805008,%eax
  801146:	8b 40 48             	mov    0x48(%eax),%eax
  801149:	83 ec 04             	sub    $0x4,%esp
  80114c:	51                   	push   %ecx
  80114d:	50                   	push   %eax
  80114e:	68 b0 2f 80 00       	push   $0x802fb0
  801153:	e8 d5 f0 ff ff       	call   80022d <cprintf>
	*dev = 0;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801161:	83 c4 10             	add    $0x10,%esp
  801164:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801169:	c9                   	leave  
  80116a:	c3                   	ret    
			*dev = devtab[i];
  80116b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
  801175:	eb f2                	jmp    801169 <dev_lookup+0x4d>

00801177 <fd_close>:
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	57                   	push   %edi
  80117b:	56                   	push   %esi
  80117c:	53                   	push   %ebx
  80117d:	83 ec 24             	sub    $0x24,%esp
  801180:	8b 75 08             	mov    0x8(%ebp),%esi
  801183:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801186:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801189:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801190:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801193:	50                   	push   %eax
  801194:	e8 33 ff ff ff       	call   8010cc <fd_lookup>
  801199:	89 c3                	mov    %eax,%ebx
  80119b:	83 c4 10             	add    $0x10,%esp
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	78 05                	js     8011a7 <fd_close+0x30>
	    || fd != fd2)
  8011a2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011a5:	74 16                	je     8011bd <fd_close+0x46>
		return (must_exist ? r : 0);
  8011a7:	89 f8                	mov    %edi,%eax
  8011a9:	84 c0                	test   %al,%al
  8011ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b0:	0f 44 d8             	cmove  %eax,%ebx
}
  8011b3:	89 d8                	mov    %ebx,%eax
  8011b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b8:	5b                   	pop    %ebx
  8011b9:	5e                   	pop    %esi
  8011ba:	5f                   	pop    %edi
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011c3:	50                   	push   %eax
  8011c4:	ff 36                	pushl  (%esi)
  8011c6:	e8 51 ff ff ff       	call   80111c <dev_lookup>
  8011cb:	89 c3                	mov    %eax,%ebx
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	78 1a                	js     8011ee <fd_close+0x77>
		if (dev->dev_close)
  8011d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011d7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011da:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	74 0b                	je     8011ee <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011e3:	83 ec 0c             	sub    $0xc,%esp
  8011e6:	56                   	push   %esi
  8011e7:	ff d0                	call   *%eax
  8011e9:	89 c3                	mov    %eax,%ebx
  8011eb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ee:	83 ec 08             	sub    $0x8,%esp
  8011f1:	56                   	push   %esi
  8011f2:	6a 00                	push   $0x0
  8011f4:	e8 0a fc ff ff       	call   800e03 <sys_page_unmap>
	return r;
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	eb b5                	jmp    8011b3 <fd_close+0x3c>

008011fe <close>:

int
close(int fdnum)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801204:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801207:	50                   	push   %eax
  801208:	ff 75 08             	pushl  0x8(%ebp)
  80120b:	e8 bc fe ff ff       	call   8010cc <fd_lookup>
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	79 02                	jns    801219 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    
		return fd_close(fd, 1);
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	6a 01                	push   $0x1
  80121e:	ff 75 f4             	pushl  -0xc(%ebp)
  801221:	e8 51 ff ff ff       	call   801177 <fd_close>
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	eb ec                	jmp    801217 <close+0x19>

0080122b <close_all>:

void
close_all(void)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	53                   	push   %ebx
  80122f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801232:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801237:	83 ec 0c             	sub    $0xc,%esp
  80123a:	53                   	push   %ebx
  80123b:	e8 be ff ff ff       	call   8011fe <close>
	for (i = 0; i < MAXFD; i++)
  801240:	83 c3 01             	add    $0x1,%ebx
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	83 fb 20             	cmp    $0x20,%ebx
  801249:	75 ec                	jne    801237 <close_all+0xc>
}
  80124b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	57                   	push   %edi
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
  801256:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801259:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80125c:	50                   	push   %eax
  80125d:	ff 75 08             	pushl  0x8(%ebp)
  801260:	e8 67 fe ff ff       	call   8010cc <fd_lookup>
  801265:	89 c3                	mov    %eax,%ebx
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	0f 88 81 00 00 00    	js     8012f3 <dup+0xa3>
		return r;
	close(newfdnum);
  801272:	83 ec 0c             	sub    $0xc,%esp
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	e8 81 ff ff ff       	call   8011fe <close>

	newfd = INDEX2FD(newfdnum);
  80127d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801280:	c1 e6 0c             	shl    $0xc,%esi
  801283:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801289:	83 c4 04             	add    $0x4,%esp
  80128c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80128f:	e8 cf fd ff ff       	call   801063 <fd2data>
  801294:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801296:	89 34 24             	mov    %esi,(%esp)
  801299:	e8 c5 fd ff ff       	call   801063 <fd2data>
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012a3:	89 d8                	mov    %ebx,%eax
  8012a5:	c1 e8 16             	shr    $0x16,%eax
  8012a8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012af:	a8 01                	test   $0x1,%al
  8012b1:	74 11                	je     8012c4 <dup+0x74>
  8012b3:	89 d8                	mov    %ebx,%eax
  8012b5:	c1 e8 0c             	shr    $0xc,%eax
  8012b8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012bf:	f6 c2 01             	test   $0x1,%dl
  8012c2:	75 39                	jne    8012fd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012c7:	89 d0                	mov    %edx,%eax
  8012c9:	c1 e8 0c             	shr    $0xc,%eax
  8012cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d3:	83 ec 0c             	sub    $0xc,%esp
  8012d6:	25 07 0e 00 00       	and    $0xe07,%eax
  8012db:	50                   	push   %eax
  8012dc:	56                   	push   %esi
  8012dd:	6a 00                	push   $0x0
  8012df:	52                   	push   %edx
  8012e0:	6a 00                	push   $0x0
  8012e2:	e8 da fa ff ff       	call   800dc1 <sys_page_map>
  8012e7:	89 c3                	mov    %eax,%ebx
  8012e9:	83 c4 20             	add    $0x20,%esp
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	78 31                	js     801321 <dup+0xd1>
		goto err;

	return newfdnum;
  8012f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012f3:	89 d8                	mov    %ebx,%eax
  8012f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f8:	5b                   	pop    %ebx
  8012f9:	5e                   	pop    %esi
  8012fa:	5f                   	pop    %edi
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	25 07 0e 00 00       	and    $0xe07,%eax
  80130c:	50                   	push   %eax
  80130d:	57                   	push   %edi
  80130e:	6a 00                	push   $0x0
  801310:	53                   	push   %ebx
  801311:	6a 00                	push   $0x0
  801313:	e8 a9 fa ff ff       	call   800dc1 <sys_page_map>
  801318:	89 c3                	mov    %eax,%ebx
  80131a:	83 c4 20             	add    $0x20,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	79 a3                	jns    8012c4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801321:	83 ec 08             	sub    $0x8,%esp
  801324:	56                   	push   %esi
  801325:	6a 00                	push   $0x0
  801327:	e8 d7 fa ff ff       	call   800e03 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80132c:	83 c4 08             	add    $0x8,%esp
  80132f:	57                   	push   %edi
  801330:	6a 00                	push   $0x0
  801332:	e8 cc fa ff ff       	call   800e03 <sys_page_unmap>
	return r;
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	eb b7                	jmp    8012f3 <dup+0xa3>

0080133c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	53                   	push   %ebx
  801340:	83 ec 1c             	sub    $0x1c,%esp
  801343:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801346:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801349:	50                   	push   %eax
  80134a:	53                   	push   %ebx
  80134b:	e8 7c fd ff ff       	call   8010cc <fd_lookup>
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	85 c0                	test   %eax,%eax
  801355:	78 3f                	js     801396 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801357:	83 ec 08             	sub    $0x8,%esp
  80135a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135d:	50                   	push   %eax
  80135e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801361:	ff 30                	pushl  (%eax)
  801363:	e8 b4 fd ff ff       	call   80111c <dev_lookup>
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 27                	js     801396 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80136f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801372:	8b 42 08             	mov    0x8(%edx),%eax
  801375:	83 e0 03             	and    $0x3,%eax
  801378:	83 f8 01             	cmp    $0x1,%eax
  80137b:	74 1e                	je     80139b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80137d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801380:	8b 40 08             	mov    0x8(%eax),%eax
  801383:	85 c0                	test   %eax,%eax
  801385:	74 35                	je     8013bc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801387:	83 ec 04             	sub    $0x4,%esp
  80138a:	ff 75 10             	pushl  0x10(%ebp)
  80138d:	ff 75 0c             	pushl  0xc(%ebp)
  801390:	52                   	push   %edx
  801391:	ff d0                	call   *%eax
  801393:	83 c4 10             	add    $0x10,%esp
}
  801396:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801399:	c9                   	leave  
  80139a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80139b:	a1 08 50 80 00       	mov    0x805008,%eax
  8013a0:	8b 40 48             	mov    0x48(%eax),%eax
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	53                   	push   %ebx
  8013a7:	50                   	push   %eax
  8013a8:	68 f1 2f 80 00       	push   $0x802ff1
  8013ad:	e8 7b ee ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ba:	eb da                	jmp    801396 <read+0x5a>
		return -E_NOT_SUPP;
  8013bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c1:	eb d3                	jmp    801396 <read+0x5a>

008013c3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	57                   	push   %edi
  8013c7:	56                   	push   %esi
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 0c             	sub    $0xc,%esp
  8013cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013cf:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d7:	39 f3                	cmp    %esi,%ebx
  8013d9:	73 23                	jae    8013fe <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013db:	83 ec 04             	sub    $0x4,%esp
  8013de:	89 f0                	mov    %esi,%eax
  8013e0:	29 d8                	sub    %ebx,%eax
  8013e2:	50                   	push   %eax
  8013e3:	89 d8                	mov    %ebx,%eax
  8013e5:	03 45 0c             	add    0xc(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	57                   	push   %edi
  8013ea:	e8 4d ff ff ff       	call   80133c <read>
		if (m < 0)
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 06                	js     8013fc <readn+0x39>
			return m;
		if (m == 0)
  8013f6:	74 06                	je     8013fe <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013f8:	01 c3                	add    %eax,%ebx
  8013fa:	eb db                	jmp    8013d7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013fc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013fe:	89 d8                	mov    %ebx,%eax
  801400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801403:	5b                   	pop    %ebx
  801404:	5e                   	pop    %esi
  801405:	5f                   	pop    %edi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	53                   	push   %ebx
  80140c:	83 ec 1c             	sub    $0x1c,%esp
  80140f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801412:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	53                   	push   %ebx
  801417:	e8 b0 fc ff ff       	call   8010cc <fd_lookup>
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 3a                	js     80145d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801429:	50                   	push   %eax
  80142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142d:	ff 30                	pushl  (%eax)
  80142f:	e8 e8 fc ff ff       	call   80111c <dev_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 22                	js     80145d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801442:	74 1e                	je     801462 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801447:	8b 52 0c             	mov    0xc(%edx),%edx
  80144a:	85 d2                	test   %edx,%edx
  80144c:	74 35                	je     801483 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	ff 75 10             	pushl  0x10(%ebp)
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	50                   	push   %eax
  801458:	ff d2                	call   *%edx
  80145a:	83 c4 10             	add    $0x10,%esp
}
  80145d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801460:	c9                   	leave  
  801461:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801462:	a1 08 50 80 00       	mov    0x805008,%eax
  801467:	8b 40 48             	mov    0x48(%eax),%eax
  80146a:	83 ec 04             	sub    $0x4,%esp
  80146d:	53                   	push   %ebx
  80146e:	50                   	push   %eax
  80146f:	68 0d 30 80 00       	push   $0x80300d
  801474:	e8 b4 ed ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  801479:	83 c4 10             	add    $0x10,%esp
  80147c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801481:	eb da                	jmp    80145d <write+0x55>
		return -E_NOT_SUPP;
  801483:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801488:	eb d3                	jmp    80145d <write+0x55>

0080148a <seek>:

int
seek(int fdnum, off_t offset)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801490:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801493:	50                   	push   %eax
  801494:	ff 75 08             	pushl  0x8(%ebp)
  801497:	e8 30 fc ff ff       	call   8010cc <fd_lookup>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 0e                	js     8014b1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 1c             	sub    $0x1c,%esp
  8014ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c0:	50                   	push   %eax
  8014c1:	53                   	push   %ebx
  8014c2:	e8 05 fc ff ff       	call   8010cc <fd_lookup>
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 37                	js     801505 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ce:	83 ec 08             	sub    $0x8,%esp
  8014d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d4:	50                   	push   %eax
  8014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d8:	ff 30                	pushl  (%eax)
  8014da:	e8 3d fc ff ff       	call   80111c <dev_lookup>
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 1f                	js     801505 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ed:	74 1b                	je     80150a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f2:	8b 52 18             	mov    0x18(%edx),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	74 32                	je     80152b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	50                   	push   %eax
  801500:	ff d2                	call   *%edx
  801502:	83 c4 10             	add    $0x10,%esp
}
  801505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801508:	c9                   	leave  
  801509:	c3                   	ret    
			thisenv->env_id, fdnum);
  80150a:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80150f:	8b 40 48             	mov    0x48(%eax),%eax
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	53                   	push   %ebx
  801516:	50                   	push   %eax
  801517:	68 d0 2f 80 00       	push   $0x802fd0
  80151c:	e8 0c ed ff ff       	call   80022d <cprintf>
		return -E_INVAL;
  801521:	83 c4 10             	add    $0x10,%esp
  801524:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801529:	eb da                	jmp    801505 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80152b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801530:	eb d3                	jmp    801505 <ftruncate+0x52>

00801532 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	53                   	push   %ebx
  801536:	83 ec 1c             	sub    $0x1c,%esp
  801539:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	ff 75 08             	pushl  0x8(%ebp)
  801543:	e8 84 fb ff ff       	call   8010cc <fd_lookup>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 4b                	js     80159a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801555:	50                   	push   %eax
  801556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801559:	ff 30                	pushl  (%eax)
  80155b:	e8 bc fb ff ff       	call   80111c <dev_lookup>
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	78 33                	js     80159a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80156e:	74 2f                	je     80159f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801570:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801573:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80157a:	00 00 00 
	stat->st_isdir = 0;
  80157d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801584:	00 00 00 
	stat->st_dev = dev;
  801587:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80158d:	83 ec 08             	sub    $0x8,%esp
  801590:	53                   	push   %ebx
  801591:	ff 75 f0             	pushl  -0x10(%ebp)
  801594:	ff 50 14             	call   *0x14(%eax)
  801597:	83 c4 10             	add    $0x10,%esp
}
  80159a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    
		return -E_NOT_SUPP;
  80159f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a4:	eb f4                	jmp    80159a <fstat+0x68>

008015a6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	56                   	push   %esi
  8015aa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	6a 00                	push   $0x0
  8015b0:	ff 75 08             	pushl  0x8(%ebp)
  8015b3:	e8 22 02 00 00       	call   8017da <open>
  8015b8:	89 c3                	mov    %eax,%ebx
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	78 1b                	js     8015dc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	50                   	push   %eax
  8015c8:	e8 65 ff ff ff       	call   801532 <fstat>
  8015cd:	89 c6                	mov    %eax,%esi
	close(fd);
  8015cf:	89 1c 24             	mov    %ebx,(%esp)
  8015d2:	e8 27 fc ff ff       	call   8011fe <close>
	return r;
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	89 f3                	mov    %esi,%ebx
}
  8015dc:	89 d8                	mov    %ebx,%eax
  8015de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e1:	5b                   	pop    %ebx
  8015e2:	5e                   	pop    %esi
  8015e3:	5d                   	pop    %ebp
  8015e4:	c3                   	ret    

008015e5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	56                   	push   %esi
  8015e9:	53                   	push   %ebx
  8015ea:	89 c6                	mov    %eax,%esi
  8015ec:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ee:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8015f5:	74 27                	je     80161e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015f7:	6a 07                	push   $0x7
  8015f9:	68 00 60 80 00       	push   $0x806000
  8015fe:	56                   	push   %esi
  8015ff:	ff 35 00 50 80 00    	pushl  0x805000
  801605:	e8 24 12 00 00       	call   80282e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80160a:	83 c4 0c             	add    $0xc,%esp
  80160d:	6a 00                	push   $0x0
  80160f:	53                   	push   %ebx
  801610:	6a 00                	push   $0x0
  801612:	e8 ae 11 00 00       	call   8027c5 <ipc_recv>
}
  801617:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	6a 01                	push   $0x1
  801623:	e8 5e 12 00 00       	call   802886 <ipc_find_env>
  801628:	a3 00 50 80 00       	mov    %eax,0x805000
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	eb c5                	jmp    8015f7 <fsipc+0x12>

00801632 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	8b 40 0c             	mov    0xc(%eax),%eax
  80163e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801643:	8b 45 0c             	mov    0xc(%ebp),%eax
  801646:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80164b:	ba 00 00 00 00       	mov    $0x0,%edx
  801650:	b8 02 00 00 00       	mov    $0x2,%eax
  801655:	e8 8b ff ff ff       	call   8015e5 <fsipc>
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <devfile_flush>:
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8b 40 0c             	mov    0xc(%eax),%eax
  801668:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80166d:	ba 00 00 00 00       	mov    $0x0,%edx
  801672:	b8 06 00 00 00       	mov    $0x6,%eax
  801677:	e8 69 ff ff ff       	call   8015e5 <fsipc>
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <devfile_stat>:
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	53                   	push   %ebx
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 40 0c             	mov    0xc(%eax),%eax
  80168e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801693:	ba 00 00 00 00       	mov    $0x0,%edx
  801698:	b8 05 00 00 00       	mov    $0x5,%eax
  80169d:	e8 43 ff ff ff       	call   8015e5 <fsipc>
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	78 2c                	js     8016d2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016a6:	83 ec 08             	sub    $0x8,%esp
  8016a9:	68 00 60 80 00       	push   $0x806000
  8016ae:	53                   	push   %ebx
  8016af:	e8 d8 f2 ff ff       	call   80098c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016b4:	a1 80 60 80 00       	mov    0x806080,%eax
  8016b9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016bf:	a1 84 60 80 00       	mov    0x806084,%eax
  8016c4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <devfile_write>:
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	53                   	push   %ebx
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8016ec:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016f2:	53                   	push   %ebx
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	68 08 60 80 00       	push   $0x806008
  8016fb:	e8 7c f4 ff ff       	call   800b7c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	b8 04 00 00 00       	mov    $0x4,%eax
  80170a:	e8 d6 fe ff ff       	call   8015e5 <fsipc>
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	85 c0                	test   %eax,%eax
  801714:	78 0b                	js     801721 <devfile_write+0x4a>
	assert(r <= n);
  801716:	39 d8                	cmp    %ebx,%eax
  801718:	77 0c                	ja     801726 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80171a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80171f:	7f 1e                	jg     80173f <devfile_write+0x68>
}
  801721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801724:	c9                   	leave  
  801725:	c3                   	ret    
	assert(r <= n);
  801726:	68 40 30 80 00       	push   $0x803040
  80172b:	68 47 30 80 00       	push   $0x803047
  801730:	68 98 00 00 00       	push   $0x98
  801735:	68 5c 30 80 00       	push   $0x80305c
  80173a:	e8 f8 e9 ff ff       	call   800137 <_panic>
	assert(r <= PGSIZE);
  80173f:	68 67 30 80 00       	push   $0x803067
  801744:	68 47 30 80 00       	push   $0x803047
  801749:	68 99 00 00 00       	push   $0x99
  80174e:	68 5c 30 80 00       	push   $0x80305c
  801753:	e8 df e9 ff ff       	call   800137 <_panic>

00801758 <devfile_read>:
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	56                   	push   %esi
  80175c:	53                   	push   %ebx
  80175d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8b 40 0c             	mov    0xc(%eax),%eax
  801766:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80176b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801771:	ba 00 00 00 00       	mov    $0x0,%edx
  801776:	b8 03 00 00 00       	mov    $0x3,%eax
  80177b:	e8 65 fe ff ff       	call   8015e5 <fsipc>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	85 c0                	test   %eax,%eax
  801784:	78 1f                	js     8017a5 <devfile_read+0x4d>
	assert(r <= n);
  801786:	39 f0                	cmp    %esi,%eax
  801788:	77 24                	ja     8017ae <devfile_read+0x56>
	assert(r <= PGSIZE);
  80178a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80178f:	7f 33                	jg     8017c4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	50                   	push   %eax
  801795:	68 00 60 80 00       	push   $0x806000
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	e8 78 f3 ff ff       	call   800b1a <memmove>
	return r;
  8017a2:	83 c4 10             	add    $0x10,%esp
}
  8017a5:	89 d8                	mov    %ebx,%eax
  8017a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    
	assert(r <= n);
  8017ae:	68 40 30 80 00       	push   $0x803040
  8017b3:	68 47 30 80 00       	push   $0x803047
  8017b8:	6a 7c                	push   $0x7c
  8017ba:	68 5c 30 80 00       	push   $0x80305c
  8017bf:	e8 73 e9 ff ff       	call   800137 <_panic>
	assert(r <= PGSIZE);
  8017c4:	68 67 30 80 00       	push   $0x803067
  8017c9:	68 47 30 80 00       	push   $0x803047
  8017ce:	6a 7d                	push   $0x7d
  8017d0:	68 5c 30 80 00       	push   $0x80305c
  8017d5:	e8 5d e9 ff ff       	call   800137 <_panic>

008017da <open>:
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	56                   	push   %esi
  8017de:	53                   	push   %ebx
  8017df:	83 ec 1c             	sub    $0x1c,%esp
  8017e2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017e5:	56                   	push   %esi
  8017e6:	e8 68 f1 ff ff       	call   800953 <strlen>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017f3:	7f 6c                	jg     801861 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017f5:	83 ec 0c             	sub    $0xc,%esp
  8017f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fb:	50                   	push   %eax
  8017fc:	e8 79 f8 ff ff       	call   80107a <fd_alloc>
  801801:	89 c3                	mov    %eax,%ebx
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	85 c0                	test   %eax,%eax
  801808:	78 3c                	js     801846 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	56                   	push   %esi
  80180e:	68 00 60 80 00       	push   $0x806000
  801813:	e8 74 f1 ff ff       	call   80098c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181b:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801820:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801823:	b8 01 00 00 00       	mov    $0x1,%eax
  801828:	e8 b8 fd ff ff       	call   8015e5 <fsipc>
  80182d:	89 c3                	mov    %eax,%ebx
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	85 c0                	test   %eax,%eax
  801834:	78 19                	js     80184f <open+0x75>
	return fd2num(fd);
  801836:	83 ec 0c             	sub    $0xc,%esp
  801839:	ff 75 f4             	pushl  -0xc(%ebp)
  80183c:	e8 12 f8 ff ff       	call   801053 <fd2num>
  801841:	89 c3                	mov    %eax,%ebx
  801843:	83 c4 10             	add    $0x10,%esp
}
  801846:	89 d8                	mov    %ebx,%eax
  801848:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184b:	5b                   	pop    %ebx
  80184c:	5e                   	pop    %esi
  80184d:	5d                   	pop    %ebp
  80184e:	c3                   	ret    
		fd_close(fd, 0);
  80184f:	83 ec 08             	sub    $0x8,%esp
  801852:	6a 00                	push   $0x0
  801854:	ff 75 f4             	pushl  -0xc(%ebp)
  801857:	e8 1b f9 ff ff       	call   801177 <fd_close>
		return r;
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	eb e5                	jmp    801846 <open+0x6c>
		return -E_BAD_PATH;
  801861:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801866:	eb de                	jmp    801846 <open+0x6c>

00801868 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	b8 08 00 00 00       	mov    $0x8,%eax
  801878:	e8 68 fd ff ff       	call   8015e5 <fsipc>
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	57                   	push   %edi
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  80188b:	68 4c 31 80 00       	push   $0x80314c
  801890:	68 c9 2b 80 00       	push   $0x802bc9
  801895:	e8 93 e9 ff ff       	call   80022d <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80189a:	83 c4 08             	add    $0x8,%esp
  80189d:	6a 00                	push   $0x0
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 33 ff ff ff       	call   8017da <open>
  8018a7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	0f 88 0a 05 00 00    	js     801dc2 <spawn+0x543>
  8018b8:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	68 00 02 00 00       	push   $0x200
  8018c2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8018c8:	50                   	push   %eax
  8018c9:	51                   	push   %ecx
  8018ca:	e8 f4 fa ff ff       	call   8013c3 <readn>
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	3d 00 02 00 00       	cmp    $0x200,%eax
  8018d7:	75 74                	jne    80194d <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  8018d9:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8018e0:	45 4c 46 
  8018e3:	75 68                	jne    80194d <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8018e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8018ea:	cd 30                	int    $0x30
  8018ec:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8018f2:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	0f 88 b6 04 00 00    	js     801db6 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801900:	25 ff 03 00 00       	and    $0x3ff,%eax
  801905:	89 c6                	mov    %eax,%esi
  801907:	c1 e6 07             	shl    $0x7,%esi
  80190a:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801910:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801916:	b9 11 00 00 00       	mov    $0x11,%ecx
  80191b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80191d:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801923:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801929:	83 ec 08             	sub    $0x8,%esp
  80192c:	68 40 31 80 00       	push   $0x803140
  801931:	68 c9 2b 80 00       	push   $0x802bc9
  801936:	e8 f2 e8 ff ff       	call   80022d <cprintf>
  80193b:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80193e:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801943:	be 00 00 00 00       	mov    $0x0,%esi
  801948:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80194b:	eb 4b                	jmp    801998 <spawn+0x119>
		close(fd);
  80194d:	83 ec 0c             	sub    $0xc,%esp
  801950:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801956:	e8 a3 f8 ff ff       	call   8011fe <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80195b:	83 c4 0c             	add    $0xc,%esp
  80195e:	68 7f 45 4c 46       	push   $0x464c457f
  801963:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801969:	68 73 30 80 00       	push   $0x803073
  80196e:	e8 ba e8 ff ff       	call   80022d <cprintf>
		return -E_NOT_EXEC;
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  80197d:	ff ff ff 
  801980:	e9 3d 04 00 00       	jmp    801dc2 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801985:	83 ec 0c             	sub    $0xc,%esp
  801988:	50                   	push   %eax
  801989:	e8 c5 ef ff ff       	call   800953 <strlen>
  80198e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801992:	83 c3 01             	add    $0x1,%ebx
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80199f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	75 df                	jne    801985 <spawn+0x106>
  8019a6:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8019ac:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8019b2:	bf 00 10 40 00       	mov    $0x401000,%edi
  8019b7:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8019b9:	89 fa                	mov    %edi,%edx
  8019bb:	83 e2 fc             	and    $0xfffffffc,%edx
  8019be:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8019c5:	29 c2                	sub    %eax,%edx
  8019c7:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8019cd:	8d 42 f8             	lea    -0x8(%edx),%eax
  8019d0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8019d5:	0f 86 0a 04 00 00    	jbe    801de5 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	6a 07                	push   $0x7
  8019e0:	68 00 00 40 00       	push   $0x400000
  8019e5:	6a 00                	push   $0x0
  8019e7:	e8 92 f3 ff ff       	call   800d7e <sys_page_alloc>
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	0f 88 f3 03 00 00    	js     801dea <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8019f7:	be 00 00 00 00       	mov    $0x0,%esi
  8019fc:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a05:	eb 30                	jmp    801a37 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801a07:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a0d:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801a13:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a1c:	57                   	push   %edi
  801a1d:	e8 6a ef ff ff       	call   80098c <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a22:	83 c4 04             	add    $0x4,%esp
  801a25:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a28:	e8 26 ef ff ff       	call   800953 <strlen>
  801a2d:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801a31:	83 c6 01             	add    $0x1,%esi
  801a34:	83 c4 10             	add    $0x10,%esp
  801a37:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801a3d:	7f c8                	jg     801a07 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801a3f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801a45:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801a4b:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a52:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801a58:	0f 85 86 00 00 00    	jne    801ae4 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801a5e:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801a64:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801a6a:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801a6d:	89 d0                	mov    %edx,%eax
  801a6f:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801a75:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801a78:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801a7d:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	6a 07                	push   $0x7
  801a88:	68 00 d0 bf ee       	push   $0xeebfd000
  801a8d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a93:	68 00 00 40 00       	push   $0x400000
  801a98:	6a 00                	push   $0x0
  801a9a:	e8 22 f3 ff ff       	call   800dc1 <sys_page_map>
  801a9f:	89 c3                	mov    %eax,%ebx
  801aa1:	83 c4 20             	add    $0x20,%esp
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	0f 88 46 03 00 00    	js     801df2 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	68 00 00 40 00       	push   $0x400000
  801ab4:	6a 00                	push   $0x0
  801ab6:	e8 48 f3 ff ff       	call   800e03 <sys_page_unmap>
  801abb:	89 c3                	mov    %eax,%ebx
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	0f 88 2a 03 00 00    	js     801df2 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801ac8:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ace:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ad5:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801adc:	00 00 00 
  801adf:	e9 4f 01 00 00       	jmp    801c33 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ae4:	68 fc 30 80 00       	push   $0x8030fc
  801ae9:	68 47 30 80 00       	push   $0x803047
  801aee:	68 f8 00 00 00       	push   $0xf8
  801af3:	68 8d 30 80 00       	push   $0x80308d
  801af8:	e8 3a e6 ff ff       	call   800137 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	6a 07                	push   $0x7
  801b02:	68 00 00 40 00       	push   $0x400000
  801b07:	6a 00                	push   $0x0
  801b09:	e8 70 f2 ff ff       	call   800d7e <sys_page_alloc>
  801b0e:	83 c4 10             	add    $0x10,%esp
  801b11:	85 c0                	test   %eax,%eax
  801b13:	0f 88 b7 02 00 00    	js     801dd0 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b19:	83 ec 08             	sub    $0x8,%esp
  801b1c:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b22:	01 f0                	add    %esi,%eax
  801b24:	50                   	push   %eax
  801b25:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b2b:	e8 5a f9 ff ff       	call   80148a <seek>
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	0f 88 9c 02 00 00    	js     801dd7 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b44:	29 f0                	sub    %esi,%eax
  801b46:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b50:	0f 47 c1             	cmova  %ecx,%eax
  801b53:	50                   	push   %eax
  801b54:	68 00 00 40 00       	push   $0x400000
  801b59:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b5f:	e8 5f f8 ff ff       	call   8013c3 <readn>
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	0f 88 6f 02 00 00    	js     801dde <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801b6f:	83 ec 0c             	sub    $0xc,%esp
  801b72:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801b78:	53                   	push   %ebx
  801b79:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801b7f:	68 00 00 40 00       	push   $0x400000
  801b84:	6a 00                	push   $0x0
  801b86:	e8 36 f2 ff ff       	call   800dc1 <sys_page_map>
  801b8b:	83 c4 20             	add    $0x20,%esp
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 7c                	js     801c0e <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	68 00 00 40 00       	push   $0x400000
  801b9a:	6a 00                	push   $0x0
  801b9c:	e8 62 f2 ff ff       	call   800e03 <sys_page_unmap>
  801ba1:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801ba4:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801baa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bb0:	89 fe                	mov    %edi,%esi
  801bb2:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801bb8:	76 69                	jbe    801c23 <spawn+0x3a4>
		if (i >= filesz) {
  801bba:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801bc0:	0f 87 37 ff ff ff    	ja     801afd <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801bc6:	83 ec 04             	sub    $0x4,%esp
  801bc9:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801bcf:	53                   	push   %ebx
  801bd0:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801bd6:	e8 a3 f1 ff ff       	call   800d7e <sys_page_alloc>
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	79 c2                	jns    801ba4 <spawn+0x325>
  801be2:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801be4:	83 ec 0c             	sub    $0xc,%esp
  801be7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bed:	e8 0d f1 ff ff       	call   800cff <sys_env_destroy>
	close(fd);
  801bf2:	83 c4 04             	add    $0x4,%esp
  801bf5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bfb:	e8 fe f5 ff ff       	call   8011fe <close>
	return r;
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801c09:	e9 b4 01 00 00       	jmp    801dc2 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801c0e:	50                   	push   %eax
  801c0f:	68 99 30 80 00       	push   $0x803099
  801c14:	68 2b 01 00 00       	push   $0x12b
  801c19:	68 8d 30 80 00       	push   $0x80308d
  801c1e:	e8 14 e5 ff ff       	call   800137 <_panic>
  801c23:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c29:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801c30:	83 c6 20             	add    $0x20,%esi
  801c33:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c3a:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801c40:	7e 6d                	jle    801caf <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801c42:	83 3e 01             	cmpl   $0x1,(%esi)
  801c45:	75 e2                	jne    801c29 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801c47:	8b 46 18             	mov    0x18(%esi),%eax
  801c4a:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801c4d:	83 f8 01             	cmp    $0x1,%eax
  801c50:	19 c0                	sbb    %eax,%eax
  801c52:	83 e0 fe             	and    $0xfffffffe,%eax
  801c55:	83 c0 07             	add    $0x7,%eax
  801c58:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801c5e:	8b 4e 04             	mov    0x4(%esi),%ecx
  801c61:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801c67:	8b 56 10             	mov    0x10(%esi),%edx
  801c6a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801c70:	8b 7e 14             	mov    0x14(%esi),%edi
  801c73:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801c79:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801c7c:	89 d8                	mov    %ebx,%eax
  801c7e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c83:	74 1a                	je     801c9f <spawn+0x420>
		va -= i;
  801c85:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801c87:	01 c7                	add    %eax,%edi
  801c89:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801c8f:	01 c2                	add    %eax,%edx
  801c91:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801c97:	29 c1                	sub    %eax,%ecx
  801c99:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801c9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca4:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801caa:	e9 01 ff ff ff       	jmp    801bb0 <spawn+0x331>
	close(fd);
  801caf:	83 ec 0c             	sub    $0xc,%esp
  801cb2:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801cb8:	e8 41 f5 ff ff       	call   8011fe <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	68 2c 31 80 00       	push   $0x80312c
  801cc5:	68 c9 2b 80 00       	push   $0x802bc9
  801cca:	e8 5e e5 ff ff       	call   80022d <cprintf>
  801ccf:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801cd2:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801cd7:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801cdd:	eb 0e                	jmp    801ced <spawn+0x46e>
  801cdf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ce5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ceb:	74 5e                	je     801d4b <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801ced:	89 d8                	mov    %ebx,%eax
  801cef:	c1 e8 16             	shr    $0x16,%eax
  801cf2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801cf9:	a8 01                	test   $0x1,%al
  801cfb:	74 e2                	je     801cdf <spawn+0x460>
  801cfd:	89 da                	mov    %ebx,%edx
  801cff:	c1 ea 0c             	shr    $0xc,%edx
  801d02:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d09:	25 05 04 00 00       	and    $0x405,%eax
  801d0e:	3d 05 04 00 00       	cmp    $0x405,%eax
  801d13:	75 ca                	jne    801cdf <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801d15:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d1c:	83 ec 0c             	sub    $0xc,%esp
  801d1f:	25 07 0e 00 00       	and    $0xe07,%eax
  801d24:	50                   	push   %eax
  801d25:	53                   	push   %ebx
  801d26:	56                   	push   %esi
  801d27:	53                   	push   %ebx
  801d28:	6a 00                	push   $0x0
  801d2a:	e8 92 f0 ff ff       	call   800dc1 <sys_page_map>
  801d2f:	83 c4 20             	add    $0x20,%esp
  801d32:	85 c0                	test   %eax,%eax
  801d34:	79 a9                	jns    801cdf <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  801d36:	50                   	push   %eax
  801d37:	68 b6 30 80 00       	push   $0x8030b6
  801d3c:	68 3b 01 00 00       	push   $0x13b
  801d41:	68 8d 30 80 00       	push   $0x80308d
  801d46:	e8 ec e3 ff ff       	call   800137 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801d4b:	83 ec 08             	sub    $0x8,%esp
  801d4e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801d54:	50                   	push   %eax
  801d55:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d5b:	e8 27 f1 ff ff       	call   800e87 <sys_env_set_trapframe>
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 25                	js     801d8c <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801d67:	83 ec 08             	sub    $0x8,%esp
  801d6a:	6a 02                	push   $0x2
  801d6c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d72:	e8 ce f0 ff ff       	call   800e45 <sys_env_set_status>
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	78 23                	js     801da1 <spawn+0x522>
	return child;
  801d7e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d84:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801d8a:	eb 36                	jmp    801dc2 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  801d8c:	50                   	push   %eax
  801d8d:	68 c8 30 80 00       	push   $0x8030c8
  801d92:	68 8a 00 00 00       	push   $0x8a
  801d97:	68 8d 30 80 00       	push   $0x80308d
  801d9c:	e8 96 e3 ff ff       	call   800137 <_panic>
		panic("sys_env_set_status: %e", r);
  801da1:	50                   	push   %eax
  801da2:	68 e2 30 80 00       	push   $0x8030e2
  801da7:	68 8d 00 00 00       	push   $0x8d
  801dac:	68 8d 30 80 00       	push   $0x80308d
  801db1:	e8 81 e3 ff ff       	call   800137 <_panic>
		return r;
  801db6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dbc:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801dc2:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5f                   	pop    %edi
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    
  801dd0:	89 c7                	mov    %eax,%edi
  801dd2:	e9 0d fe ff ff       	jmp    801be4 <spawn+0x365>
  801dd7:	89 c7                	mov    %eax,%edi
  801dd9:	e9 06 fe ff ff       	jmp    801be4 <spawn+0x365>
  801dde:	89 c7                	mov    %eax,%edi
  801de0:	e9 ff fd ff ff       	jmp    801be4 <spawn+0x365>
		return -E_NO_MEM;
  801de5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801dea:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801df0:	eb d0                	jmp    801dc2 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  801df2:	83 ec 08             	sub    $0x8,%esp
  801df5:	68 00 00 40 00       	push   $0x400000
  801dfa:	6a 00                	push   $0x0
  801dfc:	e8 02 f0 ff ff       	call   800e03 <sys_page_unmap>
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801e0a:	eb b6                	jmp    801dc2 <spawn+0x543>

00801e0c <spawnl>:
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	57                   	push   %edi
  801e10:	56                   	push   %esi
  801e11:	53                   	push   %ebx
  801e12:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801e15:	68 24 31 80 00       	push   $0x803124
  801e1a:	68 c9 2b 80 00       	push   $0x802bc9
  801e1f:	e8 09 e4 ff ff       	call   80022d <cprintf>
	va_start(vl, arg0);
  801e24:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801e27:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801e2a:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801e2f:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e32:	83 3a 00             	cmpl   $0x0,(%edx)
  801e35:	74 07                	je     801e3e <spawnl+0x32>
		argc++;
  801e37:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801e3a:	89 ca                	mov    %ecx,%edx
  801e3c:	eb f1                	jmp    801e2f <spawnl+0x23>
	const char *argv[argc+2];
  801e3e:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801e45:	83 e2 f0             	and    $0xfffffff0,%edx
  801e48:	29 d4                	sub    %edx,%esp
  801e4a:	8d 54 24 03          	lea    0x3(%esp),%edx
  801e4e:	c1 ea 02             	shr    $0x2,%edx
  801e51:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801e58:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801e5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e5d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801e64:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801e6b:	00 
	va_start(vl, arg0);
  801e6c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801e6f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
  801e76:	eb 0b                	jmp    801e83 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801e78:	83 c0 01             	add    $0x1,%eax
  801e7b:	8b 39                	mov    (%ecx),%edi
  801e7d:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801e80:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801e83:	39 d0                	cmp    %edx,%eax
  801e85:	75 f1                	jne    801e78 <spawnl+0x6c>
	return spawn(prog, argv);
  801e87:	83 ec 08             	sub    $0x8,%esp
  801e8a:	56                   	push   %esi
  801e8b:	ff 75 08             	pushl  0x8(%ebp)
  801e8e:	e8 ec f9 ff ff       	call   80187f <spawn>
}
  801e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e96:	5b                   	pop    %ebx
  801e97:	5e                   	pop    %esi
  801e98:	5f                   	pop    %edi
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    

00801e9b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ea1:	68 52 31 80 00       	push   $0x803152
  801ea6:	ff 75 0c             	pushl  0xc(%ebp)
  801ea9:	e8 de ea ff ff       	call   80098c <strcpy>
	return 0;
}
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <devsock_close>:
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	53                   	push   %ebx
  801eb9:	83 ec 10             	sub    $0x10,%esp
  801ebc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ebf:	53                   	push   %ebx
  801ec0:	e8 fc 09 00 00       	call   8028c1 <pageref>
  801ec5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ec8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ecd:	83 f8 01             	cmp    $0x1,%eax
  801ed0:	74 07                	je     801ed9 <devsock_close+0x24>
}
  801ed2:	89 d0                	mov    %edx,%eax
  801ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ed9:	83 ec 0c             	sub    $0xc,%esp
  801edc:	ff 73 0c             	pushl  0xc(%ebx)
  801edf:	e8 b9 02 00 00       	call   80219d <nsipc_close>
  801ee4:	89 c2                	mov    %eax,%edx
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	eb e7                	jmp    801ed2 <devsock_close+0x1d>

00801eeb <devsock_write>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ef1:	6a 00                	push   $0x0
  801ef3:	ff 75 10             	pushl  0x10(%ebp)
  801ef6:	ff 75 0c             	pushl  0xc(%ebp)
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	ff 70 0c             	pushl  0xc(%eax)
  801eff:	e8 76 03 00 00       	call   80227a <nsipc_send>
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <devsock_read>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	ff 75 10             	pushl  0x10(%ebp)
  801f11:	ff 75 0c             	pushl  0xc(%ebp)
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	ff 70 0c             	pushl  0xc(%eax)
  801f1a:	e8 ef 02 00 00       	call   80220e <nsipc_recv>
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <fd2sockid>:
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f27:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f2a:	52                   	push   %edx
  801f2b:	50                   	push   %eax
  801f2c:	e8 9b f1 ff ff       	call   8010cc <fd_lookup>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	85 c0                	test   %eax,%eax
  801f36:	78 10                	js     801f48 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3b:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f41:	39 08                	cmp    %ecx,(%eax)
  801f43:	75 05                	jne    801f4a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f45:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    
		return -E_NOT_SUPP;
  801f4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f4f:	eb f7                	jmp    801f48 <fd2sockid+0x27>

00801f51 <alloc_sockfd>:
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	56                   	push   %esi
  801f55:	53                   	push   %ebx
  801f56:	83 ec 1c             	sub    $0x1c,%esp
  801f59:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5e:	50                   	push   %eax
  801f5f:	e8 16 f1 ff ff       	call   80107a <fd_alloc>
  801f64:	89 c3                	mov    %eax,%ebx
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 43                	js     801fb0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f6d:	83 ec 04             	sub    $0x4,%esp
  801f70:	68 07 04 00 00       	push   $0x407
  801f75:	ff 75 f4             	pushl  -0xc(%ebp)
  801f78:	6a 00                	push   $0x0
  801f7a:	e8 ff ed ff ff       	call   800d7e <sys_page_alloc>
  801f7f:	89 c3                	mov    %eax,%ebx
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 28                	js     801fb0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f91:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f9d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fa0:	83 ec 0c             	sub    $0xc,%esp
  801fa3:	50                   	push   %eax
  801fa4:	e8 aa f0 ff ff       	call   801053 <fd2num>
  801fa9:	89 c3                	mov    %eax,%ebx
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	eb 0c                	jmp    801fbc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	56                   	push   %esi
  801fb4:	e8 e4 01 00 00       	call   80219d <nsipc_close>
		return r;
  801fb9:	83 c4 10             	add    $0x10,%esp
}
  801fbc:	89 d8                	mov    %ebx,%eax
  801fbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc1:	5b                   	pop    %ebx
  801fc2:	5e                   	pop    %esi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <accept>:
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	e8 4e ff ff ff       	call   801f21 <fd2sockid>
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	78 1b                	js     801ff2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	ff 75 10             	pushl  0x10(%ebp)
  801fdd:	ff 75 0c             	pushl  0xc(%ebp)
  801fe0:	50                   	push   %eax
  801fe1:	e8 0e 01 00 00       	call   8020f4 <nsipc_accept>
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 05                	js     801ff2 <accept+0x2d>
	return alloc_sockfd(r);
  801fed:	e8 5f ff ff ff       	call   801f51 <alloc_sockfd>
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <bind>:
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	e8 1f ff ff ff       	call   801f21 <fd2sockid>
  802002:	85 c0                	test   %eax,%eax
  802004:	78 12                	js     802018 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802006:	83 ec 04             	sub    $0x4,%esp
  802009:	ff 75 10             	pushl  0x10(%ebp)
  80200c:	ff 75 0c             	pushl  0xc(%ebp)
  80200f:	50                   	push   %eax
  802010:	e8 31 01 00 00       	call   802146 <nsipc_bind>
  802015:	83 c4 10             	add    $0x10,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <shutdown>:
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	e8 f9 fe ff ff       	call   801f21 <fd2sockid>
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 0f                	js     80203b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80202c:	83 ec 08             	sub    $0x8,%esp
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	50                   	push   %eax
  802033:	e8 43 01 00 00       	call   80217b <nsipc_shutdown>
  802038:	83 c4 10             	add    $0x10,%esp
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <connect>:
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	e8 d6 fe ff ff       	call   801f21 <fd2sockid>
  80204b:	85 c0                	test   %eax,%eax
  80204d:	78 12                	js     802061 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80204f:	83 ec 04             	sub    $0x4,%esp
  802052:	ff 75 10             	pushl  0x10(%ebp)
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	50                   	push   %eax
  802059:	e8 59 01 00 00       	call   8021b7 <nsipc_connect>
  80205e:	83 c4 10             	add    $0x10,%esp
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <listen>:
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	e8 b0 fe ff ff       	call   801f21 <fd2sockid>
  802071:	85 c0                	test   %eax,%eax
  802073:	78 0f                	js     802084 <listen+0x21>
	return nsipc_listen(r, backlog);
  802075:	83 ec 08             	sub    $0x8,%esp
  802078:	ff 75 0c             	pushl  0xc(%ebp)
  80207b:	50                   	push   %eax
  80207c:	e8 6b 01 00 00       	call   8021ec <nsipc_listen>
  802081:	83 c4 10             	add    $0x10,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <socket>:

int
socket(int domain, int type, int protocol)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80208c:	ff 75 10             	pushl  0x10(%ebp)
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	ff 75 08             	pushl  0x8(%ebp)
  802095:	e8 3e 02 00 00       	call   8022d8 <nsipc_socket>
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 05                	js     8020a6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020a1:	e8 ab fe ff ff       	call   801f51 <alloc_sockfd>
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	53                   	push   %ebx
  8020ac:	83 ec 04             	sub    $0x4,%esp
  8020af:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020b1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020b8:	74 26                	je     8020e0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020ba:	6a 07                	push   $0x7
  8020bc:	68 00 70 80 00       	push   $0x807000
  8020c1:	53                   	push   %ebx
  8020c2:	ff 35 04 50 80 00    	pushl  0x805004
  8020c8:	e8 61 07 00 00       	call   80282e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020cd:	83 c4 0c             	add    $0xc,%esp
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	e8 ea 06 00 00       	call   8027c5 <ipc_recv>
}
  8020db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020e0:	83 ec 0c             	sub    $0xc,%esp
  8020e3:	6a 02                	push   $0x2
  8020e5:	e8 9c 07 00 00       	call   802886 <ipc_find_env>
  8020ea:	a3 04 50 80 00       	mov    %eax,0x805004
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	eb c6                	jmp    8020ba <nsipc+0x12>

008020f4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	56                   	push   %esi
  8020f8:	53                   	push   %ebx
  8020f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802104:	8b 06                	mov    (%esi),%eax
  802106:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80210b:	b8 01 00 00 00       	mov    $0x1,%eax
  802110:	e8 93 ff ff ff       	call   8020a8 <nsipc>
  802115:	89 c3                	mov    %eax,%ebx
  802117:	85 c0                	test   %eax,%eax
  802119:	79 09                	jns    802124 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80211b:	89 d8                	mov    %ebx,%eax
  80211d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802120:	5b                   	pop    %ebx
  802121:	5e                   	pop    %esi
  802122:	5d                   	pop    %ebp
  802123:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	ff 35 10 70 80 00    	pushl  0x807010
  80212d:	68 00 70 80 00       	push   $0x807000
  802132:	ff 75 0c             	pushl  0xc(%ebp)
  802135:	e8 e0 e9 ff ff       	call   800b1a <memmove>
		*addrlen = ret->ret_addrlen;
  80213a:	a1 10 70 80 00       	mov    0x807010,%eax
  80213f:	89 06                	mov    %eax,(%esi)
  802141:	83 c4 10             	add    $0x10,%esp
	return r;
  802144:	eb d5                	jmp    80211b <nsipc_accept+0x27>

00802146 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	53                   	push   %ebx
  80214a:	83 ec 08             	sub    $0x8,%esp
  80214d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802158:	53                   	push   %ebx
  802159:	ff 75 0c             	pushl  0xc(%ebp)
  80215c:	68 04 70 80 00       	push   $0x807004
  802161:	e8 b4 e9 ff ff       	call   800b1a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802166:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80216c:	b8 02 00 00 00       	mov    $0x2,%eax
  802171:	e8 32 ff ff ff       	call   8020a8 <nsipc>
}
  802176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802191:	b8 03 00 00 00       	mov    $0x3,%eax
  802196:	e8 0d ff ff ff       	call   8020a8 <nsipc>
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <nsipc_close>:

int
nsipc_close(int s)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8021b0:	e8 f3 fe ff ff       	call   8020a8 <nsipc>
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	53                   	push   %ebx
  8021bb:	83 ec 08             	sub    $0x8,%esp
  8021be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021c9:	53                   	push   %ebx
  8021ca:	ff 75 0c             	pushl  0xc(%ebp)
  8021cd:	68 04 70 80 00       	push   $0x807004
  8021d2:	e8 43 e9 ff ff       	call   800b1a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021d7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021dd:	b8 05 00 00 00       	mov    $0x5,%eax
  8021e2:	e8 c1 fe ff ff       	call   8020a8 <nsipc>
}
  8021e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802202:	b8 06 00 00 00       	mov    $0x6,%eax
  802207:	e8 9c fe ff ff       	call   8020a8 <nsipc>
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	56                   	push   %esi
  802212:	53                   	push   %ebx
  802213:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80221e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802224:	8b 45 14             	mov    0x14(%ebp),%eax
  802227:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80222c:	b8 07 00 00 00       	mov    $0x7,%eax
  802231:	e8 72 fe ff ff       	call   8020a8 <nsipc>
  802236:	89 c3                	mov    %eax,%ebx
  802238:	85 c0                	test   %eax,%eax
  80223a:	78 1f                	js     80225b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80223c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802241:	7f 21                	jg     802264 <nsipc_recv+0x56>
  802243:	39 c6                	cmp    %eax,%esi
  802245:	7c 1d                	jl     802264 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	50                   	push   %eax
  80224b:	68 00 70 80 00       	push   $0x807000
  802250:	ff 75 0c             	pushl  0xc(%ebp)
  802253:	e8 c2 e8 ff ff       	call   800b1a <memmove>
  802258:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80225b:	89 d8                	mov    %ebx,%eax
  80225d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802260:	5b                   	pop    %ebx
  802261:	5e                   	pop    %esi
  802262:	5d                   	pop    %ebp
  802263:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802264:	68 5e 31 80 00       	push   $0x80315e
  802269:	68 47 30 80 00       	push   $0x803047
  80226e:	6a 62                	push   $0x62
  802270:	68 73 31 80 00       	push   $0x803173
  802275:	e8 bd de ff ff       	call   800137 <_panic>

0080227a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	53                   	push   %ebx
  80227e:	83 ec 04             	sub    $0x4,%esp
  802281:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80228c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802292:	7f 2e                	jg     8022c2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802294:	83 ec 04             	sub    $0x4,%esp
  802297:	53                   	push   %ebx
  802298:	ff 75 0c             	pushl  0xc(%ebp)
  80229b:	68 0c 70 80 00       	push   $0x80700c
  8022a0:	e8 75 e8 ff ff       	call   800b1a <memmove>
	nsipcbuf.send.req_size = size;
  8022a5:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ae:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8022b8:	e8 eb fd ff ff       	call   8020a8 <nsipc>
}
  8022bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    
	assert(size < 1600);
  8022c2:	68 7f 31 80 00       	push   $0x80317f
  8022c7:	68 47 30 80 00       	push   $0x803047
  8022cc:	6a 6d                	push   $0x6d
  8022ce:	68 73 31 80 00       	push   $0x803173
  8022d3:	e8 5f de ff ff       	call   800137 <_panic>

008022d8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e9:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022f6:	b8 09 00 00 00       	mov    $0x9,%eax
  8022fb:	e8 a8 fd ff ff       	call   8020a8 <nsipc>
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	56                   	push   %esi
  802306:	53                   	push   %ebx
  802307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80230a:	83 ec 0c             	sub    $0xc,%esp
  80230d:	ff 75 08             	pushl  0x8(%ebp)
  802310:	e8 4e ed ff ff       	call   801063 <fd2data>
  802315:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802317:	83 c4 08             	add    $0x8,%esp
  80231a:	68 8b 31 80 00       	push   $0x80318b
  80231f:	53                   	push   %ebx
  802320:	e8 67 e6 ff ff       	call   80098c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802325:	8b 46 04             	mov    0x4(%esi),%eax
  802328:	2b 06                	sub    (%esi),%eax
  80232a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802330:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802337:	00 00 00 
	stat->st_dev = &devpipe;
  80233a:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802341:	40 80 00 
	return 0;
}
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5d                   	pop    %ebp
  80234f:	c3                   	ret    

00802350 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	53                   	push   %ebx
  802354:	83 ec 0c             	sub    $0xc,%esp
  802357:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80235a:	53                   	push   %ebx
  80235b:	6a 00                	push   $0x0
  80235d:	e8 a1 ea ff ff       	call   800e03 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802362:	89 1c 24             	mov    %ebx,(%esp)
  802365:	e8 f9 ec ff ff       	call   801063 <fd2data>
  80236a:	83 c4 08             	add    $0x8,%esp
  80236d:	50                   	push   %eax
  80236e:	6a 00                	push   $0x0
  802370:	e8 8e ea ff ff       	call   800e03 <sys_page_unmap>
}
  802375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <_pipeisclosed>:
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	57                   	push   %edi
  80237e:	56                   	push   %esi
  80237f:	53                   	push   %ebx
  802380:	83 ec 1c             	sub    $0x1c,%esp
  802383:	89 c7                	mov    %eax,%edi
  802385:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802387:	a1 08 50 80 00       	mov    0x805008,%eax
  80238c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80238f:	83 ec 0c             	sub    $0xc,%esp
  802392:	57                   	push   %edi
  802393:	e8 29 05 00 00       	call   8028c1 <pageref>
  802398:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80239b:	89 34 24             	mov    %esi,(%esp)
  80239e:	e8 1e 05 00 00       	call   8028c1 <pageref>
		nn = thisenv->env_runs;
  8023a3:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023a9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023ac:	83 c4 10             	add    $0x10,%esp
  8023af:	39 cb                	cmp    %ecx,%ebx
  8023b1:	74 1b                	je     8023ce <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023b3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023b6:	75 cf                	jne    802387 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023b8:	8b 42 58             	mov    0x58(%edx),%eax
  8023bb:	6a 01                	push   $0x1
  8023bd:	50                   	push   %eax
  8023be:	53                   	push   %ebx
  8023bf:	68 92 31 80 00       	push   $0x803192
  8023c4:	e8 64 de ff ff       	call   80022d <cprintf>
  8023c9:	83 c4 10             	add    $0x10,%esp
  8023cc:	eb b9                	jmp    802387 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023d1:	0f 94 c0             	sete   %al
  8023d4:	0f b6 c0             	movzbl %al,%eax
}
  8023d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023da:	5b                   	pop    %ebx
  8023db:	5e                   	pop    %esi
  8023dc:	5f                   	pop    %edi
  8023dd:	5d                   	pop    %ebp
  8023de:	c3                   	ret    

008023df <devpipe_write>:
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	57                   	push   %edi
  8023e3:	56                   	push   %esi
  8023e4:	53                   	push   %ebx
  8023e5:	83 ec 28             	sub    $0x28,%esp
  8023e8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023eb:	56                   	push   %esi
  8023ec:	e8 72 ec ff ff       	call   801063 <fd2data>
  8023f1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023fe:	74 4f                	je     80244f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802400:	8b 43 04             	mov    0x4(%ebx),%eax
  802403:	8b 0b                	mov    (%ebx),%ecx
  802405:	8d 51 20             	lea    0x20(%ecx),%edx
  802408:	39 d0                	cmp    %edx,%eax
  80240a:	72 14                	jb     802420 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80240c:	89 da                	mov    %ebx,%edx
  80240e:	89 f0                	mov    %esi,%eax
  802410:	e8 65 ff ff ff       	call   80237a <_pipeisclosed>
  802415:	85 c0                	test   %eax,%eax
  802417:	75 3b                	jne    802454 <devpipe_write+0x75>
			sys_yield();
  802419:	e8 41 e9 ff ff       	call   800d5f <sys_yield>
  80241e:	eb e0                	jmp    802400 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802423:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802427:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80242a:	89 c2                	mov    %eax,%edx
  80242c:	c1 fa 1f             	sar    $0x1f,%edx
  80242f:	89 d1                	mov    %edx,%ecx
  802431:	c1 e9 1b             	shr    $0x1b,%ecx
  802434:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802437:	83 e2 1f             	and    $0x1f,%edx
  80243a:	29 ca                	sub    %ecx,%edx
  80243c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802440:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802444:	83 c0 01             	add    $0x1,%eax
  802447:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80244a:	83 c7 01             	add    $0x1,%edi
  80244d:	eb ac                	jmp    8023fb <devpipe_write+0x1c>
	return i;
  80244f:	8b 45 10             	mov    0x10(%ebp),%eax
  802452:	eb 05                	jmp    802459 <devpipe_write+0x7a>
				return 0;
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802459:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    

00802461 <devpipe_read>:
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	57                   	push   %edi
  802465:	56                   	push   %esi
  802466:	53                   	push   %ebx
  802467:	83 ec 18             	sub    $0x18,%esp
  80246a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80246d:	57                   	push   %edi
  80246e:	e8 f0 eb ff ff       	call   801063 <fd2data>
  802473:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802475:	83 c4 10             	add    $0x10,%esp
  802478:	be 00 00 00 00       	mov    $0x0,%esi
  80247d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802480:	75 14                	jne    802496 <devpipe_read+0x35>
	return i;
  802482:	8b 45 10             	mov    0x10(%ebp),%eax
  802485:	eb 02                	jmp    802489 <devpipe_read+0x28>
				return i;
  802487:	89 f0                	mov    %esi,%eax
}
  802489:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
			sys_yield();
  802491:	e8 c9 e8 ff ff       	call   800d5f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802496:	8b 03                	mov    (%ebx),%eax
  802498:	3b 43 04             	cmp    0x4(%ebx),%eax
  80249b:	75 18                	jne    8024b5 <devpipe_read+0x54>
			if (i > 0)
  80249d:	85 f6                	test   %esi,%esi
  80249f:	75 e6                	jne    802487 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024a1:	89 da                	mov    %ebx,%edx
  8024a3:	89 f8                	mov    %edi,%eax
  8024a5:	e8 d0 fe ff ff       	call   80237a <_pipeisclosed>
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	74 e3                	je     802491 <devpipe_read+0x30>
				return 0;
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	eb d4                	jmp    802489 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024b5:	99                   	cltd   
  8024b6:	c1 ea 1b             	shr    $0x1b,%edx
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	83 e0 1f             	and    $0x1f,%eax
  8024be:	29 d0                	sub    %edx,%eax
  8024c0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024c8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024cb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024ce:	83 c6 01             	add    $0x1,%esi
  8024d1:	eb aa                	jmp    80247d <devpipe_read+0x1c>

008024d3 <pipe>:
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	56                   	push   %esi
  8024d7:	53                   	push   %ebx
  8024d8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024de:	50                   	push   %eax
  8024df:	e8 96 eb ff ff       	call   80107a <fd_alloc>
  8024e4:	89 c3                	mov    %eax,%ebx
  8024e6:	83 c4 10             	add    $0x10,%esp
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	0f 88 23 01 00 00    	js     802614 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024f1:	83 ec 04             	sub    $0x4,%esp
  8024f4:	68 07 04 00 00       	push   $0x407
  8024f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024fc:	6a 00                	push   $0x0
  8024fe:	e8 7b e8 ff ff       	call   800d7e <sys_page_alloc>
  802503:	89 c3                	mov    %eax,%ebx
  802505:	83 c4 10             	add    $0x10,%esp
  802508:	85 c0                	test   %eax,%eax
  80250a:	0f 88 04 01 00 00    	js     802614 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802510:	83 ec 0c             	sub    $0xc,%esp
  802513:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802516:	50                   	push   %eax
  802517:	e8 5e eb ff ff       	call   80107a <fd_alloc>
  80251c:	89 c3                	mov    %eax,%ebx
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	85 c0                	test   %eax,%eax
  802523:	0f 88 db 00 00 00    	js     802604 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802529:	83 ec 04             	sub    $0x4,%esp
  80252c:	68 07 04 00 00       	push   $0x407
  802531:	ff 75 f0             	pushl  -0x10(%ebp)
  802534:	6a 00                	push   $0x0
  802536:	e8 43 e8 ff ff       	call   800d7e <sys_page_alloc>
  80253b:	89 c3                	mov    %eax,%ebx
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	85 c0                	test   %eax,%eax
  802542:	0f 88 bc 00 00 00    	js     802604 <pipe+0x131>
	va = fd2data(fd0);
  802548:	83 ec 0c             	sub    $0xc,%esp
  80254b:	ff 75 f4             	pushl  -0xc(%ebp)
  80254e:	e8 10 eb ff ff       	call   801063 <fd2data>
  802553:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802555:	83 c4 0c             	add    $0xc,%esp
  802558:	68 07 04 00 00       	push   $0x407
  80255d:	50                   	push   %eax
  80255e:	6a 00                	push   $0x0
  802560:	e8 19 e8 ff ff       	call   800d7e <sys_page_alloc>
  802565:	89 c3                	mov    %eax,%ebx
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	85 c0                	test   %eax,%eax
  80256c:	0f 88 82 00 00 00    	js     8025f4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802572:	83 ec 0c             	sub    $0xc,%esp
  802575:	ff 75 f0             	pushl  -0x10(%ebp)
  802578:	e8 e6 ea ff ff       	call   801063 <fd2data>
  80257d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802584:	50                   	push   %eax
  802585:	6a 00                	push   $0x0
  802587:	56                   	push   %esi
  802588:	6a 00                	push   $0x0
  80258a:	e8 32 e8 ff ff       	call   800dc1 <sys_page_map>
  80258f:	89 c3                	mov    %eax,%ebx
  802591:	83 c4 20             	add    $0x20,%esp
  802594:	85 c0                	test   %eax,%eax
  802596:	78 4e                	js     8025e6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802598:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80259d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025af:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025bb:	83 ec 0c             	sub    $0xc,%esp
  8025be:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c1:	e8 8d ea ff ff       	call   801053 <fd2num>
  8025c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025c9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025cb:	83 c4 04             	add    $0x4,%esp
  8025ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8025d1:	e8 7d ea ff ff       	call   801053 <fd2num>
  8025d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025d9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025dc:	83 c4 10             	add    $0x10,%esp
  8025df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025e4:	eb 2e                	jmp    802614 <pipe+0x141>
	sys_page_unmap(0, va);
  8025e6:	83 ec 08             	sub    $0x8,%esp
  8025e9:	56                   	push   %esi
  8025ea:	6a 00                	push   $0x0
  8025ec:	e8 12 e8 ff ff       	call   800e03 <sys_page_unmap>
  8025f1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025f4:	83 ec 08             	sub    $0x8,%esp
  8025f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8025fa:	6a 00                	push   $0x0
  8025fc:	e8 02 e8 ff ff       	call   800e03 <sys_page_unmap>
  802601:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802604:	83 ec 08             	sub    $0x8,%esp
  802607:	ff 75 f4             	pushl  -0xc(%ebp)
  80260a:	6a 00                	push   $0x0
  80260c:	e8 f2 e7 ff ff       	call   800e03 <sys_page_unmap>
  802611:	83 c4 10             	add    $0x10,%esp
}
  802614:	89 d8                	mov    %ebx,%eax
  802616:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802619:	5b                   	pop    %ebx
  80261a:	5e                   	pop    %esi
  80261b:	5d                   	pop    %ebp
  80261c:	c3                   	ret    

0080261d <pipeisclosed>:
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
  802620:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802623:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802626:	50                   	push   %eax
  802627:	ff 75 08             	pushl  0x8(%ebp)
  80262a:	e8 9d ea ff ff       	call   8010cc <fd_lookup>
  80262f:	83 c4 10             	add    $0x10,%esp
  802632:	85 c0                	test   %eax,%eax
  802634:	78 18                	js     80264e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802636:	83 ec 0c             	sub    $0xc,%esp
  802639:	ff 75 f4             	pushl  -0xc(%ebp)
  80263c:	e8 22 ea ff ff       	call   801063 <fd2data>
	return _pipeisclosed(fd, p);
  802641:	89 c2                	mov    %eax,%edx
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	e8 2f fd ff ff       	call   80237a <_pipeisclosed>
  80264b:	83 c4 10             	add    $0x10,%esp
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
  802655:	c3                   	ret    

00802656 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80265c:	68 aa 31 80 00       	push   $0x8031aa
  802661:	ff 75 0c             	pushl  0xc(%ebp)
  802664:	e8 23 e3 ff ff       	call   80098c <strcpy>
	return 0;
}
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <devcons_write>:
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	57                   	push   %edi
  802674:	56                   	push   %esi
  802675:	53                   	push   %ebx
  802676:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80267c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802681:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802687:	3b 75 10             	cmp    0x10(%ebp),%esi
  80268a:	73 31                	jae    8026bd <devcons_write+0x4d>
		m = n - tot;
  80268c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80268f:	29 f3                	sub    %esi,%ebx
  802691:	83 fb 7f             	cmp    $0x7f,%ebx
  802694:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802699:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80269c:	83 ec 04             	sub    $0x4,%esp
  80269f:	53                   	push   %ebx
  8026a0:	89 f0                	mov    %esi,%eax
  8026a2:	03 45 0c             	add    0xc(%ebp),%eax
  8026a5:	50                   	push   %eax
  8026a6:	57                   	push   %edi
  8026a7:	e8 6e e4 ff ff       	call   800b1a <memmove>
		sys_cputs(buf, m);
  8026ac:	83 c4 08             	add    $0x8,%esp
  8026af:	53                   	push   %ebx
  8026b0:	57                   	push   %edi
  8026b1:	e8 0c e6 ff ff       	call   800cc2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026b6:	01 de                	add    %ebx,%esi
  8026b8:	83 c4 10             	add    $0x10,%esp
  8026bb:	eb ca                	jmp    802687 <devcons_write+0x17>
}
  8026bd:	89 f0                	mov    %esi,%eax
  8026bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026c2:	5b                   	pop    %ebx
  8026c3:	5e                   	pop    %esi
  8026c4:	5f                   	pop    %edi
  8026c5:	5d                   	pop    %ebp
  8026c6:	c3                   	ret    

008026c7 <devcons_read>:
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 08             	sub    $0x8,%esp
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026d6:	74 21                	je     8026f9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8026d8:	e8 03 e6 ff ff       	call   800ce0 <sys_cgetc>
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	75 07                	jne    8026e8 <devcons_read+0x21>
		sys_yield();
  8026e1:	e8 79 e6 ff ff       	call   800d5f <sys_yield>
  8026e6:	eb f0                	jmp    8026d8 <devcons_read+0x11>
	if (c < 0)
  8026e8:	78 0f                	js     8026f9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8026ea:	83 f8 04             	cmp    $0x4,%eax
  8026ed:	74 0c                	je     8026fb <devcons_read+0x34>
	*(char*)vbuf = c;
  8026ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f2:	88 02                	mov    %al,(%edx)
	return 1;
  8026f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    
		return 0;
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802700:	eb f7                	jmp    8026f9 <devcons_read+0x32>

00802702 <cputchar>:
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80270e:	6a 01                	push   $0x1
  802710:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802713:	50                   	push   %eax
  802714:	e8 a9 e5 ff ff       	call   800cc2 <sys_cputs>
}
  802719:	83 c4 10             	add    $0x10,%esp
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <getchar>:
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802724:	6a 01                	push   $0x1
  802726:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802729:	50                   	push   %eax
  80272a:	6a 00                	push   $0x0
  80272c:	e8 0b ec ff ff       	call   80133c <read>
	if (r < 0)
  802731:	83 c4 10             	add    $0x10,%esp
  802734:	85 c0                	test   %eax,%eax
  802736:	78 06                	js     80273e <getchar+0x20>
	if (r < 1)
  802738:	74 06                	je     802740 <getchar+0x22>
	return c;
  80273a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80273e:	c9                   	leave  
  80273f:	c3                   	ret    
		return -E_EOF;
  802740:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802745:	eb f7                	jmp    80273e <getchar+0x20>

00802747 <iscons>:
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
  80274a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80274d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802750:	50                   	push   %eax
  802751:	ff 75 08             	pushl  0x8(%ebp)
  802754:	e8 73 e9 ff ff       	call   8010cc <fd_lookup>
  802759:	83 c4 10             	add    $0x10,%esp
  80275c:	85 c0                	test   %eax,%eax
  80275e:	78 11                	js     802771 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802769:	39 10                	cmp    %edx,(%eax)
  80276b:	0f 94 c0             	sete   %al
  80276e:	0f b6 c0             	movzbl %al,%eax
}
  802771:	c9                   	leave  
  802772:	c3                   	ret    

00802773 <opencons>:
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80277c:	50                   	push   %eax
  80277d:	e8 f8 e8 ff ff       	call   80107a <fd_alloc>
  802782:	83 c4 10             	add    $0x10,%esp
  802785:	85 c0                	test   %eax,%eax
  802787:	78 3a                	js     8027c3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802789:	83 ec 04             	sub    $0x4,%esp
  80278c:	68 07 04 00 00       	push   $0x407
  802791:	ff 75 f4             	pushl  -0xc(%ebp)
  802794:	6a 00                	push   $0x0
  802796:	e8 e3 e5 ff ff       	call   800d7e <sys_page_alloc>
  80279b:	83 c4 10             	add    $0x10,%esp
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	78 21                	js     8027c3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027ab:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027b7:	83 ec 0c             	sub    $0xc,%esp
  8027ba:	50                   	push   %eax
  8027bb:	e8 93 e8 ff ff       	call   801053 <fd2num>
  8027c0:	83 c4 10             	add    $0x10,%esp
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	56                   	push   %esi
  8027c9:	53                   	push   %ebx
  8027ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8027cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8027d3:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8027d5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027da:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027dd:	83 ec 0c             	sub    $0xc,%esp
  8027e0:	50                   	push   %eax
  8027e1:	e8 48 e7 ff ff       	call   800f2e <sys_ipc_recv>
	if(ret < 0){
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	78 2b                	js     802818 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027ed:	85 f6                	test   %esi,%esi
  8027ef:	74 0a                	je     8027fb <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8027f1:	a1 08 50 80 00       	mov    0x805008,%eax
  8027f6:	8b 40 74             	mov    0x74(%eax),%eax
  8027f9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027fb:	85 db                	test   %ebx,%ebx
  8027fd:	74 0a                	je     802809 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8027ff:	a1 08 50 80 00       	mov    0x805008,%eax
  802804:	8b 40 78             	mov    0x78(%eax),%eax
  802807:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802809:	a1 08 50 80 00       	mov    0x805008,%eax
  80280e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802811:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802814:	5b                   	pop    %ebx
  802815:	5e                   	pop    %esi
  802816:	5d                   	pop    %ebp
  802817:	c3                   	ret    
		if(from_env_store)
  802818:	85 f6                	test   %esi,%esi
  80281a:	74 06                	je     802822 <ipc_recv+0x5d>
			*from_env_store = 0;
  80281c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802822:	85 db                	test   %ebx,%ebx
  802824:	74 eb                	je     802811 <ipc_recv+0x4c>
			*perm_store = 0;
  802826:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80282c:	eb e3                	jmp    802811 <ipc_recv+0x4c>

0080282e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	57                   	push   %edi
  802832:	56                   	push   %esi
  802833:	53                   	push   %ebx
  802834:	83 ec 0c             	sub    $0xc,%esp
  802837:	8b 7d 08             	mov    0x8(%ebp),%edi
  80283a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80283d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802840:	85 db                	test   %ebx,%ebx
  802842:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802847:	0f 44 d8             	cmove  %eax,%ebx
  80284a:	eb 05                	jmp    802851 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80284c:	e8 0e e5 ff ff       	call   800d5f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802851:	ff 75 14             	pushl  0x14(%ebp)
  802854:	53                   	push   %ebx
  802855:	56                   	push   %esi
  802856:	57                   	push   %edi
  802857:	e8 af e6 ff ff       	call   800f0b <sys_ipc_try_send>
  80285c:	83 c4 10             	add    $0x10,%esp
  80285f:	85 c0                	test   %eax,%eax
  802861:	74 1b                	je     80287e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802863:	79 e7                	jns    80284c <ipc_send+0x1e>
  802865:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802868:	74 e2                	je     80284c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80286a:	83 ec 04             	sub    $0x4,%esp
  80286d:	68 b6 31 80 00       	push   $0x8031b6
  802872:	6a 48                	push   $0x48
  802874:	68 cb 31 80 00       	push   $0x8031cb
  802879:	e8 b9 d8 ff ff       	call   800137 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80287e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    

00802886 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802891:	89 c2                	mov    %eax,%edx
  802893:	c1 e2 07             	shl    $0x7,%edx
  802896:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80289c:	8b 52 50             	mov    0x50(%edx),%edx
  80289f:	39 ca                	cmp    %ecx,%edx
  8028a1:	74 11                	je     8028b4 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028a3:	83 c0 01             	add    $0x1,%eax
  8028a6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028ab:	75 e4                	jne    802891 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b2:	eb 0b                	jmp    8028bf <ipc_find_env+0x39>
			return envs[i].env_id;
  8028b4:	c1 e0 07             	shl    $0x7,%eax
  8028b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028bc:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028bf:	5d                   	pop    %ebp
  8028c0:	c3                   	ret    

008028c1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
  8028c4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028c7:	89 d0                	mov    %edx,%eax
  8028c9:	c1 e8 16             	shr    $0x16,%eax
  8028cc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028d3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028d8:	f6 c1 01             	test   $0x1,%cl
  8028db:	74 1d                	je     8028fa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028dd:	c1 ea 0c             	shr    $0xc,%edx
  8028e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028e7:	f6 c2 01             	test   $0x1,%dl
  8028ea:	74 0e                	je     8028fa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028ec:	c1 ea 0c             	shr    $0xc,%edx
  8028ef:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028f6:	ef 
  8028f7:	0f b7 c0             	movzwl %ax,%eax
}
  8028fa:	5d                   	pop    %ebp
  8028fb:	c3                   	ret    
  8028fc:	66 90                	xchg   %ax,%ax
  8028fe:	66 90                	xchg   %ax,%ax

00802900 <__udivdi3>:
  802900:	55                   	push   %ebp
  802901:	57                   	push   %edi
  802902:	56                   	push   %esi
  802903:	53                   	push   %ebx
  802904:	83 ec 1c             	sub    $0x1c,%esp
  802907:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80290b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80290f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802913:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802917:	85 d2                	test   %edx,%edx
  802919:	75 4d                	jne    802968 <__udivdi3+0x68>
  80291b:	39 f3                	cmp    %esi,%ebx
  80291d:	76 19                	jbe    802938 <__udivdi3+0x38>
  80291f:	31 ff                	xor    %edi,%edi
  802921:	89 e8                	mov    %ebp,%eax
  802923:	89 f2                	mov    %esi,%edx
  802925:	f7 f3                	div    %ebx
  802927:	89 fa                	mov    %edi,%edx
  802929:	83 c4 1c             	add    $0x1c,%esp
  80292c:	5b                   	pop    %ebx
  80292d:	5e                   	pop    %esi
  80292e:	5f                   	pop    %edi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    
  802931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802938:	89 d9                	mov    %ebx,%ecx
  80293a:	85 db                	test   %ebx,%ebx
  80293c:	75 0b                	jne    802949 <__udivdi3+0x49>
  80293e:	b8 01 00 00 00       	mov    $0x1,%eax
  802943:	31 d2                	xor    %edx,%edx
  802945:	f7 f3                	div    %ebx
  802947:	89 c1                	mov    %eax,%ecx
  802949:	31 d2                	xor    %edx,%edx
  80294b:	89 f0                	mov    %esi,%eax
  80294d:	f7 f1                	div    %ecx
  80294f:	89 c6                	mov    %eax,%esi
  802951:	89 e8                	mov    %ebp,%eax
  802953:	89 f7                	mov    %esi,%edi
  802955:	f7 f1                	div    %ecx
  802957:	89 fa                	mov    %edi,%edx
  802959:	83 c4 1c             	add    $0x1c,%esp
  80295c:	5b                   	pop    %ebx
  80295d:	5e                   	pop    %esi
  80295e:	5f                   	pop    %edi
  80295f:	5d                   	pop    %ebp
  802960:	c3                   	ret    
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	39 f2                	cmp    %esi,%edx
  80296a:	77 1c                	ja     802988 <__udivdi3+0x88>
  80296c:	0f bd fa             	bsr    %edx,%edi
  80296f:	83 f7 1f             	xor    $0x1f,%edi
  802972:	75 2c                	jne    8029a0 <__udivdi3+0xa0>
  802974:	39 f2                	cmp    %esi,%edx
  802976:	72 06                	jb     80297e <__udivdi3+0x7e>
  802978:	31 c0                	xor    %eax,%eax
  80297a:	39 eb                	cmp    %ebp,%ebx
  80297c:	77 a9                	ja     802927 <__udivdi3+0x27>
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
  802983:	eb a2                	jmp    802927 <__udivdi3+0x27>
  802985:	8d 76 00             	lea    0x0(%esi),%esi
  802988:	31 ff                	xor    %edi,%edi
  80298a:	31 c0                	xor    %eax,%eax
  80298c:	89 fa                	mov    %edi,%edx
  80298e:	83 c4 1c             	add    $0x1c,%esp
  802991:	5b                   	pop    %ebx
  802992:	5e                   	pop    %esi
  802993:	5f                   	pop    %edi
  802994:	5d                   	pop    %ebp
  802995:	c3                   	ret    
  802996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80299d:	8d 76 00             	lea    0x0(%esi),%esi
  8029a0:	89 f9                	mov    %edi,%ecx
  8029a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029a7:	29 f8                	sub    %edi,%eax
  8029a9:	d3 e2                	shl    %cl,%edx
  8029ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029af:	89 c1                	mov    %eax,%ecx
  8029b1:	89 da                	mov    %ebx,%edx
  8029b3:	d3 ea                	shr    %cl,%edx
  8029b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029b9:	09 d1                	or     %edx,%ecx
  8029bb:	89 f2                	mov    %esi,%edx
  8029bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029c1:	89 f9                	mov    %edi,%ecx
  8029c3:	d3 e3                	shl    %cl,%ebx
  8029c5:	89 c1                	mov    %eax,%ecx
  8029c7:	d3 ea                	shr    %cl,%edx
  8029c9:	89 f9                	mov    %edi,%ecx
  8029cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029cf:	89 eb                	mov    %ebp,%ebx
  8029d1:	d3 e6                	shl    %cl,%esi
  8029d3:	89 c1                	mov    %eax,%ecx
  8029d5:	d3 eb                	shr    %cl,%ebx
  8029d7:	09 de                	or     %ebx,%esi
  8029d9:	89 f0                	mov    %esi,%eax
  8029db:	f7 74 24 08          	divl   0x8(%esp)
  8029df:	89 d6                	mov    %edx,%esi
  8029e1:	89 c3                	mov    %eax,%ebx
  8029e3:	f7 64 24 0c          	mull   0xc(%esp)
  8029e7:	39 d6                	cmp    %edx,%esi
  8029e9:	72 15                	jb     802a00 <__udivdi3+0x100>
  8029eb:	89 f9                	mov    %edi,%ecx
  8029ed:	d3 e5                	shl    %cl,%ebp
  8029ef:	39 c5                	cmp    %eax,%ebp
  8029f1:	73 04                	jae    8029f7 <__udivdi3+0xf7>
  8029f3:	39 d6                	cmp    %edx,%esi
  8029f5:	74 09                	je     802a00 <__udivdi3+0x100>
  8029f7:	89 d8                	mov    %ebx,%eax
  8029f9:	31 ff                	xor    %edi,%edi
  8029fb:	e9 27 ff ff ff       	jmp    802927 <__udivdi3+0x27>
  802a00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a03:	31 ff                	xor    %edi,%edi
  802a05:	e9 1d ff ff ff       	jmp    802927 <__udivdi3+0x27>
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__umoddi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	83 ec 1c             	sub    $0x1c,%esp
  802a17:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a27:	89 da                	mov    %ebx,%edx
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	75 43                	jne    802a70 <__umoddi3+0x60>
  802a2d:	39 df                	cmp    %ebx,%edi
  802a2f:	76 17                	jbe    802a48 <__umoddi3+0x38>
  802a31:	89 f0                	mov    %esi,%eax
  802a33:	f7 f7                	div    %edi
  802a35:	89 d0                	mov    %edx,%eax
  802a37:	31 d2                	xor    %edx,%edx
  802a39:	83 c4 1c             	add    $0x1c,%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a48:	89 fd                	mov    %edi,%ebp
  802a4a:	85 ff                	test   %edi,%edi
  802a4c:	75 0b                	jne    802a59 <__umoddi3+0x49>
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	31 d2                	xor    %edx,%edx
  802a55:	f7 f7                	div    %edi
  802a57:	89 c5                	mov    %eax,%ebp
  802a59:	89 d8                	mov    %ebx,%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	f7 f5                	div    %ebp
  802a5f:	89 f0                	mov    %esi,%eax
  802a61:	f7 f5                	div    %ebp
  802a63:	89 d0                	mov    %edx,%eax
  802a65:	eb d0                	jmp    802a37 <__umoddi3+0x27>
  802a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a6e:	66 90                	xchg   %ax,%ax
  802a70:	89 f1                	mov    %esi,%ecx
  802a72:	39 d8                	cmp    %ebx,%eax
  802a74:	76 0a                	jbe    802a80 <__umoddi3+0x70>
  802a76:	89 f0                	mov    %esi,%eax
  802a78:	83 c4 1c             	add    $0x1c,%esp
  802a7b:	5b                   	pop    %ebx
  802a7c:	5e                   	pop    %esi
  802a7d:	5f                   	pop    %edi
  802a7e:	5d                   	pop    %ebp
  802a7f:	c3                   	ret    
  802a80:	0f bd e8             	bsr    %eax,%ebp
  802a83:	83 f5 1f             	xor    $0x1f,%ebp
  802a86:	75 20                	jne    802aa8 <__umoddi3+0x98>
  802a88:	39 d8                	cmp    %ebx,%eax
  802a8a:	0f 82 b0 00 00 00    	jb     802b40 <__umoddi3+0x130>
  802a90:	39 f7                	cmp    %esi,%edi
  802a92:	0f 86 a8 00 00 00    	jbe    802b40 <__umoddi3+0x130>
  802a98:	89 c8                	mov    %ecx,%eax
  802a9a:	83 c4 1c             	add    $0x1c,%esp
  802a9d:	5b                   	pop    %ebx
  802a9e:	5e                   	pop    %esi
  802a9f:	5f                   	pop    %edi
  802aa0:	5d                   	pop    %ebp
  802aa1:	c3                   	ret    
  802aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802aa8:	89 e9                	mov    %ebp,%ecx
  802aaa:	ba 20 00 00 00       	mov    $0x20,%edx
  802aaf:	29 ea                	sub    %ebp,%edx
  802ab1:	d3 e0                	shl    %cl,%eax
  802ab3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ab7:	89 d1                	mov    %edx,%ecx
  802ab9:	89 f8                	mov    %edi,%eax
  802abb:	d3 e8                	shr    %cl,%eax
  802abd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ac1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ac5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ac9:	09 c1                	or     %eax,%ecx
  802acb:	89 d8                	mov    %ebx,%eax
  802acd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ad1:	89 e9                	mov    %ebp,%ecx
  802ad3:	d3 e7                	shl    %cl,%edi
  802ad5:	89 d1                	mov    %edx,%ecx
  802ad7:	d3 e8                	shr    %cl,%eax
  802ad9:	89 e9                	mov    %ebp,%ecx
  802adb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802adf:	d3 e3                	shl    %cl,%ebx
  802ae1:	89 c7                	mov    %eax,%edi
  802ae3:	89 d1                	mov    %edx,%ecx
  802ae5:	89 f0                	mov    %esi,%eax
  802ae7:	d3 e8                	shr    %cl,%eax
  802ae9:	89 e9                	mov    %ebp,%ecx
  802aeb:	89 fa                	mov    %edi,%edx
  802aed:	d3 e6                	shl    %cl,%esi
  802aef:	09 d8                	or     %ebx,%eax
  802af1:	f7 74 24 08          	divl   0x8(%esp)
  802af5:	89 d1                	mov    %edx,%ecx
  802af7:	89 f3                	mov    %esi,%ebx
  802af9:	f7 64 24 0c          	mull   0xc(%esp)
  802afd:	89 c6                	mov    %eax,%esi
  802aff:	89 d7                	mov    %edx,%edi
  802b01:	39 d1                	cmp    %edx,%ecx
  802b03:	72 06                	jb     802b0b <__umoddi3+0xfb>
  802b05:	75 10                	jne    802b17 <__umoddi3+0x107>
  802b07:	39 c3                	cmp    %eax,%ebx
  802b09:	73 0c                	jae    802b17 <__umoddi3+0x107>
  802b0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b13:	89 d7                	mov    %edx,%edi
  802b15:	89 c6                	mov    %eax,%esi
  802b17:	89 ca                	mov    %ecx,%edx
  802b19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b1e:	29 f3                	sub    %esi,%ebx
  802b20:	19 fa                	sbb    %edi,%edx
  802b22:	89 d0                	mov    %edx,%eax
  802b24:	d3 e0                	shl    %cl,%eax
  802b26:	89 e9                	mov    %ebp,%ecx
  802b28:	d3 eb                	shr    %cl,%ebx
  802b2a:	d3 ea                	shr    %cl,%edx
  802b2c:	09 d8                	or     %ebx,%eax
  802b2e:	83 c4 1c             	add    $0x1c,%esp
  802b31:	5b                   	pop    %ebx
  802b32:	5e                   	pop    %esi
  802b33:	5f                   	pop    %edi
  802b34:	5d                   	pop    %ebp
  802b35:	c3                   	ret    
  802b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b3d:	8d 76 00             	lea    0x0(%esi),%esi
  802b40:	89 da                	mov    %ebx,%edx
  802b42:	29 fe                	sub    %edi,%esi
  802b44:	19 c2                	sbb    %eax,%edx
  802b46:	89 f1                	mov    %esi,%ecx
  802b48:	89 c8                	mov    %ecx,%eax
  802b4a:	e9 4b ff ff ff       	jmp    802a9a <__umoddi3+0x8a>
